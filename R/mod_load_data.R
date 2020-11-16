#' load_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_load_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      h3("Load data in the application"),
      sidebarLayout(
        sidebarPanel(
          fileInput(inputId = ns("data_input"), label = "Choose your file", accept = "csv"),
          downloadButton(outputId = ns("template"), label = "Download the file template")
        ),
        mainPanel(
          DT::dataTableOutput(outputId = ns("tab"))
        )
      )

    )
  )
}
    
#' load_data Server Function
#'
#' @noRd 
mod_load_data_server <- function(input, output, session, r){
  ns <- session$ns
 
  output$template <- downloadHandler(
    filename = "template.csv",
    content = function(file){
      readr::write_csv(paleotools::example_dataset, file)
    }
  )
  
  observeEvent(input$data_input,{
    
    if (is.null(input$data_input)){
      return(NULL)
    }
    
    r$raw_data <- readr::read_csv(input$data_input$datapath)

    select_num <- dplyr::select_if(r$raw_data, is.numeric)
    agh_sum <- rowSums(select_num, na.rm = TRUE)
    
    r$data <- r$raw_data %>%
      dplyr::mutate(row_sum = agh_sum) %>%
      tidyr::pivot_longer(cols = -c(Sample, row_sum)) %>%
      dplyr::mutate(
        new_value = value/row_sum
      ) %>%
      tidyr::pivot_wider(names_from = name, values_from = new_value, id_cols = Sample)
    
  })
  
  output$tab <- DT::renderDataTable({
    
    if (!is.na(r$raw_data)){
      select_num <- dplyr::select_if(r$raw_data, is.numeric)
      agh_sum <- rowSums(select_num, na.rm = TRUE)
      r$raw_data %>%
        dplyr::mutate(
          row_sum = agh_sum
        ) %>%
        dplyr::select(Sample, row_sum) %>%
        dplyr::mutate(
          information = dplyr::case_when(
            is.na(row_sum) ~ "No data.",
            row_sum == 1 ~ "Import OK.",
            row_sum != 1 ~ "Relative abundance is not 1, it was corrected."
          )
        ) %>%
      DT::datatable()
    }
    
  })
  
}
    
## To be copied in the UI
# mod_load_data_ui("load_data_ui_1")
    
## To be copied in the server
# callModule(mod_load_data_server, "load_data_ui_1")
 
