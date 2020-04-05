#' use_db
#' @param conn a
#' @param db a
#' @export
use_db <- function(conn, db) {
  tryCatch(
    {
      a <- DBI::dbExecute(conn, glue::glue({
        "USE {db};"
      }))
    },
    error = function(e) {
      a <- DBI::dbExecute(conn, glue::glue({
        "CREATE DATABASE {db};"
      }))
      a <- DBI::dbExecute(conn, glue::glue({
        "USE {db};"
      }))
    }
  )
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
                              db_config = config$db_config) {
  if (!is.null(db_config) & is.null(driver)) {
    driver <- db_config$driver
  }
  if (!is.null(db_config) & is.null(server)) {
    server <- db_config$server
  }
  if (!is.null(db_config) & is.null(port)) {
    port <- db_config$port
  }
  if (!is.null(db_config) & is.null(user)) {
    user <- db_config$user
  }
  if (!is.null(db_config) & is.null(password)) {
    password <- db_config$password
  }

  if (db_config$driver %in% c(
    "ODBC Driver 17 for SQL Server",
    "SQL Server"
  )) {
    return(
      DBI::dbConnect(
        odbc::odbc(),
        driver = driver,
        server = server,
        port = port,
        uid = user,
        Pwd = password,
        encoding = "utf8",
        trusted_connection = "yes",
        database = db_config$db
      )
    )
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
      )
    )
  }
}

#' tbl
#' @param table table
#' @param db db
#' @export
tbl <- function(table, db = "Sykdomspulsen_surv") {
  stopifnot(table %in% list_tables(db))

  if (is.null(connections[[db]])) {
    connections[[db]] <- get_db_connection(db = db)
    use_db(connections[[db]], db)
  }
  return(dplyr::tbl(connections[[db]], table))
}

list_tables <- function(db = "Sykdomspulsen_surv") {
  if (is.null(connections[[db]])) {
    connections[[db]] <- get_db_connection(db = db)
    use_db(connections[[db]], db)
  }
  retval <- DBI::dbListTables(connections[[db]])
  last_val <- which(retval=="trace_xe_action_map")-1
  retval <- retval[1:last_val]

  # remove airflow tables
  if(db=="Sykdomspulsen_surv"){
    retval <- retval[
      which(! retval %in% c(
        "alembic_version",
        "chart",
        "connection",
        "dag",
        "dag_pickle",
        "dag_run",
        "dag_tag",
        "import_error",
        "job",
        "known_event",
        "known_event_type",
        "kube_resource_version",
        "kube_worker_uuid",
        "log",
        "serialized_dag",
        "sla_miss",
        "slot_pool",
        "task_fail",
        "task_instance",
        "task_reschedule",
        "users",
        "variable",
        "xcom"
      ))
    ]
  }
  return(retval)
}
