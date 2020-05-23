library(readr)
library(dplyr)
library(stringr)
library(tidyverse)

################################
require("RPostgreSQL")
pw <- {
  'Stepikpa$$word'
}

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = 'stepik_api',
                 host = 'stepik-bd.c2hf8kenf8dw.us-east-1.rds.amazonaws.com', port = 5432, user = 'stepik_master', password = pw)
rm(pw)
cou_with_rev <- dbGetQuery(con, "SELECT * FROM courses_cluster LEFT JOIN courses_cover ON courses_cluster.id = courses_cover.course_id")
dbDisconnect(con)

cou_with_rev <- as.data.frame(cou_with_rev)

################################
themesW <- cou_with_rev %>%
  group_by(theme) %>%
  summarise(cluster_x = min(cluster_x))
themesW = themesW %>% 
  filter(cluster_x != 1) %>% 
  filter(cluster_x != 13) %>% 
  filter(cluster_x != 14) %>% 
  filter(cluster_x != 6)

input <- 0
time <- 0
pay <- 0
################################
time = c('От 1 до 4 дней', 'От 4 дней до полутора недель', 'От полутора недель до 3 недель', 'От 3 недель до полутора месяцев', 'От полутора месяцев и больше')
m1 <- matrix(time, ncol=1, byrow=TRUE)
d1 <- as.data.frame(m1, stringsAsFactors=FALSE)
d1$time = d1$V1
times = d1 %>%
  select(-V1)

################################
getColdStart <- function(coursesId, subjects, time, pay, n){
  if (length(coursesId) == 0) {
    # input - переменная выбора пользователя для тематики курса
    
    # time - выбора пользователя для длительности курса. Вводит 1 из 5 вариантов
    # По этим параметрам проверять длительность курса
    # От 1 до 4 дней [0; 5760]
    # От 4 дней до полутора недель [5760; 14400]
    # От полутора недель до 3 недель [14400; 30240]
    # От 3 недель до полутора месяцев [30240; 60480]
    # От полутора месяцев и больше [60480; дальше]
    
    # pay - выбора пользователя для платного/бесплатного курса. Вводит да/нет на вопрос "Готовы ли Вы платить за прохождение курса?". Надо чтобы ответ был переформатирован в TRUE/FALSE
    
    if (!(as.logical(pay))){
      recommended = cou_with_rev %>% filter(is_paid == as.logical(pay))
    } else {
      recommended = cou_with_rev 
    }
    
    recommended = recommended %>% # cou_with_rev - датасет с курсами + ср оценками + темтиками
      filter(theme == subjects) %>%
      filter(time_completion == time) %>%
      arrange(-mean_rating) %>%
      head(n) %>% 
      select(title, is_paid, id, cover)
    
  } 
  return(recommended)
}


################################
getCourse <- function(coursesId, n){
  left = coursesId[coursesId %in% cou_with_rev$id]
  cours = dplyr::filter(cou_with_rev, id %in% c(coursesId))
  if (length(left) != 0) {
    if (nrow(cours) != 0) {
      # достаем нужные матрицы косинусных расстояний, проводим рекомендацию
      clusters = cours %>% select(cluster_x) %>% distinct()
      #list_recom = list()
      recs <- data.frame(id = integer(),
                         title=character(), 
                         mean_rating=numeric(), 
                         stringsAsFactors=FALSE,
                         cover=character()) 
      for (i in clusters$cluster_x) {
        way2matr = paste(paste("./check_mtrx/sim", as.character(i), sep=""), ".txt", sep="")
        sim_i = as.matrix(read.table(way2matr))
        cou_i = cours %>% filter(cluster_x == i)
        # теперь не cours, а курсы принадл к каждому кластеру отдельно
        # new.variable.v <- cou_i$id
        # length(new.variable.v)
        mostSimilar = head(sort(sim_i[,paste("X", as.character(cou_i$id), sep="")], decreasing = T), n) 
        # заменить n на пропорцию - 2 курса из одного кластера -> реком 2 курса
        a = which(sim_i[,paste("X", as.character(cou_i$id), sep="")] %in% mostSimilar, arr.ind = TRUE)
        rows = a %% dim(sim_i)[1]
        result = rownames(sim_i)[rows]
        recommend_i = filter(cou_with_rev,id %in% result) %>% dplyr::select(id, title, mean_rating, cover)
        # хотим рекомендовать пропорциональное количество курсов из каждого кластера
        # list_recom = append(list_recom, recommend_i)
        recs = rbind(recs, recommend_i)
      }
      print(recs)
      # recom <- data.frame(matrix(unlist(list_recom), nrow=length(list_recom), byrow=T),stringsAsFactors=FALSE)
      # recom2 <- as.data.frame(t(as.matrix(recom))) 
      recommended = recs %>% arrange(-mean_rating) %>% head(n) %>% select(title, id, cover)
    }
    
  }else{
    if (length(coursesId) != 0) {
      recommended = c("Извините, введенный Вами курс отсутствует в базе :(\n")
    } 
  }
  return(recommended)
  print(recommended)
}
