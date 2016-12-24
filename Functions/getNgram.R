## Given a text file( as single character ) and the number of n-grams
## this function generates a data.table with all n-grams<n with frequencies

getNgram<- function(text,n){
    ngram_data_table = data.table(NULL)
    for (i in 1:n){
        ngram_table<-ngram(text,n = i,sep = " ")
        ngram_data_table_temp<-get.phrasetable(ngram_table)
        ngram_data_table_temp$term<-trimws(ngram_data_table_temp$ngrams,"r")
        ngram_data_table_temp$ngrams<-NULL
        ngram_data_table<-data.table(rbind(ngram_data_table,ngram_data_table_temp))
    }
    ngram_data_table[,ngram:=wordcount(term," "),by=term]
    setnames(ngram_data_table,"freq","term_freq")

    return(ngram_data_table)
}


prune_dict<-function(dict){
    dict<-rbind(dict[ngram==4,][term_freq>2],
                dict[ngram==3,][term_freq>1],
                dict[ngram<=2,])
}