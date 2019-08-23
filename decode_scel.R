library(dplyr)
library(stringr)
library(devtools)
library(cidian)
library(data.table)
library(ropencc)
library(gtools)
SS=converter(S2TWP)
cate=list.dirs(path = 'C:/Users/lenovon/Desktop/dictionary',
               recursive = F)
cate=gtools::mixedsort(cate)
delete_pos=NULL
for(i in 1:length(cate)){
  a=list.files(path = paste0(cate[i],'/'),recursive = F,
               full.names = T,pattern = 'scel')
  for(j in 1:length(a)){
    name=gsub(x = a[j],pattern = 'scel',replacement = 'txt')
    tt=tryCatch(decode_scel(scel = a[j],
                output = name,cpp = T,progress = F),
                error=function(e) return(456))
    if(length(tt) ==0){
      temp=readLines(con = name,encoding = 'UTF-8')
      temp=run_convert(SS,temp)
      writeLines(text = temp,con = name,useBytes = T)
      unlink(x = a[j],recursive = F)
    }else{
      delete_pos=c(delete_pos,paste0(i,':',j))
    }
  }
}


