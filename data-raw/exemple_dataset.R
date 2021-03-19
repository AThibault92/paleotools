## code to prepare `exemple_dataset` dataset goes here
example_dataset <- readr::read_csv("./data-raw/template.csv")
usethis::use_data(example_dataset, overwrite = TRUE)
