predict_next<-function(word,s_tdf=tdf){
    
    count<-wordcount(word)
    word<-ifelse(count>3,word_backoff(word),word)
   
    
    word_p<-paste0(gsub(" ","_",x = word),"_")
    df<-s_tdf[ngram==count+1,]
    idx<-grep(pattern = word_p,df$term,ignore.case = TRUE)
    
    poss_list<-df[idx,]
    
    best_pred<-as.character(poss_list[order(-term_freq)][1,1])
    next_word<-stri_split_fixed(best_pred,"_")[[1]][[wordcount(best_pred,"_")]]
    
    # check if prediction is NA, if so call function on subset of the word
    if(is.na(next_word)) {
        word_b<-word_backoff(word)
        next_word<-predict_next(word_b,s_tdf)
    }
    
    return(next_word)
}