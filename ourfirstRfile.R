#install.packages("twitteR")

#using the twitteR package ####
library(twitteR)


#From the twitter app (Keys and tokens)
api_key <- "NZdDgX5gBv83yRILFlJiq5J1R" # API key 
api_secret <- "rNaFONCS56mFxWHCfXWW85JP9SGwu545dPV3pMk229FQuKQfoo" #API secret key 
token <- "808308358847537152-iCuPoKnK2n56e1mN6TGn10BOa6bM4wI" #token 
token_secret <- "X265QZUQumUfcrFNgK13okahlTMYbqXCvnlyzT8gWjTvy" #token secret


setup_twitter_oauth(api_key, api_secret, token, token_secret) # setup for accessing twitter using the information above

tweets <- searchTwitter('#covid19uk', n=10000, lang = "en") # the function searchTwitter search for tweets based on the specified parameters

tweets.df <-twListToDF(tweets) # creates a data frame with one row per tweet

tweetDF <- as.data.frame(tweets.df)
