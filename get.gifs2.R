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

# initialize gif of 1 million gifs
gif.list <- vector(mode = "list", length = 1000000)
k <- 0 # list index

for (i in 1:length(words)) {
  
  k <<- k + 1
  
  api.key   <- "a3fe86f28e274fa0ab59b1c63d9d9b31"
  
  word      <- words[i]
  
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
  gif.strings <- grep("original.*giphy\\.gif", links, value = TRUE)
  gif.urls        <- substr(gif.strings, 20, nchar(gif.strings) - 1)
  
  for (j in 1:length(gif.urls)) {
  
    if (j!=1) {
      k <- k+1
    }
    else{
    }
    
    # download the image from the parsed link
    gif <- image_read(gif.urls[j])
    
    # standardize the gif
    gif <- image_scale(gif, "200!x120!")
    gif <- image_quantize(gif, max = 256)
    gif <- image_convert(gif, colorspace = 'gray')
    
    # Store results in an array
    gif.array <- array(0, dim = c( length(gif), dim(as.array(as.numeric(gif[[1]])))))
    for (r in 1:length(gif)) {
      gif.array[r, , , ] <- as.array(as.numeric(gif[[r]]))
      
    }
    # store array in list
    gif.list[k] <- gif.array
  }
}


#//////////////////////////////////////////////////////////////////
# Recover original gif from array
#//////////////////////////////////////////////////////////////////
for(i in 1:length(gif)) {
  if (i == 1) {
    frame <- array(0, dim = c(120,200,1))
    frame[1:120, 1:200,1] <- gif.array[1,1:120,1:200,]
    image_frame <- image_read(gif.array[1,1:120,1:200,])
    new.gif <- image_convert(image_frame, 'gif')
  }
  else {
    frame[1:120, 1:200,1] <- gif.array[i,1:120,1:200,]
    image_frame <- image_read(frame)
    new.gif <- c(new.gif, image_convert(image_frame, 'gif'))
  }
}
print(new.gif)

