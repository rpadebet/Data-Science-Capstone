word_backoff<-function(word){
    word_split<-stri_split_fixed(word," ")
    length<-wordcount(word," ")
    word_rem<-word_split[[1]][2:length]
    word_backoff<-stri_join_list(as.list(word_rem),collapse = " ")
}
