##' This function is used to generate the dictionary of ngrams from a given
##' text file. 
##' 
##' 
##' "DictName": argument specifes the name of the dictionary to save as
##' "textfile": argument specifies the path to the text file
##' "ngrams":   argument specifies the maximum number of ngrams to generate.
##' "saveRDS":  argument specifies whether the dictionary needs to be saved to 
##'             the local files system.
##' "prune" :   argument specifies if the dictionary needs to be pruned before saving           

library(readr)
library(ngram)
library(data.table)

source('./Functions/getNgram.R')

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


prune_dict<-function(dict){
    dict<-rbind(dict[ngram >2,][term_freq>1],
                dict[ngram<=2,])
}