#' Get Human-Readable File Size
#'
#' Returns the size of a file in a human-readable format with automatic or
#' manual unit selection (bytes, KB, MB, GB, etc.).
#'
#' @param path Character scalar. Path to the file. Must exist on disk.
#' @param unit Character scalar. Optional unit for output. If \code{NULL} (default),
#'   the most appropriate unit is chosen automatically. Allowed values:
#'   \code{"B"}, \code{"KB"}, \code{"MB"}, \code{"GB"}, \code{"TB"}, \code{"PB"},
#'   \code{"EB"}, \code{"ZB"}, \code{"YB"}.
#'
#' @return
#' Character scalar. The file size formatted as a human-readable string
#' (e.g., \code{"2.5 MB"}, \code{"1023 B"}).
#'
#' @details
#' File size is computed in bytes and converted to the requested unit using base 1000.
#'
#' If \code{unit = NULL}, the smallest unit is chosen such that the value is
#' at least 1000 (or 1 if the file is smaller than 1000 bytes).
#'
#' @examples
#' \dontrun{
#' # Automatic unit selection
#' file_size("data.csv")
#'
#' # Manual unit selection
#' file_size("data.csv", unit = "KB")
#' file_size("data.csv", unit = "B")
#' }
#'
#' @export
file_size <- function(path = NULL, unit = NULL) {
  # Validate path
  stopifnot(
    is.character(path),
    length(path) == 1L,
    !is.na(path),
    nzchar(trimws(path)),
    file.exists(path)
  )

  # Define unit hierarchy
  units <- c("B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB")

  # Get file size in bytes
  bytes <- as.numeric(file.size(path))

  if (!is.finite(bytes)) {
    stop(
      sprintf("Could not determine file size for '%s'.", path),
      call. = FALSE
    )
  }

  # Manual unit selection
  if (!is.null(unit)) {
    stopifnot(
      is.character(unit),
      length(unit) == 1L,
      !is.na(unit),
      nzchar(trimws(unit))
    )

    unit <- trimws(unit)

    if (!unit %in% units) {
      stop(
        sprintf(
          "Invalid unit: '%s'. Allowed units: %s.",
          unit,
          paste(units, collapse = ", ")
        ),
        call. = FALSE
      )
    }

    idx <- match(unit, units)
    value <- bytes / 1000^(idx - 1L)

    return(paste(format(value, trim = TRUE, scientific = FALSE), unit))
  }

  # Automatic unit selection
  idx <- pmin(
    length(units),
    1L + (bytes >= 1000) * floor(log(pmax(bytes, 1), 1000))
  )
  value <- bytes / 1000^(idx - 1L)

  paste(format(value, trim = TRUE, scientific = FALSE), units[idx])
}
