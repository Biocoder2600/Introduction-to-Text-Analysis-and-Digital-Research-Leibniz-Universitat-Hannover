library(quanteda)
library(readtext)

ie_dfm <- dfm(data_corpus_irishbudget2010, verbose=TRUE)

# Put the score for the reference text (e.g. first and fourth)
# Put NA for virgin text
refscores <- c(1, NA, NA, -1, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA) 
wsm <- textmodel_wordscores(ie_dfm, y = refscores, smooth = 1)
summary(wsm)

wsp <- predict(wsm, rescaling = "mv")
summary(wsp)

textplot_scale1d(wsp)

textplot_scale1d(wsp, groups = docvars(data_corpus_irishbudget2010, "party"))
str(wsp)

docvar <- docvars(ie_dfm)
score <- wsp@textscores
docvar <- cbind(docvar, score)

library(ggplot2)
ggplot(docvar, aes(party, textscore_mv)) +
  geom_point()

############################## UK Example #######################################

text <- readtext("./data/UK/*.txt", docvarsfrom ="filenames", dvsep = "_", docvarnames = c("party", "year"))
corpus <- corpus(text)
docnames(corpus) <- text$doc_id
dfm <- dfm(corpus, remove = stopwords("english"), tolower = TRUE, stem = TRUE,
           remove_punct = TRUE, remove_numbers=TRUE)
# Reference texts: 1992 parties manifestos
# Reference texts scores: 1992 parties manifestos. Lab: 2; LibDem: 5; Cons: 10
# Set reference scores 
refscores <- c(10, NA, 2, NA, 5, NA)
refscores 

ws <- textmodel_wordscores(dfm, refscores)
summary(ws) 

pr <- predict(ws)
summary(pr)

pr <- predict(ws, rescaling = "lbg")
summary(pr)

textplot_scale1d(pr)

textplot_scale1d(pr, doclabels = NULL,
                 groups = docvars(corpus, "party"))
