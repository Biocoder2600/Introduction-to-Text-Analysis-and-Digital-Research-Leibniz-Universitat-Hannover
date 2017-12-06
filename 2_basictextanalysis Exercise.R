# Download the corpus files

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

# You will need this two packages
library(readtext)
library(quanteda)


# Tips: use readtext() to read the text, then use corpus() to create a corpus for each book.
# Use dfm() to create dfm
# Use topfeatures() to check the data
# Use textplot_wordcloud() to plot it
# Try to create separate corpus for Book1 and Book2, and do a keyword analysis about them






