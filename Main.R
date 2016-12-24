## Load required libraries
library(data.table)
library(ngram)
library(stringi)
library(readr)

## Sourcing the functions necessary for analysis
source('./Functions/CreateDictionary.R')
source('./Functions/getNgram.R')
source('./Functions/predict_next.R')
source('./Functions/word_backoff.R')
source('./Functions/babble_sentence.R')

## Reading Appropriate Dictionary into memory
blog="US_Blogs_Dict_s"
news="US_News_Dict_s"
twit="US_Twit_Dict_s"

## Pruning Dictionary
b<-prune_dict(read_rds(paste0("./Data/Dictionaries/",blog,".RDS")))
n<-prune_dict(read_rds(paste0("./Data/Dictionaries/",news,".RDS")))
t<-prune_dict(read_rds(paste0("./Data/Dictionaries/",twit,".RDS")))

word<-"Jose c"
predict_next(word,dict = n)
