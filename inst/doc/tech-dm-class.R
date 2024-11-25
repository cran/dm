## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ------------------------------------------------------------------------
# library(nycflights13)
# library(dm)
# dm(airlines, airports, flights, planes, weather)

## ------------------------------------------------------------------------
# library(nycflights13)
# library(dm)
# empty_dm <- dm()
# empty_dm
# dm(empty_dm, airlines, airports, flights, planes, weather)

## ------------------------------------------------------------------------
# as_dm(list(
#   airlines = airlines,
#   airports = airports,
#   flights = flights,
#   planes = planes,
#   weather = weather
# ))

## ----message=FALSE-------------------------------------------------------
# sqlite_con <- dbplyr::nycflights13_sqlite()
# 
# flights_dm <- dm_from_con(sqlite_con)
# flights_dm

## ------------------------------------------------------------------------
# base_dm <- new_dm(list(
#   airlines = airlines,
#   airports = airports,
#   flights = flights,
#   planes = planes,
#   weather = weather
# ))
# base_dm

## ------------------------------------------------------------------------
# dm_validate(base_dm)

## ------------------------------------------------------------------------
# flights_dm[["airports"]]

## ------------------------------------------------------------------------
# dm_has_pk(flights_dm, airports)
# flights_dm_with_key <- dm_add_pk(flights_dm, airports, faa)
# flights_dm_with_key

## ------------------------------------------------------------------------
# dm_has_pk(flights_dm_with_key, airports)

## ------------------------------------------------------------------------
# dm_get_all_pks(flights_dm_with_key)

## ------------------------------------------------------------------------
# dm_rm_pk(flights_dm_with_key, airports) %>%
#   dm_has_pk(airports)

## ------------------------------------------------------------------------
# dm_enum_pk_candidates(flights_dm_with_key, airports)

## ------------------------------------------------------------------------
# dm_enum_pk_candidates(flights_dm_with_key, flights) %>% dplyr::count(candidate)

## ----error = TRUE--------------------------------------------------------
try({
# try(
#   dm_add_pk(flights_dm, airports, tzone, check = TRUE)
# )
})

## ------------------------------------------------------------------------
# flights_dm_with_key %>% dm_add_fk(flights, origin, airports)

## ----error=TRUE----------------------------------------------------------
try({
# try(
#   flights_dm %>% dm_add_fk(flights, origin, airports)
# )
})

## ------------------------------------------------------------------------
# flights_dm_with_fk <- dm_add_fk(flights_dm_with_key, flights, origin, airports)

## ----error=TRUE----------------------------------------------------------
try({
# try(
#   flights_dm_with_fk %>% dm_add_fk(flights, dest, airports, check = TRUE)
# )
})

## ------------------------------------------------------------------------
# dm_get_all_fks(dm_nycflights13(cycle = TRUE))

## ----error=TRUE----------------------------------------------------------
try({
# try(
#   flights_dm_with_fk %>%
#     dm_rm_fk(table = flights, column = dest, ref_table = airports) %>%
#     dm_get_all_fks(c(flights, airports))
# )
# 
# flights_dm_with_fk %>%
#   dm_rm_fk(flights, origin, airports) %>%
#   dm_get_all_fks(c(flights, airports))
# 
# flights_dm_with_fk %>%
#   dm_rm_fk(flights, columns = NULL, airports) %>%
#   dm_get_all_fks(c(flights, airports))
})

## ------------------------------------------------------------------------
# dm_enum_fk_candidates(flights_dm_with_key, weather, airports)

