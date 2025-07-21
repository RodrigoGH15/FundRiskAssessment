#uso yahoofinancer para descargar los datos del s&p 500
snp_500 <- yahoofinancer::Index$new('^SPX')
snp_data <- snp_500$get_history(start = '2022-01-02',
                                end = '2024-12-31',
                                interval = '1d')
df_snp <- as_tibble(snp_data)
df_snp$adj_close <- as.numeric(df_snp$adj_close)
write_xlsx(df_snp, path = file.path(getwd(), "data/snp.xlsx"))
