library("readr")
library("dplyr")
library("tibble")

# https://data.cityofchicago.org/
# reading CTA data from downloaded CSV files
dayBoarding <- read_csv(#path to CSV#)
stops <- read_csv(#path to CSV#)
# right now, I am only interested in the blue line, and relevant columns
blueStops <- subset(stops[,c(5,6,9,17)], BLUE=="true")
blueStops <- subset(blueStops[,c(1,2,4)])

remove(stops)

#vectors containing the names and IDs of Blue Line stops

blues <- c(unique(blueStops$MAP_ID))
blueNames <- c(unique(blueStops$STATION_DESCRIPTIVE_NAME))
# California stop name is duplicated with a typo in original data
# so we remove one of those entries
blueNames <- c(blueNames[(1:4)], blueNames[6:34])


# I also am only interested in the year 2016 and newer ridership data
dayBoarding[,3] <- lapply(dayBoarding[,3], as.Date, format="%m/%d/%Y")
dayBoarding <- filter(dayBoarding, date > "2015-12-31")


#empty tibble for blue line ridership data
blueRiders <- tibble()
# looping through the table and saving blue line data to blueFrame
for(i in 1:length(blues)){
  for(j in 1:length(dayBoarding$station_id)){
    if(as.integer(dayBoarding$station_id[j]) == blues[i]){
      blueRiders <- bind_rows(blueRiders, dayBoarding[j,])
    }
  }
}
remove(dayBoarding, i, j)
blueRiders <- arrange(blueRiders, date)

# splitting the coordinates string into latitude and longitude
# using regex and looping through
blueLatLong <- c(unique(blueStops$Location))

blueCoords <- tibble(lat=1:length(blueNames), long=1:length(blueNames))
for(i in 1:length(blueNames)){
  latReg <- "[[:digit:]][[:digit:]][[:punct:]][[:digit:]]*"
  longReg <-"-[[:digit:]]{2}[[:punct:]][[:digit:]]*"
  blueCoords$lat[i] <- regmatches(blueLatLong[i], regexpr(latReg, blueLatLong[i]))
  blueCoords$long[i] <- regmatches(blueLatLong[i], regexpr(longReg, blueLatLong[i]))
}
remove(i)

blueStops <- tibble(name = blueNames, MAP_ID = blues)
blueStops <- bind_cols(blueStops, blueCoords)

remove(blueCoords)

#writing CSV files containing stops information
write_csv(blueStops, "#path#blueStops.csv")

#now making a frame for each station's ridership data
# and a list of each station's mean ridership over the entire timeframe

meanRidership <- list()

for(i in 1:length(blueStops$name)){
  riders <- subset(blueRiders, station_id==blueStops$MAP_ID[i])
  meanRidership[i] <- mean(riders$rides)
  # exporting each stop to its own CSV
  write_csv(riders, paste("#path#",as.character(i), ".csv", sep=""))
  assign(paste("riders",as.character(i), sep=""), riders)
  remove(riders)
}
remove(i)

#creating r data file
save.image(#path#"/ridership.RData")
