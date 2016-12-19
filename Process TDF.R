library(ngram)
library(tm)
library(stringi)
library(tidyr)
library(tidytext)
library(textmineR)


#txtfile<-"./Example.txt"
cname<-"./Data/final/en_US/"
txtfile<-paste0(cname,"en_US.blogs.txt")
con<-file(txtfile,open = "r")
lines<-readLines(con,100000)
lines<-paste(lines,collapse = " ")
close(con)


dtm<-CreateDtm(doc_vec = lines,doc_names = c("Apple")
          ,ngram_window = c(1,3)
          ,lower = TRUE
          ,remove_punctuation = TRUE)
tdf<-TermDocFreq(dtm)

tdf$ngram<-sapply(tdf$term,"wordcount","_")
str(tdf)

word="paint"
predict_next(word)


