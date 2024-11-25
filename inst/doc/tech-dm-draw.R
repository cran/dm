## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ------------------------------------------------------------------------
# library(dm)
# library(dplyr)
# flights_dm_w_many_keys <- dm_nycflights13(cycle = TRUE, color = FALSE)
# flights_dm_w_many_keys

## ------------------------------------------------------------------------
# dm_draw(flights_dm_w_many_keys)

## ------------------------------------------------------------------------
# dm_get_available_colors()

## ------------------------------------------------------------------------
# flights_dm_w_many_keys_and_colors <-
#   flights_dm_w_many_keys %>%
#   dm_set_colors(
#     maroon4 = flights,
#     orange = starts_with("air"),
#     "#5986C4" = planes
#   )

## ------------------------------------------------------------------------
# dm_draw(flights_dm_w_many_keys_and_colors)

## ------------------------------------------------------------------------
# dm_get_colors(flights_dm_w_many_keys_and_colors)

## ------------------------------------------------------------------------
# flights_dm_w_many_keys_and_colors %>%
#   dm_draw(view_type = "title_only")

## ------------------------------------------------------------------------
# flights_dm_w_many_keys_and_colors %>%
#   dm_select_tbl(flights, airports, planes) %>%
#   dm_draw()

## ----eval = default_eval() && rlang::is_installed("DiagrammeRsvg")-------
# flights_dm_w_many_keys_and_colors %>%
#   dm_select_tbl(flights, airports, planes) %>%
#   dm_draw() %>%
#   DiagrammeRsvg::export_svg() %>%
#   write("flights_dm_w_many_keys_and_color.svg")

