rm(list=ls())
library(readxl)
library(lubridate)

snp <- read_xlsx(file.path(getwd(), "data/snp.xlsx"))
snp <- snp[c("date", "adj_close")]
colnames(snp) <- c("ref_date", "adj_close")
#el archivo con los valores cuota diarios del fondo lo descargué de la cmf
acciones_usa <- read_xlsx(file.path(getwd(), "data/fm_acciones_usa.xlsx"))
acciones_usa <- acciones_usa[c("Fecha", "Valor cuota")]
colnames(acciones_usa) <- c("ref_date", "nav_value")
snp$ref_date <- as_date(snp$ref_date)
acciones_usa$ref_date <- as_date(acciones_usa$ref_date)

library(dplyr)
joint_price_data <- as_tibble(acciones_usa %>%
  inner_join(snp, by = "ref_date")
)

#calculo retornos logarítmicos diarios
joint_price_data$snp_returns <- c(NA, diff(log(joint_price_data$adj_close)))
joint_price_data$acciones_usa_returns <- c(NA,
                                           diff(
                                             log(joint_price_data$nav_value)))

write_xlsx(joint_price_data, file.path(getwd(), "data/returns_data.xlsx"))
