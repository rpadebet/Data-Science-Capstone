#' Given a word/phrase and dictionary, this function
#' applies the markov chain rule and stupid backoff model
#' to predict the next word

predict_next<-function(word,dict,ngram_sep=" "){
    
    word<-stri_trans_tolower(word)
    count<-wordcount(word)
    word<-ifelse(count>3,word_backoff(word),word)
    new_word = FALSE
   
    
    word_p<-paste0(gsub(" ",ngram_sep,x = word),ngram_sep)
    df<-dict[ngram==count+1,.(term,term_freq)]
    idx<-grepl(pattern = word_p,df$term,fixed = TRUE)
    
    poss_list<-df[idx,]
    
    best_pred<-as.character(poss_list[order(-term_freq)][1,1])
    next_word<-stri_split_fixed(best_pred,ngram_sep)[[1]][[wordcount(best_pred,ngram_sep)]]
    
    # check if prediction is NA, if so call function on subset of the word
    if(is.na(best_pred)&&count>1) {
        word_b<-word_backoff(word)
        next_word<-predict_next(word_b,dict)
    }
    
    # if it is down to a unigram, then look for a match of the word closest and pick highest freq
    while(is.na(best_pred)&&count==1) {
        df<-dict[ngram==count,.(term,term_freq)]
        word_b<-char_backoff(word_p)
        expr<-paste0("^(",word_b,")[a-z]")
        idx<-grepl(pattern = expr,df$term,perl = TRUE)
        poss_list<-df[idx,]
        best_pred<-as.character(poss_list[order(-term_freq)][1,1])
        word_p<-word_b
        new_word = TRUE
    }
    
    # once the previous while loop is run, the next word is predicted using the
    # most likely version of the last word input
    if(is.na(best_pred)==FALSE && new_word==TRUE) {
        word_b<-best_pred
        next_word<-predict_next(word_b,dict)
    }
    
    
    
    return(next_word)
}