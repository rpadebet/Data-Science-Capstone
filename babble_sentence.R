#' Given a starting word and the number of words in a sentence (default 7),
#' the function babbles a sentence, each time predicting the next word from,
#' the words previously predicted

babble_sentence<-function(startWord,num_words=7){
    
    sent<-startWord
    
     for(i in seq(2:num_words)){
        next_word<-predict_next(sent)
        sent<-paste(sent,next_word)
     }
    
    print(sent)
}