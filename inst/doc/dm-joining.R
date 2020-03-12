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

## ----message=FALSE, warning=FALSE----------------------------------------
library(dm)
library(tidyverse)
library(nycflights13)

## ------------------------------------------------------------------------
dm <- dm_nycflights13()

## ------------------------------------------------------------------------
dm %>% 
  dm_draw()

## ------------------------------------------------------------------------
dm %>% 
  dm_get_all_fks()

## ------------------------------------------------------------------------
dm_joined <- dm %>% 
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

