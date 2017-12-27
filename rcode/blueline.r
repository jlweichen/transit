library("readr")
library("dplyr")
library("tibble")

# https://data.cityofchicago.org/
# reading CTA data from downloaded CSV files
dayBoarding <- read_csv(#path to CSV file#)
stops <- read_csv(#path to CSV file#)
# right now, I am only interested in the blue line
blueStops <- subset(stops[,c(5,6,9,17)], BLUE=="true")
blueStops <- subset(blueStops[,c(1,2,4)])

remove(stops)
blues <- c(unique(blueStops$MAP_ID))
blueNames <- c(unique(blueStops$STATION_DESCRIPTIVE_NAME))
blueNames <- (c(blueNames[(1:4)], blueNames[6:34]))


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

remove(dayBoarding)
blueRiders <- arrange(blueRiders, date)

# splitting the coordinates string into latitude and longitude
blueLatLong <- c(unique(blueStops$Location))

blueCoords <- tibble(lat=1:length(blueNames), long=1:length(blueNames))
for(i in 1:length(blueNames)){
  latReg <- "[[:digit:]][[:digit:]][[:punct:]][[:digit:]]*"
  longReg <-"-[[:digit:]]{2}[[:punct:]][[:digit:]]*"
  blueCoords$lat[i] <- regmatches(blueLatLong[i], regexpr(latReg, blueLatLong[i]))
  blueCoords$long[i] <- regmatches(blueLatLong[i], regexpr(longReg, blueLatLong[i]))
}

blueStops <- tibble(name = blueNames, MAP_ID = blues)
blueStops <- bind_cols(blueStops, blueCoords)

remove(blueCoords)

write_csv(blueRiders, #path to save CSV#)
write_csv(blueStops, #path to save CSV#)

#now making a frame for each station's ridership data

riders1 <- subset(blueRiders, station_id == 41240)
riders2 <- subset(blueRiders, station_id==blueStops$MAP_ID[2])

for(i in 1:length(blueStops$name)){
  riders <- subset(blueRiders, station_id==blueStops$MAP_ID[i])
  # right now not using the meta-data but I'm saving it to CSV in case I want to in the future
  write_csv(riders, paste(#directory path#"/riders",as.character(i), ".csv"))
  assign(paste("riders",as.character(i)), riders)
  remove(riders)
}

#creating r data file
save.image(#directory path#".RData")
