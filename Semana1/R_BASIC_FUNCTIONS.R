############################################################
############################################################
#             BASIC R                                      #
#             2018/11/05                                   #
############################################################
############################################################

############################################################
#First step
#install or load libraries
#install.packages("ggplot2");install.packages("ggExtra")
require(ggplot2);
require(ggExtra);

#Second step
#Read file
#data_file <- read.csv()
#data("iris")

#Third step
#See the file
View(iris)
#See the summary of the data
summary(iris)
#First row and first column   [row,column]
iris[1,1]

#Third step
#Average
mean_pl <- mean(iris$Petal.Length,na.rm=T)
#Average per group
tapply(iris$Petal.Length,iris$Species,mean)

#Fourth step
#Standard deviation and coefficient of variation
sd_pl <- sd(iris$Petal.Length,na.rm=T)

#coefficient of variation
cv_pl <- (sd_pl/mean_pl)*100

#Fifth step
#Correlation
cor.test(iris$Petal.Length,iris$Petal.Width)
###############
#Hypothesis test
#Test normality
shapiro.test(rnorm(100, mean = 5, sd = 3)) # >0.05 indicates normal distribution
#hist(iris$Petal.Length[which(iris$Species=="versicolor")])

##T test
t.test(iris$Petal.Length[which(iris$Species=="setosa")],
       iris$Petal.Length[which(iris$Species=="versicolor")])
###ANOVA
aov_iris <- aov(Petal.Length ~ Species,data = iris)
summary(aov_iris)
plot(aov_iris)

############################################################
############################################################
#Plots

##Scatterplot
piris <- ggplot(iris, aes(Sepal.Length, Petal.Length, colour = Species)) +
  geom_point()
ggMarginal(piris, groupColour = TRUE, groupFill = TRUE)

##Barplot

barplot_test <- ggplot(iris, aes(x= Petal.Length, fill = Species)) +
  geom_bar()
barplot_test

##Boxplot

boxplot_test <- ggplot(iris, aes(x= Species,y= Petal.Length, fill = factor(Species))) +
  geom_boxplot(show.legend = F)
boxplot_test
############################################################
############################################################
