## ----setup, include = FALSE----------------------------------------------
library(dm)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
fansi::set_knit_hooks(knitr::knit_hooks)
options(crayon.enabled = TRUE, width = 75, cli.width = 75)

knit_print.grViz <- function(x, ...) {
  x %>% 
    DiagrammeRsvg::export_svg() %>% 
    c("`````{=html}\n", ., "\n`````\n") %>% 
    knitr::asis_output()
}

## ------------------------------------------------------------------------
library(nycflights13)
library(dm)
empty_dm <- dm()
empty_dm
dm_add_tbl(empty_dm, airlines, airports, flights, planes, weather) 

## ------------------------------------------------------------------------
as_dm(list(airlines = airlines, 
           airports = airports, 
           flights = flights, 
           planes = planes, 
           weather = weather))

## ----message=FALSE-------------------------------------------------------
library(dplyr)
flights_dm <- dm_from_src(src_df(pkg = "nycflights13"))
flights_dm

## ------------------------------------------------------------------------
iris_dm <- new_dm(list("iris1" = iris, "iris2" = iris))
iris_dm

## ------------------------------------------------------------------------
tbl(flights_dm, "airports")

## ------------------------------------------------------------------------
dm_has_pk(flights_dm, airports)
flights_dm_with_key <- dm_add_pk(flights_dm, airports, faa)
flights_dm_with_key

## ------------------------------------------------------------------------
dm_has_pk(flights_dm_with_key, airports)

## ------------------------------------------------------------------------
dm_get_pk(flights_dm_with_key, airports)

## ------------------------------------------------------------------------
dm_rm_pk(flights_dm_with_key, airports) %>% 
  dm_has_pk(airports)

## ------------------------------------------------------------------------
dm_enum_pk_candidates(flights_dm_with_key, airports)

## ------------------------------------------------------------------------
dm_enum_pk_candidates(flights_dm_with_key, flights) %>% count(candidate)

## ------------------------------------------------------------------------
dm_get_all_pks(dm_nycflights13(cycle = TRUE))

## ------------------------------------------------------------------------
flights_dm_with_key %>% dm_add_fk(flights, origin, airports)

## ----error=TRUE----------------------------------------------------------
flights_dm %>% dm_add_fk(flights, origin, airports)

## ------------------------------------------------------------------------
flights_dm_with_fk <- dm_add_fk(flights_dm_with_key, flights, origin, airports)

## ----error=TRUE----------------------------------------------------------
flights_dm_with_fk %>% dm_add_fk(flights, dest, airports, check = TRUE)

## ------------------------------------------------------------------------
flights_dm_with_fk %>% dm_has_fk(flights, planes)
flights_dm_with_fk %>% dm_has_fk(flights, airports)

## ------------------------------------------------------------------------
flights_dm_with_fk %>% dm_get_fk(flights, planes)
flights_dm_with_fk %>% dm_get_fk(flights, airports)

## ----error=TRUE----------------------------------------------------------
flights_dm_with_fk %>% 
  dm_rm_fk(table = flights, column = dest, ref_table = airports) %>% 
  dm_get_fk(flights, airports)
flights_dm_with_fk %>% 
  dm_rm_fk(flights, origin, airports) %>% 
  dm_get_fk(flights, airports)
flights_dm_with_fk %>% 
  dm_rm_fk(flights, NULL, airports) %>% 
  dm_get_fk(flights, airports)

## ------------------------------------------------------------------------
dm_enum_fk_candidates(flights_dm_with_key, weather, airports)

## ------------------------------------------------------------------------
dm_get_all_fks(dm_nycflights13(cycle = TRUE))

