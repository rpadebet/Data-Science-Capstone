## Loading libraries
library(data.table)
library(stringi)
library(ngram)
library(knitr)
library(readr)
library(ggplot2)

## Downloading File
url<-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"

download.file(url,"./Data/SwiftKey.zip",method = "curl")
unzip("./Data/SwiftKey.zip",exdir = "./Data/")

## Referencing files
cname<-"./Data/final/en_US/"
blogsfile<-paste0(cname,"en_US.blogs.txt")
newsfile<-paste0(cname,"en_US.news.txt")
twitfile<-paste0(cname,"en_US.twitter.txt")

Sys.setlocale("LC_CTYPE", "en_US.UTF-8")

## Reading Files
blogs_file<-readLines(blogsfile,skipNul = T)
news_file<-readLines(newsfile,skipNul = T)
twit_file<-readLines(twitfile,skipNul = T)

## Generating descriptive statistics

Desc<-data.frame(
    file_name = c("en_US.blogs.txt","en_US.news.txt","en_US.twitter.txt"),
    file_size_mb = c(file.size(blogsfile)/1024^2,file.size(newsfile)/1024^2,file.size(twitfile)/1024^2),
    file_chars = c(length(blogs_file),length(news_file),length(twit_file)),
    wordcount = c(wordcount(blogs_file," "),wordcount(news_file," "),wordcount(twit_file," "))
)

kable(Desc)

## Processing and cleaning text
text<-read_file(textfile)

text_clean<-preprocess(x = text,
                       case = "lower",
                       remove.punct = TRUE,
                       remove.numbers = TRUE,
                       fix.spacing = TRUE)

## Creating ngrams upto 4
Dict<-getNgram(text_clean,ngrams)

getNgram<- function(text,n){
    ngram_data_table = data.table(NULL)
    for (i in 1:n){
        ngram_table<-ngram(text,n = i,sep = " ")
        ngram_data_table_temp<-get.phrasetable(ngram_table)
        ngram_data_table_temp$term<-trimws(ngram_data_table_temp$ngrams,"r")
        ngram_data_table_temp$ngrams<-NULL
        ngram_data_table<-data.table(rbind(ngram_data_table,ngram_data_table_temp))
    }
    ngram_data_table[,ngram:=wordcount(term," "),by=term]
    setnames(ngram_data_table,"freq","term_freq")
    
    return(ngram_data_table)
}


##Creating and saving Dictionary
blog_dict<-CreateDictionary(DictName = "US_Blogs_Dict_s",
                             textfile = blogsfile_sample,
                             ngrams = 4,
                             saveRDS = T,
                             prune = F
)

news_dict<-CreateDictionary(DictName = "US_News_Dict_s",
                             textfile = newsfile_sample,
                             ngrams = 4,
                             saveRDS = T,
                             prune = F
)

twit_dict<-CreateDictionary(DictName = "US_Twit_Dict_s",
                             textfile = twitfile_sample,
                             ngrams = 4,
                             saveRDS = T,
                             prune = F
)

## Loading Dictionary into memory

## Reading Appropriate Dictionary into memory
blog="US_Blogs_Dict_s"
news="US_News_Dict_s"
twit="US_Twit_Dict_s"

b<-read_rds(paste0("./Dictionaries/",blog,".RDS"))
n<-read_rds(paste0("./Dictionaries/",news,".RDS"))
t<-read_rds(paste0("./Dictionaries/",twit,".RDS"))

## Combining the dictionaries and grouping
combo<-rbind(b,n,t)
setkey(combo,term)
combo<-combo[,.(term_freq=sum(term_freq),ngram=mean(ngram)),term][order(-ngram,-term_freq)]

## Exploring the data
combo_top10<-rbind(combo[ngram==1,][1:10],
                   combo[ngram==2,][1:10],
                   combo[ngram==3,][1:10],
                   combo[ngram==4,][1:10]
)

## Histogram of frequencies - Unigram

h1<-ggplot(combo[ngram==1],aes(x=term_freq))+
    geom_histogram(fill = 'salmon',bins = 100, color= 'black')+ 
    labs(title = "Term Frequency Distribution: 1-Gram",x = 'Frequency', y='Number of Words')+
    xlim(0,500)+
    ylim(0,3000)
print(h1)
    

## Top 10 words and frequencies - Unigram

g1<-ggplot(combo_top10[ngram==1],aes(x=term,y=term_freq))+
    geom_bar(stat="identity",col="black",width=0.5,fill="salmon")+
    #scale_fill_gradient(low = "yellow", high = "red")+
    coord_flip()+
    ylab("Frequency of Terms)")+
    xlab("Top 10 Terms")+
    ggtitle("Top 10 Term Frequency 1-Gram")
print(g1)


## Histogram of frequencies - Bigram

h2<-ggplot(combo[ngram==2,term_freq],aes(x=term_freq))+
    geom_histogram(fill = 'yellow',bins = 100, color= 'black')+ 
    labs(title = "Term Frequency Distribution: 2-Gram",x = 'Frequency', y='Number of Words')+
    xlim(0,500)+
    ylim(0,3000)
print(h2)


## Top 10 words and frequencies - Bigram

g2<-ggplot(combo_top10[ngram==2],aes(x=term,y=term_freq))+
    geom_bar(stat="identity",col="black",width=0.5,fill="yellow")+
    #scale_fill_gradient(low = "yellow", high = "red")+
    coord_flip()+
    ylab("Frequency of Terms)")+
    xlab("Top 10 Terms")+
    ggtitle("Top 10 Term Frequency 2-Gram")
print(g2)

## Histogram of frequencies - Trigram
h3<-ggplot(combo[ngram==3,term_freq],aes(x=term_freq))+
    geom_histogram(fill = 'cyan',bins = 100, color= 'black')+ 
    labs(title = "Term Frequency Distribution: 3-Gram",x = 'Frequency', y='Number of Words')+
    xlim(0,500)+
    ylim(0,3000)
print(h3)

## Top 10 words and frequencies - Trigram
g3<-ggplot(combo_top10[ngram==3],aes(x=term,y=term_freq))+
    geom_bar(stat="identity",col="black",width=0.5,fill="cyan")+
    #scale_fill_gradient(low = "yellow", high = "red")+
    coord_flip()+
    ylab("Frequency of Terms)")+
    xlab("Top 10 Terms")+
    ggtitle("Top 10 Term Frequency 3-Gram")
print(g3)


## Histogram of frequencies - Quadgram
h4<-ggplot(combo[ngram==4,term_freq],aes(x=term_freq))+
    geom_histogram(fill = 'magenta',bins = 100, color= 'black')+ 
    labs(title = "Term Frequency Distribution: 4-Gram",x = 'Frequency', y='Number of Words')+
    xlim(0,500)+
    ylim(0,3000)
print(h4)

## Top 10 words and frequencies - Quadgram
g4<-ggplot(combo_top10[ngram==4],aes(x=term,y=term_freq))+
    geom_bar(stat="identity",col="black",width=0.5,fill="magenta")+
    #scale_fill_gradient(low = "yellow", high = "red")+
    coord_flip()+
    ylab("Frequency of Terms)")+
    xlab("Top 10 Terms")+
    ggtitle("Top 10 Term Frequency 4-Gram")
print(g4)

