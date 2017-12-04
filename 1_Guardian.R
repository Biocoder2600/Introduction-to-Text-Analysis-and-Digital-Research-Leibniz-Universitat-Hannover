install.packages("GuardianR")

library(GuardianR)

articles <- get_guardian(keywords = "Germany",
                         section = "world",
                         from.date = "2017-11-01",
                         to.date = "2017-12-01",
                         api.key = "cd428c88-1153-4281-9806-4cc5e674fe6d")

str(articles)

articles$body <- iconv(articles$body, "", "ASCII", "byte")
articles$body <- gsub("<.*?>", "", articles$body)

library(quanteda)
corpus <- corpus(articles, text_field = "body")
dfm <- dfm(corpus, remove = stopwords("english"), remove_punct = TRUE)
topfeatures(dfm, 50)
textplot_wordcloud(dfm)
