fetch_spx_data <- function(output_path) {
  message("-> Downloading S&P 500 data...")
  
  library(yahoofinancer)
  library(writexl)
  library(tibble)
  
  snp_500 <- yahoofinancer::Index$new('^SPX')
  snp_data <- snp_500$get_history(
    start = '2022-01-02',
    end = '2024-12-31',
    interval = '1d')
  
  df_snp <- as_tibble(snp_data)
  df_snp$adj_close <- as.numeric(df_snp$adj_close)
  
  write_xlsx(df_snp, path = output_path)
  message(paste("S&P data saved in: ", output_path))
  
  return(output_path)
}