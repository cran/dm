## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ----nycflights13, message=FALSE-----------------------------------------
library(nycflights13)

airports

## ------------------------------------------------------------------------
library(dm)

flights_dm_no_keys <- dm(airlines, airports, flights, planes, weather)
flights_dm_no_keys

## ----listlike------------------------------------------------------------
names(flights_dm_no_keys)
flights_dm_no_keys$airports
flights_dm_no_keys[c("airports", "flights")]

## ------------------------------------------------------------------------
dm_enum_pk_candidates(
  dm = flights_dm_no_keys,
  table = planes
)

## ------------------------------------------------------------------------
flights_dm_only_pks <-
  flights_dm_no_keys %>%
  dm_add_pk(table = airlines, columns = carrier) %>%
  dm_add_pk(airports, faa) %>%
  dm_add_pk(planes, tailnum) %>%
  dm_add_pk(weather, c(origin, time_hour))
flights_dm_only_pks

## ------------------------------------------------------------------------
dm_enum_fk_candidates(
  dm = flights_dm_only_pks,
  table = flights,
  ref_table = airlines
)

## ------------------------------------------------------------------------
flights_dm_all_keys <-
  flights_dm_only_pks %>%
  dm_add_fk(table = flights, columns = tailnum, ref_table = planes) %>%
  dm_add_fk(flights, carrier, airlines) %>%
  dm_add_fk(flights, origin, airports) %>%
  dm_add_fk(flights, c(origin, time_hour), weather)
flights_dm_all_keys

## ------------------------------------------------------------------------
flights_dm_no_keys %>%
  dm_draw(rankdir = "TB", view_type = "all")

## ------------------------------------------------------------------------
flights_dm_no_keys %>%
  dm_add_pk(airlines, carrier) %>%
  dm_draw()

## ------------------------------------------------------------------------
flights_dm_only_pks %>%
  dm_add_fk(flights, tailnum, planes) %>%
  dm_draw()

## ------------------------------------------------------------------------
flights_dm_all_keys %>%
  dm_draw()

## ------------------------------------------------------------------------
flights_dm_no_keys %>%
  dm_examine_constraints()

flights_dm_only_pks %>%
  dm_examine_constraints()

flights_dm_all_keys %>%
  dm_examine_constraints()

## ------------------------------------------------------------------------
flights_dm_only_pks %>%
  dm_get_all_pks()

## ------------------------------------------------------------------------
flights_dm_all_keys %>%
  dm_get_all_fks()

## ------------------------------------------------------------------------
flights_dm_all_keys %>%
  dm_examine_constraints() %>%
  tibble::as_tibble()

