## Testing accuracy and speed
library(readr)
library(data.table)
library(stringi)
source('~/R Projects/DataScience/Data Science Capstone/Functions/predict_next.R')

## Load the combo data set
combo_small<-paste0("./Dictionaries/","US_Combo_Dict_small",".RDS")
combo_small<-read_rds(combo_small)


## Get the unigram,hi_bigram, low_bigram and trigram sets
#combo_unigram<-combo_small[ngram==1,]
combo_bigram_hi<-combo_small[ngram==2,][term_freq>2]
combo_bigram_lo<-combo_small[ngram==2,][term_freq<2]
combo_trigram<-combo_small[ngram==3,]
combo_quadgram<-combo_small[ngram==4,]

## Random sample of 100
set.seed(500)
bi_hi_sample<-sample(combo_bigram_hi$term,size = 1000,replace = T,prob = combo_bigram_hi$term_freq)
tri_sample<-sample(combo_trigram$term,size = 1000,replace = T,prob = combo_trigram$term_freq)
quad_sample<-sample(combo_quadgram$term,size = 1000,replace = T,prob = combo_quadgram$term_freq)


## Use bigram hi sample to get first word(for prediction) and second word (for validation)
inputword<-c()
outputword<-c()
predword<-c()
for (i in seq(1:length(bi_hi_sample))) {
    inputword[i]<-stri_split_fixed(bi_hi_sample[i]," ")[[1]][1]
    outputword[i]<-stri_split_fixed(bi_hi_sample[i]," ")[[1]][2]
    predword[i]<-predict_next(inputword[i])
}
bi_hi_out<-as.data.frame(cbind(bi_hi_sample,inputword,outputword,predword))
bi_hi_out$accuracy<-stri_cmp_eq(bi_hi_out$outputword,bi_hi_out$predword)



## Use trigram sample to get first  2 words(for prediction) and third word (for validation)
inputword<-c()
outputword<-c()
predword<-c()
for (i in seq(1:length(tri_sample))) {
    inputword[i]<-stri_join(stri_split_fixed(tri_sample[i]," ")[[1]][1:2],collapse = " ")
    outputword[i]<-stri_split_fixed(tri_sample[i]," ")[[1]][3]
    predword[i]<-predict_next(inputword[i])
}
tri_out<-as.data.frame(cbind(tri_sample,inputword,outputword,predword))
tri_out$accuracy<-stri_cmp_eq(tri_out$outputword,tri_out$predword)



## Use quadgram sample to get first  3 words(for prediction) and fourth word (for validation)
inputword<-c()
outputword<-c()
predword<-c()
for (i in seq(1:length(quad_sample))) {
    inputword[i]<-stri_join(stri_split_fixed(quad_sample[i]," ")[[1]][1:3],collapse = " ")
    outputword[i]<-stri_split_fixed(quad_sample[i]," ")[[1]][4]
    predword[i]<-predict_next(inputword[i])
}
quad_out<-as.data.frame(cbind(quad_sample,inputword,outputword,predword))
quad_out$accuracy<-stri_cmp_eq(quad_out$outputword,quad_out$predword)


## Calculate Accuracies
accuracy_bi<-sum(bi_hi_out$accuracy)/nrow(bi_hi_out)
accuracy_tri<-sum(tri_out$accuracy)/nrow(tri_out)
accuracy_quad<-sum(quad_out$accuracy)/nrow(quad_out)

cat(paste0("Bigram Accuracy:\t",accuracy_bi,"\n","Trigram Accuracy:\t",accuracy_tri,"\n","Quadgram Accuracy:\t",accuracy_quad))

## Save the accuracies to a data frame
Accuracy<-data.frame(Ngram = c("Bi-gram","Tri-gram","Quad-gram"),
                     Accuracy = c(accuracy_bi,accuracy_tri,accuracy_quad))
saveRDS(object = Accuracy,file = "./Accuracy.RDS")

