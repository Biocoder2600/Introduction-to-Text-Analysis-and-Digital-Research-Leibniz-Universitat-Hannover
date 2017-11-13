# Web Scrapping
Justin Ho  
11/12/2017  


```r
library('rvest')
```

```
## Loading required package: xml2
```

```r
library('magrittr')
```

## Downloading the Website
Specifying the url for desired website to be scrapped and reading the HTML code from the website

```r
url <- 'http://www.imdb.com/search/title?count=100&release_date=2017,2017&title_type=feature'
webpage <- read_html(url)
webpage
```

```
## {xml_document}
## <html xmlns:og="http://ogp.me/ns#" xmlns:fb="http://www.facebook.com/2008/fbml">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset= ...
## [2] <body id="styleguide-v2" class="fixed">\n<script>\n    if (typeof ue ...
```

## Extracting Data
### Rankings
Using CSS selectors to scrap the rankings section

```r
rank_data_html <- html_nodes(webpage,'.text-primary') # Using CSS selector to select Ranks
```

Get the text, then turn to numberic

```r
rank_data_html
```

```
## {xml_nodeset (100)}
##  [1] <span class="lister-item-index unbold text-primary">1.</span>
##  [2] <span class="lister-item-index unbold text-primary">2.</span>
##  [3] <span class="lister-item-index unbold text-primary">3.</span>
##  [4] <span class="lister-item-index unbold text-primary">4.</span>
##  [5] <span class="lister-item-index unbold text-primary">5.</span>
##  [6] <span class="lister-item-index unbold text-primary">6.</span>
##  [7] <span class="lister-item-index unbold text-primary">7.</span>
##  [8] <span class="lister-item-index unbold text-primary">8.</span>
##  [9] <span class="lister-item-index unbold text-primary">9.</span>
## [10] <span class="lister-item-index unbold text-primary">10.</span>
## [11] <span class="lister-item-index unbold text-primary">11.</span>
## [12] <span class="lister-item-index unbold text-primary">12.</span>
## [13] <span class="lister-item-index unbold text-primary">13.</span>
## [14] <span class="lister-item-index unbold text-primary">14.</span>
## [15] <span class="lister-item-index unbold text-primary">15.</span>
## [16] <span class="lister-item-index unbold text-primary">16.</span>
## [17] <span class="lister-item-index unbold text-primary">17.</span>
## [18] <span class="lister-item-index unbold text-primary">18.</span>
## [19] <span class="lister-item-index unbold text-primary">19.</span>
## [20] <span class="lister-item-index unbold text-primary">20.</span>
## ...
```

```r
rank_data <- html_text(rank_data_html) %>% as.numeric() 
head(rank_data)
```

```
## [1] 1 2 3 4 5 6
```

### Title
Same thing

```r
title_data_html <- html_nodes(webpage,'.lister-item-header a') # Using CSS selector to select Titles
title_data <- html_text(title_data_html) # Extracting the text
head(title_data)
```

```
## [1] "Thor: Ragnarok"               "Jigsaw"                      
## [3] "Justice League"               "It"                          
## [5] "Blade Runner 2049"            "Murder on the Orient Express"
```

### Description

```r
description_data_html <- html_nodes(webpage,'.ratings-bar+ .text-muted')
description_data <- html_text(description_data_html)
head(description_data)
```

```
## [1] "\nImprisoned, the almighty Thor finds himself in a lethal gladiatorial contest against the Hulk, his former ally. Thor must fight for survival and race against time to prevent the all-powerful Hela from destroying his home and the Asgardian civilization."
## [2] "\nBodies are turning up around the city, each having met a uniquely gruesome demise. As the investigation proceeds, evidence points to one suspect: John Kramer, the man known as Jigsaw, who has been dead for ten years."                                    
## [3] "\nA group of bullied kids band together when a shapeshifting monster, taking the appearance of a clown, begins hunting children."                                                                                                                              
## [4] "\nA young blade runner's discovery of a long-buried secret leads him to track down former blade runner Rick Deckard, who's been missing for thirty years."                                                                                                     
## [5] "\nA lavish train ride unfolds into a stylish & suspenseful mystery. From the novel by Agatha Christie, Murder on the Orient Express tells of thirteen stranded strangers & one man's race to solve the puzzle before the murderer strikes again."              
## [6] "\nWhen the network of satellites designed to control the global climate starts to attack Earth, it's a race against the clock to uncover the real threat before a worldwide Geostorm wipes out everything and everyone."
```

