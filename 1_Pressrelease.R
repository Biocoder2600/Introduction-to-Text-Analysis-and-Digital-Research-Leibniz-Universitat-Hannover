library(rvest)
library(magrittr)
library(stringr)

# Trying to scrap the federal consitutional court's press release
# http://www.bundesverfassungsgericht.de/DE/Presse/Pressemitteilungen/pressemitteilungen_node.html?cms_gtp=5399872_list%253D1

# These are for testing for one page
html <- read_html("http://www.bundesverfassungsgericht.de/DE/Presse/Pressemitteilungen/pressemitteilungen_node.html?cms_gtp=5399872_list%253D1")
html %>% html_nodes("td") %>% html_nodes("a") %>% html_attr("href")

pages <- c(1:112) # There are 112 pages
pages <- c(1:2) # Trying for 2 pages

# getting the links to the press releases
links <- c()
for (i in 1:length(pages)){
  html <- read_html(paste("http://www.bundesverfassungsgericht.de/DE/Presse/Pressemitteilungen/pressemitteilungen_node.html?cms_gtp=5399872_list%253D",i, sep = ""))
  href <- html %>% html_nodes("td") %>% html_nodes("a") %>% html_attr("href")
  links <- c(links, href)
  }

# select the press releases' links
presslinks <- links[grep("^SharedDocs/Pressemitteilungen/",links)] %>% strsplit(";") %>% sapply("[", 1)


# saving the list for backup
write.csv(presslinks, file = "presslink.txt", row.names = FALSE)

# get filenames
filenames <- presslinks %>% strsplit("DE/") %>% sapply("[", 2) %>% 
  strsplit("/") %>% sapply("[", 2) %>% 
  strsplit("\\.") %>% sapply("[", 1)

# getting the text

# Testing for one text
# press <- read_html("http://www.bundesverfassungsgericht.de/SharedDocs/Pressemitteilungen/DE/2017/bvg17-046.html")
# presstext <- press %>% html_nodes("#wrapperContent") %>% html_text()
# cat(presstext, file="testing.txt", sep="", append=FALSE)

for (i in 1:length(presslinks)){
  press <- read_html(paste("http://www.bundesverfassungsgericht.de/", presslinks[i], sep = ""))
  Sys.sleep(sample(seq(1, 3, by=0.001), 1))
  press %>% html_nodes("#wrapperContent") %>% html_text() %>% 
    cat(file=paste(filenames[i], ".txt", sep = ""), sep="", append=FALSE)
  }
