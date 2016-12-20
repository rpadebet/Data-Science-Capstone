library(ngram)
library(tm)
library(stringi)
library(tidyr)
library(tidytext)
library(textmineR)
library(data.table)


#txtfile<-"./Example.txt"
cname<-"./Data/final/en_US/"
txtfile<-paste0(cname,"en_US.blogs.txt")
con<-file(txtfile,open = "r")
lines<-readLines(con,50000)
lines<-paste(lines,collapse = " ")
close(con)


dtm<-CreateDtm(doc_vec = lines,doc_names = c("blogs")
          ,ngram_window = c(1,4)
          ,lower = TRUE
          ,remove_punctuation = TRUE,
          stopword_vec = c())

tdf<-as.data.table(TermDocFreq(dtm))

tdf$ngram<-sapply(tdf$term,"wordcount","_")
str(tdf)
tdf[ngram==1 & term=="the",]

word="This"

predict_next(word)
babble_sentence(word,8)

