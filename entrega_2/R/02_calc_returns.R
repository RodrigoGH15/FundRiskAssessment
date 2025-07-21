calc_log_returns <- function(acciones_path, snp_path, output_path) {
  message("-> Calculating log returns...")
  
  library(readxl)
  library(dplyr)
  library(lubridate)
  
  acciones_usa <- read_xlsx(acciones_path) %>%
    select(ref_date = Fecha, nav_value = `Valor cuota`) %>%
    mutate(ref_date = as_date(ref_date))
  
  snp <- read_xlsx(snp_path) %>%
    select(ref_date = date, adj_close) %>%
    mutate(ref_date = as_date(ref_date))
  
  joint_data <- inner_join(acciones_usa, snp, by = "ref_date")
  
  returns_data <- joint_data %>%
    mutate(
      snp_returns = c(NA, diff(log(adj_close))),
      acciones_usa_returns = c(NA, diff(log(nav_value)))
    ) %>%
    na.omit()
  
  write_xlsx(returns_data, path = output_path)
  message(paste("Returns data saved in: ", output_path))
  
  return(output_path)
}