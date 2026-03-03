# test_that("read_file reads txt files", {
#   # Create a temporary txt file
#   tmp_txt <- tempfile(fileext = ".txt")
#   writeLines(c("a,b,c", "1,2,3", "4,5,6"), tmp_txt)
#
#   result <- read_file(tmp_txt)
#
#   expect_s3_class(result, "data.frame")
#   expect_equal(nrow(result), 2)
#   expect_equal(ncol(result), 3)
#
#   unlink(tmp_txt)
# })
#
# test_that("read_file reads csv files", {
#   tmp_csv <- tempfile(fileext = ".csv")
#   write.csv(data.frame(x = 1:3, y = c("a", "b", "c")), tmp_csv, row.names = FALSE)
#
#   result <- read_file(tmp_csv)
#
#   expect_s3_class(result, "data.frame")
#   expect_equal(nrow(result), 3)
#   expect_equal(ncol(result), 2)
#
#   unlink(tmp_csv)
# })
#
# test_that("read_file reads tsv files", {
#   tmp_tsv <- tempfile(fileext = ".tsv")
#   write.table(data.frame(a = 1:2, b = 3:4), tmp_tsv, sep = "\t", row.names = FALSE)
#
#   result <- read_file(tmp_tsv)
#
#   expect_s3_class(result, "data.frame")
#   expect_equal(nrow(result), 2)
#
#   unlink(tmp_tsv)
# })
#
# test_that("read_file reads rds files", {
#   tmp_rds <- tempfile(fileext = ".rds")
#   test_data <- data.frame(x = 1:5, y = letters[1:5])
#   saveRDS(test_data, tmp_rds)
#
#   result <- read_file(tmp_rds)
#
#   expect_equal(result, test_data)
#
#   unlink(tmp_rds)
# })
#
#
# test_that("read_file reads fst files", {
#   skip_if_not_installed("fst")
#
#   tmp_fst <- tempfile(fileext = ".fst")
#   test_data <- data.frame(x = 1:5, y = letters[1:5])
#   fst::write_fst(test_data, tmp_fst)
#
#   result <- read_file(tmp_fst)
#
#   expect_equal(result, test_data)
#
#   unlink(tmp_fst)
# })
#
# # test_that("read_file reads xlsx files", {
# #   skip_if_not_installed("readxl")
# #
# #   tmp_xlsx <- tempfile(fileext = ".xlsx")
# #   test_data <- data.frame(x = 1:5, y = letters[1:5])
# #   writexl::write_xlsx(test_data, tmp_xlsx)
# #
# #   result <- read_file(tmp_xlsx)
# #
# #   expect_s3_class(result, "data.frame")
# #   expect_equal(nrow(result), 5)
# #
# #   unlink(tmp_xlsx)
# # })
#
# test_that("read_file stops if path doesn't exist", {
#   expect_error(
#     read_file("/nonexistent/path/file.csv"),
#     "file.exists"
#   )
# })
#
# test_that("read_file stops if path is not a string", {
#   expect_error(
#     read_file(123),
#     "is.character"
#   )
# })
#
# test_that("read_file stops if path length > 1", {
#   expect_error(
#     read_file(c("file1.csv", "file2.csv")),
#     "length"
#   )
# })
#
# # test_that("read_file stops if unsupported type provided", {
# #   tmp_csv <- tempfile(fileext = ".csv")
# #   write.csv(data.frame(x = 1), tmp_csv, row.names = FALSE)
# #
# #   expect_cli_abort(
# #     read_file(tmp_csv, type = c("json", "parquet")),
# #     "Unsupported type"
# #   )
# #
# #   unlink(tmp_csv)
# # })
#
# test_that("read_file handles empty strings as NA", {
#   tmp_csv <- tempfile(fileext = ".csv")
#   writeLines(c("a,b", "1,", ",3"), tmp_csv)
#
#   result <- read_file(tmp_csv)
#
#   expect_true(is.na(result[1, 2]))
#   expect_true(is.na(result[2, 1]))
#
#   unlink(tmp_csv)
# })
