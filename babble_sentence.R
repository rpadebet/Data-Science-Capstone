#' Given a starting word ,number of words in a sentence (default 7),
#' and relevant dictionary, this function babbles a sentence, 
#' each time predicting the next word from the words previously predicted

babble_sentence<-function(startWord,num_words=7,dict=tdf){
    
    sent<-startWord
    
     for(i in seq(1:num_words)){
        new_word<-predict_next(sent,dict)
        sent<-paste(sent,new_word)
     }
    
    print(sent)
}