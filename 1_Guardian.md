# Guardian
Justin Ho  
12/4/2017  

Install the package

```r
install.packages("GuardianR")
```


Load the package

```r
library(GuardianR)
```


Simply use the get_guardian function.

```r
articles <- get_guardian(keywords = "Germany",
                         section = "world",
                         from.date = "2017-11-01",
                         to.date = "2017-12-01",
                         api.key = "cd428c88-1153-4281-9806-4cc5e674fe6d")
```

```
## [1] "Fetched page #1 of 1"
```


See what's inside

```r
str(articles)
```

```
## 'data.frame':	37 obs. of  27 variables:
##  $ id                  : Factor w/ 37 levels "world/2017/nov/21/whats-your-reaction-to-the-political-situation-in-germany",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ sectionId           : Factor w/ 1 level "world": 1 1 1 1 1 1 1 1 1 1 ...
##  $ sectionName         : Factor w/ 1 level "World news": 1 1 1 1 1 1 1 1 1 1 ...
##  $ webPublicationDate  : Factor w/ 37 levels "2017-11-21T11:22:01Z",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ webTitle            : Factor w/ 37 levels "What's your reaction to the political situation in Germany?",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ webUrl              : Factor w/ 37 levels "https://www.theguardian.com/world/2017/nov/21/whats-your-reaction-to-the-political-situation-in-germany",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ apiUrl              : Factor w/ 37 levels "https://content.guardianapis.com/world/2017/nov/21/whats-your-reaction-to-the-political-situation-in-germany",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ newspaperPageNumber : chr  NA "24" "30" NA ...
##  $ trailText           : Factor w/ 37 levels "Angela Merkel has failed to create a coalition government. Weâ\u0080\u0099d like you to share your thoughts and"| __truncated__,..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ headline            : Factor w/ 37 levels "What's your reaction to the political situation in Germany?",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ showInRelatedContent: Factor w/ 1 level "true": 1 1 1 1 1 1 1 1 1 1 ...
##  $ lastModified        : Factor w/ 37 levels "2017-11-21T11:24:05Z",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ hasStoryPackage     : logi  NA NA NA NA NA NA ...
##  $ score               : logi  NA NA NA NA NA NA ...
##  $ standfirst          : Factor w/ 37 levels "<p>Angela Merkel has failed to create a coalition government. Weâ\u0080\u0099d like you to share your thoughts "| __truncated__,..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ shortUrl            : Factor w/ 37 levels "https://gu.com/p/7tzpe",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ wordcount           : Factor w/ 36 levels "161","331","946",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ commentable         : chr  NA NA NA NA ...
##  $ allowUgc            : logi  NA NA NA NA NA NA ...
##  $ isPremoderated      : Factor w/ 1 level "false": 1 1 1 1 1 1 1 1 1 1 ...
##  $ byline              : Factor w/ 24 levels "Carmen Fishwick and Guardian readers",..: 1 2 3 1 2 4 5 6 7 8 ...
##  $ publication         : Factor w/ 3 levels "theguardian.com",..: 1 2 2 1 2 3 2 3 2 1 ...
##  $ newspaperEditionDate: chr  NA "2017-12-02T00:00:00Z" "2017-11-22T00:00:00Z" NA ...
##  $ shouldHideAdverts   : Factor w/ 1 level "false": 1 1 1 1 1 1 1 1 1 1 ...
##  $ liveBloggingNow     : logi  NA NA NA NA NA NA ...
##  $ commentCloseDate    : chr  NA NA NA NA ...
##  $ body                : Factor w/ 37 levels "<p><a href=\"https://www.theguardian.com/world/2017/nov/19/german-coalition-talks-close-to-collapse-angela-merk"| __truncated__,..: 1 2 3 4 5 6 7 8 9 10 ...
```


Clear the html tags

```r
articles$body <- iconv(articles$body, "", "ASCII", "byte")
articles$body <- gsub("<.*?>", "", articles$body)
```


Quick analysis with quanteda

```r
library(quanteda)
```

```
## quanteda version 0.99.12
```

```
## Using 3 of 4 threads for parallel computing
```

```
## 
## Attaching package: 'quanteda'
```

```
## The following object is masked from 'package:utils':
## 
##     View
```

```r
corpus <- corpus(articles, text_field = "body")
dfm <- dfm(corpus, remove = stopwords("english"), remove_punct = TRUE)
topfeatures(dfm, 50)
```

```
##       said government      party  coalition        new         us 
##        177        105        103         86         78         78 
##        one     german     merkel      talks    germany     people 
##         73         71         70         69         69         58 
##        two    parties      years  elections        can      first 
##         56         56         50         49         48         47 
##  political       also      story        fdp    embassy  president 
##         45         45         45         44         44         41 
##        now       like     leader       last       time    merkels 
##         41         39         39         39         39         37 
##       says   guardian   germanys    another       even      world 
##         37         37         36         36         36         36 
##    country       fake     europe  christian        spd         uk 
##         35         35         34         33         33         33 
##        cdu       next        get       visa photograph chancellor 
##         31         31         31         31         30         29 
##     social     called 
##         29         29
```

```r
textplot_wordcloud(dfm)
```

![](1_Guardian_files/figure-html/unnamed-chunk-6-1.png)<!-- -->
