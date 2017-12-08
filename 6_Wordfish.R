library(quanteda)

data_dfm_irishbudget2010 <- dfm(data_corpus_irishbudget2010, 
                                remove_punct = TRUE, 
                                remove_numbers = TRUE, 
                                remove = stopwords("english"),
                                verbose = TRUE)

# Run wordfish
wfm <- textmodel_wordfish(data_dfm_irishbudget2010, dir = c(6, 5))

# Summarise it
summary(wfm)

# Plot it
textplot_scale1d(wfm)

# Plot estimated word positions
textplot_scale1d(wfm, margin = "features", 
                 highlighted = c("government", "global", "children", 
                                 "bank", "economy", "the", "citizenship",
                                 "productivity", "deficit"), 
                 highlighted_color = "red")

# Plot estimated document positions
textplot_scale1d(wfm, doclabels = NULL,
                 groups = docvars(data_corpus_irishbudget2010, "party"))

str(wfm)

############################## UK Example #######################################

text <- readtext("./data/UK/*.txt", docvarsfrom ="filenames", dvsep = "_", docvarnames = c("party", "year"))
corpus <- corpus(text)
docnames(corpus) <- text$doc_id
dfm <- dfm(corpus, remove = stopwords("english"), tolower = TRUE, stem = TRUE,
           remove_punct = TRUE, remove_numbers=TRUE)

# Run wordfish
wfm <- textmodel_wordfish(dfm, dir = c(6, 5))

# Summarise it
summary(wfm)

# Plot it
textplot_scale1d(wfm)

# Plot estimated word positions
textplot_scale1d(wfm, margin = "features", 
                 highlighted = c("government", "global", "children", 
                                 "bank", "economy", "the", "citizenship",
                                 "productivity", "deficit"), 
                 highlighted_color = "red")

# Plot estimated document positions
textplot_scale1d(wfm, doclabels = NULL,
                 groups = docvars(corpus, "party"))

