install.packages("quanteda")
library(quanteda)
library(data.table)
library(ngram)

cname<-"./Data/final/en_US/"
txtfile<-paste0(cname,"en_US.blogs.txt")

text<-as.character(fread(input = txtfile,nrows = 10000,sep = "\n"))
#mytf4 <- textfile(txtfile, cache = FALSE)
#summary(corpus(text), 5)
#US_blogs<-corpus(mytf4)

#US_blogs<-corpus(text)
library(doParallel)

cl <- makeCluster(detectCores())
registerDoParallel(cl)
US_blogs_dfm<-t(dfm(US_blogs,
                  toLower=TRUE,
                  removeNumbers=TRUE,
                  removePunct=TRUE,
                  removeSeparators=TRUE,
                  removeTwitter=TRUE))
stopCluster(cl)


registerDoParallel(cl)
US_blogs_dfm_3gram<-t(dfm(US_blogs,
                  toLower=TRUE,
                  removeNumbers=TRUE,
                  removePunct=TRUE,
                  removeSeparators=TRUE,
                  ngrams=3))
stopCluster(cl)

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


