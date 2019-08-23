library(dplyr)
library(stringr)
library(data.table)
library(gtools)
#rename directory

a=list.dirs('C:/Users/lenovon/Desktop/dictionary',recursive = F)
a=gtools::mixedsort(a)
name_dir=fread('C:/Users/lenovon/Desktop/dictionary/ds.csv')
setDF(name_dir)
#rename
for(i in 1:dim(name_dir)[1]){
  file.rename(from = a[i],to = paste0('C:/Users/lenovon/Desktop/dictionary/',name_dir[i,1]))
}

#delete ds file
unlink('C:/Users/lenovon/Desktop/dictionary/ds.csv')


#rename files
a=list.dirs('C:/Users/lenovon/Desktop/dictionary',recursive = F)

for(i in 3:length(a)){
  b=list.files(a[i],pattern = 'txt',full.names = T,recursive = F) %>%
    mixedsort()
  #找出無法轉的檔案，跳過編號
  dd=list.files(a[i],pattern = '.scel')
  #remove description txt
  p=which(!grepl(pattern = '\\d+\\.txt',x = b))
  ds=b[p]
  b=b[-p]
  #read name of files
  DS=readLines(ds)
  DS=DS[DS != '']
  if(length(dd)>0){
    dd=str_extract(string = dd,pattern = '\\d+') %>% as.numeric
    DS=DS[-dd]
  }
  DS=str_split(string = DS,pattern = ': ',simplify = T) %>% .[,2] %>%
    gsub(pattern = '【官方推薦】|\\s+',replacement='')
  if(length(DS) != length(b)){
    stop('Error')
  }
  #略過簡體轉繁體未成功的檔案和標題
  if(length(DS) !=length(b)){
    stop('Error')
  }
  delete_pos=which(grepl(pattern = '<U\\+.+>',x = DS))
  if(length(delete_pos)>0){
    for(j in 1:length(DS)){
      if(j %in% delete_pos) next()
      else{
        file.rename(from = b[j],to = 
                      gsub(pattern = '\\d+\\.txt',replacement = paste0(DS[j],'.txt'),x = b[j]))
        unlink(x = b[j],recursive = F)
      }
    } 
  }else{
    for(j in 1:length(DS)){
      file.rename(from = b[j],to = 
                    gsub(pattern = '\\d+\\.txt',replacement = paste0(DS[j],'.txt'),x = b[j]))
      unlink(x = b[j],recursive = F)
    }
  }
}
