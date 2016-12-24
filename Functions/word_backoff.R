
library(stringi)

#' Given a phrase, this function applies a stupid backoff model and 
#' returns a phrase with the first word removed

word_backoff<-function(word){
    word_split<-stri_split_fixed(word," ")
    length<-stri_count_words(word)
    word_rem<-word_split[[1]][2:length]
    word_backoff<-stri_join_list(as.list(word_rem),collapse = " ")
    return(word_backoff)
}

#' Given a word, this function applies a stupid backoff model and 
#' returns a word with the last character removed

char_backoff<-function(word){
    len<-stri_length(word)
    char_backoff<-stri_sub(stri_trans_tolower(word),from = 1,length = len-1)
    return(char_backoff)
}
