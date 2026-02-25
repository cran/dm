# Extracted from test-learn.R:229

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "dm", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
con_sqlite <- skip_if_error(DBI::dbConnect(RSQLite::SQLite(), ":memory:"))
withr::defer(DBI::dbDisconnect(con_sqlite))
db2_path <- withr::local_tempfile(fileext = ".sqlite")
con2 <- DBI::dbConnect(RSQLite::SQLite(), db2_path)
withr::defer(DBI::dbDisconnect(con2))
DBI::dbExecute(con2, "CREATE TABLE parent (id INTEGER PRIMARY KEY, val TEXT NOT NULL)")
DBI::dbExecute(
    con2,
    paste(
      "CREATE TABLE child (",
      "id INTEGER PRIMARY KEY, parent_id INTEGER,",
      "FOREIGN KEY (parent_id) REFERENCES parent (id))"
    )
  )
DBI::dbDisconnect(con2)
DBI::dbExecute(
    con_sqlite,
    paste0("ATTACH DATABASE '", db2_path, "' AS other")
  )
learned_dm <- dm_from_con(con_sqlite, schema = "other", learn_keys = TRUE) %>%
    collect()
