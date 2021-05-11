## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ----message=FALSE, warning=FALSE----------------------------------------
library(dm)
library(tidyverse)

## ------------------------------------------------------------------------
dm <- dm_nycflights13()

## ------------------------------------------------------------------------
dm %>%
  dm_draw()

## ------------------------------------------------------------------------
dm %>%
  dm_get_all_fks()

## ------------------------------------------------------------------------
dm_joined <-
  dm %>%
  dm_join_to_tbl(flights, airlines, join = left_join)
dm_joined

## ------------------------------------------------------------------------
dm %>%
  tbl("flights") %>%
  names()

dm %>%
  tbl("airlines") %>%
  names()

dm_joined %>%
  names()

## ------------------------------------------------------------------------
dm_joined %>%
  class()

## ------------------------------------------------------------------------
dm %>%
  dm_join_to_tbl(flights, airlines, join = anti_join)

## ------------------------------------------------------------------------
dm_nycflights13() %>%
  dm_filter(airlines, name == "Delta Air Lines Inc.") %>%
  dm_filter(flights, month == 5) %>%
  dm_apply_filters() %>%
  dm_join_to_tbl(flights, airports, join = left_join)

## ------------------------------------------------------------------------
dm_nycflights13() %>%
  dm_select_tbl(-weather) %>%
  dm_flatten_to_tbl(start = flights)

