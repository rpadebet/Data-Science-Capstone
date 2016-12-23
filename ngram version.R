library(data.table)
library(ngram)
library(stringi)

cname<-"./Data/final/en_US/"
txtfile<-paste0(cname,"en_US.blogs.txt")

text<-as.character(fread(input = txtfile,nrows = 10000,sep = "\n"))

text_clean<-preprocess(x = text,
                       case = "lower",
                       remove.punct = TRUE,
                       remove.numbers = TRUE,
                       fix.spacing = TRUE)

one_gram<-ngram(text_clean,n = 1,sep = " ")
US_blogs_dfm_1gram<-get.phrasetable(one_gram)

two_gram<-ngram(text_clean,n = 2,sep = " ")
US_blogs_dfm_2gram<-get.phrasetable(two_gram)

three_gram<-ngram(text_clean,n = 3,sep = " ")
US_blogs_dfm_3gram<-get.phrasetable(three_gram)

US_blogs_dfm<-data.table(rbind(US_blogs_dfm_1gram,
                               US_blogs_dfm_2gram,
                               US_blogs_dfm_3gram))

US_blogs_dfm[,ngram:=wordcount(ngrams," "),by=ngrams]
source('~/R Projects/DataScience/Data Science Capstone/predict_next.R')
source('~/R Projects/DataScience/Data Science Capstone/word_backoff.R')
source('~/R Projects/DataScience/Data Science Capstone/babble_sentence.R')

setnames(x = US_blogs_dfm,old = c("ngrams","freq"),new = c("term","term_freq"))

word="Type"

system.time(predict_next(word,dict = US_blogs_dfm))
system.time(babble_sentence(word,8,dict=US_blogs_dfm))

predict_next(word)

predict_next("Risk of being",US_blogs_dfm)

Rprof(tmp <- tempfile())
predict_next("word",dict=US_blogs_dfm)
Rprof()
summaryRprof(tmp)
unlink(tmp)

Rprof(tmp <- tempfile())
babble_sentence("cricket",20,dict=US_blogs_dfm)
Rprof()
summaryRprof(tmp)
unlink(tmp)

