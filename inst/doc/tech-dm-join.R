## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ------------------------------------------------------------------------
#  library(dm)

## ------------------------------------------------------------------------
#  dm <- dm_nycflights13()

## ------------------------------------------------------------------------
#  dm %>%
#    dm_draw()

## ------------------------------------------------------------------------
#  dm %>%
#    dm_get_all_fks()

## ------------------------------------------------------------------------
#  dm_joined <-
#    dm %>%
#    dm_flatten_to_tbl(flights, airlines, .join = left_join)
#  dm_joined

## ------------------------------------------------------------------------
#  dm$flights %>%
#    names()
#  
#  dm$airlines %>%
#    names()
#  
#  dm_joined %>%
#    names()

## ------------------------------------------------------------------------
#  dm_joined %>%
#    class()

## ------------------------------------------------------------------------
#  dm %>%
#    dm_flatten_to_tbl(flights, airlines, .join = anti_join)

## ------------------------------------------------------------------------
#  dm_nycflights13(subset = FALSE) %>%
#    dm_filter(
#      airlines = (name == "Delta Air Lines Inc."),
#      airports = (name != "John F Kennedy Intl"),
#      flights = (month == 5)
#    ) %>%
#    dm_flatten_to_tbl(flights, airports, .join = left_join)

## ------------------------------------------------------------------------
#  dm_nycflights13() %>%
#    dm_select_tbl(-weather) %>%
#    dm_flatten_to_tbl(.start = flights)

## ------------------------------------------------------------------------
#  dm_nycflights13() %>%
#    dm_wrap_tbl(root = flights) %>%
#    pull_tbl(flights)

