  
knn_cluster <- function(course_id){
  
  library(RPostgreSQL)
  library(stopwords)
  library(clue)
  
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
  courses_sample  <- dbGetQuery(con, paste("SELECT * FROM courses WHERE id =", course_id))
  
  #load model & clusters information
  load("model.Rdata")
  id_clust = read.csv("id_clust.csv")
  
  #Prepare course info
  courses_sample$schedule_type = as.factor(courses_sample$schedule_type)
  courses_sample$sched_upcoming = ifelse(courses_sample$schedule_type=='upcoming', 1, 0)
  courses_sample$sched_self_paced = ifelse(courses_sample$schedule_type=='self_paced', 1, 0)
  courses_sample$sched_ended = ifelse(courses_sample$schedule_type=='ended', 1, 0)
  courses_sample$sched_active = ifelse(courses_sample$schedule_type=='active', 1, 0)
  courses_sample = courses_sample %>%
    select(-schedule_type)
  courses_sample$is_paid = ifelse(courses_sample$is_paid=='TRUE', 1, 0)
  courses_sample$is_certificate_issued = ifelse(courses_sample$is_certificate_issued=='TRUE', 1, 0)
  courses_sample$learners_count <- scale(courses_sample$learners_count, center = 5339.718, scale = 17070.37)
  courses_sample$time_to_complete <- scale(courses_sample$time_to_complete, center = 29879.25, scale = 41340.27)
  
  #Select features
  sel_sam <- courses_sample[,-c(1,2,4,5,9,10)]

  #Predict cluster
  clusters.predicted <- cl_predict(object = model, newdata = sel_sam)
  
  #Select similuar courses
  courses_recomend <- id_clust %>%
    filter(clust == clusters.predicted) %>%
    head()
  
  #Return coureses list 
  return(courses_recomend$id)
}
