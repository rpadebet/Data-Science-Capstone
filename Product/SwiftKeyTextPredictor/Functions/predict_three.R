#' Given a word/phrase and dictionary, this function
#' applies the markov chain rule and stupid backoff model
#' to predict the next three likely words
#' 
#' product
library(stringi)
library(data.table)

source('./Functions/word_backoff.R')
small<-paste0("./Dictionaries/","US_Dict_small",".RDS")
inputdict<-read_rds(small)

predict_three<-function(word,dict=inputdict,ngram_sep=" "){
    
    #' Convert input to lower case
    word<-stri_trans_tolower(word)
    #' Get the wordcount to determine the n-gram search space
    count<-stri_count_words(word)
    #' Limit the phrase to quadgram search at best
    while(count>3){
        word<-word_backoff(word)
        count<-stri_count_words(word)
    }
    
    #' Process the phrase to add trailing space to aid FIXED search
    word_p<-paste0(gsub(" ",ngram_sep,x = word),ngram_sep)
    
    #' BIGRAM SEARCH: To optimize search speed across bigrams, 
    #' we split the bigram set into high frequency(>2) and low frequency. 
    #' We first look for high frequency matches and if not found, 
    #' look in the low frequency bigram set
    
    if(count==1){
        hi_freq<-TRUE
        
        # High Frequency Bigram search
        if(hi_freq){
            df<-dict[ngram==count+1 & term_freq>2,.(term,term_freq)]
            expr<-paste0("^(",word_p,")[a-z]")
            idx<-grepl(pattern = expr,df$term,perl = TRUE)
            poss_list<-df[idx,]
            hi_freq<-ifelse(nrow(poss_list)==0,F,T)
        }
        # Low Frequency Bigram search
        else{
            df<-dict[ngram==count+1 & term_freq<=2,.(term,term_freq)]
            expr<-paste0("^(",word_p,")[a-z]")
            idx<-grepl(pattern = expr,df$term,perl = TRUE)
            poss_list<-df[idx,]
        }
        
    }
    #' TRIGRAMS and QUADGRAMS: Search for trigrams and quad grams,
    #' since this dataset is already pruned there is no need to 
    #' optimize this search
    
    else{
        df<-dict[ngram==count+1,.(term,term_freq)]
        expr<-paste0("^(",word_p,")[a-z]")
        idx<-grepl(pattern = expr,df$term,perl = TRUE)
        poss_list<-df[idx,] 
    }
    
    best_pred<-as.character(poss_list[1,1])
    
    if(is.na(best_pred)==FALSE){
        poss_list[,prob:=term_freq/sum(term_freq)]
        pred_term<-c()
        prob<-c()
        
        for(i in 1:min(5,nrow(poss_list))){
            pred_term[i]<-stri_split_fixed(
                poss_list[i,1],ngram_sep)[[1]][[
                    stri_count_words(as.character(poss_list[i,1]))]]
            
            prob[i]<-paste0(round(poss_list[i,3]*100,2),"%")
        }
        next_word<-cbind(pred_term,prob) 
        
    }
   
    
    #' STUPID BACKOFF ALGO: Check if we can predict with given phrase, if not, 
    #' use the "Stupid Backoff" algo to call the predict function 
    #' recursively after removing the first word of the phrase
    
    if(is.na(best_pred)&&count>1) {
        word_b<-word_backoff(word)
        next_word<-predict_three(word_b,dict)
    }
    
    #' PREDICTING NEW PHRASES/TYPOS: If the last search word is new, 
    #' then we use the "Stupid backoff like algo"
    #' at the character level.
    #' 
    #' CHARACTER BACKOFF
    #' We remove the "last" character and search for 
    #' the word in the bigram dataset to predict the next word.
    #' We keep doing this until we get a match!
    #'  
    #' This section of code isn't optimized as it is hopefully a rare case
    
    while(is.na(best_pred)&&count==1) {
        df<-dict[ngram==count+1,.(term,term_freq)]
        word_b<-char_backoff(word_p)
        expr<-paste0("^(",word_b,")[a-z]")
        idx<-grepl(pattern = expr,df$term,perl = TRUE)
        poss_list<-df[idx,]
        
        best_pred<-as.character(poss_list[order(-term_freq)][1,1])
        
        if(is.na(best_pred)==FALSE){
            poss_list[,prob:=term_freq/sum(term_freq)]
            pred_term<-c()
            prob<-c()
            for(i in 1:min(5,nrow(poss_list))){
                pred_term[i]<-stri_split_fixed(
                    poss_list[i,1],ngram_sep)[[1]][[
                        stri_count_words(as.character(poss_list[i,1]))]]
                prob[i]<-paste0(round(poss_list[i,3]*100,2),"%")
            }
        next_word<-cbind(pred_term,prob)
        }
        word_p<-word_b
    }
    
    next_word<-as.data.frame(next_word)
    names(next_word)<-c("Words","Probability")
    return(next_word)
}