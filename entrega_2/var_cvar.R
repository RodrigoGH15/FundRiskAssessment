rm(list=ls())
library(readxl)
returns_data = read_xlsx(file.path(getwd(), "data/returns_data.xlsx"))
returns_data <- na.omit(returns_data)
#grafico los retornos diarios del fondo
hist(returns_data$acciones_usa_returns,
     breaks = 50,
     main = "Distribución de los Retornos", 
     xlab = "Retornos Log",
     col = "lightblue",
     border = "black")
# el histograma tiene forma de campana por lo que puedo usar el método
# paramétrico para calcular el var. Los tests siempre son muy exigentes
acciones_usa_mean_variance <- c(
  mean(returns_data$acciones_usa_returns),
  var(returns_data$acciones_usa_returns))
z_score <- qnorm(0.95)

acciones_usa_var <-
  acciones_usa_mean_variance[1] - sqrt(acciones_usa_mean_variance[2]) * z_score
acciones_usa_var
# obtengo un value at risk de 1.775%, que indica que en un día normal puedo
# llegar a perder un 1.775% con un 95% de confianza

worst_returns <- returns_data$acciones_usa_returns[
  returns_data$acciones_usa_returns <= acciones_usa_var]

# El var condicional es el promedio de las pérdidas que superaron el VaR
cvar_historical <- mean(worst_returns)
cvar_historical
# obtengo un VaR condicional de 2,397%, que indica que en el peor 5% de los
# casos puedo perder un 2,4% de mi inversión

#comparación con el s&p
snp_mean_variance <- c(
  mean(returns_data$snp_returns),
  var(returns_data$snp_returns))

snp_var <- snp_mean_variance[1] - z_score * sqrt(snp_mean_variance[2])
snp_var # VaR de 1,788%, muy parecido al del fondo

worst_returns_snp <- returns_data$snp_returns[
  returns_data$snp_returns <= snp_var]

cvar_historical_snp <- mean(worst_returns_snp)
cvar_historical_snp # cvar de 2,59%. Es mayor al del fondo.
