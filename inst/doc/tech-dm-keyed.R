## ----setup, include = FALSE----------------------------------------------
source("setup/setup.R")

## ----zoom----------------------------------------------------------------
#  library(dm)
#  library(dplyr)
#  
#  flights_dm <- dm_nycflights13(cycle = TRUE)
#  flights_dm
#  flights_keyed <-
#    flights_dm %>%
#    dm_get_tables(keyed = TRUE)
#  
#  # The print output for a `dm_keyed_tbl` looks very much like that from a normal
#  # `tibble`, with additional details about keys.
#  flights_keyed$flights
#  flights_tbl_mutate <-
#    flights_keyed$flights %>%
#    mutate(am_pm_dep = if_else(dep_time < 1200, "am", "pm"), .after = dep_time)
#  
#  flights_tbl_mutate

## ----zoom2---------------------------------------------------------------
#  updated_flights_dm <- dm(
#    flights = flights_tbl_mutate,
#    !!!flights_keyed[c("airlines", "airports", "planes", "weather")]
#  )
#  
#  # The only difference in the `dm` print output is the increased number of
#  # columns
#  updated_flights_dm
#  # The schematic view of the data model remains unchanged
#  dm_draw(updated_flights_dm)

## ------------------------------------------------------------------------
#  library(tidyr)
#  
#  flights_keyed$weather
#  
#  # Maybe there is some hidden candidate for a primary key that we overlooked?
#  enum_pk_candidates(flights_keyed$weather)
#  # Seems we have to construct a column with unique values
#  # This can be done by combining column `origin` with `time_hour`, if the latter
#  # is converted to a single time zone first; all within the `dm`:
#  weather_tbl_mutate <-
#    flights_keyed$weather %>%
#    # first convert all times to the same time zone:
#    mutate(time_hour_fmt = format(time_hour, tz = "UTC")) %>%
#    # paste together as character the airport code and the time
#    unite("origin_slot_id", origin, time_hour_fmt) %>%
#    select(origin_slot_id, everything())
#  
#  # check if we the result is as expected:
#  weather_tbl_mutate %>%
#    enum_pk_candidates() %>%
#    filter(candidate)
#  # We apply the same transformation to create
#  # the foreign key in the flights table:
#  flights_tbl_mutate <-
#    flights_keyed$flights %>%
#    mutate(time_hour_fmt = format(time_hour, tz = "UTC")) %>%
#    unite("origin_slot_id", origin, time_hour_fmt) %>%
#    select(origin_slot_id, everything())
#  
#  surrogate_flights_dm <-
#    dm(
#      weather = weather_tbl_mutate,
#      flights = flights_tbl_mutate,
#      !!!flights_keyed[c("airlines", "airports", "planes")]
#    ) %>%
#    dm_add_pk(weather, origin_slot_id) %>%
#    dm_add_fk(flights, origin_slot_id, weather)
#  
#  surrogate_flights_dm %>%
#    dm_draw()

## ------------------------------------------------------------------------
#  disentangled_flights_dm <-
#    dm(
#      destination = flights_keyed$airports,
#      origin = flights_keyed$airports,
#      !!!flights_keyed[c("flights", "airlines", "planes", "weather")]
#    ) %>%
#    # Key relations are also duplicated, so the wrong ones need to be removed
#    dm_rm_fk(flights, dest, origin) %>%
#    dm_rm_fk(flights, origin, destination)
#  
#  disentangled_flights_dm %>%
#    dm_draw()

## ------------------------------------------------------------------------
#  flights_derived <-
#    flights_dm %>%
#    pull_tbl(flights, keyed = TRUE) %>%
#    count(origin, carrier)
#  
#  derived_flights_dm <- dm(flights_derived, !!!flights_keyed)
#  
#  derived_flights_dm %>%
#    dm_draw()

## ------------------------------------------------------------------------
#  planes_for_join <-
#    flights_keyed$planes %>%
#    select(tailnum, plane_type = type)
#  
#  joined_flights_tbl <-
#    flights_keyed$flights %>%
#    # let's first reduce the number of columns of flights
#    select(-dep_delay:-arr_delay, -air_time:-minute, -starts_with("sched_")) %>%
#    # in the {dm}-method for the joins you can specify which columns you want to
#    # add to the subsetted table
#    left_join(planes_for_join)
#  
#  joined_flights_dm <- dm(
#    flights_plane_type = joined_flights_tbl,
#    !!!flights_keyed[c("airlines", "airports", "weather")]
#  )
#  
#  # this is how the table looks now
#  joined_flights_dm$flights_plane_type
#  # also here, the FK-relations are transferred to the new table
#  joined_flights_dm %>%
#    dm_draw()

## ------------------------------------------------------------------------
#  dm <- dm_nycflights13()
#  dm_deconstruct(dm)

