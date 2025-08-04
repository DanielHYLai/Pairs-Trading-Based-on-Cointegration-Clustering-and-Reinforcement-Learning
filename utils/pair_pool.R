selected_stock_vec_Gen <- function(input_data) {
    
    selected_stock_vec <- c()
    
    for (idx in c(1:length(input_data))) {
        selected_stock_vec <- c(
            selected_stock_vec, 
            voting_member[[input_data[[idx]][2]]][[
                paste0(input_data[[idx]][3], "_minC")
            ]]
        )
    }
    
    return(selected_stock_vec)
}