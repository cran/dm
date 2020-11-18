## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ------------------------------------------------------------------------
library(tidyverse)
library(dm)
parent <- tibble(value = c("A", "B", "C"), pk = 1:3)
parent
child <- tibble(value = c("a", "b", "c"), pk = 1:3, fk = c(1, 1, NA))
child
demo_dm <-
  dm(parent = parent, child = child) %>%
  dm_add_pk(parent, pk) %>%
  dm_add_pk(child, pk) %>%
  dm_add_fk(child, fk, parent)

demo_dm %>% 
  dm_draw(view_type = "full")

## ------------------------------------------------------------------------
dm_examine_constraints(demo_dm)

## ------------------------------------------------------------------------
library(DBI)
sqlite_db <- DBI::dbConnect(RSQLite::SQLite())
demo_sql <- copy_dm_to(sqlite_db, demo_dm, temporary = FALSE)
demo_sql

## ------------------------------------------------------------------------
new_parent <- tibble(value = "D", pk = 4)
new_parent
new_child <- tibble(value = "d", pk = 4, fk = 4)
new_child
dm_insert_in <-
  dm(parent = new_parent, child = new_child) %>%
  copy_dm_to(sqlite_db, ., temporary = TRUE)

## ------------------------------------------------------------------------
dm_insert_out <-
  demo_sql %>%
  dm_rows_insert(dm_insert_in)

## ------------------------------------------------------------------------
dm_insert_out$child
demo_sql$child

## ------------------------------------------------------------------------
dm_insert_out <-
  demo_sql %>%
  dm_rows_insert(dm_insert_in, in_place = TRUE)

demo_sql$child

## ------------------------------------------------------------------------
updated_child <- tibble(value = "b", pk = 2, fk = 2)
updated_child
dm_update_in <-
  dm(child = updated_child) %>%
  copy_dm_to(sqlite_db, ., temporary = TRUE)

dm_update_out <-
  demo_sql %>%
  dm_rows_update(dm_update_in, in_place = TRUE)

demo_sql$child

## ------------------------------------------------------------------------
local_dm <- collect(demo_sql)

local_dm$parent
local_dm$child
dm_deleted <-
  dm(parent = new_parent, child = new_child) %>%
  dm_rows_delete(local_dm, .)

dm_deleted$child

## ------------------------------------------------------------------------
patched_child <- tibble(value = "c", pk = 3, fk = 3)
patched_child
dm_patched <-
  dm(child = patched_child) %>%
  dm_rows_patch(dm_deleted, .)

dm_patched$child

## ------------------------------------------------------------------------
upserted_parent <- tibble(value = "D", pk = 4)
upserted_parent
upserted_child <- tibble(value = c("b", "d"), pk = c(2, 4), fk = c(3, 4))
upserted_child
dm_upserted <-
  dm(parent = upserted_parent, child = upserted_child) %>%
  dm_rows_upsert(dm_patched, .)

dm_upserted$parent
dm_upserted$child

## ------------------------------------------------------------------------
dm_trunc_in <-
  demo_sql %>%
  dm_select_tbl(child)
dm_trunc_in
dm_trunc_out <-
  demo_sql %>%
  dm_rows_truncate(dm_trunc_in, in_place = TRUE)

demo_sql$child

