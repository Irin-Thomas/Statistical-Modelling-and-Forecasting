# Clear workspace
rm(list = ls())

# Load necessary libraries
library(gamlss)
library(gamlss.dist)
library(gamlss.ggplots)
library(reshape2)
library(ggplot2)
library(GGally)

# Load the body fat dataset
body_fat_data <- read.csv("bodyfat.csv")

# Explore the dataset
names(body_fat_data)
dim(body_fat_data)
head(body_fat_data)

# Remove rows with missing values
clean_data <- na.omit(body_fat_data)


y = clean_data$BodyFat
# Visualize the distribution
histDist(y)

# Transform the response variable by adding a small constant
clean_data$BodyFat_transformed <- clean_data$BodyFat + 1e-5  # Adding a small constant

#---------------------------------------
#EDA
#---------------------------------------

# Histogram for Age
ggplot(clean_data, aes(x = Age)) +
  geom_histogram(binwidth = 5, fill = "lightgreen", color = "black") +
  labs(title = "Distribution of Age", x = "Age", y = "Frequency")

# Histogram for Weight
ggplot(clean_data, aes(x = Weight)) +
  geom_histogram(binwidth = 10, fill = "lightblue", color = "black") +
  labs(title = "Distribution of Weight", x = "Weight", y = "Frequency")



# Pairwise plot of selected variables
ggpairs(clean_data[, c("BodyFat_transformed", "Age", "Weight", "Height")],
        title = "Pairwise Scatter Plots")


#Distribution of Body Fat Percentage
ggplot(clean_data, aes(x = BodyFat_transformed)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "white") +
  labs(title = "Distribution of Body Fat Percentage", x = "Body Fat (%)", y = "Frequency")

#Correlation Matrix
cor_matrix <- cor(clean_data[, sapply(clean_data, is.numeric)])
print(cor_matrix)
melted_cor <- melt(cor_matrix)
ggplot(data = melted_cor, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", limit = c(-1, 1), space = "Lab", name="Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Body Fat vs. Weight
ggplot(clean_data, aes(x = Weight, y = BodyFat_transformed)) +
  geom_point() +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Body Fat vs. Weight", x = "Weight", y = "Body Fat (%)")

# Scatter plot for Body Fat vs. Weight with regression line
ggplot(clean_data, aes(x = Weight, y = BodyFat_transformed)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "Body Fat Percentage vs. Weight", x = "Weight (lbs)", y = "Body Fat (%)")

# Scatter plot for Body Fat vs. Age
ggplot(clean_data, aes(x = Age, y = BodyFat_transformed)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Body Fat Percentage vs. Age", x = "Age (years)", y = "Body Fat (%)")

#----------------------------------
#Model Fitting
#----------------------------------

# Fit models using the transformed variable
mNO <- gamlss(BodyFat_transformed ~ Age + Weight + Height 
              + Neck + Chest + Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
              data = clean_data, family = NO)

mLOGNO <- gamlss(BodyFat_transformed ~ Age + Weight + Height + Neck
                 + Chest + Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
                 data = clean_data, family = LOGNO)

# Compare models using GAIC
GAIC(mNO, mLOGNO)


# Residual Diagnostics
resid_plots(mNO)
wp(mNO)

# Choose the best distribution
D1 <- chooseDist(mNO, type = "realplus", parallel = "snow", ncpuss = 9)
print(D1)

#------------------------------------
#Model Fitting
#-------------------------------------

# Fit multiple GAMLSS models
mBCT <- gamlss(BodyFat_transformed ~ Age + Weight + Height + Neck + Chest + 
                 Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
               data = clean_data, family = BCT)

mGB2 <- gamlss(BodyFat_transformed ~ Age + Weight + Height + Neck + Chest + 
                 Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
               data = clean_data, family = GB2)

mBCPE <- gamlss(BodyFat_transformed ~ Age + Weight + Height + Neck + Chest +
                  Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
                data = clean_data, family = BCPE)

mLOGNO <- gamlss(BodyFat_transformed ~ Age + Weight + Height + Neck + Chest + 
                   Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
                 data = clean_data, family = LOGNO)
mBCPEo <- gamlss(BodyFat_transformed ~ Age + Weight + Height + Neck + Chest + 
                   Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
                 data = clean_data, family = BCPEo)
mGG <- gamlss(BodyFat_transformed ~ Age + Weight + Height + Neck + Chest +
                Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
              data = clean_data, family = GG)
mBCCGo <- gamlss(BodyFat_transformed ~ Age + Weight + Height + Neck + Chest + 
                   Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
                 data = clean_data, family = BCCGo)
mBCCG <- gamlss(BodyFat_transformed ~ Age + Weight + Height + Neck + Chest + 
                  Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
                data = clean_data, family = BCCG)


# Compare models using GAIC
model_comparison <- GAIC(mBCCG,mBCCGo,mGG,mBCPEo,mLOGNO,mBCPE,mGB2,mBCT)
print(model_comparison)

plot(mBCT)
wp(mBCT )
resid_plots(mBCT)

#----------------------------------------
#Prediction
#-----------------------------------------



# New data for predictions (ensure all variables are included)
new_data <- data.frame(
  Age = c(25, 30, 35, 40, 45, 50),
  Weight = c(150, 180, 200, 220, 240, 260),
  Height = c(68, 70, 72, 74, 76, 78),
  Neck = c(14, 15, 16, 17, 18, 19),
  Chest = c(36, 40, 42, 44, 46, 48),
  Abdomen = c(32, 34, 36, 38, 40, 42),
  Hip = c(40, 42, 44, 46, 48, 50),
  Thigh = c(24, 26, 28, 30, 32, 34),
  Knee = c(15, 16, 17, 18, 19, 20),
  Ankle = c(9, 10, 11, 12, 13, 14),
  Biceps = c(12, 13, 14, 15, 16, 17),
  Forearm = c(10, 11, 12, 13, 14, 15),
  Wrist = c(7, 8, 9, 10, 11, 12)
)

# Fit the BCT model again
mBCT <- gamlss(BodyFat_transformed ~ Age + Weight + Height + Neck + Chest + Abdomen + Hip + Thigh + Knee + Ankle + Biceps + Forearm + Wrist, 
               data = clean_data, family = BCT)

# Make predictions using the BCT model
pred_BCT <- predict(mBCT, newdata = new_data, type = "response")

# Combine predictions into a data frame
predictions_BCT <- data.frame(
  Age = new_data$Age,
  Weight = new_data$Weight,
  Predicted_BodyFat_BCT = pred_BCT
)

plot(pred_BCT, 
     main = "Predicted Body Fat Percentages", 
     ylab = "Predicted Body Fat (%)", 
     xlab = "Index", 
     type = "b",  # Type 'b' creates both points and lines
     pch = 19,    # Solid circle for points
     col = "blue") # Color

print(pred_BCT)


# Residual plots (example, adjust as needed)
residuals <- resid(mBCT)
par(mfrow = c(2, 2))  # Set up plotting area for multiple plots
plot(residuals, main = "Residuals", ylab = "Residuals", xlab = "Index")
qqnorm(residuals); qqline(residuals, col = "red", lwd = 2)  # Q-Q plot for residuals

# Display predictions
print(predictions_BCT)

