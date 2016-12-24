#' Given a phrase, this function applies a stupid backoff model and 
#' returns a phrase with the first word removed

word_backoff<-function(word){
    word_split<-stri_split_fixed(word," ")
    length<-wordcount(word," ")
    word_rem<-word_split[[1]][2:length]
    word_backoff<-stri_join_list(as.list(word_rem),collapse = " ")
    return(word_backoff)
}
