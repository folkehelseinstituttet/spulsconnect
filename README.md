# Sykdompulsen Connect (spulsconnect)

This repo contains functions that allow you to interact with the Sykdomspulsen infrastructure developed by the Norwegian Institute of Public Health.

## Installation

If you want to install the dev versions (or access packages that haven't been released on CRAN), run `usethis::edit_r_profile()` to edit your `.Rprofile`. Then write in:

```
options(repos=structure(c(
  FHI="https://folkehelseinstituttet.github.io/drat/",
  CRAN="https://cran.rstudio.com"
)))
```

You will then save this file, close it, and restart RStudio. You can now install all `fhiverse` packages (see below) in the normal manner.

```
install.package("spulsconnect")
```

## fhiverse

The `fhiverse` is a set of R packages developed by the Norwegian Institute of Public Health to help solve problems relating to:

- structural data in Norway (e.g. maps, population, redistricting)
- convenience functions for Norwegian researchers (e.g. Norwgian formatting, Norwegian characters)
- analysis planning (especially for making graphs/tables for reports)
- file structures in projects
- styleguides/recommendations for FHI employees

Save the file and restart R. This will allow you to install `fhiverse` packages from the FHI registry.

Current `fhiverse` packages are:

- [spread](https://folkehelseinstituttet.github.io/spread)
- [fhidata](https://folkehelseinstituttet.github.io/fhi)
- [fhiplot](https://folkehelseinstituttet.github.io/fhi)
- [plnr](https://folkehelseinstituttet.github.io/fhi)
- [fhi](https://folkehelseinstituttet.github.io/fhi)
- [spulsconnect](https://folkehelseinstituttet.github.io/spulsconnect)

## NOT IMPLEMENTED YET // Environmental variables

NOT IMPLEMENTED, IGNORE FOR THE MOMENT:

To connect to the Sykdomspulsen database, you will need to include environmental variables into your `.Renviron` file by running the command:

```
usethis::edit_r_environ()
```

and then entering the following:

```
DB_DRIVER='MySQL'
DB_SERVER='db'
DB_PORT='3306'
DB_USER='XXXXXXXXXXXX'
DB_PASSWORD='XXXXXXXXXXXX'
DB_DB='sykdomspuls'
```
