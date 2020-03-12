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
library(tidyverse)
library(nycflights13)
library(dm)

## ----message=FALSE, warning=FALSE----------------------------------------
library(tidyverse)
library(nycflights13)
library(dm)

## ------------------------------------------------------------------------
dm <- dm_nycflights13()

## ------------------------------------------------------------------------
dm

## ------------------------------------------------------------------------
dm_draw(dm)

## ------------------------------------------------------------------------
tbl(dm, "airports")

## ------------------------------------------------------------------------
filtered_dm <- 
  dm %>%
  dm_filter(airports, name == "John F Kennedy Intl")
filtered_dm

## ------------------------------------------------------------------------
rows_per_table <- 
  filtered_dm %>% 
  dm_apply_filters() %>% 
  dm_nrow()
rows_per_table
sum(rows_per_table)

## ------------------------------------------------------------------------
dm %>% 
  dm_filter(flights, dest == "IAD") %>% 
  dm_apply_filters() %>% 
  dm_nrow()

## ------------------------------------------------------------------------
dm_delta_may <- dm %>%
  dm_filter(airlines, name == "Delta Air Lines Inc.") %>%
  dm_filter(airports, name != "John F Kennedy Intl") %>%
  dm_filter(flights, month == 5)
dm_delta_may
dm_delta_may %>% 
  dm_apply_filters() %>% 
  dm_nrow()

## ------------------------------------------------------------------------
dm_delta_may %>% 
  dm_apply_filters_to_tbl("airlines")

## ------------------------------------------------------------------------
dm_delta_may %>% 
  dm_apply_filters_to_tbl("planes")

## ------------------------------------------------------------------------
dm_delta_may %>% 
  dm_apply_filters_to_tbl("flights")

## ------------------------------------------------------------------------
airlines_filtered <- filter(airlines, name == "Delta Air Lines Inc.")
airports_filtered <- filter(airports, name != "John F Kennedy Intl")
flights %>%
  semi_join(airlines_filtered, by = "carrier") %>%
  semi_join(airports_filtered, by = c("origin" = "faa")) %>%
  filter(month == 5)

## ---- warning=F----------------------------------------------------------
dm %>%
  dm_select_tbl(flights, airlines, airports) %>%
  dm_filter(flights, month == 5) %>% 
  copy_dm_to(dbplyr::src_memdb(), ., unique_table_names = TRUE) %>% 
  dm_filter(airlines, name == "Delta Air Lines Inc.") %>%
  dm_filter(airports, name != "John F Kennedy Intl") %>%
  dm_apply_filters() %>% 
  dm_get_tables() %>%
  map(dbplyr::sql_render)

