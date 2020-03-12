## ----setup, include = FALSE----------------------------------------------
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

## ---- echo = FALSE-------------------------------------------------------
dm_nycflights13(cycle = TRUE) %>%
  dm_draw()

