#' Read Multiple Files from a Directory (optionally recursively)
#'
#' Reads multiple files from a directory into R, returning a named list of objects
#' or attaching them to an environment. Can search subfolders recursively.
#'
#' @param path Character scalar. Path to a directory containing files to read.
#' @param attach Logical scalar. If \code{TRUE}, objects are attached to the specified
#'   environment using \code{list2env()}. If \code{FALSE} (default), a named list is returned.
#' @param type Character vector. File extensions to detect. Defaults to
#'   \code{c("txt", "csv", "tsv", "rds", "fst", "xlsx")}.
#'   Matching is case-insensitive.
#' @param recursive Logical scalar. Should search subfolders recursively? Default \code{FALSE}.
#' @param df_as_tibble Logical scalar. Passed to \code{read_file()} to control whether data
#'   frames are returned as tibbles.
#' @param clean_names Logical scalar. Passed to \code{read_file()} to control whether column
#'   names are cleaned.
#' @param envir Environment. Target environment used when \code{attach = TRUE}. Defaults to
#'   \code{parent.frame()}.
#' @param ... Additional arguments forwarded to \code{read_file()}.
#'
#' @return
#' If \code{attach = FALSE}, a named list of imported objects. If \code{attach = TRUE},
#' the character vector of object names is returned invisibly.
#'
#' @details
#' When \code{recursive = TRUE}, the function searches all subdirectories for matching files.
#' Object names are generated from basenames only (subdirectory structure is not included),
#' and \code{make.unique()} is used to handle duplicate filenames across directories.
#'
#' @examples
#' \dontrun{
#' # Non-recursive (default, files in 'data' only):
#' x <- read_folder("data", type = c("csv", "xlsx"))
#'
#' # Recursive (files in 'data' and all subfolders):
#' y <- read_folder("data", type = c("csv", "xlsx"), recursive = TRUE)
#' }
#'
#' @export
read_folder <- function(path = NULL,
                        attach = FALSE,
                        type = c("txt", "csv", "tsv", "rds", "fst", "xlsx"),
                        recursive = FALSE,
                        df_as_tibble = TRUE,
                        clean_names = TRUE,
                        envir = parent.frame(),
                        ...) {
  # Validate inputs
  stopifnot(is.character(path),
            length(path) == 1L,
            !is.na(path),
            dir.exists(path))

  stopifnot(is.logical(attach),
            length(attach) == 1L,
            !is.na(attach))

  stopifnot(is.character(type),
            length(type) > 0L,
            all(!is.na(type)),
            all(nzchar(trimws(type))),
            all(type %in% c("txt", "csv", "tsv", "rds", "fst", "xlsx")))

  stopifnot(is.logical(recursive),
            length(recursive) == 1L,
            !is.na(recursive))

  stopifnot(is.logical(df_as_tibble),
            length(df_as_tibble) == 1L,
            !is.na(df_as_tibble))

  stopifnot(is.logical(clean_names),
            length(clean_names) == 1L,
            !is.na(clean_names))

  stopifnot(is.environment(envir))

  # Get file names in directory (recursively if requested)
  name <- list.files(
    path = path,
    pattern = paste0("\\.(", paste(tolower(type), collapse = "|"), ")$"),
    full.names = TRUE,
    ignore.case = TRUE,
    recursive = recursive
  )

  # Prepare object names
  format_name <- function(name) {
    tmp <- tools::file_path_sans_ext(tolower(basename(name)))
    make.unique(tmp, sep = "")
  }

  # Read files with prepared names
  obj <- purrr::map(
    .x = stats::setNames(name, format_name(name = name)),
    .f = ~read_file(
      .x,
      type = type,
      df_as_tibble = df_as_tibble,
      clean_names = clean_names,
      ...
    )
  )

  # Execute attach if requested
  if (isTRUE(attach)) {
    list2env(obj, envir = envir)
    return(invisible(names(obj)))
  }

  return(obj)
}
