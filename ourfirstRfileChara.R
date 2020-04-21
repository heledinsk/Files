pacman::p_load("pacman", "tidyverse", "magrittr", "nycflights13", "gapminder", "Lahman", "maps", "lubridate", "pryr", "hms", "hexbin", "feather", "htmlwidgets", "stringr", "forcats", "broom", "pander", "modelr", "tidyr","twitteR", "methods", "readr", "haven", "testthat","RSQLite","syuzhet","plotly","tm","wordcloud","SnowballC")

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
previousdataset<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/Covid19Tweetsold.csv")
new<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/tweets5wr.csv")

all <- (rbind(previousdataset, new))
Covid19Tweetsnew <- all[!duplicated(all$text),] 
Covid19Tweetsnew <- Covid19Tweetsnew[order(Covid19Tweetsnew$created),]
Covid19Tweetsnew <- distinct(Covid19Tweetsnew) %>% 
                    unique()
Covid19Tweetsnew <- Covid19Tweetsnew[!duplicated(Covid19Tweetsnew$text),] 
write.csv(Covid19Tweetsnew,"C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/Covid19Tweets.csv", row.names = FALSE)

### Prep
Covid19Tweets<- read_csv("C:/Users/avrch/Desktop/Files/BI AU - 2019-2021/2nd Semester/Applied Data Science/AppliedDataScience/Covid19Tweets.csv")

Covid19Tweets$text <- gsub("?http(s?)://(.*)", "", Covid19Tweets$text) #replacing urls with "" using regular expressions.

#using only sample size for faster performance
tweetsdataset <- Covid19Tweets[sample(nrow(Covid19Tweets), 100), ]%>%
  unique()
tweets <-tweetsdataset$text

#into character vecotr
tweets <- as.character(tweets)  


#################################################################################################
#Data prep
##### WITH TOKENIZATION AND STEMMING 

library(tm)

View(clean_tweets)
# remove retweet entities
clean_tweets <- gsub('(RT|via)((?:\\b\\W*@\\w+)+)', '', tweets)
# remove @ people - this removes the whole string for person, do we want that or just delete the @
clean_tweets <- gsub('@\\w+', '', clean_tweets)
# remove punctuation
clean_tweets = gsub('[[:punct:]]', '', clean_tweets)
# remove numbers
clean_tweets = gsub('[[:digit:]]', '', clean_tweets)
# remove html links
clean_tweets = gsub('http\\w+', '', clean_tweets)
# remove unnecessary spaces
clean_tweets = gsub('[ \t]{2,}', '', clean_tweets)
clean_tweets = gsub('^\\s+|\\s+$', '', clean_tweets)
# remove emojis or special characters
clean_tweets = gsub('<.*>', '', enc2native(clean_tweets))
# removing delimiters
clean_tweets <- removePunctuation(clean_tweets)
# removing whitespace
clean_tweets <- stripWhitespace(clean_tweets)
# lower case conversion
clean_tweets <- tolower(clean_tweets)

#(x)stopword removal ?? I skipped it for now - it does not work really :D 
clean_tweets_stop <- removeWords(clean_tweets, stopwords("english"))

# stemming
clean_tweets_stem <- stemDocument(clean_tweets_stop)

# into tokens - not sure if useful, if we not decide to just use one word per tweet? 
token <- words(clean_tweets_stem)

view(token)
##################################################################################
#Analysis#

# Get sentiments using the four different lexicons
syuzhet <- get_sentiment(clean_tweets, method="syuzhet")
View(syuzhet)
bing <- get_sentiment(clean_tweets, method="bing")
afinn <- get_sentiment(clean_tweets, method="afinn")
nrc <- get_sentiment(clean_tweets, method="nrc")
#collect them in a data frame together with the tweet time (maybe also TweetID)
sentiments <- data.frame(syuzhet, bing, afinn, nrc, tweetsdataset$created)# the date is not be proper here if we sampled
sentiments <- sentiments %>% 
  arrange(tweetsdataset.created)

# get the emotions using the NRC dictionary
emotions <- get_nrc_sentiment(clean_tweets)
View(emotions)
emo_bar = colSums(emotions)
View(emo_bar)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])
View(emo_sum)
# Build a collumn to put the overwheigting emotion in 
'????'

#####################################################################################
#Visualization#

#### Time series of sentiments over time ####
# plot the different sentiments from different methods in a time series
plot_ly(sentiments, x=~tweetsdataset.created, y=~syuzhet, type="scatter", mode="jitter", name="syuzhet") %>%
  add_trace(y=~bing, mode="lines", name="bing") %>%
  add_trace(y=~afinn, mode="lines", name="afinn") %>%
  add_trace(y=~nrc, mode="lines", name="nrc") %>%
  layout(title="Recent sentiments regarding COVID19 in the UK",
         yaxis=list(title="score"), xaxis=list(title="date"))

# Visualize the emotions from NRC sentiments
plot_ly(emo_sum, x=~emotion, y=~count, type="bar", color=~emotion) %>%
  layout(xaxis=list(title=""), showlegend=FALSE,
         title="Distribution of emotion categories COVID19 in UK")


##########################################################################################
# Comparison word cloud#

all = c(
  paste(clean_tweets[emotions$anger > 0], collapse=" "),
  paste(clean_tweets[emotions$anticipation > 0], collapse=" "),
  paste(clean_tweets[emotions$disgust > 0], collapse=" "),
  paste(clean_tweets[emotions$fear > 0], collapse=" "),
  paste(clean_tweets[emotions$joy > 0], collapse=" "),
  paste(clean_tweets[emotions$sadness > 0], collapse=" "),
  paste(clean_tweets[emotions$surprise > 0], collapse=" "),
  paste(clean_tweets[emotions$trust > 0], collapse=" ")
)


all <- removeWords(clean_tweets, stopwords("english"))
# create corpus
corpus = Corpus(VectorSource(all))
#
# create term-document matrix
tdm = TermDocumentMatrix(corpus)
#
# convert as matrix
tdm = as.matrix(tdm)
tdm1 <- tdm[nchar(rownames(tdm)) < 11,]
#
# add column names
colnames(tdm) = c('anger', 'anticipation', 'disgust', 'fear', 'joy', 'sadness', 'surprise', 'trust')
colnames(tdm1) <- colnames(tdm)
comparison.cloud(tdm1, random.order=FALSE,
                 colors = c("#00B2FF", "red", "#FF0099", "#6600CC", "green", "orange", "blue", "brown"),
                 title.size=1, max.words=250, scale=c(2.5, 0.4),rot.per=0.4)


#next step try to determine emotions from ngrams!

