% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zoom.R
\name{dm_zoom_to}
\alias{dm_zoom_to}
\alias{dm_insert_zoomed}
\alias{dm_update_zoomed}
\alias{dm_discard_zoomed}
\title{Mark table for manipulation}
\usage{
dm_zoom_to(dm, table)

dm_insert_zoomed(dm, new_tbl_name = NULL, repair = "unique", quiet = FALSE)

dm_update_zoomed(dm)

dm_discard_zoomed(dm)
}
\arguments{
\item{dm}{A \code{dm} object.}

\item{table}{A table in the \code{dm}.}

\item{new_tbl_name}{Name of the new table.}

\item{repair}{Either a string or a function. If a string, it must
be one of \code{"check_unique"}, \code{"minimal"}, \code{"unique"}, or \code{"universal"}.
If a function, it is invoked with a vector of minimal names and must
return minimal names, otherwise an error is thrown.
\itemize{
\item Minimal names are never \code{NULL} or \code{NA}. When an element doesn't
have a name, its minimal name is an empty string.
\item Unique names are unique. A suffix is appended to duplicate
names to make them unique.
\item Universal names are unique and syntactic, meaning that you can
safely use the names as variables without causing a syntax
error.
}

The \code{"check_unique"} option doesn't perform any name repair.
Instead, an error is raised if the names don't suit the
\code{"unique"} criteria.}

\item{quiet}{By default, the user is informed of any renaming
caused by repairing the names. This only concerns unique and
universal repairing. Set \code{quiet} to \code{TRUE} to silence the
messages.}
}
\value{
For \code{dm_zoom_to()}: A \code{zoomed_dm} object.

For \code{dm_insert_zoomed()}, \code{dm_update_zoomed()} and \code{dm_discard_zoomed()}: A \code{dm} object.
}
\description{
Zooming to a table of a \code{\link{dm}} allows for the use of many \code{dplyr}-verbs directly on this table, while retaining the
context of the \code{dm} object.

\code{dm_zoom_to()} zooms to the given table.

\code{dm_update_zoomed()} overwrites the originally zoomed table with the manipulated table.
The filter conditions for the zoomed table are added to the original filter conditions.

\code{dm_insert_zoomed()} adds a new table to the \code{dm}.

\code{dm_discard_zoomed()} discards the zoomed table and returns the \code{dm} as it was before zooming.

Please refer to \code{vignette("tech-db-zoom", package = "dm")}
for a more detailed introduction.
}
\details{
Whenever possible, the key relations of the original table are transferred to the resulting table
when using \code{dm_insert_zoomed()} or \code{dm_update_zoomed()}.

Functions from \code{dplyr} that are supported for a \code{zoomed_dm}: \code{\link[=group_by]{group_by()}}, \code{\link[=summarise]{summarise()}}, \code{\link[=mutate]{mutate()}},
\code{\link[=transmute]{transmute()}}, \code{\link[=filter]{filter()}}, \code{\link[=select]{select()}}, \code{\link[=rename]{rename()}} and \code{\link[=ungroup]{ungroup()}}.
You can use these functions just like you would
with a normal table.

Calling \code{\link[=filter]{filter()}} on a zoomed \code{dm} is different from calling \code{\link[=dm_filter]{dm_filter()}}:
only with the latter, the filter expression is added to the list of table filters stored in the dm.

Furthermore, different \code{join()}-variants from {dplyr} are also supported,
e.g. \code{\link[=left_join]{left_join()}} and \code{\link[=semi_join]{semi_join()}}.
(Support for \code{\link[=nest_join]{nest_join()}} is planned.)
The join-methods for \code{zoomed_dm} infer the columns to join by from the primary and foreign keys,
and have an extra argument \code{select} that allows choosing the columns of the RHS table.

And -- last but not least -- also the {tidyr}-functions \code{\link[=unite]{unite()}} and \code{\link[=separate]{separate()}} are supported for \code{zoomed_dm}.
}
\examples{
\dontshow{if (rlang::is_installed("nycflights13") && rlang::is_installed("DiagrammeR")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
flights_zoomed <- dm_zoom_to(dm_nycflights13(), flights)

flights_zoomed

flights_zoomed_transformed <-
  flights_zoomed \%>\%
  mutate(am_pm_dep = ifelse(dep_time < 1200, "am", "pm")) \%>\%
  # `by`-argument of `left_join()` can be explicitly given
  # otherwise the key-relation is used
  left_join(airports) \%>\%
  select(year:dep_time, am_pm_dep, everything())

flights_zoomed_transformed

# replace table `flights` with the zoomed table
flights_zoomed_transformed \%>\%
  dm_update_zoomed()

# insert the zoomed table as a new table
flights_zoomed_transformed \%>\%
  dm_insert_zoomed("extended_flights") \%>\%
  dm_draw()

# discard the zoomed table
flights_zoomed_transformed \%>\%
  dm_discard_zoomed()
\dontshow{\}) # examplesIf}
}
