## ----setup, message=FALSE------------------------------------------------
library(dm)
library(nycflights13)

## ------------------------------------------------------------------------
flights_dm_no_keys <- tibble::lst(airlines, airports, flights, planes, weather) %>%
  as_dm()

## ------------------------------------------------------------------------
dm_enum_pk_candidates(
  dm = flights_dm_no_keys,
  table = planes
)

## ------------------------------------------------------------------------
flights_dm_only_pks <- flights_dm_no_keys %>%
  dm_add_pk(table = airlines, column = carrier) %>%
  dm_add_pk(airports, faa) %>%
  dm_add_pk(planes, tailnum)
flights_dm_only_pks

## ------------------------------------------------------------------------
dm_get_all_pks(flights_dm_only_pks)

## ------------------------------------------------------------------------
dm_enum_fk_candidates(
  dm = flights_dm_only_pks,
  table = flights,
  ref_table = airlines
)

## ------------------------------------------------------------------------
flights_dm_all_keys <- flights_dm_only_pks %>%
  dm_add_fk(table = flights, column = tailnum, ref_table = planes, check = FALSE) %>%
  dm_add_fk(flights, carrier, airlines) %>%
  dm_add_fk(flights, origin, airports)
flights_dm_all_keys

## ------------------------------------------------------------------------
dm_get_all_pks(flights_dm_all_keys)

## ------------------------------------------------------------------------
flights_dm_all_keys

