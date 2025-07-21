analyze_var_cvar <- function(returns_path) {
  message("Analyzing VaR and CVaR data...")
  
  library(readxl)
  
  returns_data <- read_xlsx(returns_path)

  calculate_metrics <- function(returns, confidence_level = 0.95) {
    z_score <- qnorm(confidence_level)
    mean_ret <- mean(returns)
    sd_ret <- sd(returns)
    
    var_param <- -(mean_ret - sd_ret * z_score)
    # le agregamos un - porque el var se reporta como pérdida
    var_param_simple <- exp(var_param) - 1
    
    worst_returns <- returns[returns <= -var_param]
    
    cvar_historical <- mean(worst_returns)
    cvar_historical_simple <- exp(cvar_historical) - 1
    # convertimos ambos retornos de vuelta a simple para que se puedan
    # interpretar de mejor manera.
    
    return(list(VaR = var_param_simple, CVaR = -cvar_historical_simple))
  }
  
  metrics_acciones <- calculate_metrics(returns_data$acciones_usa_returns)
  metrics_snp <- calculate_metrics(returns_data$snp_returns)
  
  message("   --- Resultados del Fondo 'Acciones USA' ---")
  message(paste0("VaR (95%) Paramétrico: ",
                 scales::percent(metrics_acciones$VaR, accuracy = 0.01)))
  message(paste0("CVaR (95%) Histórico: ",
                 scales::percent(metrics_acciones$CVaR, accuracy = 0.01)))
  
  message("   --- Resultados del Benchmark 'S&P 500' ---")
  message(paste0("   VaR (95%) Paramétrico: ",
                 scales::percent(metrics_snp$VaR, accuracy = 0.01)))
  message(paste0("   CVaR (95%) Histórico: ",
                 scales::percent(metrics_snp$CVaR, accuracy = 0.01)))
  return(list(
    acciones_usa = metrics_acciones,
    snp_500 = metrics_snp
  ))
}
