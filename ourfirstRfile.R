#install.packages("twitteR")

#using the twitteR package ####
library(twitteR)


#From the twitter app (Keys and tokens)
#api_key <- "" # API key 
#api_secret <- "" #API secret key 
#token <- "" #token 
#token_secret <- "" #token secret


setup_twitter_oauth(api_key, api_secret, token, token_secret) # setup for accessing twitter using the information above

tweets <- searchTwitter("#covid19uk -filter:retweets", n=100000, lang = "en", retryOnRateLimit = 120) # the function searchTwitter search for tweets based on the specified parameters
#tweets1 = searchTwitter('#covid19uk', since = '2020-03-01', geocode = '57.1512475,-7.3292194', n=100000, lang="en") #https://rpubs.com/sumitkumar-00/twitter_sentiment_analysis, I haver not tried it, I altered the geo code to uk
#searchTwitter("#covid19uk -filter:retweets", n = 40000, lang = "en", since = '2016-12-12',until = "2016-12-13", retryOnRateLimit = 120)
#tweets <- strip_retweets(tweets)
tweets.df <-twListToDF(tweets) # creates a data frame with one row per tweet

tweetDF <- as.data.frame(tweets.df)

write.csv(tweetDF,"C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets5wr.csv", row.names = FALSE)

#############################################

#Alternative with rtweet: 
#install.packages("rtweet")
library(rtweet)

api_key <- "NZdDgX5gBv83yRILFlJiq5J1R" # API key 
api_secret <- "rNaFONCS56mFxWHCfXWW85JP9SGwu545dPV3pMk229FQuKQfoo" #API secret key 
access_token <- "808308358847537152-krRV8KqJDCnHaMFVBmwfVjkriYRjCRC" #token 
token_secret <- "BPIS3e4jIYWN4AuXHkUm7w931BSjMoIWq1A0NmkyFwA0m" #token secret

## authenticate via web browser
token <- create_token(
  app = "rstatsjournalismresearch",
  consumer_key = api_key,
  consumer_secret = api_secret,
  access_token = access_token,
  access_secret = token_secret)

#After restart, this automatically connects you
library(rtweet)
get_token()

# get sample tweet
rt <- search_tweets(
  "#covid19uk lang:en",
  n = 100000, 
  include_rts = FALSE,
  retryonratelimit = TRUE
)



#write it as csv
rtweet::write_as_csv(rt,"tweet0415.csv")



####################################################################
############ with map 
# try the map
rt <- search_tweets(
  "#CORONAVIRUSFRANCE -filter:retweets",
  n = 10000
)


install.packages("maps")
library(maps)
## create lat/lng variables using all available tweet and profile geo-location data
rt <- lat_lng(rt)

## plot state boundaries
par(mar = c(0, 0, 0, 0))
maps::map("france", lwd = .25)

## plot lat and lng points onto state map
with(rt, points(lng, lat, pch = 20, cex = .75, col = rgb(0, .3, .7, .75)))



##############################################################################

#### Working on the original files to delete retweets
#original<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets4wr.csv") #working on the original files to delete retweets
#oriwt <- ori[- grep("RT", ori$text),] #deleting RT from a data frame of already collected tweets
#write.csv(d,"C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets3wr.csv", row.names = FALSE)#rewriting datasets without retweets
####

### Merging the various data frames, deleting duplicates, ordering by date
library(readr)
wr1<- read_csv("tweet0415.csv")
wr2<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets2wr.csv")
wr3<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets3wr.csv")
wr4<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets4wr.csv")

all <- wr1
  #(rbind(wr1, wr2, wr3, wr4))
final <- all[!duplicated(all$text),] 
final <- final[order(final$created),]
write.csv(final,"tweet04_07-15.csv", row.names = FALSE)
###
