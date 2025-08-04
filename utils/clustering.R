# Import packages
{
    library(cluster)
    library(clusterSim)
    library(dplyr)
    library(fpc)
    library(SNFtool)
}

# Calculate the PSI index
PSI_index <- function(mat_normalized, cluster) {
    
    group <- cluster
    ordered_indices  <- order(group)
    reordered_matrix <- mat_normalized[ordered_indices, ordered_indices]

    C      <- list()
    mean_1 <- c()
    l      <- c()
    
    for (idx in 1:length(unique(group))) {
        C[[idx]] <- as.matrix(
            log(
                reordered_matrix[
                    (length(which(group <= idx - 1)) + 1):length(which(group <= idx)), 
                    (length(which(group <= idx - 1)) + 1):length(which(group <= idx))
                ]
            )
        )
        diag(C[[idx]]) <- 0
        mean_1[idx]    <- sum(C[[idx]])
        l[idx] <- length(C[[idx]])
    }

    compute <- reordered_matrix
    logcompute <- log(compute)
    
    for (idx in 1:length(unique(group))) {
        logcompute[
            (length(which(group <= idx - 1)) + 1):length(which(group <= idx)), 
            (length(which(group <= idx - 1)) + 1):length(which(group <= idx))
        ] <- 0
    }
    
    logical_index <- row(logcompute) < col(logcompute)
    result <- logcompute[logical_index]
    sum_2  <- sum(result)
    
    logical_index <- row(logcompute) > col(logcompute)
    result <- logcompute[logical_index]
    sum_3  <- sum(result)
    
    d <- (sum(mean_1) / (sum(l) - ncol(mat_normalized))) / 
        ((sum_2 + sum_3) / (length(logcompute) - sum(l)))
    
    return(1 / d)
}

# Calculate the values of clustering criteria
cluster_criteria_Calculator <- function(df, result) {
    
    SS  <- round(silhouette(result, dist(df))[, 3] %>% mean(), 2)
    CHI <- round(calinhara(x = df, clustering = result), 2)
    DBI <- round(index.DB(x = df, cl = result)$DB, 2)
    PSI <- round(PSI_index(
        mat_normalized = affinityMatrix(df, K = length(unique(result))), 
        cluster = result
    ), 2)
    
    return(list(SSI = SS, CHI = CHI, DBI = DBI, PSI = PSI))
}

# Find the optimal cluster numbers
clustering_method_Optimal <- function(df, K, seed = NULL) {

    if (is.null(seed) == FALSE) {
        set.seed(seed = seed)
    }

    criteria_result <- matrix(0, nrow = K - 1, ncol = 4)

    dist_matrix <- stats::dist(df, method = "euclidean")
    temp_hc <- stats::hclust(d = dist_matrix, method = "complete")
    
    for (num in c(2:K)) {
        
        temp_model <- cutree(temp_hc, k = num)
        temp_criteria <- cluster_criteria_Calculator(
            df = df, result = temp_model
        )

        for (col_idx in c(1:length(temp_criteria))) {
            criteria_result[num - 1, col_idx] <- temp_criteria[[col_idx]]
        }
    }
    
    criteria_result <- as.data.frame(criteria_result)
    row.names(criteria_result) <- paste("Num =", c(2:K))
    names(criteria_result) <- names(temp_criteria)
    
    return(criteria_result)
}
