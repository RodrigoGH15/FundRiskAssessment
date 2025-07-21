plot_tracking_error_diff <- function(returns_path) {
  message("-> Generating Plot...")
  
  library(readxl)
  library(ggplot2)
  library(dplyr)
  
  returns_data <- read_xlsx(returns_path)
  
  returns_data <- returns_data %>%
    mutate(diff_returns = acciones_usa_returns - snp_returns)
  returns_data_sub <- returns_data %>%
    filter(row_number() %% 5 == 1)
  # Tuve que hacer sampling porque eran demasiados datos y era difícil ver el 
  # gráfico
  
  p <- ggplot() +
    geom_line(data = returns_data_sub, aes(x = ref_date, y = diff_returns), 
              color = "darkred", size = 0.7) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
    labs(
      title = "Diferencia de Retornos Diarios: FM Acciones USA vs S&P 500",
      x = "Fecha",
      y = "Diferencia de retornos (log)"
    ) +
    theme_minimal()
  
  print(p)
}
