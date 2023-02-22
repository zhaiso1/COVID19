require(DMwR)
require(randomForest)

VMM <- function(data, drug_name, smote = TRUE){
  # Data structure: Y (drug failure status), DRUG (combinatorial treatment category), X (features)
  # SMOTE for class imbalance
  if(smote == TRUE){
    data.smote <- double()
    for(i in 1:length(drug_name)){
      index <- which(data$DRUG == drug_name[i])
      datai <- data[index,]
      
      datai.smote <- SMOTE(Y ~ ., data = datai, K = 5)
      datai.smote <- datai.smote$data
      
      
      data.smote <- rbind.data.frame(data.smote, datai.smote)
    }
    data <- data.smote
  }
  
  # VMM
  y.mat <- double()
  for(i in 1:length(drug_name)){
    index <- which(data$DRUG == drug_name[i])
    datai <- data[index,]
    
    fit <- randomForest(as,factor(Y) ~ ., data = datai, importance=TRUE, ntree=1000, nodesize=3)
    y <- predict(fit, data, type = "prob"); y <- y[,2]
    
    y.mat <- cbind.data.frame(y.mat, y)
  }
  colnames(y.mat) <- drug_name
  
  y.mat
}


