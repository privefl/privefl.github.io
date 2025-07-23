# remotes::install_github("ropensci-archive/rplos")
# remotes::install_github("ropensci-archive/microdemic")
# remotes::install_github("ropensci-archive/fulltext")
DOIs <- c("10.1101/2022.10.10.511629", "10.1093/bioinformatics/btac348",
          "10.1101/2021.03.29.437510", "10.1093/bioinformatics/btab519",
          "10.1101/2020.10.30.362079", "10.1101/2020.10.06.328203",
          "10.1093/bioinformatics/btaa1029", "10.1093/molbev/msaa053",
          "10.1093/bioinformatics/btaa520", "10.1101/653204",
          "10.1534/genetics.119.302019", "10.1093/bioinformatics/bty185")
abstracts <- fulltext::ft_abstract(DOIs, from = "crossref")$crossref

abstracts2 <- unname(sapply(abstracts, function(x) 
  gsub("(<.*?>)", "", x$abstract) %>% 
    sub("abstract", "", ., ignore.case = TRUE) %>% 
    sub("motivation", "", ., ignore.case = TRUE) %>% 
    sub("results", "", ., ignore.case = TRUE) %>% 
    sub("conclusion", "", ., ignore.case = TRUE) %>% 
    sub("supplementary", "", ., ignore.case = TRUE) %>% 
    sub("information", "", ., ignore.case = TRUE)))

words <- tolower(unlist(strsplit(abstracts2, " |\n|\\.|,")))
to_remove <- c("", "two", "using", "find", "different", "available")

# to_remove <- ""
clean_words <- words[!grepl("http|@|#|ü|ä|ö|\"|\\(", words) & !words %in% to_remove]

corpus <- tm::tm_map(tm::Corpus(tm::VectorSource(clean_words)), function(x) 
  tm::removeWords(x, tm::stopwords()))
tdm <- tm::TermDocumentMatrix(corpus)
freq <- slam::row_sums(tdm)

png("twitter-banner.png", width = 1500, height = 500, units = "px")
wordcloud::wordcloud(clean_words, max.words = 20, scale = c(5, 0.1),
                     rot.per = 0.1, use.r.layout = FALSE, )
dev.off()

(word_freq <- dplyr::arrange(tibble::enframe(freq), -value))
widget <- wordcloud2::wordcloud2(word_freq, widgetsize = c(1500, 480))

tmp <- tempfile(fileext = ".html")
png <- sub("\\.html$", ".png", tmp)
htmlwidgets::saveWidget(widget, tmp, selfcontained = FALSE)
webshot::webshot(
  tmp,
  png,
  delay = 5,
  vwidth = 1800,
  vheight = 510
)

library(magick)
crop <- function(im, left = 0, top = 0, right = 0, bottom = 0) {
  d <- dim(im[[1]]); w <- d[2]; h <- d[3]
  image_crop(im, glue::glue("{w-left-right}x{h-top-bottom}+{left}+{top}"))
}
image_read(png) %>%
  crop(right = 300, bottom = 10) %>% 
  image_write("twitter-banner.png")


image_read("twitter-banner.png")

