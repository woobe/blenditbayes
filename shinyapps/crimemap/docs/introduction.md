Introduction
========================================================

*(based on my useR! conference abstract)*  

The maturality and extensive graphical abilities of *R* and its packages make *R* an excellent choice for professional data visualisation. This talk focuses on interactive spatial visualization and illustrates two different approaches with case studies based on open crime data in UK ([Home Office, 2014](http://data.police.uk)).

Previous work has shown that it is possible to combine the functionality in packages **ggmap**, **ggplot2**, **shiny** and **shinyapps** for crime data visualization in the form of a web application named 'CrimeMap' ([Chow, 2013](http://bit.ly/bib_crimemap)). The web application is user-friendly and highly customizable. It allows users to create and customize spatial visualization in a few clicks without prior knowledge in *R* (see screenshot below). Moreover, shiny automatcially adjusts the best application layout for desktop computers, tablets and smartphones.

<center>![ball](http://woobe.bitbucket.org/images/github/milestone_2013_11.jpg)</center>

Following the release of **rMaps** ([Vaidyanathan, 2014](https://github.com/ramnathv/rMaps)), Chow built upon the original 'CrimeMap' and created a new package **rCrimemap** ([Chow, 2014](http://bit.ly/rCrimemap)). Leveraging the power of *JavaScript* mapping libraries such as 'leaflet' via **rMaps**, **rCrimemap** allows users to create an interactive crime map in *R* with intuitive map controls using only one line of code. Both zooming and navigation are similar to what ones would expect from using a typical digital map.

The availability of these packages means *R* developers can now easily overlay both graphcial and numerical results from complex statistical analysis with maps to create professional and insightful spatial visualization. This is particularly useful for effective communication and decision making.



## Basic Usage

This <a href="http://shinyapps.io?kid=2B7XZ" target="_blank">ShinyApp</a> allows you to download and visualise crime data in England, Wales & Northern Ireland from <a href="http://data.police.uk" target="_blank">data.police.uk</a>. The data is made available under the <a href="http://www.nationalarchives.gov.uk/doc/open-government-licence/version/2/" target="_blank">Open Government License</a>. For more information, see my original blog posts <a href="http://bit.ly/bib_crimemap_blog1" target="_blank">here</a>, <a href="http://bit.ly/bib_crimemap_blog2" target="_blank">here</a> and <a href="http://bit.ly/bib_crimemap_blog3" target="_blank">here</a>.


Simply enter a <b>location</b> of your choice (e.g. Oxford), choose the <b>first month</b> for data collection (e.g. Jan 2012), decide <b>how many months</b> of data you need and then click <b>"Update"</b>. There are more settings available for you to customise the plots. Scroll down and <b>try them out!</b>.
  
  
## rCrimemap

This is the next generation of CrimeMap and it is under rapid development. For more information, see [http://bit.ly/rCrimemap](http://bit.ly/rCrimemap). Eventually this package will become a new shiny web app to host the truly interactive rCrimemap. Watch this space!
  


## My LondonR Talk

If you are interested in the historical development of CrimeMap and rCrimemap, please have a look at my slides [http://bit.ly/londonr_crimemap](http://bit.ly/londonr_crimemap)
  
  