Data-Preprocessing: removing "\\\ n""

```r
description_data<-gsub("\n","",description_data)
head(description_data)
```

```
## [1] "Imprisoned, the almighty Thor finds himself in a lethal gladiatorial contest against the Hulk, his former ally. Thor must fight for survival and race against time to prevent the all-powerful Hela from destroying his home and the Asgardian civilization."
## [2] "Bodies are turning up around the city, each having met a uniquely gruesome demise. As the investigation proceeds, evidence points to one suspect: John Kramer, the man known as Jigsaw, who has been dead for ten years."                                    
## [3] "A group of bullied kids band together when a shapeshifting monster, taking the appearance of a clown, begins hunting children."                                                                                                                              
## [4] "A young blade runner's discovery of a long-buried secret leads him to track down former blade runner Rick Deckard, who's been missing for thirty years."                                                                                                     
## [5] "A lavish train ride unfolds into a stylish & suspenseful mystery. From the novel by Agatha Christie, Murder on the Orient Express tells of thirteen stranded strangers & one man's race to solve the puzzle before the murderer strikes again."              
## [6] "When the network of satellites designed to control the global climate starts to attack Earth, it's a race against the clock to uncover the real threat before a worldwide Geostorm wipes out everything and everyone."
```

### Movie runtime

```r
runtime_data_html <- html_nodes(webpage,'.text-muted .runtime')
runtime_data <- html_text(runtime_data_html)
head(runtime_data)
```

```
## [1] "130 min" "92 min"  "121 min" "135 min" "164 min" "114 min"
```

Data-Preprocessing: removing mins and converting it to numerical

```r
runtime_data<-gsub(" min","",runtime_data) # Removing mins 
runtime_data<-as.numeric(runtime_data)
head(runtime_data)
```

```
## [1] 130  92 121 135 164 114
```

### Genre

```r
genre_data_html <- html_nodes(webpage,'.genre')
genre_data <- html_text(genre_data_html)
genre_data<-gsub("\n","",genre_data)
genre_data<-gsub(" ","",genre_data)
genre_data<-gsub(",.*","",genre_data)
head(genre_data)
```

```
## [1] "Action"  "Crime"   "Action"  "Drama"   "Mystery" "Crime"
```

### Rating

```r
rating_data_html <- html_nodes(webpage,'.ratings-imdb-rating strong')
rating_data <- html_text(rating_data_html)
rating_data<-as.numeric(rating_data)
head(rating_data)
```

```
## [1] 8.2 6.1 7.7 8.4 6.8 5.7
```

### Metascore

```r
metascore_data_html <- html_nodes(webpage,'.metascore')
metascore_data <- html_text(metascore_data_html)
metascore_data<-gsub(" ","",metascore_data)
head(metascore_data)
```

```
## [1] "73" "39" "70" "81" "53" "21"
```

Let's check the length of metascore data

```r
length(metascore_data)
```

```
## [1] 83
```

There are missing data!

## Better approach
Instead of grabing each element one by one. Splitting the who webpage into chuncks.

```r
split_html <- html_nodes(webpage,'.lister-item-content') 
(split_html[1])
```

```
## {xml_nodeset (1)}
## [1] <div class="lister-item-content">\n<h3 class="lister-item-header">\n ...
```

For each chunck, use if...else statement to extract the data and put NA if no data can be extracted.

