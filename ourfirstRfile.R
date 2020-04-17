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






library(syuzhet)
library(plotly)
library(tm)
library(wordcloud)
library(dplyr)

#loading data
file <- read.csv("D:/Tereza/Aarhus university/master/2. semester/Applied Data Science/project/Covid19Tweets.csv")
tweets <-file$text

View(tweets)
str(tweets)
#into character vecotr
tweets <- as.character(tweets)

#getting rid of duplicate data
tweets <- unique(tweets)

#using only sample size for faster performance
tweets <- sample (tweets, size=100)

##### NO TOKENIZATION OR STEMMING - TRYING TO DETERMINE THE EMOTION OF THE WHOLE TWEET

# remove retweet entities
tweets1 <- gsub('(RT|via)((?:\\b\\W*@\\w+)+)', '', tweets)
# remove at people - this removes the whole string for person, do we want that or just delete the @
tweets1 <- gsub('@\\w+', '', tweets1)
# remove punctuation
tweets1 = gsub('[[:punct:]]', '', tweets1)
# remove numbers
tweets1 = gsub('[[:digit:]]', '', tweets1)
# remove html links
tweets1 = gsub('http\\w+', '', tweets1)
# remove unnecessary spaces
tweets1 = gsub('[ \t]{2,}', '', tweets1)
tweets1 = gsub('^\\s+|\\s+$', '', tweets1)
# remove emojis or special characters
tweets1 = gsub('<.*>', '', enc2native(tweets1))


# removing delimiters
tweets1 <- removePunctuation(tweets1)

# removing whitespace
tweets1 <- stripWhitespace(tweets1)

# lower case conversion
tweets1 <- tolower(tweets1)

# get the emotions using the NRC dictionary
emotions <- get_nrc_sentiment(tweets1)
View(emotions)
emo_bar = colSums(emotions)
View(emo_bar)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
View(emo_sum)
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])

View(tweets1)


#this shows the sentiment score per tweet
sentiment(tweets1)

#this creates matrix showing the emotions - maybe we could  pivot it..? 
get_nrc_sentiment(tweets1)







##### WITH TOKENIZATION AND STEMMING 

library(tm)

View(clean_tweets)
# remove retweet entities
clean_tweets <- gsub('(RT|via)((?:\\b\\W*@\\w+)+)', '', tweets)
# remove at people - this removes the whole string for person, do we want that or just delete the @
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

# stopword removal ?? I skipped it for now 
clean_tweets <- removeWords(clean_tweets, stopwords("english"))

# stemming
clean_tweets <- stemDocument(clean_tweets)
View(clean_tweets)
View(tweets)

# into tokens 
clean_tweets <- words(clean_tweets)

clean_tweets


# extract the timestamp - skipped
timestamp <- as.POSIXct(sapply(clean_tweets, function(x)x$getCreated()), origin="1970-01-01", tz="GMT")
timestamp <- timestamp[!duplicated(clean_tweets)]
clean_tweets <- clean_tweets[!duplicated(clean_tweets)]

# Get sentiments using the four different lexicons
syuzhet <- get_sentiment(clean_tweets, method="syuzhet")
View(syuzhet)
bing <- get_sentiment(clean_tweets, method="bing")
afinn <- get_sentiment(clean_tweets, method="afinn")
nrc <- get_sentiment(clean_tweets, method="nrc")
sentiments <- data.frame(syuzhet, bing, afinn, nrc, timestamp)

# get the emotions using the NRC dictionary
emotions <- get_nrc_sentiment(clean_tweets)
View(emotions)
emo_bar = colSums(emotions)
View(emo_bar)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
View(emo_sum)
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])

# plot the different sentiments from different methods
plot_ly(sentiments, x=~timestamp, y=~syuzhet, type="scatter", mode="jitter", name="syuzhet") %>%
  add_trace(y=~bing, mode="lines", name="bing") %>%
  add_trace(y=~afinn, mode="lines", name="afinn") %>%
  add_trace(y=~nrc, mode="lines", name="nrc") %>%
  layout(title="Recent sentiments of HDB in Singapore",
         yaxis=list(title="score"), xaxis=list(title="date"))

# Visualize the emotions from NRC sentiments
plot_ly(emo_sum, x=~emotion, y=~count, type="bar", color=~emotion) %>%
  layout(xaxis=list(title=""), showlegend=FALSE,
         title="Distribution of emotion categories COVID19 in UK")

# Comparison word cloud
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



sentiment(clean_tweets)
get_nrc_sentiment(clean_tweets)

# add sentiment score to data.frame
column <- sentiment(clean_tweets)$sentiment 
