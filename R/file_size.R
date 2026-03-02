#' Format file size with SI decimal units
#'
#' Computes the size of a file and formats the result using SI decimal units
#' (base 1000). If `unit` is `NULL`, the function selects an appropriate unit
#' automatically. If `unit` is supplied, it must match one of the supported
#' unit strings exactly.
#'
#' @param path Character scalar. Path to an existing file.
#' @param unit Character scalar or `NULL`. One of `"B"`, `"KB"`, `"MB"`, `"GB"`,
#'   `"TB"`, `"PB"`, `"EB"`, `"ZB"`, `"YB"`. If `NULL`, the unit is chosen
#'   automatically.
#'
#' @return A character scalar of the form `"<value> <unit>"`, where `<value>` is
#'   formatted in fixed notation.
#'
#' @details
#' Units follow SI prefixes and use powers of 1000. This differs from IEC binary
#' units (KiB, MiB, etc.), which use powers of 1024.
#'
#' Input validation uses `stopifnot()` for basic checks. Invalid `unit` values
#' trigger `cli::cli_abort()` with a descriptive message.
#'
#' @examples
#' \dontrun{
#' file_size("iris.txt")
#' file_size("iris.txt", unit = "MB")
#' }
#'
#' @export
file_size <- function(path = NULL, unit = NULL){

  stopifnot(is.character(path), length(path) == 1L, !is.na(path), nzchar(trimws(path)), file.exists(path))
  u <- c("B","KB","MB","GB","TB","PB","EB", "ZB", "YB")
  bytes <- as.numeric(file.size(path))
  if (!is.finite(bytes)) cli::cli_abort("Could not determine file size for {.path {path}}.")

  # Manual unit selection
  if (!is.null(unit)) {
    stopifnot(is.character(unit), length(unit) == 1L, !is.na(unit), nzchar(trimws(unit)))
    unit <- trimws(unit)
    if (!unit %in% u) cli::cli_abort(c("Invalid unit: {.val {unit}}.", "Allowed units: {.val {paste(u, collapse = ', ')}}."))
    i <- match(unit, u)
    value <- bytes / 1000^(i - 1L)
    return(paste(format(value, trim = TRUE, scientific = FALSE), unit))
  }

  # Automatic unit selection
  i <- pmin(length(u), 1L + (bytes >= 1000) * floor(log(pmax(bytes, 1), 1000)))
  value <- bytes / 1000^(i - 1L)
  return(paste(format(value, trim = TRUE, scientific = FALSE), u[i]))
}
