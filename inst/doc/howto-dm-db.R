## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ------------------------------------------------------------------------
library(RMariaDB)
my_db <- dbConnect(
  MariaDB(),
  username = 'guest',
  password = 'relational',
  dbname = 'Financial_ijs',
  host = 'relational.fit.cvut.cz'
)

## ----message = FALSE-----------------------------------------------------
library(dm)

my_dm <- dm_from_src(my_db)
my_dm

## ------------------------------------------------------------------------
dbListTables(my_db)

library(dbplyr)
loans <- tbl(my_db, "loans")
accounts <- tbl(my_db, "accounts")

my_manual_dm <- dm(loans, accounts)
my_manual_dm

## ------------------------------------------------------------------------
my_dm_keys <-
  my_manual_dm %>%
  dm_add_pk(accounts, id) %>%
  dm_add_pk(loans, id) %>%
  dm_add_fk(loans, account_id, accounts) %>%
  dm_set_colors(green = loans, orange = accounts)

my_dm_keys %>%
  dm_draw()

## ------------------------------------------------------------------------
trans <- tbl(my_db, "trans")

my_dm_keys %>%
  dm_add_tbl(trans)

## ------------------------------------------------------------------------
my_dm_keys

my_dm_trans <-
  my_dm_keys %>%
  dm_add_tbl(trans)

my_dm_trans

## ------------------------------------------------------------------------
my_dm_keys %>%
  dm_flatten_to_tbl(loans)

my_dm_keys %>%
  dm_flatten_to_tbl(loans) %>%
  sql_render()

## ------------------------------------------------------------------------
my_dm_total <-
  my_dm_keys %>%
  dm_zoom_to(loans) %>%
  group_by(account_id) %>%
  summarize(total_amount = sum(amount, na.rm = TRUE)) %>%
  ungroup() %>%
  dm_insert_zoomed("total_loans")

my_dm_total$total_loans

my_dm_total %>%
  dm_draw()

my_dm_total$total_loans %>%
  sql_render()

## ------------------------------------------------------------------------
my_dm_sqlite <- dm_financial_sqlite()

my_dm_total <-
  my_dm_sqlite %>%
  dm_zoom_to(loans) %>%
  group_by(account_id) %>%
  summarize(total_amount = sum(amount, na.rm = TRUE)) %>%
  ungroup() %>%
  dm_insert_zoomed("total_loans")

## ------------------------------------------------------------------------
my_dm_total_computed <-
  my_dm_total %>%
  compute()

my_dm_total_computed$total_loans

my_dm_total_computed$total_loans %>%
  sql_render()

## ------------------------------------------------------------------------
my_dm_local <-
  my_dm_total %>%
  collect()

my_dm_local$total_loans

## ------------------------------------------------------------------------
my_dm_total_inplace <-
  my_dm_sqlite %>%
  dm_zoom_to(loans) %>%
  group_by(account_id) %>%
  summarize(total_amount = sum(amount, na.rm = TRUE)) %>%
  ungroup() %>%
  compute() %>%
  dm_insert_zoomed("total_loans")

my_dm_total_inplace$total_loans %>%
  sql_render()

## ------------------------------------------------------------------------
dm_financial_sqlite

## ------------------------------------------------------------------------
loans_df <-
  my_dm_sqlite %>%
  dm_squash_to_tbl(loans) %>%
  select(id, amount, duration, A3) %>%
  collect()

model <- lm(amount ~ duration + A3, data = loans_df)

loans_residuals <- tibble::tibble(
  id = loans_df$id,
  resid = unname(residuals(model))
)

my_dm_sqlite_resid <-
  copy_to(my_dm_sqlite, loans_residuals, temporary = FALSE) %>%
  dm_add_pk(loans_residuals, id) %>%
  dm_add_fk(loans_residuals, id, loans)

my_dm_sqlite_resid %>%
  dm_draw()
my_dm_sqlite_resid %>%
  dm_examine_constraints()
my_dm_sqlite_resid$loans_residuals

