## code to prepare `model_maat_knn_3ohfa` dataset goes here
model_maat_knn_3ohfa <- readRDS("C:/Users/AT2914/Documents/r-projects/old_dec_2020/calib_agh/output/models/maat_knn_noduplicate.rds")
usethis::use_data(model_maat_knn_3ohfa, overwrite = TRUE)
