#' predict_temperature UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import tidymodels
mod_predict_temperature_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      h3("Predict temperature")
    ),
    sidebarLayout(
      sidebarPanel(
        width = 2,
        "Chose the models:",
        checkboxGroupInput(inputId = ns("model_list"), label = NULL,
                           choices = c("Multiple linear regression", "k-nn", "random forest"),
                           selected = c("Multiple linear regression", "k-nn", "random forest")),
        actionButton(inputId = ns("run"), label = "Run the models"),
        uiOutput(outputId = ns("uiout_dl_results"))
      ),
      mainPanel(
        width = 10,
        echarts4r::echarts4rOutput(outputId = ns("plot"), height = "600px")
      )
    )
  )
}
    
#' predict_temperature Server Function
#'
#' @noRd 
mod_predict_temperature_server <- function(input, output, session, r){
  ns <- session$ns
 
  observeEvent(input$run,{
    
    r$results <- tibble::tibble(
      Sample = r$data$Sample
    )
    
    if ("Multiple linear regression" %in% input$model_list){
      pred_lm <- predict(paleotools::model_maat_lm_3ohfa, r$data)
      r$results$`linear regression` <- pred_lm$.pred
    }
    
    if ("k-nn" %in% input$model_list){
      pred_knn <- predict(paleotools::model_maat_knn_3ohfa, r$data)
      r$results$`k-nn` <- pred_knn$.pred
    }
    
    if ("random forest" %in% input$model_list){
      pred_rf <- predict(paleotools::model_maat_rf_3ohfa, r$data)
      r$results$`Randfom forest` <- pred_rf$.pred
    }
    
  })
  
  output$uiout_dl_results <- renderUI({
    
    if (!is.na(r$results)){
      downloadButton(outputId = ns("dl_results"), label = "Download results")
    }
    
  })
  
  output$dl_results <- downloadHandler(
    filename = "results.csv",
    content = function(file){
      readr::write_csv(r$results, file)
    }
  )
  
  output$plot <- echarts4r::renderEcharts4r({
    
    if (!is.na(r$results)){
      r$results %>%
        tidyr::pivot_longer(cols = -Sample) %>%
        dplyr::group_by(name) %>%
        echarts4r::e_charts(Sample) %>%
        echarts4r::e_line(value, smooth = 0) %>%
        echarts4r::e_flip_coords() %>%
        echarts4r::e_theme("macarons") %>%
        echarts4r::e_x_axis(name = "Predicted MAAT (°C)", nameLocation = "center", nameGap = 30) %>%
        echarts4r::e_toolbox() %>%
        echarts4r::e_toolbox_feature(feature = c("saveAsImage"), title = "Download") %>%
        echarts4r::e_tooltip(
          trigger = "item"
        ) %>%
        echarts4r::e_title("MAAT predictions")
    }
    
  })
  
}
    
## To be copied in the UI
# mod_predict_temperature_ui("predict_temperature_ui_1")
    
## To be copied in the server
# callModule(mod_predict_temperature_server, "predict_temperature_ui_1")
 
