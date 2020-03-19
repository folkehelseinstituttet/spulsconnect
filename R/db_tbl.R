#' use_db
#' @param conn a
#' @param db a
#' @export
use_db <- function(conn, db) {
  tryCatch({
    a <- DBI::dbExecute(conn, glue::glue({
      "USE {db};"
    }))
  }, error = function(e){
    a <- DBI::dbExecute(conn, glue::glue({
      "CREATE DATABASE {db};"
    }))
    a <- DBI::dbExecute(conn, glue::glue({
      "USE {db};"
    }))
  })
}


#' get_db_connection
#' @param driver driver
#' @param server server
#' @param db db
#' @param port port
#' @param user user
#' @param password password
#' @param db_config A list containing driver, server, db, port, user, password
#' @export get_db_connection
get_db_connection <- function(
  driver = NULL,
  server = NULL,
  db = NULL,
  port = NULL,
  user = NULL,
  password = NULL,
  db_config = config$db_config
) {

  if(!is.null(db_config) & is.null(driver)){
    driver <- db_config$driver
  }
  if(!is.null(db_config) & is.null(server)){
    server <- db_config$server
  }
  if(!is.null(db_config) & is.null(port)){
    port <- db_config$port
  }
  if(!is.null(db_config) & is.null(user)){
    user <- db_config$user
  }
  if(!is.null(db_config) & is.null(password)){
    password <- db_config$password
  }

  if(db_config$driver %in% c(
    "ODBC Driver 17 for SQL Server",
    "SQL Server"
    )){
    return(
      DBI::dbConnect(
        odbc::odbc(),
        driver = driver,
        server = server,
        port = port,
        uid = user,
        Pwd = password,
        encoding = "utf8",
        trusted_connection="yes",
        database = db_config$db
      ))
  } else {
    return(
      DBI::dbConnect(
        odbc::odbc(),
        driver = driver,
        server = server,
        port = port,
        user = user,
        password = password,
        encoding = "utf8"
      ))
  }
}

#' tbl
#' @param table table
#' @param db db
#' @export
tbl <- function(table, db = "Sykdomspulsen_surv") {
  if (is.null(connections[[db]])) {
    connections[[db]] <- get_db_connection()
    use_db(connections[[db]], db)
  }
  return(dplyr::tbl(connections[[db]], table))
}

