# Flags/values to be used in the 'dashboards' scene
config <- new.env()

takstkoder <- list(
  "11ad" = "Legekontakt",
  "11ak" = "Legekontakt",
  "1ad" = "Telefonkontakt",
  "1ak" = "Telefonkontakt",
  "1bd" = "Telefonkontakt",
  "1bk" = "Telefonkontakt",
  "1g" = "Telefonkontakt",
  "1h" = "Telefonkontakt",
  "2ad" = "Legekontakt",
  "2ae" = "Telefonkontakt",
  "2ak" = "Legekontakt",
  "2fk" = "Legekontakt"
)


# NAV Kommune nummer til FREG
# Some municip numbers received by KUHR do not match the expected
# numbers from folkeregistret. This table translates between them

# Any other municip numbers not in config for sykdomspulsen will be set to 9999
# Bydels number also exist for these codes (see docoumentation)
nav_to_freg <- list(
  "312" = 301,
  "313" = 301,
  "314" = 301,
  "315" = 301,
  "316" = 301,
  "318" = 301,
  "319" = 301,
  "321" = 301,
  "326" = 301,
  "327" = 301,
  "328" = 301,
  "330" = 301,
  "331" = 301,
  "334" = 301,
  "335" = 301,
  "1161" = 1103,
  "1162" = 1103,
  "1164" = 1103,
  "1165" = 1103,
  "1202" = 1201,
  "1203" = 1201,
  "1204" = 1201,
  "1205" = 1201,
  "1206" = 1201,
  "1208" = 1201,
  "1209" = 1201,
  "1210" = 1201,
  "1603" = 301,
  "1604" = 1601,
  "1605" = 1601,
  "1607" = 1601
)

# FAKE INFO
def_norsyss_fake <- new.env()
def_norsyss_fake$Diagnose <- c(
  "A02", "A03", "A05", "A72", "A73", "A75", "A76", "A77",
  "A78", "B02", "B70", "B71", "D01", "D02", "D06", "D08",
  "D09", "D10", "D11", "D14", "D18", "D25", "D29", "D70",
  "D73", "D87", "D96", "D99", "F70", "F73", "H01", "H04",
  "H13", "H29", "H71", "H77", "R01", "R02", "R03", "R04",
  "R05", "R06", "R07", "R08", "R09", "R21", "R24", "R25",
  "R29", "R71", "R72", "R74", "R75", "R76", "R77", "R78",
  "R79", "R80", "R81", "R82", "R83", "R95", "R96", "R99",
  "S06", "S07", "S10", "S12", "S17", "S29", "S70", "S71",
  "S72", "S73", "S76", "S84", "S95", "S99", "XXX"
)

def_norsyss_fake$PasientAlder <- c(
  "0-4",
  "5-9",
  "10-14",
  "10-19",
  "15-19",
  "20-29",
  "30-39",
  "40-49",
  "50-59",
  "60-64",
  "60-69",
  "65-69",
  "70-79",
  "80+"
)

def_norsyss_fake$PasientKommune <- as.numeric(stringr::str_remove_all(fhidata::norway_locations_b2020$municip_code, "municip"))

def_norsyss_fake$BehandlerKommune <- as.numeric(stringr::str_remove_all(fhidata::norway_locations_b2020$municip_code, "municip"))

def_norsyss_fake$Konsultasjonsdato <- seq.Date(as.Date("2020-01-01"), as.Date("2020-01-02"), 1)

def_norsyss_fake$Takst <- c(
  "11ad",
  "11ak",
  "1ad",
  "1ak",
  "1bd",
  "1bk",
  "1g",
  "1h",
  "2ad",
  "2ae",
  "2ak",
  "2fk"
)

def_norsyss_fake$Praksis <- c(
  "Fastlege",
  "Fastl\u00F8nnet",
  "Legevakt",
  "kommunal legevakt"
)
