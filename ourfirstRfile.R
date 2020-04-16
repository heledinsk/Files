library(readr)
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

#### Working on the original files to delete retweets
#original<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets4wr.csv") #working on the original files to delete retweets
#oriwt <- ori[- grep("RT", ori$text),] #deleting RT from a data frame of already collected tweets
#write.csv(d,"C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets3wr.csv", row.names = FALSE)#rewriting datasets without retweets
####

### Merging the various data frames, deleting duplicates, ordering by date
library(readr)
#wr1<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets1wr.csv")
#wr2<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets2wr.csv")
#wr3<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets3wr.csv")
#wr4<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets4wr.csv")

#all <- (rbind(wr1, wr2, wr3, wr4))
#final <- all[!duplicated(all$text),] 
#final <- final[order(final$created),]
#write.csv(Covid19Tweets2,"C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/Covid19Tweets.csv", row.names = FALSE)
###

Covid19Tweets<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/Covid19Tweets.csv")

Covid19Tweets <- distinct(Covid19Tweets)
Covid19Tweets <- unique(Covid19Tweets)
Covid19Tweets <- Covid19Tweets[!duplicated(Covid19Tweets$text),] 
#write.csv(Covid19Tweets2,"C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/Covid19Tweets.csv", row.names = FALSE)
