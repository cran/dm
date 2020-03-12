## ----setup, include = FALSE----------------------------------------------
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
library(nycflights13)
library(tidyverse)
library(dm)

## ----message=FALSE-------------------------------------------------------
library(tidyverse)
library(dm)

## ----message=FALSE-------------------------------------------------------
flights_dm <- dm_from_src(src_df(pkg = "nycflights13"))
flights_dm

## ------------------------------------------------------------------------
dm_get_src(flights_dm)
dm_get_all_pks(flights_dm)
dm_get_all_fks(flights_dm)

## ------------------------------------------------------------------------
flights_dm_with_one_key <- 
  flights_dm %>% 
  dm_add_pk(airlines, carrier) %>% 
  dm_add_fk(flights, carrier, airlines)

## ------------------------------------------------------------------------
flights_dm_with_one_key %>% 
  dm_draw()

## ------------------------------------------------------------------------
flights_dm_with_keys <- dm_nycflights13(cycle = TRUE)
flights_dm_with_keys %>% 
  dm_draw()

## ------------------------------------------------------------------------
flights_dm_acyclic <- dm_nycflights13()
flights_dm_acyclic %>% 
  dm_draw()

## ------------------------------------------------------------------------
us_flights_from_jfk_prepared <- 
  flights_dm_acyclic %>%
  dm_filter(airports, name == "John F Kennedy Intl") %>% 
  dm_filter(airlines, name == "US Airways Inc.")
us_flights_from_jfk_prepared

## ------------------------------------------------------------------------
us_flights_from_jfk <- dm_apply_filters(us_flights_from_jfk_prepared)
us_flights_from_jfk %>% 
  dm_get_tables() %>% 
  map_int(nrow)

## ------------------------------------------------------------------------
dm_apply_filters_to_tbl(us_flights_from_jfk, "planes")

## ------------------------------------------------------------------------
dm_apply_filters_to_tbl(us_flights_from_jfk, "planes") %>% 
  count(model)

## ----eval=FALSE----------------------------------------------------------
#  flights %>%
#    left_join(airports, by = c("origin" = "faa")) %>%
#    filter(name == "John F Kennedy Intl") %>%
#    left_join(airlines, by = "carrier") %>%
#    filter(name.y == "US Airways Inc.") %>%
#    semi_join(planes, ., by = "tailnum") %>%
#    count(model)

## ------------------------------------------------------------------------
flights_dm_with_keys %>%
  dm_join_to_tbl(airlines, flights, join = left_join)

## ----eval=FALSE----------------------------------------------------------
#  library(nycflights13)
#  airlines %>%
#    left_join(flights, by = "carrier")

## ------------------------------------------------------------------------
src_sqlite <- src_sqlite(":memory:", create = TRUE)
src_sqlite
flights_dm_with_keys_remote <- copy_dm_to(src_sqlite, flights_dm_with_keys)

## ------------------------------------------------------------------------
src_sqlite
flights_dm_with_keys_remote

## ----eval=FALSE----------------------------------------------------------
#  flights_dm_from_remote <- dm_learn_from_db(src_sqlite)
