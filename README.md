blenditbayes
============

Codes used in my blog "Blend it like a Bayesian!" (http://blenditbayes.blogspot.co.uk/)

## Blog Posts

[Visualising Crime Hotspots in England and Wales using {ggmap}] (http://blenditbayes.blogspot.co.uk/2013/06/visualising-crime-hotspots-in-england_25.html)
(Folder: 2013-06-street-level)

```{r}
## Define the period
ex3.period <- format(seq(as.Date("2012-01-01"), length=12, by="months"), "%Y-%m")

## Use the wrapper
ex3.plot <- crimeplot.wrapper(point.of.interest = "Manchester",
                              period = ex3.period,
                              type.map = "satellite",
                              type.facet = "month",
                              output.filename = "ex3.png",
                              output.size = c(1400,1400))

```
![Alt text](http://woobe.bitbucket.org/images/blenditbayes/2013-06-street-level-crime/ex1.png)

