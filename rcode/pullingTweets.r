library("twitteR")
library("dplyr")
library("readr")

# used https://opensource.com/article/17/6/collecting-and-mapping-twitter-data-using-r
# helpful guide with twitteR library
# and http://thoughtfaucet.com/search-twitter-by-location/examples/

APIkey <- #API key
APIsecret <- #API secret
tokenKey <- #token key
tokenSecret <-#token secret

# Chicago woeid = 2379574 used when finding what's trending locally

setup_twitter_oauth(APIkey, APIsecret, tokenKey, tokenSecret)

# loading the Blue Line data
load(#path to ridership.RData)

# now to make a list with the total number of tweets for each stop
totalTweets <-c()

#empty tibble for all tweets returned by API query
bigTweets <- as_data_frame()

# with this for loop, we repeat the procedure for each of the 33 stops
# radius of half mile chosen; walking distance, allows good number of tweets
# smaller radius gives hyper-localized tweets, n of 1000 tweets max per stop
# tweets since Dec. 15, 2017, but will likely be more recent per API limit to last 7 days
# aware of overlap near close-together stations such as those in the Loop

for(i in 1:length(blueNames)){
  search <- paste("geocode:", as.character(blueStops$lat[i]), ",",sep="")
  search <- paste(search, as.character(blueStops$long[i]),",0.5mi", sep="")
  stopTweets <- searchTwitter(search, since = "2017-12-15",n = 1000, lang = "en")
  stopFrame <- twListToDF(stopTweets)
  stopFrame <- subset(stopFrame[,c(1,5,8,10,11,15,16)])
  #stopFrame <- filter(stopFrame, is.na(stopFrame$latitude) == FALSE)
  bigTweets <- bind_rows(bigTweets, stopFrame)
  # if I want to archive the tweets in CSV I uncomment the below and edit file name
  # write_csv(stopFrame, paste(#path#"frame",as.character(i), ".csv", sep=""))
  totalTweets[i] <- length(stopFrame$id)
  Sys.sleep(10)
}
remove(i, stopFrame, stopTweets, search)
# we will need the lat and long later, so making numeric now
bigTweets$latitude <- as.numeric(bigTweets$latitude)
bigTweets$longitude <- as.numeric(bigTweets$longitude)

# want to remove tweets with NA for long or lat
cleanTweets <- data_frame()

for(i in 1:length(bigTweets$id)){
  if(is.na(bigTweets$latitude[i])==FALSE & is.na(bigTweets$longitude[i])==FALSE){
    columnar <- bigTweets[i,]
    cleanTweets <- bind_rows(cleanTweets, columnar)
  }
}
remove(bigTweets, columnar)

#removing duplicate tweets
cleanTweets <- cleanTweets[!duplicated(cleanTweets), ]

#double check the size of cleanTweets and tweetIDs are the same size
#could use logcial check but I use browser which shows they are both the same size
tweetIDs <- c(unique(cleanTweets$id))

remove(i, APIsecret, APIkey, tokenSecret, tokenKey, tweetIDs)
save.image(#path to save to, "twitter.RData")
