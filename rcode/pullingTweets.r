library("rtweet")
library("dplyr")
library("readr")
library("tidyr")

#using rtweet library and Oauth2.0

appname <- #the app name you selected on app.twitter.com
key <- # API key
secret <- # API secret

twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)

# making a vector of base lat and long coords, created in QuantumGIS
# these cover the city of Chicago in a grid
allpoints <- read_csv("~/chicago/allpoints.csv")
for(i in 1:length(allpoints)){
  allpoints$LAT[i] <- as.numeric(allpoints$LAT[i])
  allpoints$LONG[i] <- as.numeric(allpoints$LONG[i])
}

# now to make a list with the total number of tweets around each point
totalTweets <-c()

#empty tibble for all tweets returned by API query
bigTweets <- as_data_frame()

# with this for loop, we repeat the procedure for each of the points selected
# radius of 1.4 miles chosen; blanketing the area, allows good number of tweets
# smaller radius and more points - more tweets!
# sadly, also means more calls to the API and if we make too many, the API times out
# we space the queries 25 seconds apart for this reason
# n of 1800 tweets max per query
# tweets over the past one week, or last 604800 seconds of time!
# aware of overlap possibility and will filter
# duplicate posts later
if(dir.exists("~/chicago/data")==FALSE){
    dir.create("~/chicago/data")
}
trendPath <- paste("~/chicago/data/tweets/", format(Sys.time(), format="%Y%m%d"), sep="")
if(dir.exists(trendPath)==FALSE){
    dir.create(trendPath)
}

for(i in 1:length(allpoints$LAT)){
  search <- paste("geocode:", as.character(allpoints$LAT[i]), ",",sep="")
  search <- paste(search, as.character(allpoints$LONG[i]),",1.4mi", sep="")
  stopTweets <- search_tweets(search, since = format(Sys.time()-604800, format="%Y-%m-%d"),n = 1800, lang = "en")
  if(length(stopTweets) == 0){
    next
  }
  bigTweets <- bind_rows(bigTweets, stopTweets)
  # if I want to archive the tweets in CSV I uncomment the below and edit file name
  write_as_csv(stopTweets, paste(trendPath,as.character(i), ".csv", sep=""))
  totalTweets[i] <- length(stopTweets$id)
  remove(stopTweets)
  Sys.sleep(35)
}
remove(i, stopFrame, stopTweets, search)

#removing duplicate tweets
bigTweets <- unique(bigTweets)

# ensuring the lat and long columns are numeric
bigTweets$latitude <- as.numeric(bigTweets$latitude)
bigTweets$longitude <- as.numeric(bigTweets$longitude)


remove(APIsecret, APIkey, tokenSecret, tokenKey)
save.image("~/chicago/data/twitter.RData")

# if I want to archive bigTweets I write it as a separate CSV
write_csv(bigTweets, paste(trendPath, "/bigTweets", format(Sys.time(), format="%Y%m%d"), ".csv", sep=""))
