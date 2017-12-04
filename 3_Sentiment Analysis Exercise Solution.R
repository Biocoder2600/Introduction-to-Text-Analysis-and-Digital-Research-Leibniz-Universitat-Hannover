download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/1.AGameOfThrones-GeorgeR.R.Martin.epub", "1.zip")
download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/2.AClashOfKings-GeorgeR.R.Martin.epub", "2.zip")
download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/3.AStormOfSwords-GeorgeR.R.Martin.epub", "3.zip")
download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/4.AFeastForCrows-GeorgeR.R.Martin.epub", "4.zip")
download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/5.ADanceWithDragons-GeorgeR.R.Martin.epub", "5.zip")
unzip("1.zip", exdir = file.path("data", "book1"))
unzip("2.zip", exdir = file.path("data", "book2"))
unzip("3.zip", exdir = file.path("data", "book3"))
unzip("4.zip", exdir = file.path("data", "book4"))
unzip("5.zip", exdir = file.path("data", "book5"))


library(readtext)
library(dplyr)
library(quanteda)
library(stringr)
book1 <- readtext(file.path("data", "book1", "*.html")) %>% corpus()
docvars(book1, "Book") <- "1"
book2 <- readtext(file.path("data", "book2", "*.html")) %>% corpus()
docvars(book2, "Book") <- "2"
book3 <- readtext(file.path("data", "book3", "*.html")) %>% corpus()
docvars(book3, "Book") <- "3"
book4 <- readtext(file.path("data", "book4", "*.html")) %>% corpus()
docvars(book4, "Book") <- "4"
# book5 <- readtext(file.path("data", "book5", "*.html")) %>% corpus()
# docvars(book5, "Book") <- "5"

# Solving the formatting in Book 5
## Getting all filenames
path <- file.path("data", "book5")
out.file<-""
file.names <- dir(path, pattern =".html")

## Looping through the files, concatenating them together 
for(i in 1:length(file.names)){
  file <- read.table(file.path(path,file.names[i]),header=TRUE, sep=";", stringsAsFactors=FALSE)
  out.file <- rbind(out.file, file)
}

## Spliting and Clearing html tags
book5 <- paste(out.file) %>% strsplit(".html#") %>% unlist() # every chapter starts with ".html#
book5 <- gsub("\\t", " ", book5, fixed = TRUE)
book5 <- gsub("<.*?>", " ", book5)
book5 <- gsub("a href=index_split_[0-9][0-9][0-9]", " ", book5)
book5 <- corpus(book5)

docvars(book5, "doc_id") <- sprintf('%0.3d', 1:ndoc(book5))
book5 <- corpus_subset(book5, doc_id < 183 & doc_id > 110)
docvars(book5, "doc_id") <- sprintf('%0.3d', 1:ndoc(book5))
docvars(book5, "Book") <- "5"

books_corpus <- corpus(c(book1, book2, book3, book4, book5)) 
docvars(books_corpus, "ntoken") <- ntoken(books_corpus)
books_corpus <- corpus_subset(books_corpus, ntoken > 2000) # Removing content and appendix etc
docvars(books_corpus, "chap") <- str_extract_all(docvars(books_corpus, "doc_id"), "[0-9][0-9][0-9]") %>% unlist()
docnames(books_corpus) <- paste(docvars(books_corpus, "Book"), docvars(books_corpus, "chap"), sep ="_")
docvars(books_corpus, 'doc_id') <- NULL
docvar <- docvars(books_corpus)
  
custom_stopwords <- c("said", "one")

books_dfm <- tokens(books_corpus, remove_numbers = TRUE, remove_punct = TRUE, remove_symbols = TRUE) %>% 
  dfm(remove = c(stopwords("english"),custom_stopwords))
topfeatures(books_dfm, 100)

# Generating a png instead of displaying in the Plot screen
# png("wordcloud.png", width=800,height=800)
# textplot_wordcloud(books_dfm, min.freq = 100, random.order = FALSE,
#                    rot.per = .25, 
#                    colors = RColorBrewer::brewer.pal(6,"Accent"))
# dev.off()

# Getting the lexicon from the Tidytext package
bing <- tidytext::get_sentiments("bing")
bingpos <- bing$word[bing$sentiment == "positive"]
bingneg <- bing$word[bing$sentiment == "negative"]
bingdict <- dictionary(list(positive = bingpos,
                            negative = bingneg))

# Creating a "document-sentiment matrix" with the dictionary
sentdfm <- dfm(books_dfm, dictionary = bingdict)
sentmat <- as.data.frame(sentdfm)
sentmat["sentiment"] <- sentmat$positive - sentmat$negative
sentmat["emotionwords"] <- sentmat$positive + sentmat$negative
docvar <- cbind(docvar, sentmat)

# Plotting it
library(ggplot2)
ggplot(docvar, aes(chap, sentiment, fill = Book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~Book, ncol = 5, scales = "free_x")

ggplot(docvar, aes(chap, sentiment, fill = Book)) +
  geom_point(aes(colour = factor(Book)))

# Bonus: Where to find Khaleesi?
kwic(books_corpus, "khaleesi")
textplot_xray(kwic(books_corpus, "khaleesi"))

