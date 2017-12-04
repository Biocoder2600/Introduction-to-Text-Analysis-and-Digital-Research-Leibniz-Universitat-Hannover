# Twitter Scrapping
Justin Ho  
11/12/2017  

## Getting Twitter API Key
To access the Twitter APIs, you will need to register a twitter application. To register a twitter application and get your consumer keys:

1. Go to [Twitter's App Page](https://apps.twitter.com) in a web browser.
2. Click on 'create new app'.
3. Give your app a unique name, a description, any relevant web address, and agree to the terms and conditions. Set the callback URL to http://127.0.0.1:1410. You might have to add a cellphone number your twitter account.
4. Go to the keys and access section of the app page, and copy your consumer key and consumer secret to the code below.
5. (optional): For actions requiring write permissions, generate an access token and access secret.
(Drafted by Ken Benoit)

You will also need to install at least the following R packages:

```r
install.packages(c('twitteR', 'RCurl', 'ROAuth', 'httr'))
```


For security purpose, the keys is stored in another R file, don't upload this onto Github!

```r
require(twitteR)
```

```
## Loading required package: twitteR
```

```r
source("twitterkeys.R")
setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessSecret)
```

```
## [1] "Using direct authentication"
```


Try to search tweets about "#MeToo" and turn into dataframe

```r
results <- searchTwitter('#metoo', n=100)
twdf <- as.data.frame(t(sapply(results, as.data.frame)))
```


Have a quick preview

```r
head(twdf$text)
```

```
## [[1]]
## [1] "RT @ConnieSchultz: While they coo at each other, the #MeToo movement unfurls all round them. They and their kind are no match for the fury…"
## 
## [[2]]
## [1] "RT @HuffPost: #MeToo movement in running for Time's Person of the Year https://t.co/o9kh3BJ3HZ https://t.co/OsE4grFz1M"
## 
## [[3]]
## [1] "RT @Esther_Voet: Och och, @NPORadio1, de 1e keer dat inhoudelijk wordt gesproken over #TariqRamadan naar aanleiding van #metoo(beschuldigin…"
## 
## [[4]]
## [1] "RT @ConnieSchultz: While they coo at each other, the #MeToo movement unfurls all round them. They and their kind are no match for the fury…"
## 
## [[5]]
## [1] "RT @RobertKnijff: ‘Ik zeg nee en je duwt gewoon je tong in mijn mond, waarom?’\nFrancisco van Jole (@2525) #MeToo \nZolang de omerta van de ‘…"
## 
## [[6]]
## [1] "@mmpadellan For me it's a toss up between Kap and Mueller but some have made a good point about Mueller s time comi… https://t.co/zFZVR6nGk0"
```

