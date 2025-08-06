#creating two sequences
seqA <- "ATAATGATACCATATATA"
seqB <- "ATACTGATACCCCCCCCC"

# seqC <- "ATGATGATACC"
#splitting sequences in  letters
seqA <- strsplit(seqA, "")[[1]]
seqB <- strsplit(seqB, "")[[1]]

#starting counter
x <- 0

for(i in 1:length(seqA)){
  #counting differences
  if(seqA[[i]]!= seqB[[i]]){
  x <- x+1
  }
}

#getting possible changes and obtaining similarities
x <- 1-(x/length(seqA))
