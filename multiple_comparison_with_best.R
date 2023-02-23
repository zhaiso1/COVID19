
MCB <- function(data, drug_name, effect_modifier, nrep=1000, prob_range=c(0.025,0.975), smote = TRUE){
  # extract patient subgroup based on selected effect modifiers
  INDEX <- extract_subgroup(data, effect_modifier)
  
  y.obs <- VMM(data, drug_name, smote); y.obs <- y.obs[INDEX,]
  prob.obs <- apply(y.obs, 2, mean)
  mcb.obs <- generate.mcb(prob.obs)
  
  # bootstrap for null distribution
  PROB.boot <- matrix(NA, ncol = ncol(y.obs), nrow = nrep)
  MCB.boot <- matrix(NA, ncol = ncol(y.obs), nrow = nrep)
  
  for (k in 1:nrep) {
    print(k)
    tryCatch({
      # bootstrap from the original data
      index.boot0 <- double() 
      for (dd in 1:length(drug_name)) {
        index.cand <- which(data$DRUG == drug_name[dd])
        index.boot <- sample(index.cand, length(index.cand), replace = TRUE)
        index.boot0 <- c(index.boot0, index.boot)
      }
      data.boot <- data[index.boot0,]
      
      # repeat VMM
      INDEX.boot <- extract_subgroup(data.boot, effect_modifier)
      y.boot <- VMM(data.boot, drug_name, smote); y.boot <- y.boot[INDEX.boot,]
      
      PROB.boot[k,] <- apply(y.boot, 2, mean)
      
      for (j in 1:length(drug_name)) {
        MCB.boot[k,j] <- PROB.boot[k,j] - min(PROB.boot[k,-j])
      }
    }, error=function(e){})
  }
  
  colnames(PROB.boot) <- drug_name; colnames(MCB.boot) <- drug_name
  
  # calculate nonparametric bootstrap percentile confidence interval
  Delta.boot <- matrix(NA, ncol = ncol(MCB.boot), nrow = nrep)
  for (j in 1:length(drug_name)) {
    Delta.boot[,j] <- MCB.boot[,j] - mcb.obs[j]
  }
  colnames(Delta.boot) <- drug_name
  
  delta.lb <- delta.ub <- double()
  
  for (j in 1:length(drug_name)) {
    cand <- sort(Delta.boot[,j])
    
    delta.ub[j] <- quantile(cand, probs = prob_range[1])
    delta.lb[j] <- quantile(cand, probs = prob_range[2])
  }
  
  re0 <- cbind.data.frame(est = mcb.obs,
                          lwr = mcb.obs - delta.lb,
                          upr = mcb.obs - delta.ub)
  
  rownames(re0) <- drug_name
  return(re0)
}

# generate MCB point estimate
generate.mcb <- function(prob.obs){
  mcb.obs <- double()
  for (i in 1:length(prob.obs)) {
    mcb.obs[i] <- prob.obs[i] - min(prob.obs[-i])
  }
  return(mcb.obs)
}


# extract patient subgroup based on selected effect modifiers
extract_subgroup <- function(data, effect_modifier){
  INDEX <- 1:nrow(data)
  for (i in 1:nrow(effect_modifier)) {
    name <- rownames(effect_modifier)[i]
    x <- data[,which(colnames(data) == name)]
    index <- which(x > effect_modifier[i,1] & x < effect_modifier[i,2])
    INDEX <- intersect(INDEX, index)
  }
  INDEX
}


