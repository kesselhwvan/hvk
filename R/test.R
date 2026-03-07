# if(interactive()){
#     tmp_file <- tempfile(fileext = ".txt")
#     data.table::fwrite(x = iris, file = tmp_file, sep = "\t", row.names = FALSE)
#     read_file(tmp_file)
#     file.exists(tmp_file)
#     unlink(tmp_file)
#     file.exists(tmp_file)
# }


# read_folder(folder = "folder", type = "rdata")
# read_folder(folder = "folder", type = c("rdata", "txt"), recursive = T, attach = T)
# save(iris1, file = "iris.rdata")




# read_file(file = "folder/iris1.rdata")
# read_file(file = "folder/iris1.txt")
#
# read_folder(folder = "folder", attach = TRUE, recursive = T)



