# Import packages, custom functions, and setting
{
    library(ggplot2)
    library(readr)
    
    source("utils/clustering.R")
    source("utils/pair_pool.R")
    
    windowsFonts("Times New Roman" = windowsFont("Times New Roman"))
    options(warn = -1)
}

# Load data
{
    load("data/price.rData")
    load("data/test_result.rData")
    load("data/frequency_matrix.rData")
    load("data/voting.rData")
    
    train <- read_csv("data/train.csv", show_col_types = FALSE)
    test  <- read_csv("data/test.csv", show_col_types = FALSE)
    entropy_result <- read_csv("data/entropy_result.csv", show_col_types = FALSE)
}

# Part of selection of q
{
    entropy_result$highlight <- ifelse(
        entropy_result$x >= 0.1 & 
        entropy_result$x <= 0.2, "highlight", 
        "normal"
    )
    
    ggplot(entropy_result, aes(x = x, y = y)) + 
        geom_line(size = 1.5, color = "blue") + 
        geom_point(aes(color = highlight), size = 3) + 
        geom_hline(data = subset(entropy_result, x == 0.2), 
                   aes(yintercept = y), 
                   linetype = "dashed", size=1.5, color = "grey") +
        scale_color_manual(values = c("highlight" = "red", "normal" = "black"), guide = "none") +
        theme_minimal() + 
        labs(x = expression(italic("q")), y = expression(italic("H")[italic("q")])) + 
        theme(
            axis.title.x = element_text(size = 35, family = "Times New Roman"), 
            axis.title.y = element_text(size = 35, family = "Times New Roman"), 
            axis.text.x = element_text(size = 20, family = "Times New Roman", color = "black"), 
            axis.text.y = element_text(size = 20, family = "Times New Roman", color = "black")
        ) -> p; p
}

# Part of selection of K
{
    K_opt_list <- list()
    
    for (idx in names(threshold_FM_all)) {
        temp_FM <- threshold_FM_all[[idx]]
        temp_result <- clustering_method_Optimal(temp_FM, K = 6, seed = 1)
        K_opt_list[[idx]] <- temp_result
    }
}

# Part of voting member
{
    TFM_CvalueTB <- lapply(names(voting_member), function(name) {
        df <- voting_member[[name]][["criteria_value"]]
        df$source <- paste0("TFM_", name)
        
        return(df)
    }) %>% 
        do.call(rbind, .)
    
    CvalueTB <- TFM_CvalueTB
    row.names(CvalueTB) <- paste(CvalueTB$source, c("K=2", "K=3"), sep = "_")
    CvalueTB <- CvalueTB[, -5]
    
    selected_stock_vec <- c()
    for (name in names(CvalueTB)) {
        selected_stock_vec <- c(
            selected_stock_vec, 
            CvalueTB[CvalueTB[[name]] > median(CvalueTB[[name]]), ] %>% 
                row.names() %>% strsplit("_") %>% 
                selected_stock_vec_Gen(input_data = .)
        )
    }
}

# Figure for pair pool
{
    input_data = sort(table(selected_stock_vec), decreasing = TRUE)
    
    par(mar = c(5, 6, 2, 2))
    
    fig <- barplot(
        input_data,
        names.arg = rep("", length(input_data)),
        border = TRUE,
        col = adjustcolor("#46A3FF", alpha.f = 1),
        ylim = c(0, max(input_data) + 3),
        xlab = expression(italic("i")^"*"),
        ylab = expression(zeta(italic("X")[italic("i")^"*"])),
        cex.lab = 1.5,
        cex.axis = 1.2,
        cex.names = 1.2
    )
    
    abline(v = fig[61] + 0.3, col = "red", lty = 2, lwd = 2)
    
    text(x = fig[61], y = -0.5, labels = "61", col = "red", cex = 1.2, xpd = TRUE)
    
    unique_vals <- sort(unique(input_data))
    point_x <- c()
    point_y <- c()
    
    for (val in unique_vals) {
        idx <- which(input_data == val)
        last_idx <- tail(idx, 1)
        point_x <- c(point_x, fig[last_idx])
        point_y <- c(point_y, input_data[last_idx])
    }
    
    lines(point_x, point_y, type = "o", pch = 21, bg = "black", lwd = 2)
}
