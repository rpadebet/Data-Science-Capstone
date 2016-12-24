## Load required libraries
library(data.table)
library(ngram)
library(stringi)
library(readr)
library(doParallel)

## Refer original files
cname<-"./Data/final/en_US/"
blogsfile<-paste0(cname,"en_US.blogs.txt")
newsfile<-paste0(cname,"en_US.news.txt")
twitfile<-paste0(cname,"en_US.twitter.txt")

## Create sample files
dname<-"./Data/final/en_US/sample/"
blogsfile_sample<-paste0(dname,"en_US.blogs.txt")
newsfile_sample<-paste0(dname,"en_US.news.txt")
twitfile_sample<-paste0(dname,"en_US.twitter.txt")

text<-as.character(fread(input = blogsfile,nrows = 100000,sep = "\n"))
write_file(text,blogsfile_sample)
text<-as.character(fread(input = newsfile,nrows = 100000,sep = "\n"))
write_file(text,newsfile_sample)
text<-as.character(fread(input = twitfile,nrows = 400000,sep = "\n"))
write_file(text,twitfile_sample)

## Sourcing the functions necessary for analysis
source('~/R Projects/DataScience/Data Science Capstone/CreateDictionary.R')
source('~/R Projects/DataScience/Data Science Capstone/getNgram.R')
source('~/R Projects/DataScience/Data Science Capstone/predict_next.R')
source('~/R Projects/DataScience/Data Science Capstone/word_backoff.R')
source('~/R Projects/DataScience/Data Science Capstone/babble_sentence.R')


## Creating Dictionaries
dictionary<-CreateDictionary(DictName = "US_Blogs_Dict_s",
                             textfile = blogsfile_sample,
                             ngrams = 4,
                             saveRDS = T,
                             prune = F
                             )
rm(dictionary)
dictionary<-CreateDictionary(DictName = "US_News_Dict_s",
                             textfile = newsfile_sample,
                             ngrams = 4,
                             saveRDS = T,
                             prune = F
)
rm(dictionary)
dictionary<-CreateDictionary(DictName = "US_Twit_Dict_s",
                             textfile = twitfile_sample,
                             ngrams = 4,
                             saveRDS = T,
                             prune = F
)
rm(dictionary)


## Reading Appropriate Dictionary into memory
blog=read_rds(paste0("./Data/Dictionaries/","US_Blogs_Dict_s",".RDS"))
news=read_rds(paste0("./Data/Dictionaries/","US_News_Dict_s",".RDS"))
twit=read_rds(paste0("./Data/Dictionaries/","US_Twit_Dict_s",".RDS"))



dict<-twit

## Testing via System.Time()
word="Type"
predict_next(word,dict)
predict_next(word,dict)
system.time(predict_next(word,dict))
system.time(babble_sentence(word,8,dict))


## Testing via R Profiler
word<-"This was"
Rprof(tmp <- tempfile())
predict_next(word,dict)
Rprof()
summaryRprof(tmp)
unlink(tmp)

Rprof(tmp <- tempfile())
babble_sentence(word,20,dict)
Rprof()
summaryRprof(tmp)
unlink(tmp)


