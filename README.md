# Sykdompulsen Connect (spulsconnect)

This repo contains functions that allow you to interact with the Sykdomspulsen infrastructure developed by the Norwegian Institute of Public Health.

# Installation

You should include Folkehelseinstituttet's drat repository as a default option for your computer. You can do this by installing the package `usethis` and then running the command:

```
usethis::edit_r_profile()
```

This will open a document called `.Rprofile`. Inside this document you will enter:

```
options(
  repos = c(
    folkehelseinstituttet = "https://folkehelseinstituttet.github.io/drat/",
    CRAN = "https://cran.rstudio.com/"
  )
)
```

You will then save this file, close it, and restart RStudio. You can now install all FHI packages in the normal manner:

```
install.package("spulsconnect")
```
