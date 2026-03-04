#' Read a Single File into R
#'
#' Reads a single file from disk and returns the appropriate R object. Supports
#' multiple file formats with automatic format detection via file extension.
#'
#' @param file Character scalar. Path to the file to read. Must exist on disk.
#' @param type Character vector. Supported file extensions: \code{"txt"}, \code{"csv"},
#'   \code{"tsv"}, \code{"rds"}, \code{"fst"}, or \code{"xlsx"}.
#'   File type is auto-detected via extension; this parameter is used for validation only.
#' @param df_as_tibble Logical scalar. If \code{TRUE} (default), data frames are
#'   converted to tibbles via \code{tibble::as_tibble()}.
#' @param clean_names Logical scalar. If \code{TRUE} (default), column names of
#'   data frames are cleaned via \code{janitor::clean_names()}.
#' @param ... Additional arguments passed to the underlying file reader.
#'   For example, \code{sheet} for Excel files via \code{readxl::read_xlsx()}.
#'
#' @return
#' An R object produced by the relevant file reader. For tabular inputs
#' (\code{.txt}, \code{.csv}, \code{.tsv}, \code{.xlsx}), typically a
#' \code{data.frame} or tibble. For \code{.rds}, the stored R object is returned.
#' For \code{.fst}, a data frame is returned via \code{fst::read_fst()}.
#'
#' @details
#' The function reads the file extension from the filename (case-insensitive) and
#' routes to the appropriate reader:
#' \itemize{
#'   \item \code{txt}, \code{csv}, \code{tsv}: \code{data.table::fread()}
#'   \item \code{rds}: \code{base::readRDS()}
#'   \item \code{fst}: \code{fst::read_fst()}
#'   \item \code{xlsx}: \code{readxl::read_xlsx()}
#' }
#'
#' When \code{df_as_tibble = TRUE}, tabular data is converted to a tibble
#' (row names are preserved in a new column if present).
#' When \code{clean_names = TRUE}, column names are cleaned after tibble conversion.
#'
#' @seealso
#' \code{\link[tools]{file_ext}}, \code{\link[data.table]{fread}}, \code{\link[base]{readRDS}},
#' \code{\link[fst]{read_fst}}, \code{\link[readxl]{read_xlsx}}, \code{\link[tibble]{as_tibble}},
#' \code{\link[janitor]{clean_names}}
#'
#' @examples
#' \dontrun{
#' # Read CSV file as tibble
#' d1 <- read_file("data/example.csv")
#'
#' # Read Excel sheet 2 without converting to tibble
#' d2 <- read_file("data/example.xlsx", sheet = 2, df_as_tibble = FALSE)
#'
#' # Read RDS file without cleaning column names
#' m <- read_file("models/fit.rds", clean_names = FALSE)
#' }
#'
#' @export
read_file <- function(file = NULL,
                      type = c("txt", "csv", "tsv", "rds", "fst", "xlsx"),
                      df_as_tibble = TRUE,
                      clean_names = TRUE,
                      ...) {
  # Validate inputs
  stopifnot(
    is.character(file),
    length(file) == 1L,
    !is.na(file),
    nzchar(trimws(file)),
    file.exists(file)
  )

  stopifnot(
    is.character(type),
    length(type) > 0L,
    all(!is.na(type)),
    all(nzchar(trimws(type))),
    all(type %in% c("txt", "csv", "tsv", "rds", "fst", "xlsx"))
  )

  stopifnot(
    is.logical(df_as_tibble),
    length(df_as_tibble) == 1L,
    !is.na(df_as_tibble)
  )

  stopifnot(
    is.logical(clean_names),
    length(clean_names) == 1L,
    !is.na(clean_names)
  )

  # Get file extension and select reader
  file_ext <- tolower(tools::file_ext(file))

  obj <- switch(
    file_ext,
    txt  = data.table::fread(file = file, na.strings = "", data.table = FALSE),
    csv  = data.table::fread(file = file, na.strings = "", data.table = FALSE),
    tsv  = data.table::fread(file = file, na.strings = "", data.table = FALSE),
    rds  = readRDS(file = file),
    fst  = fst::read_fst(path = file),
    xlsx = readxl::read_xlsx(path = file, ...),
    stop("Unsupported file extension: ", file_ext)
  )

  # Post-process data frames
  if (inherits(obj, "data.frame")) {
    if (isTRUE(df_as_tibble)) {
      obj <- tibble::as_tibble(
        obj,
        rownames = if (tibble::has_rownames(obj)) "rowname" else NULL
      )
    }
    if (isTRUE(clean_names)) {
      obj <- janitor::clean_names(obj)
    }
  }

  obj
}
