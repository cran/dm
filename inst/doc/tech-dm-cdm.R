## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ------------------------------------------------------------------------
library(dm)
flights_dm <- dm_nycflights13()
tbl(flights_dm, "airports")
flights_dm$planes
flights_dm[["weather"]]

## ------------------------------------------------------------------------
dm_apply_filters_to_tbl(flights_dm, airlines)

