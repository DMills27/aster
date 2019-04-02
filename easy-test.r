library(aster)
#loads the echinacea dataset
data(echinacea)  
# creates a vector of strings corresponding to some column headings from the echinacea dataset
vars <- c("ld02", "ld03", "ld04", "fl02", "fl03", "fl04",
          "hdct02", "hdct03", "hdct04")
# done to make the "response" a vector
redata <- reshape(echinacea, varying = list(vars), direction = "long",
                  timevar = "varb", times = as.factor(vars), v.names = "resp")
#affixes a new variable called root to the data frame and sets all of its values to one
redata <- data.frame(redata, root = 1) 
#describes the predecessor structure of the graph
pred <- c(0, 1, 2, 1, 2, 3, 4, 5, 6)
#defines the one-parameter exponential families associated with the nodes. Here, 1 stands for Bernoulli and 3 for zero-truncated Poisson
fam <- c(1, 1, 1, 1, 1, 1, 3, 3, 3) 
hdct <- grepl("hdct", as.character(redata$varb))
redata <- data.frame(redata, hdct = as.integer(hdct))
level <- gsub("[0-9]", "", as.character(redata$varb))
redata <- data.frame(redata, level = as.factor(level))
aout <- aster(resp ~ varb + level : (nsloc + ewloc) + hdct : pop,
              pred, fam, varb, id, root, data = redata)
summary(aout, show.graph = TRUE)
