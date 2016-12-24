
CreateDictionary = function(DictName,textfile,ngrams=4,saveRDS=TRUE,prune=TRUE){
    t<-Sys.time()
    print(paste0("Beginning to create dictionary:",t))
    text<-read_file(textfile)
    
    text_clean<-preprocess(x = text,
                           case = "lower",
                           remove.punct = TRUE,
                           remove.numbers = TRUE,
                           fix.spacing = TRUE)
    
    t1<-Sys.time()
    print(paste0("Finished Cleaning Text:",t1))
    
    Dict<-getNgram(text_clean,ngrams)
    
    t2<-Sys.time()
    print(paste0("Finished ngram creations:",t2))
    
    if(prune==T){
        Dict<-prune_dict(Dict)
    }
    
    if(saveRDS==T){
        saveRDS(Dict,paste0("./Data/Dictionaries/",DictName,".RDS"))
    }
    print(paste0("Time to generate and save dictionary:",as.numeric(Sys.time() -t, units = "mins")," minutes"))
    
    return(Dict)
    
    
}