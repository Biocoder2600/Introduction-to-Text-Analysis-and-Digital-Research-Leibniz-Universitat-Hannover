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
book5 <- readtext(file.path("data", "book5", "*.html")) %>% corpus()
docvars(book5, "Book") <- "5"




# Getting the lexicon from the Tidytext package


# Creating a "document-sentiment matrix" with the dictionary


# Combining with the meta data matrix


# Plotting it


