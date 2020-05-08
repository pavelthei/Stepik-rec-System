getCourses <- function(coursesId, n){
  cours = filter(courses,id %in% coursesId)
  
  if (nrow(cours)==0) {
    recommend = "Python" # пока так, чтобы не удалять условие
  } else {
    mostSimilar = head(sort(sim2[,as.character(cours$id)], decreasing = T), n)
    a = which(sim2[,as.character(cours$id)] %in% mostSimilar, arr.ind = TRUE)
    rows = a %% dim(sim2)[1]
    result = rownames(sim2)[rows]
    recommend = filter(courses,id %in% result) %>% dplyr::select(title)
  }
  
  return(recommend)
}