install.packages("devtools")
devtools::install_github("tollpatsch/rzeit")
library(rzeit)

results <- zeitGet(api = "0f3757681af8cf01cc1468b4abbaa594f52c2c242a42ebbb0a95", 
                   "Horst Seehofer", 
                   limit = 1000,
                   dateBegin = "2017-01-01", 
                   dateEnd = "2017-12-31", 
                   c("title","teaser_text", "release_date"))

results2 <- zeitGet(api = "0f3757681af8cf01cc1468b4abbaa594f52c2c242a42ebbb0a95", 
                   "Angela Merkel",
                   limit = 1000,
                   dateBegin = "2017-01-01", 
                   dateEnd = "2017-12-31", 
                   c("title","teaser_text"))
library(quanteda)
corpus1 <- corpus(results$matches, text_field = "teaser_text")
dfm1tokens <- tokens(corpus1)
dfm1 <- dfm(dfm1tokens, remove = stopwords("german"), remove_punct = TRUE)
topfeatures(dfm1, 50)
# textplot_wordcloud(dfm1)

docvars(corpus1)

corpus2 <- corpus(results2$matches, text_field = "teaser_text")
dfm2 <- dfm(corpus2, remove = stopwords("german"), remove_punct = TRUE)
topfeatures(dfm2, 50)
# textplot_wordcloud(dfm2)
results$matches

# Collect two corpus (Can be different political parties, football players, anything etc.).
# Do a keyness analysis and compare the corpus
# Share the result in slack

kwds <- textstat_keyness(rbind(dfm1, dfm2), target = seq_along(dfm1tokens))
head(kwds, 20)
tail(kwds, 20)
textplot_keyness(kwds)

library(dplyr)

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



# Transforming the data into the format for topicmodels
trimdfm <- dfm_trim(dfm2, max_docfreq = .1, max_count = 20)
trimdfm
topfeatures(trimdfm)
trimdfm <- convert(trimdfm, to = "topicmodels")

# Fit the model (Warning: IT MAY TAKE LONG)
start.time <- Sys.time()
results_lda <- LDA(trimdfm, 10, method="VEM")  
end.time <- Sys.time()
print(end.time - start.time)

# See the terms
get_terms(results_lda, k=20)

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





