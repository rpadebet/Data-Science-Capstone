
url<-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"

download.file(url,"./Data/SwiftKey.zip",method = "curl")
unzip("./Data/SwiftKey.zip",exdir = "./Data/")

## Loading Twitter file and reading
txtfile<-"./Data/final/en_US/en_US.twitter.txt"
con<-file(txtfile,open = "r")
length(con)
x<-(readLines(con,5))

close(con)

## Quiz 1
file.size("./Data/final/en_US/en_US.blogs.txt")

lines<-readLines(con)
length(lines)

install.packages("tm")
library(tm)
install.packages("slam")

blog_en<-Corpus(DirSource(directory ="./Data/final/en_US/" ))

#3
blogs<-file("./Data/final/en_US/en_US.blogs.txt","r")
blogs_file<-readLines(blogs)
max_blog_line<-max(sapply(blogs_file,stri_length))
close(blogs)
news<-file("./Data/final/en_US/en_US.news.txt","r")
news_file<-readLines(news)
max_news_line<-max(sapply(news_file,stri_length))
close(news)

# testing tm
twit<-file("./Data/final/en_US/en_US.twitter.txt","r")
twit_file<-readLines(twit)
close(twit)

library(tm)
EN<-Corpus(DirSource("./Data/final/en_US/" ))

twit_doc<-EN[3]
twit_doc<-tm_map(twit_doc,content_transformer(tolower))
twit_doc_mtx<-DocumentTermMatrix(twit)


##4
library(stringi)

stri_detect_regex("I love you like I hate you",'([hH]ate)')

hate_count<-sum(sapply(twit_file,stri_detect_regex,'(hate)'))
love_count<-sum(sapply(twit_file,stri_detect_regex,'(love)'))

love_count/hate_count


##5
stri_locate_all_regex(twit_file,'(biostats)',omit_no_match = TRUE)

biostat_locate <- sapply(twit_file,stri_detect_regex
                         ,'(biostats)'
                         ,simplify = TRUE)
biostat_locate[biostat_locate==TRUE]

##6
expr<-'(A computer once beat me at chess, but it was no match for me at kickboxing)'
exact_match<-sapply(twit_file,stri_detect_regex
                    ,expr
                    ,simplify = TRUE)

sum(exact_match[exact_match==TRUE])
