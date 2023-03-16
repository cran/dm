## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ----eval = FALSE--------------------------------------------------------
#  library(RMariaDB)
#  
#  my_db <- dbConnect(
#    MariaDB(),
#    username = "guest",
#    password = "relational",
#    dbname = "Financial_ijs",
#    host = "relational.fit.cvut.cz"
#  )

## ----echo = FALSE--------------------------------------------------------
#  library(RMariaDB)
#  my_db <- dm:::financial_db_con()

## ------------------------------------------------------------------------
#  library(dm)
#  
#  my_dm <- dm_from_con(my_db)
#  my_dm

## ------------------------------------------------------------------------
#  dbListTables(my_db)
#  
#  library(dbplyr)
#  loans <- tbl(my_db, "loans")
#  accounts <- tbl(my_db, "accounts")
#  
#  my_manual_dm <- dm(loans, accounts)
#  my_manual_dm

## ----load----------------------------------------------------------------
#  library(dm)
#  
#  fin_dm <- dm_from_con(my_db, learn_keys = FALSE)
#  fin_dm

## ------------------------------------------------------------------------
#  my_dm_keys <-
#    my_manual_dm %>%
#    dm_add_pk(accounts, id) %>%
#    dm_add_pk(loans, id) %>%
#    dm_add_fk(loans, account_id, accounts) %>%
#    dm_set_colors(green = loans, orange = accounts)
#  
#  my_dm_keys %>%
#    dm_draw()

## ------------------------------------------------------------------------
#  trans <- tbl(my_db, "trans")
#  
#  my_dm_keys %>%
#    dm(trans)

## ----error = TRUE--------------------------------------------------------
#  unserialize(serialize(my_dm_keys, NULL))

## ------------------------------------------------------------------------
#  my_db_fun <- function() {
#    dbConnect(
#      MariaDB(),
#      username = "guest",
#      password = "relational",
#      dbname = "Financial_ijs",
#      host = "relational.fit.cvut.cz"
#    )
#  }
#  
#  my_dm_fun <- function(my_db = my_db_fun()) {
#    loans <- tbl(my_db, "loans")
#    accounts <- tbl(my_db, "accounts")
#    dm(loans, accounts) %>%
#      dm_add_pk(accounts, id) %>%
#      dm_add_pk(loans, id) %>%
#      dm_add_fk(loans, account_id, accounts) %>%
#      dm_set_colors(green = loans, orange = accounts)
#  }

## ----echo = FALSE--------------------------------------------------------
#  my_db_fun <- function() {
#    dm:::financial_db_con()
#  }

## ----echo = FALSE--------------------------------------------------------
#  my_dm_fun() %>%
#    dm_draw()

## ------------------------------------------------------------------------
#  my_dm_keys
#  
#  my_dm_trans <-
#    my_dm_keys %>%
#    dm(trans)
#  
#  my_dm_trans

## ------------------------------------------------------------------------
#  my_dm_keys %>%
#    dm_flatten_to_tbl(loans)
#  
#  my_dm_keys %>%
#    dm_flatten_to_tbl(loans) %>%
#    sql_render()

## ------------------------------------------------------------------------
#  my_dm_total <-
#    my_dm_keys %>%
#    dm_zoom_to(loans) %>%
#    group_by(account_id) %>%
#    summarize(total_amount = sum(amount, na.rm = TRUE)) %>%
#    ungroup() %>%
#    dm_insert_zoomed("total_loans")

## ------------------------------------------------------------------------
#  my_dm_total %>%
#    dm_set_colors(violet = total_loans) %>%
#    dm_draw()

## ------------------------------------------------------------------------
#  my_dm_total$total_loans

## ------------------------------------------------------------------------
#  my_dm_total$total_loans %>%
#    sql_render()

## ------------------------------------------------------------------------
#  my_dm_local <-
#    my_dm_total %>%
#    collect()
#  
#  my_dm_local$total_loans

## ------------------------------------------------------------------------
#  my_dm_total %>%
#    dm_nrow()

## ------------------------------------------------------------------------
#  destination_db <- DBI::dbConnect(RSQLite::SQLite())
#  
#  deployed_dm <- copy_dm_to(destination_db, my_dm_local)
#  
#  deployed_dm
#  my_dm_local

## ----disconnect----------------------------------------------------------
#  DBI::dbDisconnect(destination_db)
#  DBI::dbDisconnect(my_db)

