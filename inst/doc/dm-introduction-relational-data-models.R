## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ------------------------------------------------------------------------
library(tidyverse)
library(dm)
library(nycflights13)

flights %>% 
  left_join(airlines, by = "carrier") %>%
  left_join(planes, by = "tailnum") %>%
  left_join(airports, by = c("origin" = "faa"))

## ----warning=F, message=F------------------------------------------------
dm <- dm_nycflights13(cycle = TRUE) 

dm %>% 
  dm_draw()

## ------------------------------------------------------------------------
dm %>%
  dm_get_all_pks()

## ------------------------------------------------------------------------
dm %>% 
  dm_enum_pk_candidates(airports)

## ------------------------------------------------------------------------
dm %>% 
  dm_enum_fk_candidates(flights, airlines)

## ------------------------------------------------------------------------
dm %>% 
  dm_get_fk(flights, airlines)

## ------------------------------------------------------------------------
#  Update in one single location...
airlines[airlines$carrier == "UA", "name"] <- "United broke my guitar"

airlines %>%
  filter(carrier == "UA")

# ...propagates to all related records
flights %>%
  left_join(airlines) %>% 
  select(flight, name)

## ------------------------------------------------------------------------
planes %>%
  decompose_table(model_id, model, manufacturer, type, engines, seats, manufacturer, speed)

## ------------------------------------------------------------------------
src_sqlite <- src_sqlite(":memory:", create = TRUE)
src_sqlite
copy_dm_to(src_sqlite, dm)
src_sqlite

## ----eval=FALSE----------------------------------------------------------
#  dm_learn_from_db(src_sqlite)

