library(twitteR)


#From the twitter app (Keys and tokens)
api_key <- "NZdDgX5gBv83yRILFlJiq5J1R" # API key 
api_secret <- "rNaFONCS56mFxWHCfXWW85JP9SGwu545dPV3pMk229FQuKQfoo" #API secret key 
token <- "808308358847537152-krRV8KqJDCnHaMFVBmwfVjkriYRjCRC" #token 
token_secret <- "BPIS3e4jIYWN4AuXHkUm7w931BSjMoIWq1A0NmkyFwA0m" #token secret


setup_twitter_oauth(api_key, api_secret, token, token_secret) # setup for accessing twitter using the information above

tweets <- searchTwitter('#covid19uk', n=100000, lang = "en") # the function searchTwitter search for tweets based on the specified parameters

tweets.df <-twListToDF(tweets) # creates a data frame with one row per tweet

tweetDF <- as.data.frame(tweets.df)

write.csv(tweets.df,"C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweetsdf.csv", row.names = FALSE)

