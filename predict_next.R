predict_next<-function(word,dict=tdf){
    
    word<-stri_trans_tolower(word)
    count<-wordcount(word)
    word<-ifelse(count>3,word_backoff(word),word)
   
    
    word_p<-paste0(gsub(" ","_",x = word),"_")
    df<-dict[ngram==count+1,]
    idx<-grep(pattern = word_p,df$term,fixed = TRUE)
    
    poss_list<-df[idx,]
    
    best_pred<-as.character(poss_list[order(-term_freq)][1,1])
    next_word<-stri_split_fixed(best_pred,"_")[[1]][[wordcount(best_pred,"_")]]
    
    # check if prediction is NA, if so call function on subset of the word
    if(is.na(best_pred)) {
        word_b<-word_backoff(word)
        next_word<-predict_next(word_b,dict)
    }
    
    
    return(next_word)
}