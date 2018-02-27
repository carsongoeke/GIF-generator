
#//////////////////////////////////////////////////////////////////
# Importing Packages
#//////////////////////////////////////////////////////////////////
library(curl)
library(magick)
library(tm)

#//////////////////////////////////////////////////////////////////
# Most Common Words
#//////////////////////////////////////////////////////////////////
words <- read.csv("~/Desktop/r scripts/most.common.words.csv")
words$WORDS <- as.character(words$WORDS)
non.trivial <- removeWords(words$WORDS, stopwords("en"))
words <- words[words$WORDS %in% non.trivial,]

#//////////////////////////////////////////////////////////////////
# initializing variables
#//////////////////////////////////////////////////////////////////
api.key   <- "a3fe86f28e274fa0ab59b1c63d9d9b31"

word      <- "time"

tf.gif <- tf$placeholder(tf$float32, shape(NULL, 120, 200, 4))




#api.call  <- paste0("https://api.giphy.com/v1/gifs/translate?api_key=",
#                api.key,
#                "&s=",
#                word)
api.call  <- paste0("https://api.giphy.com/v1/gifs/search?api_key=",
                    api.key,
                    "&q=",
                    word,
                    "&limit=1000&offset=0&rating=R&lang=en")

# parse the api call
search.results <- as.character(
                  noquote(strsplit(readLines(curl(url = api.call)),
                          split = ",", fixed = TRUE)[[1]]))
links <- grep(".gif",search.results, value = TRUE)
links <- gsub("\\\\", "", links)
original.gif.string <- grep("original.*giphy\\.gif", links, value = TRUE)
original.url        <- substr(original.gif.string, 20, nchar(original.gif.string) - 1)

# download the image from the parsed link
gif <- image_read(original.url[1])
gif <- image_scale(gif, "200!x120!")

#gif <- image_noise(gif, noisetype = 'gaussian')
gif <- image_quantize(gif, max = 200, colorspace = 'gray')
# Store results in an array
gif.array <- array(0, dim = c( length(gif), dim(as.array(as.numeric(gif[[1]])))))
for (i in 1:length(gif)) {
  gif.array[i,,,] <- as.array( as.numeric( gif[[i]]))
  
}




#//////////////////////////////////////////////////////////////////
# Recover original gif from array
#//////////////////////////////////////////////////////////////////
for(i in 1:length(gif)) {
  if (i == 1) {
    new.gif <- image_convert(image_read(gif.array[i,,,]), 'gif')
  }
  else {
    new.gif <- c(new.gif, image_convert(image_read(gif.array[i,,,]), 'gif'))
  }
}
print(new.gif)
