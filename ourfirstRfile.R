pacman::p_load( "pacman", "tidyverse", "magrittr", "nycflights13", "gapminder", "Lahman", "maps", "lubridate", "pryr", "hms", "hexbin", "feather", "htmlwidgets", "stringr", "forcats", "broom", "pander", "modelr", "tidyr","rvest", "methods", "readr", "haven", "testthat","RSQLite")
)

#using the twitteR package ####
library(twitteR)

#From the twitter app (Keys and tokens)
#api_key <- "" # API key 
#api_secret <- "" #API secret key 
#token <- "-" #token 
#token_secret <- "" #token secret

setup_twitter_oauth(api_key, api_secret, token, token_secret) # setup for accessing twitter using the information above

tweets <- searchTwitter("#covid19uk -filter:retweets", n=100000, lang = "en", retryOnRateLimit = 120)# the function searchTwitter search for tweets based on the specified parameters
tweets.df <-twListToDF(tweets) # creates a data frame with one row per tweet

tweetDF <- as.data.frame(tweets.df)

write.csv(tweets.df,"C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweetsdf.csv", row.names = FALSE)


#############################################

#Alternative with rtweet: 
#install.packages("rtweet")
library(rtweet)

#One time connection to get started
api_key <- "*" # API key 
api_secret <- "*" #API secret key 
access_token <- "*" #token 
token_secret <- "*" #token secret

## authenticate via web browser
token <- create_token(
  app = "rstatsjournalismresearch",
  consumer_key = api_key,
  consumer_secret = api_secret,
  access_token = access_token,
  access_secret = token_secret)

#After restart, this automatically connects you to the api
library(rtweet)
get_token()

# get sample tweet
rt <- search_tweets(
  "#covid19uk -filter:retweets",
  n = 20
)


#test to check if stuff gets truncated: 
test <- search_tweets(
  "Even for those of us who have experienced a demanding hostile environment and witnessed",
  n = 20
)
test$text


#write it as csv
rtweet::write_as_csv(rt,"tweetstest.csv")
