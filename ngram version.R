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

## Create sample of Blogs file
lines<-read_lines(blogsfile,progress = T)
lines<-paste(lines,collapse = " ")
write_file(lines,blogsfile_sample)
rm(lines)

## Create sample of News file
lines<-read_lines(newsfile,progress = T)
lines<-paste(lines,collapse = " ")
write_file(lines,newsfile_sample)
rm(lines)

## Create sample of Twitter file
lines<-read_lines(twitfile,progress = T)
lines<-paste(lines,collapse = " ")
write_file(lines,twitfile_sample)
rm(lines)

## Sourcing the functions necessary for analysis
source('./Functions/CreateDictionary.R')
source('./Functions/getNgram.R')
source('./Functions/predict_next.R')
source('./Functions/word_backoff.R')
source('./Functions/babble_sentence.R')


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
blog="US_Blogs_Dict_s"
news="US_News_Dict_s"
twit="US_Twit_Dict_s"

## Pruning Dictionary
b<-prune_dict(read_rds(paste0("./Data/Dictionaries/",blog,".RDS")))
n<-prune_dict(read_rds(paste0("./Data/Dictionaries/",news,".RDS")))
t<-prune_dict(read_rds(paste0("./Data/Dictionaries/",twit,".RDS")))

## Testing via System.Time()
word="Type"
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





