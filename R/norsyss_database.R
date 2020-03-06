#' Connect to NorSySS database
#' @export
norsyss_connect <- function(){
  if (.Platform$OS.type == "windows") {
    con <- RODBC::odbcDriverConnect("driver={Sql Server};server=dm-prod;database=SykdomspulsenAnalyse; trusted_connection=yes")
  } else {
    con <- RODBC::odbcDriverConnect("driver={ODBC Driver 17 for SQL Server};server=dm-prod;database=SykdomspulsenAnalyse; trusted_connection=yes")
  }
  return(con)
}

#' Download raw data from NorSySS database
#' @param con DB connection
#' @param date_from Start date
#' @param date_to End date
#' @export
norsyss_download_raw <- function(
  con,
  date_from,
  date_to
){
  command <- paste0(
    "select Id,Diagnose,PasientAlder,PasientKommune,BehandlerKommune,Konsultasjonsdato,Takst,Praksis from Konsultasjon join KonsultasjonDiagnose on Id=KonsultasjonId join KonsultasjonTakst on Id=KonsultasjonTakst.KonsultasjonId where Konsultasjonsdato >='",
    date_from,
    "' AND Konsultasjonsdato <= '",
    date_to,
    "'"
  )
  d <- RODBC::sqlQuery(con, command)
  setDT(d)
  return(d)
}
