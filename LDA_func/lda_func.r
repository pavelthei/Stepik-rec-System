
lda_clust <- function(id_course, show_title = TRUE){

library(RPostgreSQL)
library(stopwords)
library(topicmodels)
library(tm)
library(tidytext)
library(reshape2)
library(dplyr)
library(readr)
library(stringr)
library(stopwords)

#Create connection
pw <- {
  'Stepikpa$$word'
}

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = 'stepik_api',
                 host = 'stepik-bd.c2hf8kenf8dw.us-east-1.rds.amazonaws.com', port = 5432,
                 user = 'stepik_master', password = pw)
rm(pw)

#Download course information
courses_sample  <- dbGetQuery(con, paste("SELECT * FROM courses WHERE id =", id_course))

load("lda.Rdata")
id_topic = read.csv("id_topics.csv")

courses_sample = courses_sample %>% dplyr::select(c(id, title, description)) %>% na.omit()

all_text = as.data.frame(c(str_c(courses_sample$title, courses_sample$description, sep=" ")))
colnames(all_text) = c("text")
all_text$id = courses_sample$id

all_text$text = all_text$text %>% str_to_lower() %>% str_replace_all("<(.*?)>", "") %>%  
  str_replace_all("[^A-Za-z0-9а-яА-Я+#ёЁйЙ -]+", " ") %>% str_squish()

all_text$lem = system2("mystem", c("-c", "-l", "-d"), input=all_text$text, stdout=TRUE) %>% str_to_lower() %>% 
  str_replace_all("<(.*?)>", "") %>%  
  str_replace_all("[^A-Za-z0-9а-яА-Я+#ёЁйЙ -]+", " ") %>% str_squish()

corpus<-Corpus(VectorSource(all_text$lem))

dtm <- DocumentTermMatrix(corpus)

result <- posterior(ap_lda, dtm)
result <- apply(result$topics, 1, which.max)

if (show_title == TRUE){
courses_recomend <- id_topic %>%
  filter(topics == result) %>%
  select(id, title) %>%
  head() 
} else {
  courses_recomend <- id_topic %>%
    filter(topics == result) %>%
    select(id) %>%
  head()
}

return(courses_recomend)

}
