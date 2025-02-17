# Birds p m-sqr ⊥ Water consumption | Feed mix, Outdoor temperature
# Birds p m-sqr ⊥ Water consumption | Feed mix, Month
# Birds p m-sqr ⊥ Water consumption | Prod type

library(dagitty)
library(tidyverse)
library(caret)
library(ipred)
library(dplyr)
library(forcats)
library(stringr)
library(randomForest)
library(xgboost)
library(boot)
rm(list = ls())

setwd("C:/Users/christian.thorjussen/Project Nortura/")
# source("C:/broiler_acites/ascites_case/step 1 merging dataframe.R")
# source("C:/broiler_acites/ascites_case/step 3 data cleaning.R")
# source("C:/broiler_acites/ascites_case/step 4a modeling growth curves.R")
# source("C:/broiler_acites/ascites_case/step 4c data management.R")

load("wide_data_for_analysis.Rda")
wide_data$feed_name <- str_replace(wide_data$feed_name, "o?=", "aa")
wide_data$prod_type = as.factor(wide_data$prod_type)
wide_data <- subset(wide_data, hybrid == "Ross 308")


###############################################################
# Birds p m-sqr ⊥ Water consumption | Prod type
###############################################################

#################
#BOOCOIN testing# 
#################

###################
# Tuning f(x,z) #
##################
data <- subset(wide_data, select = c('birds_m_sqr', 'average_water', 'prod_type'))
data <- na.omit(data)
type <- data.frame(type = data$prod_type)

#Create dummy variables for feed variable
dummy_vars <- model.matrix(~ factor(type), type)

# Remove the intercept column
dummy_vars <- dummy_vars[, -1]

# Bind the dummy variables to the original data frame
data <- cbind(data, dummy_vars)
data <- subset(data, select = -prod_type)
colnames(data) <- c('birds_m_sqr', 'average_food', 
                    'ptype1', 'ptype2', 'ptype3')

label <- data$birds_m_sqr
training <- as.matrix(data[, !(names(data) %in% c("birds_m_sqr"))])



params <- list(
  objective = "reg:squarederror", 
  nrounds = 20,
  eta = c(0.1,0.2,0.3),                      
  max_depth = 6
)

# Perform k-fold cross-validation
cv_result <- xgb.cv(
  params = params,
  data = xgb.DMatrix(data = training, label = label),
  nfold = 5,                     # Number of folds
  nrounds = 100,                 # Number of boosting rounds
  verbose = TRUE
)
cv <- data.frame(Boosting_Round =  cv_result$evaluation_log$iter, 
                 Train_Error = cv_result$evaluation_log$train_rmse_mean, 
                 Test_Error = cv_result$evaluation_log$test_rmse_mean)

train_error <- cv_result$evaluation_log$train_rmse_mean
test_error <- cv_result$evaluation_log$test_rmse_mean


ggplot(cv, aes(x = Boosting_Round)) +
  geom_line(aes(y = Train_Error, color = "Train Error"), size = 1) +
  geom_line(aes(y = Test_Error, color = "Test Error"), size = 1) +
  scale_color_manual(values = c("Train Error" = "blue", "Test Error" = "red")) +
  labs(x = "Boosting Round", y = "Error Rate") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, max(cv$Boosting_Round), by = 10))  #



data <- subset(wide_data, select = c('birds_m_sqr', 'average_water', 'prod_type'))
data <- na.omit(data)
data$prod_type <- as.factor(data$prod_type)

