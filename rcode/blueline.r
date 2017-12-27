library("readr")
library("dplyr")
library("tibble")

# https://data.cityofchicago.org/
# reading CTA data from downloaded CSV files
dayBoarding <- read_csv("/Users/Jennifer/Documents/chicago/data/stationEntriesDailyTotals.csv")
stops <- read_csv("/Users/Jennifer/Documents/chicago/data/listOfStops.csv")
# right now, I am only interested in the blue line
blueStops <- subset(stops, BLUE=="true")
remove(stops)
blues <- c(unique(blueStops$MAP_ID))
blueLatLong <- c(unique(blueStops$Location))
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

write_csv(blueRiders, "blueRiders.csv")
write_csv(blueStops, "blueStops.csv")
