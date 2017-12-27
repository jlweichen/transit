library("httr")
library("jsonlite")
library("twitteR")
library("dplyr")
library("readr")

# used https://opensource.com/article/17/6/collecting-and-mapping-twitter-data-using-r
# helpful guide with twitteR library
# and http://thoughtfaucet.com/search-twitter-by-location/examples/

APIkey <- #API key
APIsecret <-  #API secret
tokenKey <- #token key
tokenSecret <-#token secret

# Chicago woeid = 2379574 used when finding what's trending locally

setup_twitter_oauth(APIkey, APIsecret, tokenKey, tokenSecret)

# loading the Blue Line data
load(#path#"/ridership.RData")

# now to make a list with the total number of tweets for each stop
totalTweets <-list()

#empty tibble for all unique tweets
bigTweets <- tibble()

# with this for loop, we repeat the procedure for each of the 33 stops
# radius of half mile chosen; walking distance, allows good number of tweets
# smaller radius gives hyper-localized tweets, n of 700 tweets max per stop
# aware of overlap near close-together stations such as those in the Loop

for(i in 1:length(blueStops$name)){
  search <- paste("geocode:", as.character(blueStops$lat[i]), ",",sep="")
  search <- paste(search, as.character(blueStops$long[i]),",0.5mi", sep="")
  stopTweets <- searchTwitter(search, n = 700, lang = "en")
  stopFrame <- twListToDF(stopTweets)
  stopFrame <- filter(stopFrame, is.na(stopFrame$latitude) == FALSE)
  totalTweets[[i]] <- length(stopFrame$id)
  bigTweets <- bind_rows(bigTweets, stopFrame)
  # if I want to archive the tweets in CSV I uncomment the below and edit file name
  write_csv(stopFrame, paste("#filepath#/frame",as.character(i), ".csv", sep=""))
  # pausing between iterations 15 seconds to not time out the API, can adjust as needed
  Sys.sleep(10)
  remove(stopFrame, stopTweets, search)
}

tweetIDs <- c(unique(bigTweets$id))
bigTweets <- bigTweets[!duplicated(bigTweets), ]
#double check the size of bigTweets and tweet IDs are the same
#could use logcial check but I use browser which shows they are both the same size

remove(i, APIsecret, APIkey, tokenSecret, tokenKey, tweetIDs)
save.image(#path#"/twitter.RData")
