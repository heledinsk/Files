<<<<<<< HEAD
#Lets have an R file ready 
#We can rename it in the future, please do 
<<<<<<< HEAD
#Hello, Hello
=======
#blablabla meeting
#second trial
#third triallllllllllll
>>>>>>> fe3c09ed83682b574ae5972fa17aa46deedde32f
=======
#install.packages("twitteR")

 #load the library
#using the twitteR package ####
library(twitteR)


#From the twitter app (Keys and tokens)
#api_key <- "" # API key 
#api_secret <- "" #API secret key 
#token <- "" #token 
#token_secret <- "" #token secret


setup_twitter_oauth(api_key, api_secret, token, token_secret) # setup for accessing twitter using the information above

tweets <- searchTwitter('#covid19uk', n=100000, lang = "en") # the function searchTwitter search for tweets based on the specified parameters
#tweets1 = searchTwitter('#covid19uk', since = '2020-03-01', geocode = '57.1512475,-7.3292194', n=100000, lang="en") #https://rpubs.com/sumitkumar-00/twitter_sentiment_analysis, I haver not tried it, I altered the geo code to uk
#Maybe we should not collect retweeted tweets so we can collect distinct ones, computer is super slow with that many data
#I manages to collect and save 100000 tweets on 4/4/2019
tweets.df <-twListToDF(tweets) # creates a data frame with one row per tweet

tweetDF <- as.data.frame(tweets.df)

write.csv(tweets.df,"C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweetsdf.csv", row.names = FALSE)
>>>>>>> 75579b299bddaea3bcbcee8af8b7852dec82208c

