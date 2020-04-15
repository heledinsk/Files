#install.packages("twitteR")

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


