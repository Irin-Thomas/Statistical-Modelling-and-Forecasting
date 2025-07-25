# Load necessary libraries
library(gamlss)
library(MASS)
library(ggplot2)

# Load the BMI dataset
data(dbbmi)

# Define the age range to analyze (e.g., 10-11 years)
old <- 14
da <- with(dbbmi, subset(dbbmi, age > old & age < old + 1))
bmi14 <- da$bmi  # Extract BMI values

# Plot histogram
hist(bmi14, breaks = 10, main = "Histogram of BMI (Age 13-14)", col = "lightblue")

# Alternative histogram using MASS package
truehist(bmi14, nbins = 10, col = "lightgreen")

# Fit different parametric distributions
mod1 <- gamlss(bmi14 ~ 1, family = NO)   # Normal distribution
mod2 <- gamlss(bmi14 ~ 1, family = LOGNO) # Lognormal distribution
mod3 <- gamlss(bmi14 ~ 1, family = BCCG)# Box-Cox-Cole-Green distribution
mod4 <- gamlss(bmi14 ~ 1, family=SN1)   #Skewed Normal distribiution
mod5 <- gamlss(bmi14 ~ 1, family = BCPE)  # Box-Cox Power Exponential
mod6 <- gamlss(bmi14 ~ 1, family = BCTo)  # Box-Cox-t
mod7 <- gamlss(bmi14 ~ 1, family = GA)    # Gamma
mod8 <- gamlss(bmi14 ~ 1, family = IG) # Inverse Gaussian

# Compare models using AIC
AIC(mod1, mod2, mod3,mod4,mod5,mod6,mod7,mod8)

# Select the best model (lowest AIC)
best_model <- mod3   # Assuming BCCG is the best

# Output parameter estimates
summary(best_model)

# Plot the fitted distribution
histDist(bmi14, family = BCCG, main = "Fitted BCCG Distribution")
