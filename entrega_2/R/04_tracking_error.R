calc_tracking_error <- function(returns_path) {
  message("-> Calculating Tracking Error...")
  
  library(readxl)
  library(dplyr)
  
  returns_data <- read_xlsx(returns_path)
  
  returns_data <- returns_data %>%
    mutate(diff_returns = acciones_usa_returns - snp_returns)
  mean_log_returns <- mean(returns_data$diff_returns)
  mean_simple_returns <- exp(mean_log_returns) - 1
  log_var_returns <- var(returns_data$diff_returns)
  tracking_error_simple <- (1 + mean_simple_returns) *
    sqrt(exp(log_var_returns) - 1)
  # al igual que con var y cvar trasformamos el resultado de vuelta a simple.
  # eso sí, acá la transformación es más complicada
  message(paste0("Tracking Error diario: ",
                 scales::percent(tracking_error_simple, accuracy = 0.01)))
  message(paste0("Tracking Error anualizado: ",
                 scales::percent(tracking_error_simple * sqrt(252),
                                 accuracy = 0.01)))
  
  return(tracking_error_simple)
}
