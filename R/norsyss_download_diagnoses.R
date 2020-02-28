gen_fake_norsyss_raw_data <- function() {
  Id <- NULL

  d <- expand.grid(
    Diagnose = def_norsyss_fake$Diagnose,
    PasientAlder = def_norsyss_fake$PasientAlder,
    PasientKommune = def_norsyss_fake$PasientKommune[1:2],
    BehandlerKommune = def_norsyss_fake$BehandlerKommune[1:2],
    Konsultasjonsdato = def_norsyss_fake$Konsultasjonsdato,
    Takst = def_norsyss_fake$Takst,
    Praksis = def_norsyss_fake$Praksis
  )
  setDT(d)
  d[, Id := 1:.N]

  return(d)
}

norsyss_aggregate_format_raw_data <- function(d, diags) {
  . <- BehandlerKommune <- Diagnose <- Id <-
    Konsultasjonsdato <- Kontaktype <- PasientAlder <-
    Praksis <- Takst <- age <- consult <- from <-
    municip <- n_diff <- pb <- NULL

  for (i in seq_along(diags)) {
    d[, (names(diags)[i]) := 0]
    d[Diagnose %in% diags[[i]], (names(diags)[i]) := 1]
  }

  ### Praksis

  d[Praksis == "Fastl\u00F8nnet", Praksis := "Fastlege"]
  d[Praksis == "kommunal legevakt", Praksis := "Legevakt"]


  d[, Kontaktype := "Ukjent"]
  ### Kontaktkode
  for (takstkode in names(takstkoder)) {
    d[Takst == takstkode, Kontaktype := takstkoder[takstkode]]
  }

  dups <- d[, .(n_diff = length(unique(Kontaktype))), by = .(Id)]
  d <- d[!(Id %in% dups[n_diff >= 2, Id] & Kontaktype == "Telefonkontakt")]

  d[, age := "Ukjent"]
  d[PasientAlder == "0-4", age := "0-4"]
  d[PasientAlder == "5-9", age := "5-14"]
  d[PasientAlder == "0-9", age := "5-14"]
  d[PasientAlder == "10-14", age := "5-14"]
  d[PasientAlder == "10-19", age := "15-19"]
  d[PasientAlder == "15-19", age := "15-19"]
  d[PasientAlder == "20-29", age := "20-29"]
  d[PasientAlder == "30-39", age := "30-64"]
  d[PasientAlder == "40-49", age := "30-64"]
  d[PasientAlder == "50-59", age := "30-64"]
  d[PasientAlder == "60-64", age := "30-64"]
  d[PasientAlder == "65-69", age := "65+"]
  d[PasientAlder == "60-69", age := "65+"]
  d[PasientAlder == "70-79", age := "65+"]
  d[PasientAlder == "80+", age := "65+"]



  # Fixing behandler kommune nummer
  for (old in names(nav_to_freg)) {
    d[as.character(BehandlerKommune) == old, BehandlerKommune := nav_to_freg[old]]
  }


  # Collapsing it down to 1 row per consultation
  d <- d[,
    lapply(.SD, sum),
    by = .(
      Id,
      BehandlerKommune,
      age,
      Konsultasjonsdato,
      Praksis,
      Kontaktype
    ),
    .SDcols = names(diags)
  ]
  d[, consult := 1]

  # Collapsing it down to 1 row per kommune/age/day
  d <- d[, lapply(.SD, sum), ,
    by = .(
      BehandlerKommune,
      age,
      Konsultasjonsdato,
      Praksis,
      Kontaktype
    ),
    .SDcols = c(names(diags), "consult")
  ]

  d[, municip := paste0("municip", formatC(BehandlerKommune, width = 4, flag = 0))]
  d[, BehandlerKommune := NULL]
  setnames(d, "Konsultasjonsdato", "date")

  return(d)
}

