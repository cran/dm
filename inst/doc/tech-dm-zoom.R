## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ----zoom----------------------------------------------------------------
library(dm)
library(dplyr)
flights_dm <- dm_nycflights13()
flights_dm
flights_zoomed <-
  flights_dm %>%
  dm_zoom_to(flights)
# The print output for a `zoomed_dm` looks very much like that from a normal `tibble`.
flights_zoomed

flights_zoomed_mutate <-
  flights_zoomed %>%
  mutate(am_pm_dep = if_else(dep_time < 1200, "am", "pm")) %>%
  # in order to see our changes in the output we use `select()` for reordering the columns
  select(year:dep_time, am_pm_dep, everything())
flights_zoomed_mutate

# To update the original `dm` with a new `flights` table we use `dm_update_zoomed()`:
updated_flights_dm <-
  flights_zoomed_mutate %>%
  dm_update_zoomed()
# The only difference in the `dm` print output is the increased number of columns
updated_flights_dm
# The schematic view of the data model remains unchanged
dm_draw(updated_flights_dm)

## ------------------------------------------------------------------------
library(tidyr)
weather_zoomed <-
  flights_dm %>%
  dm_zoom_to(weather)
weather_zoomed
# Maybe there is some hidden candidate for a primary key that we overlooked
enum_pk_candidates(weather_zoomed)
# Seems we have to construct a column with unique values
# This can be done by combining column `origin` with `time_hour`, if the latter
# is converted to a single time zone first; all within the `dm`:
weather_zoomed_mutate <-
  weather_zoomed %>%
  # first convert all times to the same time zone:
  mutate(time_hour_fmt = format(time_hour, tz = "UTC")) %>%
  # paste together as character the airport code and the time
  unite("origin_slot_id", origin, time_hour_fmt) %>%
  select(origin_slot_id, everything())
# check if we the result is as expected:
enum_pk_candidates(weather_zoomed_mutate) %>% filter(candidate)
flights_upd_weather_dm <-
  weather_zoomed_mutate %>%
  dm_update_zoomed() %>%
  dm_add_pk(weather, origin_slot_id)
flights_upd_weather_dm
# creating the coveted FK relation between `flights` and `weather`
extended_flights_dm <-
  flights_upd_weather_dm %>%
  dm_zoom_to(flights) %>%
  mutate(time_hour_fmt = format(time_hour, tz = "UTC")) %>%
  # need to keep `origin` as FK to airports, so `remove = FALSE`
  unite("origin_slot_id", origin, time_hour_fmt, remove = FALSE) %>%
  dm_update_zoomed() %>%
  dm_add_fk(flights, origin_slot_id, weather)
extended_flights_dm %>% dm_draw()

## ------------------------------------------------------------------------
dm_draw(dm_nycflights13(cycle = TRUE))

## ------------------------------------------------------------------------
disentangled_flights_dm <-
  dm_nycflights13(cycle = TRUE) %>%
  # zooming and immediately inserting essentially creates a copy of the original table
  dm_zoom_to(airports) %>%
  # reinserting the `airports` table under the name `destination`
  dm_insert_zoomed("destination") %>%
  # renaming the originally zoomed table
  dm_rename_tbl(origin = airports) %>%
  # Key relations are also duplicated, so the wrong ones need to be removed
  dm_rm_fk(flights, dest, origin) %>%
  dm_rm_fk(flights, origin, destination)
dm_draw(disentangled_flights_dm)

## ------------------------------------------------------------------------
dm_with_summary <-
  flights_dm %>%
  dm_zoom_to(flights) %>%
  count(origin, carrier) %>%
  dm_insert_zoomed("dep_carrier_count")
dm_draw(dm_with_summary)

## ------------------------------------------------------------------------
joined_flights_dm <-
  flights_dm %>%
  dm_zoom_to(flights) %>%
  # let's first reduce the number of columns of flights
  select(-dep_delay:-arr_delay, -air_time:-time_hour) %>%
  # in the {dm}-method for the joins you can specify which columns you want to add to the zoomed table
  left_join(planes, select = c(tailnum, plane_type = type)) %>%
  dm_insert_zoomed("flights_plane_type")
# this is how the table looks now
joined_flights_dm$flights_plane_type
# also here, the FK-relations are transferred to the new table
dm_draw(joined_flights_dm)

## ------------------------------------------------------------------------
flights_dm %>%
  dm_zoom_to(flights) %>%
  select(-dep_delay:-arr_delay, -air_time:-time_hour) %>%
  left_join(planes, select = c(tailnum, plane_type = type)) %>%
  pull_tbl()

