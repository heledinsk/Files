#install.packages("twitteR")

install.packages(c("devtools", "rjson", "bit64", "httr"))
Make sure to restart your R session at this point
library(devtools)
install_github("geoffjentry/twitteR")


#using the twitteR package ####
library(twitteR)
??twitteR

strip_retweets

#From the twitter app (Keys and tokens)
api_key <- "NZdDgX5gBv83yRILFlJiq5J1R" # API key 
api_secret <- "rNaFONCS56mFxWHCfXWW85JP9SGwu545dPV3pMk229FQuKQfoo" #API secret key 
token <- "808308358847537152-krRV8KqJDCnHaMFVBmwfVjkriYRjCRC" #token 
token_secret <- "BPIS3e4jIYWN4AuXHkUm7w931BSjMoIWq1A0NmkyFwA0m" #token secret


setup_twitter_oauth(api_key, api_secret, token, token_secret) # setup for accessing twitter using the information above

tweets <- searchTwitter('#covid19uk', n=500, lang = 'en') # the function searchTwitter search for tweets based on the specified parameters
tweets1 <-  searchTwitter('#covid19uk', geocode = '57.1512475,-7.3292194', since = '2020-03-01', n=500, lang='en') #https://rpubs.com/sumitkumar-00/twitter_sentiment_analysis, I haver not tried it, I altered the geo code to uk

#,
#Maybe we should not collect retweeted tweets so we can collect distinct ones, computer is super slow with that many data
#I manages to collect and save 100000 tweets on 4/4/2019
tweets.df <-twListToDF(tweets) # creates a data frame with one row per tweet

tweetDF <- as.data.frame(tweets.df)

write.csv(tweets.df,"/R/ADS/tweetsdf.csv", row.names = FALSE)
