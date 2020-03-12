## ----setup, include = FALSE----------------------------------------------
library(dplyr)
library(dm)
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

## ------------------------------------------------------------------------
library(dm)
library(dplyr)
flights_dm_w_many_keys <- dm_nycflights13(color = FALSE)
flights_dm_w_many_keys

## ------------------------------------------------------------------------
dm_draw(flights_dm_w_many_keys)

## ------------------------------------------------------------------------
dm_get_available_colors()

## ------------------------------------------------------------------------
flights_dm_w_many_keys_and_colors <-
  flights_dm_w_many_keys %>% 
  dm_set_colors(
    maroon4 = flights,
    orange = starts_with("air"),
    "#5986C4" = planes
  )

## ------------------------------------------------------------------------
dm_draw(flights_dm_w_many_keys_and_colors)

## ------------------------------------------------------------------------
dm_get_colors(flights_dm_w_many_keys_and_colors)

## ------------------------------------------------------------------------
flights_dm_w_many_keys_and_colors %>% 
  dm_draw(view_type = "title_only")

## ------------------------------------------------------------------------
flights_dm_w_many_keys_and_colors %>% 
  dm_select_tbl(flights, airports, planes) %>% 
  dm_draw()

