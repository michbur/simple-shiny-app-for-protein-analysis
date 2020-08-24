library(shiny)
library(DT)

shinyUI(fluidPage(

    titlePanel("Sample protein app"),

    sidebarLayout(
        sidebarPanel(
            fileInput("seqs",
                      "Enter fasta file")
        ),

        mainPanel(
            uiOutput("ui")
        )
    )
))
