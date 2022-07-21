## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ------------------------------------------------------------------------
#  library(dm)
#  library(tidyverse)
#  library(dbplyr)
#  
#  fin_dm <-
#    dm_financial() %>%
#    dm_select_tbl(-trans) %>%
#    collect()
#  
#  local_db <- DBI::dbConnect(RSQLite::SQLite())
#  deployed_dm <- copy_dm_to(local_db, fin_dm, temporary = FALSE)

## ------------------------------------------------------------------------
#  my_dm_total <-
#    deployed_dm %>%
#    dm_zoom_to(loans) %>%
#    group_by(account_id) %>%
#    summarize(total_amount = sum(amount, na.rm = TRUE)) %>%
#    ungroup() %>%
#    dm_insert_zoomed("total_loans")

## ------------------------------------------------------------------------
#  my_dm_total$total_loans %>%
#    sql_render()

## ------------------------------------------------------------------------
#  my_dm_total_computed <-
#    deployed_dm %>%
#    dm_zoom_to(loans) %>%
#    group_by(account_id) %>%
#    summarize(total_amount = sum(amount, na.rm = TRUE)) %>%
#    ungroup() %>%
#    compute() %>%
#    dm_insert_zoomed("total_loans")
#  
#  my_dm_total_computed$total_loans %>%
#    sql_render()

## ----echo = FALSE, eval = TRUE-------------------------------------------
# https://github.com/tidyverse/dbplyr/issues/639, https://github.com/tidyverse/dbplyr/pull/649
remote_name_total_loans <- "dbplyr_001"
stopifnot(grepl(remote_name_total_loans, sql_render(my_dm_total_computed$total_loans), fixed = TRUE))

## ------------------------------------------------------------------------
#  my_dm_total_snapshot <-
#    my_dm_total %>%
#    compute()

## ------------------------------------------------------------------------
#  loans_df <-
#    deployed_dm %>%
#    dm_flatten_to_tbl(loans, .recursive = TRUE) %>%
#    select(id, amount, duration, A3) %>%
#    collect()

## ------------------------------------------------------------------------
#  model <- lm(amount ~ duration + A3, data = loans_df)
#  
#  loans_residuals <- tibble::tibble(
#    id = loans_df$id,
#    resid = unname(residuals(model))
#  )
#  
#  loans_residuals

## ------------------------------------------------------------------------
#  my_dm_sqlite_resid <-
#    copy_to(deployed_dm, loans_residuals, temporary = FALSE) %>%
#    dm_add_pk(loans_residuals, id) %>%
#    dm_add_fk(loans_residuals, id, loans)
#  
#  my_dm_sqlite_resid %>%
#    dm_set_colors(violet = loans_residuals) %>%
#    dm_draw()
#  my_dm_sqlite_resid %>%
#    dm_examine_constraints()
#  my_dm_sqlite_resid$loans_residuals

## ------------------------------------------------------------------------
#  dm_financial() %>%
#    dm_nrow()
#  fin_dm <-
#    dm_financial() %>%
#    dm_select_tbl(-trans) %>%
#    collect()
#  
#  fin_dm

## ------------------------------------------------------------------------
#  destination_db <- DBI::dbConnect(RSQLite::SQLite())
#  
#  deployed_dm <-
#    copy_dm_to(destination_db, fin_dm, temporary = FALSE)
#  
#  deployed_dm

## ------------------------------------------------------------------------
#  dup_dm <-
#    copy_dm_to(destination_db, fin_dm, temporary = FALSE, table_names = ~ paste0("dup_", .x))
#  
#  dup_dm
#  remote_name(dup_dm$accounts)
#  remote_name(deployed_dm$accounts)

## ----disconnect----------------------------------------------------------
#  DBI::dbDisconnect(destination_db)
#  DBI::dbDisconnect(local_db)

