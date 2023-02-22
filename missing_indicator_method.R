
MIM <- function(data.X) {
  data.X.new <- double()
  for (i in 1:ncol(data.X)) {
    name0 <- colnames(data.X)[i]
    
    Xi <- data.X[,i] # original feature
    I.Xi <- rep(0, length(c1)) # missing indicator
    index <- which(is.na(Xi) == TRUE)
    I.Xi[index] <- 1 # "1" if missing
    Xi[index] <- 0 # replace "NA" by an arbitrary value, say "0"
    
    X.mat <- cbind(Xi,I.Xi)
    colnames(X.mat) <- c(name0, paste0("I.",name0))
    
    data.X.new <- cbind.data.frame(data.X.new, X.mat)
  }
  data.X.new
}
