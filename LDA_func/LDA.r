

library(topicmodels)
library(tm)
  
courses = courses_sample %>% dplyr::select(c(id, title, description)) %>% na.omit()

all_text = as.data.frame(c(str_c(courses$title, courses$description, sep=" ")))
colnames(all_text) = c("text")
all_text$id = courses$id

all_text$text = all_text$text %>% str_to_lower() %>% str_replace_all("<(.*?)>", "") %>%  
  str_replace_all("[^A-Za-z0-9а-яА-Я+#ёЁйЙ -]+", " ") %>% str_squish()

all_text$lem = system2("/home/yurii/snap/mystem-3.1-linux-64bit/mystem", c("-c", "-l", "-d"), input=all_text$text, stdout=TRUE) %>% str_to_lower() %>% 
  str_replace_all("<(.*?)>", "") %>%  
  str_replace_all("[^A-Za-z0-9а-яА-Я+#ёЁйЙ -]+", " ") %>% str_squish()

corpus<-Corpus(VectorSource(all_text$lem))

dtm <- DocumentTermMatrix(corpus, control = list(stopwords = c(stopwords("ru"),stopwords("en"),"will","основной","основа","обучение","весь","учебный","школа","класс","мочь", "type","types","тип", "can", "com", "это","наставник","тест","вуз","наш","каждый","курс","http","https","язык","org","свой","задача","course","также","урок","работа","тема","stepik","модуль","задание","который")))

# можешь поменять значение k это количество топиков 
ap_lda <- LDA(dtm, k = 30, control = list(seed = 1234))
ap_lda

library(tidytext)
library(reshape2)

ap_topics <- tidytext::tidy(ap_lda, matrix = "beta")
ap_topics

library(ggplot2)
library(dplyr)

ap_top_terms <- ap_topics %>%
  group_by(topic) %>%
  top_n(15, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

ap_top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered()

ap_topics

save(ap_lda,file = "/home/yurii/Документы/Ucheba/stepik_project/LDA/lda.Rdata")
courses_sample$topics <- topics(ap_lda)
courses_sample <- select(courses_sample, id, title, topics)
write.csv(courses_sample,"/home/yurii/Документы/Ucheba/stepik_project/LDA_func/id_topics.csv")
