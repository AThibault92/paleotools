#' explore_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_explore_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      h3("Explore the data")
    ),
    sidebarLayout(
      sidebarPanel(
        uiOutput(outputId = ns("uiout_select_sample"))
      ),
      mainPanel(
        echarts4r::echarts4rOutput(outputId = ns("plot"))
      )
    )
  )
}
    
#' explore_data Server Function
#'
#' @noRd 
mod_explore_data_server <- function(input, output, session, r){
  ns <- session$ns
 
  output$uiout_select_sample <- renderUI({
    
    if (!is.na(r$data)){
      selectInput(inputId = ns("select_sample"), label = "Chose the sample to plot", choices = r$data$Sample)
    }
    
  })
  
  output$plot <- echarts4r::renderEcharts4r({
    
    if (!is.na(r$data) & !is.null(input$select_sample)){
      
      r$data %>%
        dplyr::filter(Sample == input$select_sample) %>%
        tidyr::pivot_longer(cols = -Sample) %>%
        echarts4r::e_charts(name) %>%
        echarts4r::e_bar(value) %>%
        echarts4r::e_title("Relatives abundances of each 3-OH FA", input$select_sample) %>%
        echarts4r::e_legend(show = FALSE) %>%
        echarts4r::e_y_axis(name = "Relative abundance", nameLocation = "center", nameGap = 30) %>%
        echarts4r::e_toolbox() %>%
        echarts4r::e_toolbox_feature(feature = c("saveAsImage"), title = "Download") %>%
        echarts4r::e_tooltip(
          trigger = "item",
          formatter = htmlwidgets::JS("
    function(params){
      return('3-OH FA: ' + params.value[0] + '<br />Relative abundance : ' + Math.round(params.value[1]*1000)/1000)
    }
    ")
        ) %>%
        echarts4r::e_theme("macarons")
      
    }
    
  })
  
}
    
## To be copied in the UI
# mod_explore_data_ui("explore_data_ui_1")
    
## To be copied in the server
# callModule(mod_explore_data_server, "explore_data_ui_1")
 
