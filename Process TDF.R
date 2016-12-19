library(ngram)
library(tm)
library(stringi)
library(tidyr)
library(tidytext)
library(textmineR)


txtfile<-"./Example.txt"
con<-file(txtfile,open = "r")
lines<-readLines(con)
length(lines)
lines<-paste(lines,collapse = " ")
close(con)


dtm<-CreateDtm(doc_vec = lines,doc_names = c("Apple")
          ,ngram_window = c(1,4)
          ,lower = TRUE
          ,remove_punctuation = TRUE)
tdf<-TermDocFreq(dtm)

tdf$ngram<-sapply(tdf$term,"wordcount","_")
str(tdf)

