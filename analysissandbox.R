Prep
#install.packages("syuzhet")
#install.packages("plotly")
#install.packages ("tm")
#install.packages("wordcloud")
#install.packages("SnowballC")

library(SnowballC)
library(syuzhet)
library(plotly)
library(tm)
library(wordcloud)
library(dplyr)

#loading data
file <- read.csv("sandbox.csv")
tweets <-file$text

View(tweets)
str(tweets)
#into character vecotr
tweets <- as.character(tweets)
#getting rid of duplicate data
tweets <- unique(tweets)
#using only sample size for faster performance
tweets <- sample (tweets, size=100)

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
clean_tweets_stem <- stemDocument(clean_tweets)
View(clean_tweets)
View(tweets)

# into tokens - not sure if useful, if we not decide to just use one word per tweet? 
token <- words(clean_tweets)


##################################################################################
#Analysis#

# Get sentiments using the four different lexicons
syuzhet <- get_sentiment(clean_tweets, method="syuzhet")
View(syuzhet)
bing <- get_sentiment(clean_tweets, method="bing")
afinn <- get_sentiment(clean_tweets, method="afinn")
nrc <- get_sentiment(clean_tweets, method="nrc")
#collect them in a data frame together with the tweet time (maybe also TweetID)
sentiments <- data.frame(syuzhet, bing, afinn, nrc, file$created_at)
sentiments <- sentiments %>% 
  arrange(file.created_at)

# get the emotions using the NRC dictionary
emotions <- get_nrc_sentiment(clean_tweets)
View(emotions)
emo_bar = colSums(emotions)
View(emo_bar)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
View(emo_sum)
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])

# Build a collumn to put the overwheigting emotion in 
'????'

#####################################################################################
#Visualization#

#### Time series of sentiments over time ####
# plot the different sentiments from different methods in a time series
plot_ly(sentiments, x=~file.created_at, y=~syuzhet, type="scatter", mode="jitter", name="syuzhet") %>%
  add_trace(y=~bing, mode="lines", name="bing") %>%
  add_trace(y=~afinn, mode="lines", name="afinn") %>%
  add_trace(y=~nrc, mode="lines", name="nrc") %>%
  layout(title="Recent sentiments of HDB in Singapore",
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
