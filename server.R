library(shiny)
library(biogram)
library(DT)

predictive_model <- function(x) {
    ifelse(lengths(x) > 10, "positive", "negative")
}

options(shiny.maxRequestSize=10*1024^2)

shinyServer(function(input, output) {
    
    rv <- reactiveValues(loaded_data = FALSE,
                         seqs = NULL)
    
    
    
    observe({
        if(!is.null(input[["seqs"]][["datapath"]])) {
            rv[["seqs"]] <- read_fasta(input[["seqs"]][["datapath"]])
        }
        
        if(!is.null(input[["use_area"]])) {
            if(input[["use_area"]] > 0) {
                rv[["seqs"]] <- read_fasta(textConnection(input[["area_seqs"]]))
            }
        }
        
        if(!is.null(rv[["seqs"]])) {
            rv[["loaded_data"]] <- TRUE
        }
    })
    
    
    output[["ui"]] <- renderUI({
        if(rv[["loaded_data"]]) {
            list(dataTableOutput("preds"),
                 verbatimTextOutput("input_seqs"))
        } else {
            list(textAreaInput("area_seqs", "Paste your sequences", value = "", 
                               height = "300px", width = "700px"),
                 actionButton("use_area", "Submit sequences from the field above"))
        }
    })
    
    output[["preds"]] <- renderDT({
        data.frame(seq_name = names(rv[["seqs"]]),
                   pred = predictive_model(rv[["seqs"]]))
    })
    
    output[["input_seqs"]] <- renderPrint({
        
        rv[["seqs"]]
        
    })
    
})
