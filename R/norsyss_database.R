#' Connect to NorSySS database
#' @export
norsyss_connect <- function() {
  if(is.null(connections_rodbc[["SykdomspulsenAnalyse"]])){
    if (.Platform$OS.type == "windows") {
      connections_rodbc[["SykdomspulsenAnalyse"]] <- RODBC::odbcDriverConnect("driver={Sql Server};server=dm-prod;database=SykdomspulsenAnalyse; trusted_connection=yes")
    } else {
      connections_rodbc[["SykdomspulsenAnalyse"]] <- RODBC::odbcDriverConnect("driver={ODBC Driver 17 for SQL Server};server=dm-prod;database=SykdomspulsenAnalyse; trusted_connection=yes")
    }
  }

  return(connections_rodbc[["SykdomspulsenAnalyse"]])
}

#' Download raw data from NorSySS database
#' @param date_from Start date
#' @param date_to End date
#' @export
norsyss_download_raw <- function(
                                 date_from,
                                 date_to) {
  con <- norsyss_connect()
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
