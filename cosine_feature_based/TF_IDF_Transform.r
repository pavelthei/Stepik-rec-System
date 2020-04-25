transform_tf_idf <- function(courses_data, trash_freq = 0.95){
  #courses_data - dataset with courses (should have columns: title, summary, description)
  #trash_freq - the share of frequent words to delete
  library(readr)
  library(dplyr)
  library(stringr)
  library(tidytext)
  library(stopwords)
  library(tidyr)
  
  #filtering data
  courses = courses_data %>% dplyr::select(c(id, title, summary, description)) %>% na.omit()
  
  # combining all text columns into one
  all_text = as.data.frame(c(str_c(courses$title, courses$summary, courses$description, sep=" ")))
  colnames(all_text) = c("text")
  all_text$id = courses$id
  
  # cleaning from all trash
  all_text$text = all_text$text %>% str_to_lower() %>% str_replace_all("<(.*?)>", "") %>%  
    str_replace_all("[^A-Za-z0-9а-яА-Я+#ёЁйЙ -]+", " ") %>% str_squish()
  
  # lematization
  all_text$lem = system2("mystem", c("-c", "-l", "-d"), input=all_text$text, stdout=TRUE) %>% str_to_lower() %>% 
    str_replace_all("<(.*?)>", "") %>%  
    str_replace_all("[^A-Za-z0-9а-яА-Я+#ёЁйЙ -]+", " ") %>% str_squish()
  
  # Unnest tokens
  all_text_tidy = all_text %>% unnest_tokens(words, lem)
  
  #deleting stopwords
  rustopwords = data.frame(words=stopwords("ru"), stringsAsFactors=FALSE)
  enstopwords = data.frame(words=stopwords("en"), stringsAsFactors=FALSE)
  all_text_tidy = all_text_tidy %>% filter(!(words %in% c(stopwords("ru"),"это")))
  all_text_tidy = all_text_tidy %>% filter(!(words %in% enstopwords))
  
  # Deleting to frequent words
  words_count = all_text_tidy %>% 
    dplyr::count(words) 
  words_count = words_count %>% 
    filter(n < quantile(words_count$n, trash_freq))
  all_text_tidy = all_text_tidy %>% 
    filter(words %in% words_count$words)
  
  # Calculating td_idf for each word
  all_text_tidy_tfidf = all_text_tidy %>%
    dplyr::count(id, words) %>%  bind_tf_idf(words, id, n)
  
  # Spread the data
  all_text_tidy_tfidf = all_text_tidy_tfidf %>%
    dplyr::select(id, words, tf_idf) %>%
    spread(words, tf_idf, fill = 0) 
  
  return(all_text_tidy_tfidf)
}