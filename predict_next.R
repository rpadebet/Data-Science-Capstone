predict_next<-function(word,s_tdf=tdf){
    ngram<-wordcount(word)
    word_p<-paste0(gsub(" ","_",x = word),"_")
    df<-s_tdf[s_tdf$ngram==ngram+1,]
    idx<-grep(pattern = word_p,df$term,ignore.case = TRUE)
    
    poss_list<-df[idx,]
    pred_list<-poss_list[poss_list$ngram==wordcount(word)+1,]
    pred_list_ord<-pred_list[order(pred_list$term_freq,decreasing = T),]
    
    best_pred<-pred_list_ord[1,1]
    next_word<-stri_split_fixed(best_pred,"_")[[1]][[wordcount(best_pred,"_")]]
    
    # check if prediction is NA, if so call function on subset of the word
    if(is.na(next_word)) {
        #print("backing")
        word_b<-word_backoff(word)
        next_word<-predict_next(word_b,s_tdf)
    }
    
    return(next_word)
}