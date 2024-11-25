## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ------------------------------------------------------------------------
# library(dm)

## ------------------------------------------------------------------------
# data_1 <- tibble(a = c(1, 2, 1), b = c(1, 4, 1), c = c(5, 6, 7))
# data_2 <- tibble(a = c(1, 2, 3), b = c(4, 5, 6), c = c(7, 8, 9))

## ----error = TRUE--------------------------------------------------------
try({
# check_key(data_1, a)
})

## ------------------------------------------------------------------------
# check_key(data_2, a)

## ------------------------------------------------------------------------
# check_subset(data_1, a, data_2, a)

## ----error = TRUE--------------------------------------------------------
try({
# check_subset(data_2, a, data_1, a)
})

## ----eval=FALSE----------------------------------------------------------
# check_key(t2, c2)
# check_subset(t1, c1, t2, c2)

## ----error=TRUE----------------------------------------------------------
try({
# check_set_equality(data_1, a, data_2, a)
})

## ------------------------------------------------------------------------
# data_3 <- tibble(a = c(2, 1, 2), b = c(4, 5, 6), c = c(7, 8, 9))
# 
# check_set_equality(data_1, a, data_3, a)

## ------------------------------------------------------------------------
# d1 <- tibble(a = 1:5)
# d2 <- tibble(c = c(1:5, 5))
# d3 <- tibble(c = 1:4)
# d4 <- tibble(a = c(2:5, 5))

## ----error=TRUE----------------------------------------------------------
try({
# # This does not pass, `c` is not unique key of d2:
# check_cardinality_0_n(d2, c, d1, a)
# 
# # This passes, multiple values in d2$c are allowed:
# check_cardinality_0_n(d1, a, d2, c)
# 
# # This does not pass, injectivity is violated:
# check_cardinality_1_1(d1, a, d2, c)
# 
# # This passes:
# check_cardinality_0_1(d1, a, d3, c)
})

## ------------------------------------------------------------------------
# examine_cardinality(d1, a, d3, c)
# examine_cardinality(d1, a, d2, c)
# examine_cardinality(d1, a, d1, a)
# examine_cardinality(d1, a, d4, a)

## ------------------------------------------------------------------------
# examine_cardinality(d2, c, d1, a)

## ------------------------------------------------------------------------
# mtcars_tibble <- tibble::as_tibble(mtcars)
# mtcars_tibble
# decomposed_table <- decompose_table(mtcars_tibble, am_gear_carb_id, am, gear, carb)
# decomposed_table

## ------------------------------------------------------------------------
# parent_table <- decomposed_table$parent_table
# child_table <- decomposed_table$child_table
# reunite_parent_child(child_table, parent_table, id_column = am_gear_carb_id)

## ----eval = FALSE--------------------------------------------------------
# # Shortcut:
# reunite_parent_child_from_list(decomposed_table, id_column = am_gear_carb_id)

