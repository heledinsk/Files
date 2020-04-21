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
#2233


#1. TRYING TO CLEAN THE DATA

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








#2. adding columns with sentiment per each word!

# Load dplyr and tidytext
library(dplyr)
library(tidytext)
library(syuzhet)
library(textdata)
install.packages("textdata")
# Choose the bing lexicon
#get_sentiments("bing")
get_sentiments("bing")

# Choose the nrc lexicon; INSTALLED UNDER CONDITION OF CITING IT!!!!
get_sentiments("nrc") %>%
  count(sentiment) # Count words by sentiment

sandbox <- read.csv("D:/Tereza/Aarhus university/master/2. semester/Applied Data Science/project/sandbox.csv")

#a. keep only some columns 
data <- select(sandbox, created_at, text)
data <- data %>%
  mutate(tweet_number = row_number())

#change vector types
data <- transform(data, text = as.character(text), created_at =as.Date(created_at))

str(data)


#tide 
tidy <- data %>%
  # Group by the titles of the plays
  group_by(tweet_number) %>%
  # Transform the non-tidy text data to tidy text data
  unnest_tokens(word, text) %>%
  ungroup()

# Pipe the tidy data frame to the next line
tidy %>% 
  # Use count to find out how many times each word is used
  count(word, sort = TRUE)


#adding column with sentiment - so it should be theoretically possible with emotion? 
sentiment <- tidy %>%
  # Implement sentiment analysis with the "bing" lexicon
  inner_join(get_sentiments("bing"))


#this code adds sentiment to column (of words, not whole tweets)
sentiment %>%
  # Find how many positive/negative words each tweet (so here it is tweet number) has
  group_by(tweet_number) %>%
  count(tweet_number,sentiment)
View(sentiment)




word_counts <- tidy %>%
  # Implement sentiment analysis using the "bing" lexicon
  inner_join(get_sentiments("bing")) %>%
  # Count by word and sentiment
  count(word,sentiment)

top_words <- word_counts %>%
  # Group by sentiment
  group_by(sentiment) %>%
  # Take the top 10 for each sentiment
  top_n(10) %>%
  ungroup() %>%
  # Make word a factor in order of n
  mutate(word = reorder(word, n))

# Use aes() to put words on the x-axis and n on the y-axis
ggplot(top_words, aes(word, n, fill = sentiment)) +
  # Make a bar chart with geom_col()
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free") +  
  coord_flip()






#3. next try: add words to separate columns, keep the whole tweet there and assign sentiments to the selected words
sandbox <- read.csv("D:/Tereza/Aarhus university/master/2. semester/Applied Data Science/project/sandbox.csv")
View(sandbox)

# extract hashtags and put them in a new collumn

hash <- str_match_all(sandbox$text, "#\\w+")

sandbox_hash <- sandbox %>%
  mutate(hashtags = hash)

View(sandbox_hash)
str(sandbox_hash)

#a. keep only some columns 
data <- select(sandbox_hash, text)
str(data)

#b. delete some uneccesary columns
file <- select(sandbox_hash, -user_id, -status_id, -reply_to_user_id, -reply_to_status_id, -urls_t.co, -ext_media_url, -ext_media_t.co, -mentions_user_id,-quoted_status_id, -quoted_user_id)
View(file)

#add row number - to spot from what tweet a a word is 
file <- data %>%
  mutate(tweet_number = row_number())
file$tweet_number
str(file)

#transform text into character vector, date into date, we probably need to change other variables 
file <- transform(file, text = as.character(text))
View(file)
str(file)

tweets <-file$text
View(tweets)
str(tweets)


#try to merge tweets and the words file - do it later
merged <- merge(file_tokens, file, by = "tweet_number")



#tokenize
library(tidytext)
file_tokens <- file %>%
  unnest_tokens(word, text)

View(file_tokens)
str(file_tokens)

file <- select(file_tokens, word, tweet_number)
View(file)

#stop words
get_stopwords()

#making a dokument with only the words
tweets <- file_tokens$word
str(tweets)
View(tweets)



cleaned_file <- file_tokens %>%
  anti_join(get_stopwords())
View(cleaned_file$word)

str(cleaned_file)
str(cleaned_file$word) #without stop words 2143
str(file_tokens$word) #with stop words we have 3151 words - so we have deleted 1008 stop words


#try to merge tweets and the words file - do it later
merged <- merge(file, cleaned_file, by = "tweet_number")
View(merged)

merged %>%
  count(word, sort = TRUE) #what are the most common words

#count positive words
positive <- get_sentiments("bing") %>%
  filter(sentiment == "positive")

#count positve words
merged %>%
  semi_join(positive) %>%
  count(word, sort = TRUE)

#negative words
negative <- get_sentiments("bing") %>%
  filter(sentiment == "negative")

merged %>%
  semi_join(negative) %>%
  count(word, sort = TRUE)


sentiment <- merged %>%
  # Implement sentiment analysis with the "bing" lexicon
  inner_join(get_sentiments("bing"))

sentiment %>%
  # Find how many positive/negative words THERE IS 
  count(word,sentiment, sort = TRUE)

View(sentiment)




#next step try to determine emotions from ngrams!
