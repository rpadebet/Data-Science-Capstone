predict_next<-function(word,tdf){
    word_p<-paste0(gsub(" ","_",x = word),"_")
    idx<-grep(pattern = word_p,tdf$term,ignore.case = TRUE)
    
    poss_list<-tdf[idx,]
    pred_list<-poss_list[poss_list$ngram==wordcount(word)+1,]
    pred_list_ord<-pred_list[order(pred_list$term_freq,decreasing = T),]
    
    best_pred<-pred_list_ord[1,1]
    predict_next<-stri_split_fixed(best_pred,"_")[[1]][[wordcount(best_pred,"_")]]
    return(predict_next)
}