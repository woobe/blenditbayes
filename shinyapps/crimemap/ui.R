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
      helpText(HTML("<b>READY?</b>")),
      HTML("Continue to scroll down and modify the settings. Come back and click this when you are ready to render new plots."),
      submitButton("Update Graphs and Tables")
    ),
    
    wellPanel(
      helpText(HTML("<b>BASIC SETTINGS</b>")),
      
      textInput("poi", "Enter a Location of Interest:", "Demo (London)"),
      helpText("Examples: Oxford, Wembley Stadium, M16 0RA etc."),
      
      dateInput("start", "First Month of Data Collection:", value = "2012-01-01", format = "yyyy-mm",
                min = "2012-01-01", max = "2013-12-31"),
      
      sliderInput("months", "Length of Analysis (Months):", 
                  min = 1, max = 24, step = 1, value = 3),
      helpText("Note: data is available from Dec 2010 to Dec 2013. There is inconsistency in 2010-2011 records so I have omitted them for now. It takes longer to redner the plots when you increase this number.")      
      ),
    
    wellPanel(
      helpText(HTML("<b>MAP SETTINGS</b>")),
      # selectInput("lang", "Display Langauge:", choice = c("en-GB","fr")),
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
                  choice = c("grey95","black", "white", "red", "orange", "yellow", "green", "blue", "purple")),
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
      HTML('Background in Water and Machine Learning'),
      HTML('<br>'),
      HTML('<a href="http://bit.ly/aboutme_jofaichow" target="_blank">About Me</a>, '),
      HTML('<a href="http://bit.ly/blenditbayes" target="_blank">Blog</a>, '),
      HTML('<a href="http://bit.ly/github_woobe" target="_blank">Github</a>, '),
      HTML('<a href="http://bit.ly/linkedin_jofaichow" target="_blank">LinkedIn</a>, '),
      HTML('<a href="http://bit.ly/kaggle_woobe" target="_blank">Kaggle</a>.')
    ),
    
    wellPanel(
      helpText(HTML("<b>VERSION CONTROL</b>")),
      HTML('Version 0.1.5'),
      HTML('<br>'),
      HTML('Deployed on 10-Mar-2014')
    )
    
  ),
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Main Panel
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  mainPanel(
    tabsetPanel(

      ## Experiment
      #tabPanel("LondonR Demo", includeMarkdown("docs/londonr.md")),
      #tabPanel("Sandbox (rCharts)", showOutput("myChart", "nvd3")),
      #tabPanel("Sandbox", includeMarkdown("docs/sandbox.md")),
      
      ## Core tabs
      tabPanel("Introduction", includeMarkdown("docs/introduction.md")),
      tabPanel("Data", dataTableOutput("datatable")),
      tabPanel("Heat Map", plotOutput("map")),
      tabPanel("Trends", plotOutput("trends1")),
      tabPanel("Related News", includeMarkdown("docs/related_news.md")),
      tabPanel("Changes", includeMarkdown("docs/changes.md"))
    ) 
  )
  
))





