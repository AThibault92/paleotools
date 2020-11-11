#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  r <- reactiveValues(
    raw_data = NA,
    data = NA,
    results = NA
  )
  
  callModule(mod_load_data_server, "load_data_ui_1", r)
  callModule(mod_explore_data_server, "explore_data_ui_1", r)
  callModule(mod_predict_temperature_server, "predict_temperature_ui_1", r)
}
