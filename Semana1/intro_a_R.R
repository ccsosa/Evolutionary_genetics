############################################
######    Script Introduction to R    ######
############################################

###########################################################
#### Definition of Variables/Objects
###########################################################

variable_1 <- "hello world" # variable of type character/text
variable_1 ## displays the result of the variable in the console

is(variable_1) # shows the type of the variable
class(variable_1) # shows the type of the variable

variable_2 <- 123455 # variable of type integer
variable_2 ## displays the result of the variable in the console
is(variable_2)
class(variable_2)

variable_3 <- 1.23445 # variable of type float/decimal
variable_3 ## displays the result of the variable in the console
is(variable_3)
class(variable_3)

variable_4 <- FALSE # variable of type bool/logical
variable_4
is(variable_4)
class(variable_4)

###########################################################
### Objects/Variables/Vectors
###########################################################

vector_1 <- c("element_1", "element_2", "element_3")
vector_1

is(vector_1) # prints the class of the variable
length(vector_1) # returns the number of elements in the variable/vector

vector_2 <- c(1.2, 1.56, 3.54, 6.78)
vector_2

vector_4 <- c(TRUE, FALSE, TRUE, TRUE, TRUE)
vector_4
is(vector_4) # prints the class of the variable
length(vector_4) # returns the number of elements in the variable/vector

vector_5 <- factor(c("F", "M", "F", "F", "F", "M", "M"), labels = c("Female", "Male")) 
vector_5
is(vector_5) # the class indicates it is of type factor



matrix_1 <- matrix( c(1.2, 1.56, 3.54, 6.78, 6.8, 0.98), nrow = 2, ncol = 3)
is(matrix_1)
dim(matrix_1)
nrow(matrix_1)
ncol(matrix_1)

matrix_2 <- matrix(c(1.2, "texto", 3.54, 6.78, 6.8, 0.98), nrow = 2, ncol = 3)
matriz_2

###########################################################
###### Accessing Elements of Vectors and Matrices (INDEXING)
###########################################################

vector_1 <- c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)

vector_1[1] # extracts the first element
vector_1[2:7] # extracts elements starting from 2 until 7 position

1:10 # the ":" generates a sequence of numbers -> start:end
10:1 # reverse squence

vector_1[c(1, 3)] # extracts elements 1 and 3

vector_1[-1] # returns all elements of the vector except the one at position 1
vector_1[-c(1, 3)] # returns all elements of the vector except those at positions 1 and 3

vector_1[10]
length(vector_1)

matriz_1
matriz_1[1, 1] # extracts the element at row 1 and column 1
matriz_1[2, 3] # extracts the element at row 2 and column 3
matriz_1[1, ] # extracts the entire row 1
matriz_1[, 2] # extracts the entire column 2
matriz_1[10, 11] # returns an error when the indices are outside the matrix's dimensions

# EXERCICE 1





###########################################################
#### Comparaciones logicas entre vectores 
###########################################################

vector_logico <- c(TRUE, FALSE, TRUE, FALSE, TRUE)

vector_1 == vector_2 #comparamos si los elementos dentro de ambos vectores son iguales

vector_1 != vector_2 #comparamos si los elementos dentro de ambos vectores son diferentes

vector_1 >= vector_2 #comparamos si los elementos dentro del vector_1 son mayores iguales a los del vector_2

vector_1 <= vector_2 #comparamos si los elementos dentro del vector_1 son menores iguales a los del vector_2

vector_1 >= 2 # comparamos si los elementos del vector_1  son mayores iguales a 2

vector_1[vector_1 >= 2] # extraer los valores que cumplan cierta condicion (FILTRO)

which(vector_1 >= 2)

vector_1[which(vector_1 >= 2)]

###########################################################
#### Data Frames
###########################################################

df_1 <- data.frame(name = c("andres", "roberto", "maria", "daniel"),
                   surname = c("mendez", "lopez", "gomez", "castro"),
                   age = c(24, 32, 28, 38),
                   weigth = c(78.5, 83.2, NA, 89.1),
                   marital_status = factor(c("single", "single", "married", "married"))) # this is how a data frame is defined
df_1
View(df_1) # opens the built-in data viewer in R Studio

is(df_1)
class(df_1)
dim(df_1) # This function returns the number of rows and columns in the data frame
str(df_1) # This function returns the types of each column in the data frame
names(df_1) # extracts the column names into a vector
nrow(df_1) # extracts the number of rows
ncol(df_1) # extracts the number of columns

names(df_1) <- c("variable_1", "variable_2", "variable_3", "variable_4", "variable_5") # renames the columns of df_1
View(df_1)


names(df_1) <- c("name", "surname", "age", "weigth", "marital_status") # renames the columns of df_1

### Accessing elements of a data frame

df_1$weigth # extracts the "weigth" column as a vector

df_1[, 1] # extracts the first column as a vector
df_1[, c(1, 3)] # extracts columns 1 and 3 as a data frame
df_1[, 1:3] # extracts columns 1 through 3 as a data frame
df_1[, -c(1, 3)] # extracts all columns except 1 and 3

df_1[, c("name", "weigth")] # columns can be selected based on their names

df_1[3, ] # extracts the third row
df_1[-c(1, 3), ] # extracts all rows except 1 and 3 as a data frame
df_1[1:3, ] # extracts rows 1 through 3


##################################################
#####                filters          ###########
#################################################

df_1$age > 30 # Will return a TRUE value when a match is found
df_1[df_1$age > 30, ] # Filters the rows of the dataframe based on the age column when it is greater than 30

df_1[df_1$age >= 30 & df_1$weigth >= 70, ]# Filters by more than one logical condition


# EXERCICE

#1. Create a new variable/column in the data.frame df_1 named height


#2. Filter individuals that are married



##################################################
#####                Functions        ###########
#################################################

my_function <-  function(entrada_1, entrada_2, entrada_3){
  sum <- entrada_1 + entrada_2 + entrada_3
  return(sum)
} #my_function

my_function(entrada = 5, entrada_2 = 6, entrada_3 = 8) #my_function retorna la suma de los valores que ingresamos

my_function(entrada = c(1,2,3), entrada_2 = c(4,5,6), entrada_3 = c(7,8,9))#los valores de entrada pueden ser vectores



##################################################
#####       import libraries         ###########
#################################################

#download and import libraries

install.packages("readr")
install.packages("readxl")
install.packages("foreign")
library(readr)
library(readxl)
library(foreign)


# EXERCICE

# 1. install and load the 'terra' package

