#ranas
vec_exercise <- c("a","b","c","d","e","f","g","h","i","j")
vec_exercise[c(3,7,9)]
vec_exercise[c(1,2,3,4,5)]
vec_exercise[c(1:5)]
a <- vec_exercise [-c(1:5)]
b <- vec_exercise [c(1:5)]


data <- data.frame(species = c("A","A","A","B","B","B"),
                   dist=c("Quindio","Quindio","Quindio",
                          "valle","valle","valle"),
                   long = c(11.3,15.6,9,2,3,5),
                   temp=c(22,26,21,30,32,33))

?boxplot()
boxplot(long ~ species, data = data, col = "lightgray")

par(mfrow = c(1,2))
boxplot(long ~ species, data = data, col = "lightgray")
boxplot(temp ~ species, data = data, col = "lightgray")
