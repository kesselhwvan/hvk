#' Read Multiple Data Files from a Directory
#'
#' Reads all supported data files from a specified directory and returns them
#' as a named list or attaches them to the global environment. Files with
#' duplicate names (different extensions) are automatically renamed with
#' numeric suffixes.
#'
#' @param path A string specifying the directory path. Must be an existing
#'   directory.
#'
#' @param attach A logical scalar. If `TRUE`, assigns all loaded files as
#'   objects in the global environment and invisibly returns their names.
#'   If `FALSE` (default), returns a named list. Default: `FALSE`.
#'
#' @param type A character vector of file types to read. Allowed values are:
#'   "txt", "csv", "tsv", "rds", "fst", or "xlsx". Default includes all
#'   supported types. Only files matching these extensions are loaded.
#'
#' @param ... Additional arguments passed to [read_file()], which forwards
#'   them to the underlying read functions (e.g., sheet argument for xlsx).
#'
#' @returns
#'   If `attach = FALSE`: A named list of data frames, where names are
#'   derived from filenames (without extensions). Duplicate names are
#'   suffixed with numbers (e.g., "iris", "iris1", "iris2").
#'
#'   If `attach = TRUE`: Invisibly returns a character vector of object
#'   names assigned to the global environment.
#'
#' @details
#' Files are matched case-insensitively. Filenames are converted to lowercase
#' and duplicates are resolved by appending numeric suffixes (e.g., "iris1",
#' "iris2"). This handles cases where multiple file formats exist for the
#' same dataset (e.g., iris.csv and iris.rds).
#'
#' Each file is read using [read_file()], which applies optimized settings
#' for the respective file format.
#'
#' @examples
#' \dontrun{
#'   # Read all supported files from a directory
#'   data_list <- read_folder("./data")
#'
#'   # Access individual datasets
#'   iris_data <- data_list$iris
#'
#'   # Load files directly into environment
#'   read_folder("./data", attach = TRUE)
#'   # Now iris, setosa, etc. are available as objects
#'
#'   # Read only specific file types
#'   csv_files <- read_folder("./data", type = c("csv", "tsv"))
#'
#'   # Pass arguments to underlying read functions
#'   read_folder("./data", sheet = "Sheet1")
#' }
#'
#' @seealso
#'   [read_file()] for reading individual files
#'   [list2env()] for manual assignment to environment
#'
#' @export
read_folder <- function(path = NULL, attach = FALSE, type = c("txt", "csv", "tsv", "rds", "fst", "xlsx"), ...){


  stopifnot(
    is.character(path),
    length(path) == 1L,
    !is.na(path),
    nzchar(trimws(path)),
    dir.exists(path)
  )

  stopifnot(is.logical(attach), length(attach) == 1L, !is.na(attach))
  stopifnot(length(type) > 0L, is.character(type))

  object <- list.files(
    path = path,
    pattern = paste0("\\.(", paste(tolower(type), collapse = "|"), ")$"),
    full.names = TRUE,
    ignore.case = TRUE
  )

  res <- purrr::map(
    .x = stats::setNames(object = object,
                         nm = make.unique(tools::file_path_sans_ext(tolower(basename(object))), sep = "")),
    .f = ~read_file(.x, type = type, ...)
  )

  if (attach){
    list2env(res, envir = .GlobalEnv)
    invisible(names(res))
  } else {
    res
  }
}