#' Download NorSySS aggregated diagnoses
#'
#' A function to extract NorSySS diagnoses, aggregated
#' by day and municipality.
#' @param date_from Start date for extracting data
#' @param date_to End date for extracting data
#' @param folder Folder the data file will end up in
#' @param file_name File name of the data file
#' @param ages Age remapping
#' @param diags Diagnosis codes to download
#' @param overwrite_file Do you want to overwrite the file if it already exists?
#' @param ... Not used
#' @import data.table
#' @examples
#' \dontrun{
#' norsyss_download_aggregated_diagnoses(
#'   date_from = "2020-01-01",
#'   date_to = lubridate::today(),
#'   folder = getwd(),
#'   diags = list("influenza" = c("R80"))
#' )
#' }
#' @export
norsyss_download_aggregated_diagnoses <- function(
                                                  date_from = "2020-01-01",
                                                  date_to = lubridate::today(),
                                                  folder = getwd(),
                                                  file_name = glue::glue("norsyss_{lubridate::today()}.txt"),
                                                  ages = c(
                                                    "0-4" = "0-4",
                                                    "5-14" = "5-9",
                                                    "5-14" = "10-14",
                                                    "15-19" = "15-19",
                                                    "20-29" = "20-29",
                                                    "30-64" = "30-39",
                                                    "30-64" = "40-49",
                                                    "30-64" = "50-59",
                                                    "30-64" = "60-64",
                                                    "65-69" = "65+",
                                                    "70-79" = "65+",
                                                    "80+" = "65+"
                                                  ),
                                                  diags = list(
                                                    "influensa" = c("R80"),
                                                    "gastro" = c("D11", "D70", "D73"),
                                                    "respiratory" = c("R05", "R74", "R78", "R83"),
                                                    "respiratoryexternal" = c("R05", "R74", "R78", "R83"),
                                                    "respiratoryinternal" = c("R05", "R74", "R83"),
                                                    "lungebetennelse" = c("R81"),
                                                    "bronkitt" = c("R78"),
                                                    "skabb" = c("S72"),
                                                    "emerg1" = c("R80"),
                                                    "emerg2" = c("R80"),
                                                    "emerg3" = c("R80"),
                                                    "emerg4" = c("R80"),
                                                    "emerg5" = c("R80")
                                                  ),
                                                  overwrite_file = FALSE,
                                                  ...) {
  . <- BehandlerKommune <- Diagnose <- Id <-
    Konsultasjonsdato <- Kontaktype <- PasientAlder <-
    Praksis <- Takst <- age <- consult <- from <-
    municip <- n_diff <- pb <- NULL

  file_temp <- fs::path(tempdir(), file_name)
  file_permanent <- fs::path(folder, file_name)

  if (overwrite_file == FALSE) {
    if (file.exists(file_permanent)) {
      x <- fread(file_permanent)
      max_date <- as.Date(max(x$date, na.rm = T))
      # as long as last date in the file is within 2 days of the requested date
      if (abs(as.numeric(difftime(date_to, max_date, units = "days"))) <= 2) {
        message("file already exists! exiting...")
        return()
      }
    }
  }

  if (.Platform$OS.type == "windows") {
    db <- RODBC::odbcDriverConnect("driver={Sql Server};server=dm-prod;database=SykdomspulsenAnalyse; trusted_connection=yes")
  } else {
    db <- RODBC::odbcDriverConnect("driver={ODBC Driver 17 for SQL Server};server=dm-prod;database=SykdomspulsenAnalyse; trusted_connection=yes")
  }
  on.exit(close(db))

  # calculate dates
  datesToExtract <- data.table(from = seq(as.Date(date_from), by = "month", length.out = 300), to = seq(as.Date(date_from), by = "month", length.out = 301)[-1] - 1)
  # Remove future dates
  datesToExtract <- datesToExtract[from <= date_to]

  # predefine storage of results
  pb <- progress::progress_bar$new(
    format = "[:bar] :current/:total (:percent) in :elapsedfull, eta: :eta",
    clear = FALSE,
    total = nrow(datesToExtract)
  )
  pb$tick(0)

  for (i in 1:nrow(datesToExtract)) {
    pb$tick()

    command <- paste0(
      "select Id,Diagnose,PasientAlder,PasientKommune,BehandlerKommune,Konsultasjonsdato,Takst,Praksis from Konsultasjon join KonsultasjonDiagnose on Id=KonsultasjonId join KonsultasjonTakst on Id=KonsultasjonTakst.KonsultasjonId where Konsultasjonsdato >='",
      datesToExtract[i]$from,
      "' AND Konsultasjonsdato <= '",
      datesToExtract[i]$to,
      "'"
    )
    d <- RODBC::sqlQuery(db, command)
    d <- data.table(d)
    d <- norsyss_aggregate_format_raw_data(d, diags = diags)
    if (i == 1) {
      utils::write.table(d, file_temp, sep = "\t", row.names = FALSE, col.names = TRUE, append = FALSE)
    } else {
      utils::write.table(d, file_temp, sep = "\t", row.names = FALSE, col.names = FALSE, append = TRUE)
    }
  }

  if (.Platform$OS.type == "windows") {
    fs::file_move(file_temp, file_permanent)
  } else {
    system(glue::glue("mv {file_temp} {file_permanent}"))
  }

  return(file_permanent)
}