boocoin_test_3 <- function(data, index, p){
  resample <- data[index, ]
  # resample <- data[sample(nrow(data),nrow(data),replace=TRUE),] #Uncomment for testing
  # p = 0.8 #Uncomment for testing
 
  #Create the shuffled variable
  resample$shuffled_X = sample(resample$average_water)
  #XGBoost
  type <- data.frame(type = resample$prod_type)
  
  #Create dummy variables for feed variable
  dummy_vars <- model.matrix(~ factor(type), type)
  
  # Remove the intercept column
  dummy_vars <- dummy_vars[, -1]
  
  # Bind the dummy variables to the original data frame
  resample <- cbind(resample, dummy_vars)
  data_1 <- subset(resample, select = -c(prod_type, shuffled_X))
  colnames(data_1) <- c('birds_m_sqr', 'average_water',
                        'ptype1', 'ptype2', 'ptype3')
  
  
  #Data Partition
  #Partitioning data into training and test
  inTraining <- createDataPartition(data_1$birds_m_sqr, p = p, list = FALSE)
  training <- data_1[inTraining,]
  testing  <- data_1[-inTraining,]
  
  # Splitting training data into dependent and features
  label <- training$birds_m_sqr
  training <- as.matrix(training[, !(names(training) %in% c("birds_m_sqr"))])
  
  xgb_model_1 <- xgb.train(
    data = xgb.DMatrix(data = training, label = label),
    objective = "reg:squarederror", 
    nrounds = 35,
    eta = c(0.1,0.2,0.3),                      
    max_depth = 6)
  
  # Make predictions on the test set
  test.target <- testing$birds_m_sqr
  testing <- as.matrix(testing[, !(names(testing) %in% c("birds_m_sqr"))])
  predictions <- predict(xgb_model_1, as.matrix(testing))
  
  #  Calculate r-squared
  XGB_R2_1 <- cor(test.target, predictions) ^ 2
  
  data_2 <- subset(resample, select = -c(prod_type, average_water)) # Now we are using shuffled_X
  colnames(data_2) <- c('birds_m_sqr', 'shuffled_X',
                        'ptype1', 'ptype2', 'ptype3')
  
  inTraining <- createDataPartition(data_2$birds_m_sqr, p = p, list = FALSE)
  training <- data_2[inTraining,]
  testing  <- data_2[-inTraining,]
  
  # Splitting training data into dependent and features
  label <- training$birds_m_sqr
  training <- as.matrix(training[, !(names(training) %in% c("birds_m_sqr"))])
  
  xgb_model_2 <- xgb.train(
    data = xgb.DMatrix(data = training, label = label),
    objective = "reg:squarederror", 
    nrounds = 35,
    eta = c(0.1,0.2,0.3),                      
    max_depth = 6)
  
  # Make predictions on the test set
  test.target <- testing$birds_m_sqr
  testing <- as.matrix(testing[, !(names(testing) %in% c("birds_m_sqr"))])
  predictions <- predict(xgb_model_2, as.matrix(testing))
  
  #  Calculate r-squared
  XGB_R2_2 <- cor(test.target, predictions) ^ 2
  return(c(XGB_R2_1, XGB_R2_2 ,XGB_R2_1-XGB_R2_2))
}

N <- nrow(data) #number of observations in data set
R = 10000 #Number of bootstrap replica

dirichlet <- matrix( rexp(N * R, 1) , ncol = N, byrow = TRUE) #Creating a matrix of dirichlet weights 
dirichlet_w <- dirichlet / rowSums(dirichlet)

bayesian_boot <- boot(data=data, statistic = boocoin_test_3, weights = dirichlet_w, R=rep(1,R), p=0.85) #Bootstrapping 
hist(bayesian_boot$t[,3])
hist(bayesian_boot$t[,3], breaks = 60,  freq = FALSE, main = " ", xlab = "Difference in R-Squared", col = "lightblue")

plot3 <- hist(bayesian_boot$t[,3], breaks = 60,  freq = FALSE, main = " ", xlab = "Difference in R-Squared", col = "lightblue")

png("C:/broiler_acites/ascites_case/Results/plot1_test3.png", width = 800, height = 600)  # Adjust width and height as needed
plot(plot3, col = "lightblue", main = " ", xlab = "Difference in R-Squared", freq = F)
dev.off()
