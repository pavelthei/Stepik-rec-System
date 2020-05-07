UB_IB_recommender <- function(user_id, n_rec = 6){
  
  #### BEFORE APPLYING CHECK IF THE FUNCTION PARAMS SUIT TO TRAINED MODEL ###
  
  # Importing libraries 
  library(dplyr)
  library(tidyverse)
  library(tidyr)
  library(recommenderlab)
  
  # Creating connection to DB
  require("RPostgreSQL")
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, dbname = 'stepik_api',
                   host = 'stepik-bd.c2hf8kenf8dw.us-east-1.rds.amazonaws.com', port = 5432,
                   user = 'stepik_master', password = 'Stepikpa$$word')
  on.exit(dbDisconnect(con))
  # Get Data
  reviews = dbGetQuery(con, "SELECT course_id, user_id, score FROM reviews")
  
  # Check if the user id in the base
  if (!(user_id %in% unique(reviews$user_id))){
    return("User ID is not in the base")
  }
  # Transforming data
  reviews = spread(reviews, key = course_id, value = score)
  reviews = as.data.frame(reviews)
  rownames(reviews) = reviews$user_id
  reviews = reviews %>% dplyr::select(-user_id)
 
  reviews = as(as.matrix(reviews), "realRatingMatrix")

  #filtering data
  reviews = reviews[rowCounts(reviews) > 2, colCounts(reviews) > 5] 
  reviews = reviews[rownames(reviews) == user_id, ]

  model = readRDS(file='UB_IB_Model.rda')
  predicted = predict(object = model, newdata = reviews, n = n_rec)
  pr = predicted@itemLabels[predicted@items[[1]]]
  
  if (length(pr) > 0){
    return(pr)
  }
  else{
    return("No predictions")
  }
}


