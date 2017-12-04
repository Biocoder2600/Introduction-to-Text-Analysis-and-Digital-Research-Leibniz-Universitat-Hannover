library(readtext)
library(quanteda)
library(magrittr)

# Loading the documents
amazon <-  corpus(readtext(file.path("data","amazon_reviews.csv"), text_field = "Text"))
amazondfm <- dfm(amazon, remove_punct = TRUE, remove_numbers = TRUE, verbose = TRUE, remove_url = TRUE, stem = FALSE, remove = c(stopwords("english"), "br"))
docvar <- docvars(amazon)

topfeatures(amazondfm)

bing <- tidytext::get_sentiments("bing")
bingpos <- bing$word[bing$sentiment == "positive"]
bingneg <- bing$word[bing$sentiment == "negative"]
bingdict <- dictionary(list(positive = bingpos,
                            negative = bingneg))

# Creating a "document-sentiment matrix" with the dictionary
sentdfm <- dfm(amazondfm, dictionary = bingdict)
sentmat <- as.data.frame(sentdfm)
sentmat["sentiment"] <- sentmat$positive - sentmat$negative
sentmat["emotionwords"] <- sentmat$positive + sentmat$negative

# Combining with the meta data matrix
docvar <- cbind(docvar, sentmat)

# Plotting it
library(ggplot2)
ggplot(docvar, aes(Score, sentiment)) +
  geom_jitter(width = 0.25, alpha = 0.1, color = "brown1") +
  geom_smooth(method = "lm", color = "chartreuse4", alpha = 0.8)

# There is a correlation between the comment and the score
cor(docvar$Score, docvar$sentiment)

# Doing Sentiment Analysis with Another Package (Tidytext)
# Loading the documents
snp <-  corpus(readtext(file.path("data","SNP_corpus.csv"), text_field = "post_message"))
snpdfm <- dfm(snp, stem = FALSE, remove_punct = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove = stopwords("english"), verbose = TRUE)
docvars(snp, "Party") <- "SNP"
docvars(snp, "doc_id") <- str_replace_all(docvars(snp, "doc_id"), "\\.csv\\.", "_")
docnames(snp) <- paste(docvars(snp, "doc_id"), lubridate::as_date(docvars(snp, "post_published")), docvars(snp, "likes_count_fb"), sep = "_")# adding doc names

ukip <-  corpus(readtext(file.path("data","UKIP_corpus.csv"), text_field = "post_message"))
ukipdfm <- dfm(snp, stem = FALSE, remove_punct = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove = stopwords("english"), verbose = TRUE)
docvars(ukip, "Party") <- "UKIP"
docvars(ukip, "doc_id") <- str_replace_all(docvars(ukip, "doc_id"), "\\.csv\\.", "_")
docnames(ukip) <- paste(docvars(ukip, "doc_id"), lubridate::as_date(docvars(ukip, "post_published")), docvars(ukip, "likes_count_fb"), sep = "_")# adding doc names

combined <- corpus(c(snp, ukip))
docvar <- docvars(combined)
combineddfm <- dfm(combined, stem = FALSE, remove_punct = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove = stopwords("english"), verbose = TRUE)
topfeatures(combineddfm)

library(dplyr)
library(tidytext)
library(tidyr)

# Sentiment Analysis with Tidy
tidy_corpus <- tidy(combineddfm)

corpus_sentiments <- tidy_corpus %>%
  inner_join(get_sentiments("bing"), by = c(term = "word")) %>%
  count(document, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)

# Data wraggling
corpus_sentiments <- corpus_sentiments %>%
  separate(document, c("party", "type", "no", "date", "like"), sep = "_", convert = TRUE)
corpus_sentiments$date <- as.Date(corpus_sentiments$date)
corpus_sentiments <- corpus_sentiments %>% group_by(party) %>% mutate(med = mean(sentiment))

library(ggplot2)
library(scales)
ggplot(corpus_sentiments, aes(date, sentiment, fill = party)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~party, ncol = 2, scales = "free_x")  +
  scale_x_date(labels = date_format("%Y-%m"), date_breaks = "3 month") +
  geom_hline(aes(yintercept = 0, group = party), colour = 'black', alpha = 0.5) +
  geom_smooth(method = "auto", alpha = 0.6, colour = 'blue')

corpus_sentiments %>% group_by(party) %>% 
  summarise(avg = mean(sentiment), sd = sd(sentiment))

# Using Afinn
corpus_sentiments_afinn <- tidy_corpus %>% 
  inner_join(get_sentiments("afinn"), by = c(term = "word"))  %>% 
  separate(document, c("party", "type", "no", "date", "like"), sep = "_", convert = TRUE)
corpus_sentiments_afinn$date <- as.Date(corpus_sentiments_afinn$date)
ggplot(corpus_sentiments_afinn, aes(date, score, fill = party)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~party, ncol = 2, scales = "free_x")  +
  scale_x_date(labels = date_format("%Y-%m"), date_breaks = "3 month") +
  geom_hline(aes(yintercept = 0, group = party), colour = 'black', alpha = 0.5) +
  geom_smooth(method = "auto", alpha = 0.6, colour = 'blue')

corpus_sentiments_afinn %>% group_by(party) %>% 
  summarise(avg = mean(score), sd = sd(score))