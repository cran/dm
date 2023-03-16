## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ----connect, eval = FALSE-----------------------------------------------
#  library(RMariaDB)
#  
#  fin_db <- dbConnect(
#    MariaDB(),
#    username = "guest",
#    password = "relational",
#    dbname = "Financial_ijs",
#    host = "relational.fit.cvut.cz"
#  )

## ----connect-real, echo = FALSE------------------------------------------
#  library(RMariaDB)
#  
#  fin_db <- dm:::financial_db_con()

## ----load-full-----------------------------------------------------------
#  library(dm)
#  
#  fin_dm <- dm_from_con(fin_db)
#  fin_dm

## ----names---------------------------------------------------------------
#  names(fin_dm)
#  fin_dm$loans
#  dplyr::count(fin_dm$trans)

## ----select--------------------------------------------------------------
#  fin_dm_small <- fin_dm[c("loans", "accounts", "districts", "trans")]
#  fin_dm_small <-
#    fin_dm %>%
#    dm_select_tbl(loans, accounts, districts, trans)

## ----load----------------------------------------------------------------
#  library(dm)
#  
#  fin_dm_small <-
#    dm_from_con(fin_db, learn_keys = FALSE) %>%
#    dm_select_tbl(loans, accounts, districts, trans)

## ----keys----------------------------------------------------------------
#  fin_dm_keys <-
#    fin_dm_small %>%
#    dm_add_pk(table = accounts, columns = id) %>%
#    dm_add_pk(loans, id) %>%
#    dm_add_fk(table = loans, columns = account_id, ref_table = accounts) %>%
#    dm_add_pk(trans, id) %>%
#    dm_add_fk(trans, account_id, accounts) %>%
#    dm_add_pk(districts, id) %>%
#    dm_add_fk(accounts, district_id, districts)

## ----visualize_keys------------------------------------------------------
#  fin_dm_keys %>%
#    dm_set_colors(darkgreen = c(loans, accounts), darkblue = trans, grey = districts) %>%
#    dm_draw()

## ----squash--------------------------------------------------------------
#  fin_dm_keys %>%
#    dm_flatten_to_tbl(loans, .recursive = TRUE)

## ----model---------------------------------------------------------------
#  loans_df <-
#    fin_dm_keys %>%
#    dm_flatten_to_tbl(loans, .recursive = TRUE) %>%
#    select(id, amount, duration, A3) %>%
#    collect()
#  
#  model <- lm(amount ~ duration + A3, data = loans_df)
#  
#  model

## ----zoom----------------------------------------------------------------
#  fin_dm_total <-
#    fin_dm_keys %>%
#    dm_zoom_to(loans) %>%
#    group_by(account_id) %>%
#    summarize(total_amount = sum(amount, na.rm = TRUE)) %>%
#    ungroup() %>%
#    dm_insert_zoomed("total_loans")
#  
#  fin_dm_total$total_loans

## ----constraints---------------------------------------------------------
#  fin_dm_total %>%
#    dm_examine_constraints()

## ----disconnect, echo = FALSE, results = "hide"--------------------------
#  dbDisconnect(fin_db)

