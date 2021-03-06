% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/foreign-keys.R
\name{dm_has_fk}
\alias{dm_has_fk}
\alias{dm_get_fk}
\title{Check if foreign keys exists}
\usage{
dm_has_fk(dm, table, ref_table, ...)

dm_get_fk(dm, table, ref_table, ...)
}
\arguments{
\item{dm}{A \code{dm} object.}

\item{table}{A table in the \code{dm}.}

\item{ref_table}{The table which \code{table} will be referencing.}

\item{...}{These dots are for future extensions and must be empty.}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}

These functions are deprecated because of their limited use
since the introduction of foreign keys to arbitrary columns in dm 0.2.1.
Use \code{\link[=dm_get_all_fks]{dm_get_all_fks()}} with table manipulation functions instead.
}
\keyword{internal}
