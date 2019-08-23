library(rvest)
library(dplyr)
library(curl)
library(stringr)
library(ropencc)
#Sys.setlocale(locale='chinese')
#Sys.setlocale(category = 'LC_ALL')
SS=converter(type=S2TW)
#category
cate=
  read_html('https://pinyin.sogou.com/dict/') %>%
  html_nodes('body') %>% html_nodes('#dict_category_show') %>%
  html_nodes('.dict_category_list_title') %>%
  html_text(trim=T)
cate=run_convert(SS,cate)
#category of url
url_cate=
  read_html('https://pinyin.sogou.com/dict/') %>%
  html_nodes('body') %>% 
  html_nodes('#dict_category_show') %>%
  html_nodes('.dict_category_list_title') %>%
  html_nodes('a') %>% html_attr('href')
#陷阱 需要補上搜狗網址

url_cate=paste0('https://pinyin.sogou.com',url_cate)
#開始爬蟲
if(!dir.exists('C:/Users/lenovon/Desktop/dictionary')){
  dir.create('C:/Users/lenovon/Desktop/dictionary')
}

#中文資料名稱產生太多無法處理問題QQ
write.csv(x = data.frame(key=cate,stringsAsFactors = F),
          file ='C:/Users/lenovon/Desktop/dictionary/ds.csv',row.names = F)

for(i in 1:length(url_cate)){
  if(!dir.exists(paste0('C:/Users/lenovon/Desktop/dictionary/',i))){
    dir.create(paste0('C:/Users/lenovon/Desktop/dictionary/',i)) 
  }
  #找到正確規律網址
  temp=
    read_html(url_cate[i]) %>%
    html_nodes('#dict_page_list') %>%
    html_nodes('ul') %>%
    html_nodes('span') %>% html_nodes('a')%>%
    html_attr('href')
  #扣除現在頁碼會產生NA
  temp=temp[!is.na(temp)]
  #抓出最大頁碼
  page=str_extract('default/\\d+',string = temp) %>% 
    gsub(pattern = 'default/',replacement = '') %>%
    as.numeric %>% max
  temp=paste0('https://pinyin.sogou.com',
              str_extract(string = temp[1],pattern = '.+default/'))
  N=1
  description=NULL
  for(j in 1:page){
    a=read_html(x = paste0(temp,j)) %>%
        html_nodes('div') %>%
        html_nodes('#dict_detail_list') %>%
        html_nodes('.dict_detail_block') 
    title=a %>%
      html_nodes('.detail_title') %>%
      html_text(trim=T)  %>%
      run_convert(worker = SS,text = .)
    #防止意外產生
    if(any(str_detect(string = title,pattern = '/'))){
      title=gsub(pattern = '/',replacement = '@@',x = title)
    }
    title_url=a %>% 
      html_nodes('.dict_detail_show') %>%
      html_nodes('.dict_dl_btn') %>%
      html_nodes('a') %>%
      html_attr('href')
    for(k in 1:length(title_url)){
      description=c(description,paste0(N,': ',title[k]),"")
      curl_download(url=title_url[k],
                    destfile=paste0('C:/Users/lenovon/Desktop/dictionary/',i,'/',N,'.scel'))
      N=N+1
    }
  }
  writeLines(description,con=paste0('C:/Users/lenovon/Desktop/dictionary/',i,'/','title.txt'))
}
