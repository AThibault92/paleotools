## code to prepare `exemple_dataset` dataset goes here
example_dataset <- readxl::read_excel("C:/Users/AT2914/Documents/r-projects/calib_agh/data/raw/data_app_paleo.xlsx", sheet = "data_input")
usethis::use_data(example_dataset)
