## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ----message=FALSE, warning=FALSE----------------------------------------
#  library(nycflights13)
#  library(dm)

## ------------------------------------------------------------------------
#  dm <- dm_nycflights13()

## ------------------------------------------------------------------------
#  dm

## ------------------------------------------------------------------------
#  dm_draw(dm)

## ------------------------------------------------------------------------
#  tbl(dm, "airports")

## ------------------------------------------------------------------------
#  filtered_dm <-
#    dm %>%
#    dm_filter(airports = (name == "John F Kennedy Intl"))
#  filtered_dm

## ------------------------------------------------------------------------
#  rows_per_table <-
#    filtered_dm %>%
#    dm_nrow()
#  rows_per_table
#  sum(rows_per_table)

## ----echo = FALSE, eval = TRUE-------------------------------------------
sum_nrow <- NA
sum_nrow_filtered <- NA

## ------------------------------------------------------------------------
#  sum_nrow <- sum(dm_nrow(dm))
#  sum_nrow_filtered <- sum(dm_nrow(dm_apply_filters(filtered_dm)))

## ------------------------------------------------------------------------
#  dm %>%
#    dm_filter(flights = (dest == "IAD")) %>%
#    dm_nrow()

## ------------------------------------------------------------------------
#  dm_delta_may <-
#    dm %>%
#    dm_filter(
#      airlines = (name == "Delta Air Lines Inc."),
#      airports = (name != "John F Kennedy Intl"),
#      flights = (month == 1)
#    )
#  dm_delta_may
#  dm_delta_may %>%
#    dm_nrow()

## ------------------------------------------------------------------------
#  dm_delta_may$airlines

## ------------------------------------------------------------------------
#  dm_delta_may$planes

## ------------------------------------------------------------------------
#  dm_delta_may$flights %>%
#    dplyr::count(month)

## ------------------------------------------------------------------------
#  airlines_filtered <- filter(airlines, name == "Delta Air Lines Inc.")
#  airports_filtered <- filter(airports, name != "John F Kennedy Intl")
#  flights %>%
#    semi_join(airlines_filtered, by = "carrier") %>%
#    semi_join(airports_filtered, by = c("origin" = "faa")) %>%
#    filter(month == 5)

## ----warning=FALSE-------------------------------------------------------
#  dm %>%
#    dm_select_tbl(flights, airlines, airports) %>%
#    copy_dm_to(dbplyr::src_memdb(), .) %>%
#    dm_filter(
#      airlines = (name == "Delta Air Lines Inc."),
#      airports = (name != "John F Kennedy Intl"),
#      flights = (month == 1)
#    ) %>%
#    dm_get_tables() %>%
#    purrr::map(dbplyr::sql_render)

