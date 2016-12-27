
##' This file is used the create the dictionaries required for prediction
##' We sample the text files given and use the "ngram" package to create 
##' dictionaries. We also save the dictionaries as RDS file to reuse


## Load required libraries
library(data.table)
library(readr)


## Refer original files
cname<-"./Data/final/en_US/"
blogsfile<-paste0(cname,"en_US.blogs.txt")
newsfile<-paste0(cname,"en_US.news.txt")
twitfile<-paste0(cname,"en_US.twitter.txt")

Sys.setlocale("LC_CTYPE", "en_US.UTF-8")


## File sizes
blogsize<-file.size(blogsfile)
newsize<-file.size(newsfile)
twitsize<-file.size(twitfile)

Desc<-data.frame(
    file_name = c("en_US.blogs.txt","en_US.news.txt","en_US.twitter.txt"),
    file_size = c(file.size(blogsfile)/1024^2,file.size(newsfile)/1024^2,file.size(twitfile)/1024^2),
    file_chars = c(length(blogsfile),length(newsfile),length(twitfile)),
    wordcount = c(stri_count_words(blogsfile),stri_count_words(newsfile),stri_count_words(twitfile))
    
)

## Create sample files
dname<-"./Data/final/en_US/sample/"
blogsfile_sample<-paste0(dname,"en_US.blogs.txt")
newsfile_sample<-paste0(dname,"en_US.news.txt")
twitfile_sample<-paste0(dname,"en_US.twitter.txt")

## Create sample of Blogs file
lines<-read_lines(blogsfile,n_max=200000,progress = T)
lines<-paste(lines,collapse = " ")
write_file(lines,blogsfile_sample)
rm(lines)

## Create sample of News file
lines<-read_lines(newsfile,n_max=200000,progress = T)
lines<-paste(lines,collapse = " ")
write_file(lines,newsfile_sample)
rm(lines)

## Create sample of Twitter file
lines<-read_lines(twitfile,n_max=400000,progress = T)
lines<-paste(lines,collapse = " ")
write_file(lines,twitfile_sample)
rm(lines)

## Sourcing the functions necessary for analysis
source('./Functions/CreateDictionary.R')
source('./Functions/getNgram.R')


## Creating Context Dictionaries
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

## Creating Combined Dictionary
## Reading Appropriate Dictionary into memory
blog="US_Blogs_Dict_s"
news="US_News_Dict_s"
twit="US_Twit_Dict_s"

## Pruning Dictionary
b<-read_rds(paste0("./Data/Dictionaries/",blog,".RDS"))
n<-read_rds(paste0("./Data/Dictionaries/",news,".RDS"))
t<-read_rds(paste0("./Data/Dictionaries/",twit,".RDS"))

## Combining the dictionaries and grouping
combo<-rbind(b,n,t)
setkey(combo,term)
combo<-combo[,.(term_freq=sum(term_freq),ngram=mean(ngram)),term][order(-ngram,-term_freq)]
saveRDS(combo,paste0("./Data/Dictionaries/","US_Combo_Dict_s",".RDS"))
combo<-read_rds(paste0("./Data/Dictionaries/","US_Combo_Dict_s",".RDS"))

## Pruning the combined dictionary
combo_1g<-combo[ngram==1,]
combo_2g<-combo[ngram==2,]
combo_3g<-combo[ngram==3,][term_freq>1]
combo_4g<-combo[ngram==4 ][term_freq>1]

## Saving the combined dictionary
combo_small<-rbind(combo_1g,combo_2g,combo_3g,combo_4g)
saveRDS(combo_small,paste0("./Data/Dictionaries/","US_Combo_Dict_small",".RDS"))
rm(combo_small)

## Creating smaller dictionary
small<-read_rds(paste0("./Data/Dictionaries/","US_Combo_Dict_small",".RDS"))
small<-small[ngram>1,][term_freq>1,]
saveRDS(small,paste0("./Data/Dictionaries/","US_Dict_small",".RDS"))
rm(small)
