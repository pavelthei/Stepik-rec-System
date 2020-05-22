cosine <- function(path_to_save="./"){
  library(readr)
  library(dplyr)
  library(stringr)
  library(tidyverse)
  require("RPostgreSQL")
  
  # Getting courses data
  pw <- {
    'Stepikpa$$word'
  }
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, dbname = 'stepik_api',
                   host = 'stepik-bd.c2hf8kenf8dw.us-east-1.rds.amazonaws.com', port = 5432,
                   user = 'stepik_master', password = pw)
  rm(pw)
  courses <- dbGetQuery(con, "SELECT * from courses")
  
  # Managing data
  co2 = courses %>%
    select(id, is_certificate_issued, description, schedule_type, learners_count, quizzes_count, time_to_complete, language, title, is_paid)
  co2[5:7] = scale(co2[,5:7])
  # Language
  co2$en = ifelse(co2$language=="en", 1, 0)
  co2$ru = ifelse(co2$language=="ru", 1, 0)
  co2 = co2 %>%
    select(-language)
  # Schedule type
  co2$schedule_type = as.factor(co2$schedule_type)
  co2$sched_upcoming = ifelse(co2$schedule_type=='upcoming', 1, 0)
  co2$sched_self_paced = ifelse(co2$schedule_type=='self_paced', 1, 0)
  co2$sched_ended = ifelse(co2$schedule_type=='ended', 1, 0)
  co2$sched_active = ifelse(co2$schedule_type=='active', 1, 0)
  co2 = co2 %>%
    select(-schedule_type)
  # Description
  co2$description = str_replace_all(co2$description, "[a-z]", "")
  co2$description = str_replace_all(co2$description, "[[:punct:]]", "")
  co2$description = str_replace_all(co2$description, "<>", "")
  # Getting TF-IDF
  source("~/Stepik-rec-System/cosine_feature_based/TF_IDF_Transform.r")
  aa = transform_tf_idf(co2)
  aa = distinct(aa)
  co2 = co2 %>%
    select(-description, -title)
  
  new_co = left_join(aa, co2, by = 'id')
  
  # Making cosine matrix
  rownames(new_co) = new_co$id
  co = new_co %>% dplyr::select(-id)
  sim2 = lsa::cosine(t(as.matrix(co)))
  diag(sim2) = 0
  write.table(sim2, paste(path_to_save, 'cosine_matrix.txt'))
  
}


cosine("~/Stepik-rec-System/cosine_feature_based/")

