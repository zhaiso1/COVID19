
sharp.null.test <- function(data, drug_name, nperm=1000, smote=TRUE){
  y.obs <- VMM(data, drug_name, smote)
  
  null.dist <- double()
  for (k in 1:nperm) {
    trt <- sample(data$DRUG, nrow(data), replace = FALSE)
    data.perm <- data
    data.perm$DRUG <- trt
    
    Y.MAT <- double()
    for (i in 1:100) {
      trt <- sample(data.perm$DRUG, nrow(data.perm), replace = FALSE)
      data.perm2 <- data.perm
      data.perm2$DRUG <- trt
      
      y.mat <- VMM(data.perm2, drug_name, smote)
      
      Y.MAT <- cbind.data.frame(Y.MAT, y.mat)
    }
    
    null.dist[k] <- sum(apply(Y.MAT, 1, var))
  }
  
  re <- list(distribution = null.dist, pvalue = mean(null.dist > y.obs))
  return(re)
}