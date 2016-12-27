predict_three(word="Tulusa",dict = combo_small)


## Load required libraries
library(data.table)
library(readr)
library(knitr)
library(stringi)


## Sourcing the functions necessary for analysis
source('./Functions/predict_next.R')
source('./Functions/babble_sentence.R')
source('./Functions/predict_three.R')

## Loading the pruned combo library
combo_small<-read_rds(paste0("./Data/Dictionaries/","US_Combo_Dict_small",".RDS"))

## Profiling the code for speed of prediction
Rprof(tmp <- tempfile())
word<-"worst ever inning"
predict_next(word,dict = combo_small)
Rprof()
summaryRprof(tmp)
unlink(tmp)

## Profiling code for generating sentences (gives average speed)
Rprof(tmp <- tempfile())
word<-"cinder"
babble_sentence(word,dict = combo_small,num_words = 10)
Rprof()
summaryRprof(tmp)
unlink(tmp)






###############################################################################
#               Code for Context based prediction                             #
###############################################################################

## Reading Appropriate Dictionary into memory
blog="US_Blogs_Dict_s"
news="US_News_Dict_s"
twit="US_Twit_Dict_s"

## Pruning Dictionary
b<-prune_dict(read_rds(paste0("./Data/Dictionaries/",blog,".RDS")))
n<-prune_dict(read_rds(paste0("./Data/Dictionaries/",news,".RDS")))
t<-prune_dict(read_rds(paste0("./Data/Dictionaries/",twit,".RDS")))

## Testing Speed
Rprof(tmp <- tempfile())
word<-"zumbas class"
prediction<-data.frame(
    blog=predict_next(word,dict = b),
    news=predict_next(word,dict = n),
    twitter=predict_next(word,dict = t)
)

print(kable(prediction))
Rprof()
summaryRprof(tmp)
unlink(tmp)

################################################################################





