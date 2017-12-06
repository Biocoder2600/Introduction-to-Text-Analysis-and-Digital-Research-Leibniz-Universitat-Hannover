# download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/1.AGameOfThrones-GeorgeR.R.Martin.epub", "1.zip")
# download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/2.AClashOfKings-GeorgeR.R.Martin.epub", "2.zip")
# download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/3.AStormOfSwords-GeorgeR.R.Martin.epub", "3.zip")
# download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/4.AFeastForCrows-GeorgeR.R.Martin.epub", "4.zip")
# download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/5.ADanceWithDragons-GeorgeR.R.Martin.epub", "5.zip")
# unzip("1.zip", exdir = file.path("data", "book1"))
# unzip("2.zip", exdir = file.path("data", "book2"))
# unzip("3.zip", exdir = file.path("data", "book3"))
# unzip("4.zip", exdir = file.path("data", "book4"))
# unzip("5.zip", exdir = file.path("data", "book5"))


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

# Creating dfm
books_dfm <- tokens(books_corpus, remove_numbers = TRUE, remove_punct = TRUE, remove_symbols = TRUE) %>% 
  dfm(remove = c(stopwords("english"),custom_stopwords))
topfeatures(books_dfm, 100)

# Transforming the data into the format for topicmodels
trimdfm <- dfm_trim(books_dfm, min_docfreq = 20, min_count = 100)
trimdfm
topfeatures(trimdfm)
trimdfm <- convert(trimdfm, to = "topicmodels")

# Fit the model (Warning: IT MAY TAKE LONG)
library(topicmodels)
start.time <- Sys.time()
results_lda <- LDA(trimdfm, 10, method="VEM")  
end.time <- Sys.time()
print(end.time - start.time)

# # You may want to save the .RData since it took so long to run
# save.image("~/GitHub/Hanover Source/gottopicmodels.RData")

# See the terms
get_terms(results_lda, k=20)

# Check
hist(get_topics(results_lda))

# Fancy visualisation
library(tidytext)
library(tidyr)
library(ggplot2)
library(dplyr)

topics <- tidy(results_lda, matrix = "beta") # Change this line and run the whole chunk

top_terms <- topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top_terms %>% mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()

# Adding the data into the meta-data matrix
docvar["topic"] <- get_topics(results_lda)
table(docvar$Book, docvar$topic)

# Visualising with ggplot2
# install.packages("reshape2")
library(reshape2)
topictable <- table(docvar$topic, docvar$Book) %>% as.data.frame.matrix()
topictable$topic <- rownames(topictable)
topictable <- melt(topictable, id.vars = "topic", variable.name = "Book",value.name = "freq")

# normalising the frequency
topictable$norfreq[topictable$Book == "1"] <- topictable$freq[topictable$Book == "1"] / sum(topictable$freq[topictable$Book == "1"])
topictable$norfreq[topictable$Book == "2"] <- topictable$freq[topictable$Book == "2"] / sum(topictable$freq[topictable$Book == "2"])
topictable$norfreq[topictable$Book == "3"] <- topictable$freq[topictable$Book == "3"] / sum(topictable$freq[topictable$Book == "3"])
topictable$norfreq[topictable$Book == "4"] <- topictable$freq[topictable$Book == "4"] / sum(topictable$freq[topictable$Book == "4"])
topictable$norfreq[topictable$Book == "5"] <- topictable$freq[topictable$Book == "5"] / sum(topictable$freq[topictable$Book == "5"])

ggplot(topictable, aes(topic, norfreq)) + 
  geom_point(aes(colour = Book )) +
  scale_x_discrete(limits = c(1:10)) +
  scale_y_continuous()

# Another visualisation
doc_gamma <- tidy(results_lda, matrix = "gamma") %>%
  separate(document, c("project", "wave", "name", "interviewer", "clean", "year", "sex"), sep = "_", convert = TRUE)

doc_gamma %>%
  mutate(project = reorder(project, gamma * topic)) %>%
  ggplot(aes(factor(topic), gamma)) +
  geom_boxplot() +
  facet_wrap(~ project) +
  scale_x_discrete(limits = c(1:10))


