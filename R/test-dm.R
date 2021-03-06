#' Loads `dm` objects into one or more registered sources
#'
#' @description Works like `dbplyr::test_load()`, just for `dm`_objects.
#'
#' @return A list of the same `dm` object on different \pkg{dplyr} sources.
#'
#' @noRd
#' @examples
#' dbplyr::test_register_src("df", dplyr::src_df(env = new.env()))
#' dbplyr::test_register_src("sqlite", dplyr::src_sqlite(":memory:", create = TRUE))
#' @examplesIf rlang::is_installed("nycflights13")
#'
#' dm_test_obj <- dm_nycflights13(cycle = TRUE)
#' dm_test_obj_srcs <- dm_test_load(dm_test_obj)
dm_test_load <- function(x,
                         srcs = dbplyr:::test_srcs$get(), # FIXME: not exported from {dplyr}... could also "borrow" source code as new function here!?
                         ignore = character(),
                         set_key_constraints = TRUE) {
  stopifnot(is.character(ignore))
  srcs <- srcs[setdiff(names(srcs), ignore)]

  map(srcs, ~ copy_dm_to(., dm = x, unique_table_names = TRUE, set_key_constraints = set_key_constraints))
}


# internal helper functions:

# validates, that `table` is character and is part of the `dm` object
dm_tbl_name <- function(dm, table) {
  table_name <- as_name(ensym(table))

  # Missing argument?
  if (table_name == "") {
    arg_name <- deparse(uncurly(substitute(table)))
    abort_table_missing(arg_name)
  }

  if (!(table_name %in% src_tbls_impl(dm))) {
    abort_table_not_in_dm(table_name, src_tbls_impl(dm))
  }

  table_name
}

dm_tbl_name_null <- function(dm, table) {
  table_expr <- enexpr(table)

  # Missing argument?
  if (quo_is_null(table_expr)) {
    return(NULL)
  }

  table_name <- as_name(table_expr)

  if (!(table_name %in% src_tbls_impl(dm))) {
    abort_table_not_in_dm(table_name, src_tbls_impl(dm))
  }

  table_name
}

uncurly <- function(call) {
  # Transforms {{ x }} to x
  # Doesn't work for other expression patterns
  call[[2]][[2]]
}

is_this_a_test <- function() {
  # Only run if the top level call is devtools::test() or testthat::test_check()

  calls <-
    sys.calls() %>%
    as.list() %>%
    map(as.list) %>%
    map(1) %>%
    map_chr(as_label)

  is_test_call <- any(calls %in% c("devtools::test", "testthat::test_check", "testthat::test_file", "testthis:::test_this"))

  is_testing <- rlang::is_installed("testthat") && testthat::is_testing()

  is_test_call || is_testing
}


# more general 'check'-type functions -------------------------------------


check_param_class <- function(param_value, correct_class, param_name = deparse(substitute(param_value))) {
  if (!inherits(param_value, correct_class)) {
    abort_parameter_not_correct_class(
      parameter = param_name,
      correct_class = correct_class,
      class = class(param_value)
    )
  }
}

check_param_length <- function(param_value, correct_length = 1, param_name = deparse(substitute(param_value))) {
  if (length(param_value) != correct_length) {
    abort_parameter_not_correct_length(
      parameter = param_name,
      correct_length = correct_length,
      param_value
    )
  }
}

# general error: table not part of `dm` -----------------------------------

abort_table_missing <- function(arg_name) {
  abort(error_txt_table_missing(arg_name), .subclass = dm_error_full("table_missing"))
}

error_txt_table_missing <- function(arg_name) {
  glue("Must pass {tick(arg_name)} argument.")
}

abort_table_not_in_dm <- function(table_name, dm_tables) {
  abort(error_txt_table_not_in_dm(table_name, dm_tables), .subclass = dm_error_full("table_not_in_dm"))
}

error_txt_table_not_in_dm <- function(table_name, dm_tables) {
  glue("Table {commas(tick(table_name))} not in `dm` object. Available table names: {commas(tick(dm_tables))}.")
}
