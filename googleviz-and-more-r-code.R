# Adapted from librarianwomack Youtube channel, R-bloggers and multiple blogs. 

install.packages("googleVis")
install.packages("RJSONIO") # this package takes r objects and transforms them into json objects we can put into JS

library(googleVis) # lets you Google data and API to use function for data processing in R
library(RJSONIO)

# Creating googlevis-type object - simple viz and plotting it
Geo <- gvisGeoMap(Population, locationvar = "Country", numvar = "Population", options = list(height = 350, dataMode = 'regions'))
plot(Geo)

# Create another dynamic visualization
input <- read.csv("http://www.rci.rutgers.edu/~rwomack/Rexamples/UNdata.csv", header = TRUE)
Map <- data.frame(input$Country.or.Area, input$Value)
names(Map) <- c("Country", "Age")
Geo <- gvisGeoMap(Map, locationvar = "Country", numvar = "Age", options = list(height = 350, dataMode = 'regions'))
plot(Geo)

# Create a googleViz motion object and plot it.
M <- gvisMotionChart(Fruits, idvar = "Fruit", timevar = "Year")
plot(M)

## Chloropleth mapping (code chunk 28) of low & high population states

# File download
download.file("http://www.census.gov/popest/data/national/totals/2012/files/NST_EST2012_ALLDATA.csv", "census.csv")

# Read in the data
statePodData <- read.csv("census.csv")

# Prepare data and create new vars
popNames <- as.character(statePodData$Name)
pop2010 <- statePodData$CENSUS2010POP

# Do some data manipulation - mark certain level states blue, others red
popDich <- ifelse(pop2010 < 3000000, "red", "blue")

# Load up additional mapping packages
library(maps)
library(mapproj)

# Load the built in data
data(state)

# Create the graph
mapNames <- map("state", plot = FALSE)$names
mapNames.state <- ifelse(regexpr(":", mapNames) <0, 
                        mapNames, 
                        substr(mapNames, 1, regexpr(":", mapNames)-1))

popNames.lower <- tolower(popNames)
cols <- popDich[match(mapNames.state, popNames.lower)]
map("state", fill = TRUE, col = cols, proj = "albers", param = c(35,50))
title("48 States by population")
