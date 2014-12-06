 data$cohorts_all <- apply(data[1:last_filter_ind], 1, paste, collapse="//")
 lcohort <- lapply(strsplit(x=data$cohorts_all, split="//"), function(x) sapply(x, function(y)y))    
 cohorts_all<- do.call(rbind.data.frame, lcohort)
 names(cohorts_all) <- names

