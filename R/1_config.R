set_config <- function() {

  user <- Sys.getenv("SPULS_USER", "")
  if(user == "") user <- NULL

  password <- Sys.getenv("SPULS_PASSWORD", "")
  if(password == "") password <- NULL

  config$db_config <- list(
    driver = Sys.getenv("SPULS_DRIVER", "SQL Server"),
    server = Sys.getenv("SPULS_SERVER", "dm-prod"),
    db = Sys.getenv("SPULS_DB", "Sykdomspulsen_surv"),
    port = as.integer(Sys.getenv("SPULS_PORT", 1433)),
    user = user,
    password = password
  )

  config$folder_sykdomspulsen <- "F:/Prosjekter/Dashboards"
}
