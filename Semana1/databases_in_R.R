#################################################
#####  Database management in R ################
###############################################

#################################################
### install  and load necessary packages #######
###############################################

install.packages("dplyr")
install.packages("readr")
install.packages("readxl")
install.packages("tibble")
install.packages("tidyverse")
library(dplyr)
library(readr)
library(readxl)
library(tibble)
library(tidyverse)


### 1. Load a database using the readxl and readr libraries

#look at the help to see function params ?readxl::read_excel()
# read file oryza_glaberrima_database.xlsx 

oryza_tbl = readxl::read_excel() 

# EXERCICE

#1. print total number of rows and Columns

#2. Open the table in the R-studio Viewer

#3. Describe the content of the table


#############################################
########### Piping in R - %>% ##############
###########################################

## CALCULATE THE SUM OF THE SQUARED ROOT OF VECTOR ELEMENTS

#traditional way

vec <- c(-4, -9, -16)
vec_abs <- abs(vec) #absolute value of vec
vec_sqrt <- sqrt(vec_abs)
result <- sum(vec_sqrt)
print(paste0("The sum of the squared root of vector element is: ", result))


# With pipes

result_pip <- c(-4, -9, -16) %>% abs(x = .) %>% sqrt(x = .) %>% sum(x = .)
print(paste0("The sum of the squared root of vector element is: ", result_pip))


########################################3
#### data manipulation with dplyr #####3
########################################

###Function dplyr::mutate() adds/create new variables 

# traditional way
oryza_tbl$new_var1 <- 1:nrow(oryza_tbl) 
oryza_tbl$new_var2 <- oryza_tbl$new_var1*2


#with pipes and dplyr
oryza_tbl <- oryza_tbl %>%  dplyr::mutate(., new_var1 = 1:nrow(.),
                                          new_var2 = new_var1*2)

###Function dplyr::select() picks or remove variables based on their names.

# traditional way
oryza_tbl[, c("Latitude", "Longitude", "V2_Altitude")]

#with pipes and dplyr
oryza_tbl %>% dplyr::select(., Latitude, Longitude, V2_Altitude)

oryza_tbl %>% dplyr::select(., 1:2, V2_Altitude, -V2_temp_avg)

#select variables that starts with V1

# traditional way
tbl_names <- names(oryza_tbl)
sel_var <- grepl("V1", tbl_names)
oryza_tbl[, sel_var]

#with pipes and dplyr
oryza_tbl %>% dplyr::select(., dplyr::starts_with("V1"))



#return a dataframe with only character type columns

# traditional way
col_char <- c() #create an empty container
for(col in 1:ncol(oryza_tbl)){
  col_as_vector <- unlist(oryza_tbl[, col])
  col_char[col] <- is.character(col_as_vector)
}
oryza_tbl[, col_char]

#with pipes and dplyr
oryza_tbl %>% dplyr::select(., dplyr::where(is.character))

###Function dplyr::filter() select rows based on condition

# traditional way
oryza_tbl[oryza_tbl$V2_prec_avg >= 170,  ]

# with pipes and dplyr
oryza_tbl %>% dplyr::filter(., V2_prec_avg >= 170)

#note that dplyr::filter automatically removes NA rows

oryza_tbl %>% dplyr::filter(., V2_prec_avg >= 170 | is.na(V2_prec_avg))

### dplyr::summarise() and dplyr::group_by()

oryza_tbl %>% dplyr::summarise(., temp_avg = mean(V2_temp_avg, na.rm = T),
                               prec_avg = mean(V2_prec_avg, na.rm =T))

# compute mean in grouped data
oryza_tbl %>% 
  dplyr::group_by(V1_ecology) %>% 
  dplyr::summarise(., temp_avg = mean(V2_temp_avg, na.rm = T),
                   prec_avg = mean(V2_prec_avg, na.rm =T),
                   counts  = n())




# EXERCICE

# 1. convert the variable V2_temp_avg in kelvin degrees to celsius degree
# hint. use formula celcius_degree = kelvin_degree - 273.15

# 2. convert the character type variables to numeric 
#   (guess what is wrong with those variables)

# 3. filter rows that are not NA in the column DArTseq_kgroups 

# 4. calculate mean and standard deviation of V2_prec_avg grouping by DArTseq_kgroups variable



##################################################
#####               GRAPHS           ###########
#################################################


########################
### gggplot2 ##########
#######################

#scatterplot base-graphics
plot(x = oryza_tbl$V2_temp_avg, 
     y =  oryza_tbl$V2_prec_avg,
     xlab = "Average temperature",
     ylab = "Average Precipitation")

#scatterplot ggplot2

ggplot(data = oryza_tbl)+
  geom_point(aes(x = V2_temp_avg, y = V2_prec_avg))+
  xlab("Average temperature")+
  ylab("Average Precipitation")+
  theme_bw()


#Histogram base-graphics

hist(oryza_tbl$V2_temp_avg, freq = F, xlab = "Average temperature")
lines(density(na.omit(oryza_tbl$V2_temp_avg)), col = "red", lwd = 2)


#histogram ggplot2

ggplot(oryza_tbl, aes(x = V2_temp_avg))+
  geom_histogram(aes(y=..density..), colour="black", fill="white")+
  geom_density(alpha=.2, fill="#FF6666") +
  theme_bw()


###############################
##### MAPS with leaflet #######
###############################

install.packages("leaflet");library(leaflet)

markers <- oryza_tbl %>% 
  dplyr::filter(!is.na(Longitude) | !is.na(Latitude)) %>% 
  dplyr::select(DArTseq_kgroups, Longitude, Latitude) %>% 
  dplyr::sample_n(100)

leaflet(data = markers) %>% 
  addTiles() %>% 
  addMarkers(lng = ~Longitude,
             lat = ~Latitude,
             popup = ~paste0("Group:", DArTseq_kgroups))














