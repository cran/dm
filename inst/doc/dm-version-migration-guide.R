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
library(dm)

## ------------------------------------------------------------------------
library(dm)
flights_dm <- dm_nycflights13()
tbl(flights_dm, "airports")
flights_dm$planes
flights_dm[["weather"]]

## ------------------------------------------------------------------------
dm_apply_filters_to_tbl(flights_dm, airlines)

