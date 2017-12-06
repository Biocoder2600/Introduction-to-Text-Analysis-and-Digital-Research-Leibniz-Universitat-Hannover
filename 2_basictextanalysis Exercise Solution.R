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
library(wordcloud)


# Tips: use readtext() to read the text, then use corpus() to create a corpus for each book.
# Use dfm() to create dfm
# Use topfeatures() to check the data
# Use textplot_wordcloud() to plot it
# Try to create separate corpus for Book1 and Book2, and do a keyword analysis about them

book1 <- readtext(file.path("data", "book1", "*.html")) %>% corpus()
docvars(book1, "Book") <- "1"
book2 <- readtext(file.path("data", "book2", "*.html")) %>% corpus()
docvars(book2, "Book") <- "2"

custom_stopwords <- c("said", "one")

book1tokens <- tokens(book1, remove_punct = TRUE, remove_numbers = TRUE, verbose = TRUE)
book1dfm <- dfm(book1tokens, remove = c(stopwords('english'), custom_stopwords)) %>% 
  dfm_trim(min_doc = 5, min_count = 10)

book2tokens <- tokens(book2, remove_punct = TRUE, remove_numbers = TRUE, verbose = TRUE)
book2dfm <- dfm(book2tokens, remove = c(stopwords('english'), custom_stopwords)) %>% 
  dfm_trim(min_doc = 5, min_count = 10)

# Bonus: Where to find Khaleesi?
kwic(book1, "khaleesi")
textplot_xray(kwic(book1, "khaleesi"))

# Estimating Keyness
# Use rbind() to combine two datasets
kwds <- textstat_keyness(rbind(book1dfm, book2dfm), target = seq_along(book1tokens))
head(kwds, 20)
tail(kwds, 20)
textplot_keyness(kwds)

# Like I said, when you have to use the same codes for more than once, write a function!
keyness_cloud <- function(x, a = "A", b = "B", acol = "#00C094", bcol = "#F8766D", w = 600, h = 600, maxword = 500, png = TRUE){
  set.seed(1024)
  kwdssig <- data.frame(term = row.names(x), chi2 = x$chi2, p=x$p) %>% 
    filter(x$p <= 0.05) %>% 
    select(term, chi2)
  row.names(kwdssig) <- kwdssig$term
  kwdssig$a <- kwdssig$chi2
  kwdssig$b <- kwdssig$chi2
  kwdssig$b[kwdssig$b > 0] <- 0
  kwdssig$a[kwdssig$a < 0] <- 0
  kwdssig <- kwdssig[,-1:-2]
  colnames(kwdssig) <- c(a, b)
  if (png) {
    png(paste0(deparse(substitute(x)), ".png"), width = w, height = h)
    comparison.cloud(kwdssig, random.order=FALSE, colors = c(acol, bcol),scale=c(6,.6), title.size=3, max.words = maxword)
    dev.off()
  } else {
    comparison.cloud(kwdssig, random.order=FALSE, colors = c(acol, bcol),scale=c(6,.6), title.size=3, max.words = maxword)
  }
}

keyness_cloud(kwds, "Book1", "Book2", png = FALSE)

