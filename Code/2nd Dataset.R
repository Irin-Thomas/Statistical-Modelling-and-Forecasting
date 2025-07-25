# Load necessary libraries
library(gamlss)
library(gamlss.data)

# Load the grip strength dataset
data(grip)

# Set a unique seed for reproducibility (use your assigned seed)
set.seed(300)
index <- sample(3766, 1000)
mydata <- grip[index, ]
dim(mydata)
# Check dataset structure
str(mydata)

# Scatter plot of grip strength against age
plot(grip~ age,data = mydata)

# Fit the LMS model using BCCG distribution
gbccg <- gamlss(grip ~ pb(age), sigma.fo = ~pb(age), 
                nu.fo = ~pb(age), data = mydata, family = BCCG)

# Effective degrees of freedom
edfAll(gbccg)

gbct <- gamlss(grip ~ pb(age), 
               sigma.fo = ~ pb(age), 
               nu.fo = ~ pb(age), 
               tau.fo = ~ pb(age), 
               data = mydata, 
               family = BCT, 
               start.from = gbccg)

gbcpe <- gamlss(grip ~ pb(age), 
                sigma.fo = ~ pb(age), 
                nu.fo = ~ pb(age), 
                tau.fo = ~ pb(age), 
                data = mydata, 
                family = BCPE, 
                start.from = gbccg)


# Compare models using GAIC
GAIC(gbccg, gbct,gbcpe)
# Correct function name is fittedPlot() (lowercase P)
fittedPlot(gbccg, gbct, x = mydata$age)

# Generate centile plots
centiles(gbct, xvar = mydata$age)
par(mar=c(4,4,2,1))  # Bottom, Left, Top, Right margins
plot(gbct)
wp(gbct)
Q.stats(gbct)

