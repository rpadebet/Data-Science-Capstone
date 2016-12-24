
CreateDictionary = function(DictName,textfile,ngrams=4,saveRDS=TRUE,prune=TRUE){
    text<-read_file(textfile)
    
    text_clean<-preprocess(x = text,
                           case = "lower",
                           remove.punct = TRUE,
                           remove.numbers = TRUE,
                           fix.spacing = TRUE)
    
    Dict<-getNgram(text_clean,ngrams)
    
    
    if(prune==T){
        Dict<-rbind(Dict[ngram>2,][term_freq>1],
                    Dict[ngram<=2,])
    }
    
    if(saveRDS==T){
        saveRDS(Dict,paste0("./Data/Dictionaries/",DictName,".RDS"))
    }
    return(Dict)
    
}