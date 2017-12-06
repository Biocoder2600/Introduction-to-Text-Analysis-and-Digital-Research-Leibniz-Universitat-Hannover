# install.packages("stringr")
# install.packages("topicmodels")
# install.packages("tidytext")
# install.packages("tidyr")
# install.packages("ggplot2")
# install.packages("dplyr")

#######################################################
#   House Keeping                                     #
#######################################################

library(quanteda)
library(readtext)
library(stringr)
library(topicmodels)

custom_stopwords <- c("facebook", "video", "photo", "added", "new", "photos", "album", "shared", "live", "don", "t", "don_t", "s", "http","Scottish National Party", "national_party", "scotland","snp", "scottish", "national", "party", "mhairi", "black", "john", "swinney", "nicola", "sturgeon", "alex", "salmond", "mp", "mps",
                      "UK Independence Party", "ukip", "independence","mep", "nigel", "farage", "douglas", "carswell", "angus", "robertson", "paul", "nuttall", "mep", "carswell", "mike", "hookem", "peter", "whittle", "james", "carver", "diane", "suzanne", "evans", "louise", "bours", "jane", "collins", "seymour", "jill",
                      "said","post", "will", "can", "must", "make", "get", "read", "find", "says", "may", "prime", "first", "minister", "uk", "mayoral", "deputy", "leader", "ll", "ve", "re", "humza", "yousaf", "spokesman", "even", "go", "back", "take", "latest", "want", "say", "join", "debate", "us", "next", "years", "figures", "plans", "number",
                      "results", "week", "including", "like", "thanks", "miss", "hs2", "give", "days", "agree", "support", "conference", "watch", "now", "speech", "know", "need", "going", "try", 
                      "set", "holyrood", "launched", "continue", "see", "link", "candidate", "candidates", "news", "day", "year", "plan", "around", "last", "just", "good", "best", "tonight", "statement",
                      "bbc", "already", "secretary", "cabinet", "views", "think", "let", "better", "one", "time", "parliament", "government", "governments", "help", "ever", "yesterday", "sure", "word", "spread", "this", "to", "seem",
                      "way", "announced", "highlights", "morning", "msp", "makes", "many", "mr", "q", "still", "also", "never", "part", "members", "survey", "quite",
                      "continues", "put", "close", "months", "getting", "using", "come", "came", "lords", "lord", "believe", "things", "result", "meps", "head", "writes", "means", "mean","keep", "shows", "place", "made","making", "change", "proper",
                      "joined", "every", "show", "kind", "real", "great", "since", "news.scotland.gov.uk", "www.snp.org", "www.ref.scot")

# Creating snp corpus
snp <-  corpus(readtext(file.path("data","SNP_corpus.csv"), text_field = "post_message"))
snpdfm <- dfm(snp, stem = FALSE, remove_punct = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove = stopwords("english"), verbose = TRUE)
docvars(snp, "Party") <- "SNP"
docvars(snp, "doc_id") <- str_replace_all(docvars(snp, "doc_id"), "\\.csv\\.", "_")
docnames(snp) <- paste(docvars(snp, "doc_id"), lubridate::as_date(docvars(snp, "post_published")), docvars(snp, "likes_count_fb"), sep = "_")# adding doc names

# Creating ukip corpus
ukip <-  corpus(readtext(file.path("data","UKIP_corpus.csv"), text_field = "post_message"))
ukipdfm <- dfm(snp, stem = FALSE, remove_punct = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove = c(stopwords('english'), custom_stopwords), verbose = TRUE)
docvars(ukip, "Party") <- "UKIP"
docvars(ukip, "doc_id") <- str_replace_all(docvars(ukip, "doc_id"), "\\.csv\\.", "_")
docnames(ukip) <- paste(docvars(ukip, "doc_id"), lubridate::as_date(docvars(ukip, "post_published")), docvars(ukip, "likes_count_fb"), sep = "_")# adding doc names

# Combine them all
combined <- corpus(c(snp, ukip))
docvar <- docvars(combined)
combineddfm <- dfm(combined, stem = FALSE, remove_punct = TRUE, remove_numbers = TRUE, remove_url = TRUE, remove = c(stopwords('english'), custom_stopwords), verbose = TRUE)
topfeatures(combineddfm)


#######################################################
#   Exercise Begins here                              #
#######################################################


# Transforming the data into the format for topicmodels


# Fit the model


# See the terms


# Visualisation of topics with ggplot2


# Adding the data into the meta-data matrix


# Visualising the meta-data with ggplot2

