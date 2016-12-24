#' Given a word/phrase and dictionary, this function
#' applies the markov chain rule and stupid backoff model
#' to predict the next word

predict_next<-function(word,dict,ngram_sep=" "){
    
    word<-stri_trans_tolower(word)
    count<-wordcount(word)
    word<-ifelse(count>3,word_backoff(word),word)
   
    
    word_p<-paste0(gsub(" ",ngram_sep,x = word),ngram_sep)
    df<-dict[ngram==count+1,.(term,term_freq)]
    idx<-grepl(pattern = word_p,df$term,fixed = TRUE)
    
    poss_list<-df[idx,]
    
    best_pred<-as.character(poss_list[order(-term_freq)][1,1])
    next_word<-stri_split_fixed(best_pred,ngram_sep)[[1]][[wordcount(best_pred,ngram_sep)]]
    
    # check if prediction is NA, if so call function on subset of the word
    if(is.na(best_pred)) {
        word_b<-word_backoff(word)
        next_word<-predict_next(word_b,dict)
    }
    
    
    return(next_word)
}