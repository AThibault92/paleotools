## code to prepare `model_maat_lm_3ohfa` dataset goes here
model_maat_lm_3ohfa <- readRDS("C:/Users/AT2914/Documents/r-projects/old_dec_2020/calib_agh/output/models/maat_reg_noduplicate.rds")
usethis::use_data(model_maat_lm_3ohfa, overwrite = TRUE)
