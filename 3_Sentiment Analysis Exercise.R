download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/1.AGameOfThrones-GeorgeR.R.Martin.epub", "b1.zip")
download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/2.AClashOfKings-GeorgeR.R.Martin.epub", "b2.zip")
download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/3.AStormOfSwords-GeorgeR.R.Martin.epub", "b3.zip")
download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/4.AFeastForCrows-GeorgeR.R.Martin.epub", "b4.zip")
download.file("https://archive.org/download/A_Game_of_Thrones_Series/A%20Game%20of%20Thrones%20-%20Books%201%20-%205%20%20A%20Song%20of%20Ice%20and%20Fire/5.ADanceWithDragons-GeorgeR.R.Martin.epub", "b5.zip")
unzip("b1.zip", exdir = file.path("data", "book1"))
unzip("b2.zip", exdir = file.path("data", "book2"))
unzip("b3.zip", exdir = file.path("data", "book3"))
unzip("b4.zip", exdir = file.path("data", "book4"))
unzip("b5.zip", exdir = file.path("data", "book5"))


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
book5 <- readtext(file.path("data", "book5", "*.html")) %>% corpus()
docvars(book5, "Book") <- "5"

books_corpus <- corpus(c(book1, book2, book3, book4, book5)) 



# Getting the lexicon from the Tidytext package


# Creating a "document-sentiment matrix" with the dictionary


# Combining with the meta data matrix


# Plotting it


# Advanced Challenges:
# 1. Try other lexicons. There are three sources: "afinn", "bing", and "nrc".
# 2. Why the result of book 5 looks so weird? Try to solve it!