```r
metascore_data_test <- c()
for (i in 1:length(split_html)){ # Looping over all the chuncks one by one
  if (length(html_nodes(split_html[i],'.metascore')) == 0){ # If the length of the extracted data equals to zero, put NA
    metascore_data_item <- NA
  } else {
    metascore_data_item <- html_nodes(split_html[i],'.metascore') %>% html_text() # Extract the data if the length is not zero
  }
  metascore_data_test <- c(metascore_data_test, metascore_data_item) # concatenate the data into a list
}
metascore_data_test<-gsub(" ","",metascore_data_test) # erase the white space
length(metascore_data_test)
```

```
## [1] 100
```

## Even better approach
If you have to repeat the codes, write a function!


```r
node_or_na <- function( x , node ){
  final_list <- c()
  for (i in 1:length(x)){
    if (length(html_nodes(x[i],node)) == 0){
      list_item <- NA
    } else {
      list_item <- html_nodes(x[i],node) %>% html_text()
    }
    final_list <- c(final_list, list_item)
  }
  return(final_list)
}
```

Use the function to extract

```r
metascore_data <- node_or_na(split_html,'.metascore')
metascore_data <- gsub(" ","",metascore_data_test)
metascore_data
```

```
##   [1] "73" "39" NA   "70" "81" "53" NA   "21" "57" "42" "44" "63" "42" "70"
##  [15] NA   "73" NA   "48" "23" "86" "34" "76" "82" "65" "77" "81" "73" "55"
##  [29] "73" "73" "77" "68" "48" "74" "94" "73" "94" "56" NA   "29" NA   "62"
##  [43] "80" "28" "51" "67" "59" "95" "39" "76" "12" "40" "87" "84" "44" "79"
##  [57] "70" "34" NA   "65" "79" "17" "37" NA   "86" NA   "65" NA   NA   "45"
##  [71] "75" "27" NA   "71" "77" "68" NA   "86" "65" "74" "74" "62" NA   NA  
##  [85] NA   "47" "47" "72" "71" "77" "33" "72" "88" NA   "49" "92" "78" "55"
##  [99] "57" "54"
```

```r
length(metascore_data)
```

```
## [1] 100
```

## Creating a data frame

```r
df <- cbind(rank_data, title_data, description_data, genre_data, rating_data, runtime_data, metascore_data) %>% 
  as.data.frame()
head(df)
```

```
##   rank_data                   title_data
## 1         1               Thor: Ragnarok
## 2         2                       Jigsaw
## 3         3               Justice League
## 4         4                           It
## 5         5            Blade Runner 2049
## 6         6 Murder on the Orient Express
##                                                                                                                                                                                                                                               description_data
## 1 Imprisoned, the almighty Thor finds himself in a lethal gladiatorial contest against the Hulk, his former ally. Thor must fight for survival and race against time to prevent the all-powerful Hela from destroying his home and the Asgardian civilization.
## 2                                     Bodies are turning up around the city, each having met a uniquely gruesome demise. As the investigation proceeds, evidence points to one suspect: John Kramer, the man known as Jigsaw, who has been dead for ten years.
## 3                                                                                                                               A group of bullied kids band together when a shapeshifting monster, taking the appearance of a clown, begins hunting children.
## 4                                                                                                      A young blade runner's discovery of a long-buried secret leads him to track down former blade runner Rick Deckard, who's been missing for thirty years.
## 5               A lavish train ride unfolds into a stylish & suspenseful mystery. From the novel by Agatha Christie, Murder on the Orient Express tells of thirteen stranded strangers & one man's race to solve the puzzle before the murderer strikes again.
## 6                                        When the network of satellites designed to control the global climate starts to attack Earth, it's a race against the clock to uncover the real threat before a worldwide Geostorm wipes out everything and everyone.
##   genre_data rating_data runtime_data metascore_data
## 1     Action         8.2          130             73
## 2      Crime         6.1           92             39
## 3     Action         7.7          121           <NA>
## 4      Drama         8.4          135             70
## 5    Mystery         6.8          164             81
## 6      Crime         5.7          114             53
```

