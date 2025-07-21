rm(list=ls())
getwd()
source(file.path(getwd(), "entrega_2/R/01_fetch_data.R"))
source(file.path(getwd(), "entrega_2/R/02_calc_returns.R"))
source(file.path(getwd(), "entrega_2/R/03_var_cvar.R"))
source(file.path(getwd(), "entrega_2/R/04_tracking_error.R"))
source(file.path(getwd(), "entrega_2/R/05_visualization.R"))

acciones_raw_path <- "data/raw/fm_acciones_usa.xlsx"
snp_raw_path      <- "data/raw/snp.xlsx"
returns_proc_path <- "data/processed/returns_data.xlsx"

 # Paso 1: Obtener datos del S&P
fetch_spx_data(output_path = snp_raw_path)

 # Paso 2: Calcular retornos
calc_log_returns(
  acciones_path = acciones_raw_path,
  snp_path = snp_raw_path,
  output_path = returns_proc_path
)

 # Paso 3: Analizar VaR y CVaR
var_cvar <- analyze_var_cvar(returns_path = returns_proc_path)
# El VaR del fondo y del índice son muy parecidos. Tienen una diferencia de 1bp
# Por otro lado, el CVaR si tiene una diferencia más grande, de casi 20 bp.

 # Paso 4: Calcular Tracking Error del fondo
tracking_error <- calc_tracking_error(returns_path = returns_proc_path)
# Un tracking error de 1.01% diario es muy alto. En este caso, esto se explica
# porque el fondo invierte en USA pero paga aportes y rescates en pesos, por
# lo que es un tracking error "sucio" que incluye el tipo de cambio

plot_tracking_error_diff(returns_proc_path)
