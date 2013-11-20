library(shiny)
# library(shinyIncubator)
# library(ggplot2)
# library(ggmap)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Application title
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  headerPanel("Crime Data Visualisation"),

  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Sidebar Panel
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sidebarPanel(
    
    wellPanel(
      helpText(HTML("<b>INTRODUCTION</b>")),
      HTML('This <a href="http://shinyapps.io?kid=2B7XZ" target="_blank">ShinyApp</a> allows you to download and visualise crime data in England, Wales & Northern Ireland from <a href="http://data.police.uk" target="_blank">data.police.uk</a>. The data is made available under the <a href="http://www.nationalarchives.gov.uk/doc/open-government-licence/version/2/" target="_blank">Open Government License</a>. For more information, see my original <a href="http://blenditbayes.blogspot.co.uk/2013/06/visualising-crime-hotspots-in-england_25.html" target="_blank">blog post</a>.')
      ),
    
    wellPanel(
      helpText(HTML("<b>USAGE</b>")),
      HTML('Simply enter a <b>location</b> of your choice (e.g. Oxford), choose the <b>first month</b> for data collection (e.g. Jan 2012), decide <b>how many months</b> of data you need and then click <b>"Update"</b>. There are more settings available for you to customise the plots. Scroll down and <b>try them out!</b>.')
           ),
    
    wellPanel(
      helpText(HTML("<b>READY?</b>")),
      HTML("Continue to scroll down and modify the settings. Come back and click this when you are ready to render new plots."),
      submitButton("Update Graphs and Tables")
    ),
    
    wellPanel(
      helpText(HTML("<b>BASIC SETTINGS</b>")),
      textInput("poi", "Enter a Location of Interest:", "Oxford"),
      helpText("Examples: London, Wembley Stadium, M16 0RA etc."),
      dateInput("start", "First Month of Data Collection:", value = "2012-01-01", format = "yyyy-mm",
                min = "2012-01-01", max = "2013-09-30"),
      sliderInput("months", "Length of Analysis (Months):", 
                  min = 1, max = 12, step = 1, value = 3),
      helpText("Note: data is available from Dec 2010 to Sep 2013. There is inconsistency in 2010-2011 records so I have omitted them for now. It takes longer to redner the plots when you increase this number.")      
      ),
    
    wellPanel(
      helpText(HTML("<b>MAP SETTINGS</b>")),
      selectInput("facet", "Choose Facet Type:", choice = c("none","type", "month", "category")),
      selectInput("type", "Choose Google Map Type:", choice = c("roadmap", "satellite", "hybrid","terrain")),    
      checkboxInput("res", "High Resolution?", FALSE),
      checkboxInput("bw", "Black & White?", FALSE),
      sliderInput("zoom", "Zoom Level (Recommended - 14):", 
                  min = 12, max = 16, step = 1, value = 14)
    ),
    
    
    wellPanel(
      helpText(HTML("<b>DENSITY PLOT SETTINGS</b>")),
      sliderInput("alpharanage", "Alpha Range:",
                  min = 0, max = 1, step = 0.1, value = c(0.1, 0.4)),
      sliderInput("bins", "Number of Bins:", 
                  min = 5, max = 50, step = 5, value = 15),
      sliderInput("boundwidth", "Boundary Lines Width:", 
                  min = 0, max = 1, step = 0.1, value = 0.1),
      selectInput("boundcolour", "Boundary Lines Colour:", 
                  choice = c("black", "white", "grey", "red", "orange", "yellow", "green", "blue", "purple")),
      selectInput("low", "Fill Gradient (Low):", 
                  choice = c("yellow", "red", "orange", "green", "blue", "purple", "white", "black", "grey")),
      selectInput("high", "Fill Gradient (High):", 
                  choice = c("red", "orange", "yellow", "green", "blue", "purple", "white", "black", "grey"))
      ),
        
    wellPanel(   
      helpText(HTML("<b>MISC. SETTINGS</b>")),
      checkboxInput("watermark", "Use 'Blenditbayes' Watermark?", TRUE),
      helpText("Note: automatically disabled when 'Facet' is used.")
    ),
        
    wellPanel(
      helpText(HTML("<b>ABOUT ME</b>")),
      HTML('Jo-fai Chow'),
      HTML('<br>'),
      HTML('Research Engineer | Data Geek'),
      HTML('<br>'),
      HTML('<a href="http://about.me/jofai_chow" target="_blank">About Me</a>, '),
      HTML('<a href="http://blenditbayes.blogspot.co.uk" target="_blank">Blog</a>, '),
      HTML('<a href="https://github.com/woobe" target="_blank">Github</a>, '),
      HTML('<a href="http://uk.linkedin.com/in/jofaichow" target="_blank">LinkedIn</a>, '),
      HTML('<a href="http://www.kaggle.com/users/28271/woobe" target="_blank">Kaggle</a>.')
    ),
    
    wellPanel(
      helpText(HTML("<b>VERSION CONTROL</b>")),
      HTML('Version 0.1.0 - Prototype')
    )
    
  ),
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Main Panel
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  mainPanel(
    tabsetPanel(
      tabPanel("Data", dataTableOutput("datatable")),
      tabPanel("Crime Map", plotOutput("map")),
      tabPanel("Trends", plotOutput("trends1"))
    ) 
  )
  
))





