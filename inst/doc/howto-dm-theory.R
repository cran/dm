## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ------------------------------------------------------------------------
#  library(tidyverse)
#  library(dm)
#  library(nycflights13)
#  
#  nycflights13_df <-
#    flights %>%
#    left_join(airlines, by = "carrier") %>%
#    left_join(planes, by = "tailnum") %>%
#    left_join(airports, by = c("origin" = "faa")) %>%
#    left_join(weather, by = c("origin", "time_hour"))
#  
#  nycflights13_df

## ----warning=FALSE, message=FALSE----------------------------------------
#  dm <- dm_nycflights13(cycle = TRUE)
#  
#  dm %>%
#    dm_draw()

## ------------------------------------------------------------------------
#  object.size(dm)
#  
#  object.size(nycflights13_df)

## ------------------------------------------------------------------------
#  dm %>%
#    dm_get_all_pks()

## ------------------------------------------------------------------------
#  dm %>%
#    dm_enum_pk_candidates(airports)

## ------------------------------------------------------------------------
#  dm %>%
#    dm_enum_fk_candidates(flights, airlines)

## ------------------------------------------------------------------------
#  dm %>%
#    dm_get_all_fks()

## ------------------------------------------------------------------------
#  dm %>%
#    dm_examine_constraints()

## ------------------------------------------------------------------------
#  #  Update in one single location...
#  airlines[airlines$carrier == "UA", "name"] <- "United broke my guitar"
#  
#  airlines %>%
#    filter(carrier == "UA")
#  
#  # ...propagates to all related records
#  flights %>%
#    left_join(airlines) %>%
#    select(flight, name)

## ------------------------------------------------------------------------
#  planes %>%
#    decompose_table(model_id, model, manufacturer, type, engines, seats, speed)

## ------------------------------------------------------------------------
#  con_sqlite <- DBI::dbConnect(RSQLite::SQLite())
#  con_sqlite
#  DBI::dbListTables(con_sqlite)
#  
#  copy_dm_to(con_sqlite, dm)
#  DBI::dbListTables(con_sqlite)

## ------------------------------------------------------------------------
#  dm_from_con(con_sqlite)

## ----disconnect----------------------------------------------------------
#  DBI::dbDisconnect(con_sqlite)

