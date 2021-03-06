library(ngram)
library(tm)
library(stringi)
library(tidyr)
library(tidytext)
library(textmineR)
library(data.table)
library(doParallel)


#txtfile<-"./Example.txt"
cname<-"./Data/final/en_US/"
txtfile<-paste0(cname,"en_US.blogs.txt")
con<-file(txtfile,open = "r")
lines<-readLines(con,500000)
lines<-paste(lines,collapse = " ")
close(con)

cl <- makeCluster(detectCores()-1)
registerDoParallel(cl)
dtm<-CreateDtm(doc_vec = lines,doc_names = c("blogs")
          ,ngram_window = c(1,3)
          ,lower = TRUE
          ,remove_punctuation = TRUE,
          stopword_vec = c())


tdf<-as.data.table(TermDocFreq(dtm))

#tdf$ngram<-sapply(tdf$term,"wordcount","_")

system.time(
tdf[,ngram:=wordcount(term,"_"),by=term]
)

tdf_1gram<-tdf[ngram==1,][order(-term_freq)]
tdf_2gram<-tdf[ngram==2& term_freq>2,][order(-term_freq)]
tdf_3gram<-tdf[ngram==3 & term_freq>2,][order(-term_freq)]
#tdf_4gram<-tdf[ngram==4 & term_freq>1,][order(-term_freq)]

dict_blog<-rbind(tdf_1gram,tdf_2gram,tdf_3gram)

stopCluster(cl)
#tdf_1gram$next_word<-sapply(tdf_1gram$term,predict_next,tdf_2gram)
#tdf_2gram$next_word<-sapply(tdf_2gram$term,predict_next,tdf_3gram)
#tdf_3gram$next_word<-sapply(tdf_3gram$term,predict_next,tdf_4gram)



word="Type"

system.time(predict_next(word,dict = tdf))
system.time(babble_sentence(word,8,dict=dict_blog))

predict_next(word)

predict_next("Risk of being",dict_blog)

Rprof(tmp <- tempfile())
predict_next("word",dict=dict_blog)
Rprof()
summaryRprof(tmp)
unlink(tmp)

Rprof(tmp <- tempfile())
babble_sentence("cricket",20,dict=dict_blog)
Rprof()
summaryRprof(tmp)
unlink(tmp)