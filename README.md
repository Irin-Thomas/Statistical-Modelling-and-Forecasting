# Statistical-Modelling-and-Forecasting

The project presents a comprehensive statistical analysis of three datasets using the **Generalised Additive Models for Location, Scale, and Shape (GAMLSS)** framework in R. The models address different distributional assumptions, non-linear trends, and heteroscedasticity in real-world data.

---

## 📂 Project Structure
- 3rd datset
- Code: 
    - 01_bmi_distribution_fitting.R
    - 02_grip_strength_centile_curves.R
    - 03_body_fat_prediction_model.R
- Report
---

## 🧪 Datasets & Objectives

### 1. **BMI Data – Distribution Fitting**
- Dataset: BMI for 14-year-old Dutch boys
- Objective: Fit the best parametric distribution
- Result: **BCCG (Box-Cox-Cole-Green)** selected based on lowest AIC (1905.45)

### 2. **Grip Strength Data – Centile Estimation**
- Dataset: Grip strength vs. age for English schoolchildren
- Objective: Estimate centile curves using smooth functions
- Result: **BCT model** provided best fit, capturing growth and heteroscedasticity

### 3. **Body Fat Data – Predictive Modelling**
- Dataset: Body measurements of adult males (Kaggle)
- Objective: Predict body fat % from anthropometric variables
- Result: **BCT model** selected (lowest AIC = 1532.204); strongest predictor: **abdomen circumference**

---

## 📈 Key Techniques Used

- GAMLSS modelling in **R**
- Model selection via **AIC/GAIC**
- Diagnostic tools: residual plots, worm plots, Q-Q plots
- Centile curve generation for growth reference
- Prediction and model evaluation using new data

---

## 🔍 Main Findings

- **BMI Analysis**: Median BMI ≈ 18.97 with slight positive skew; BCCG captured the data shape well.
- **Grip Strength**: Growth patterns show increasing spread with age; BCT model handled tail heaviness effectively.
- **Body Fat Prediction**: Abdomen and weight were key predictors; predictions followed expected physiological trends; model residuals showed good normality.

---

## 🖼️ Sample Visual Outputs

### 📉 BMI Dataset – Distribution Fit (BCCG)
BMI Distribution
## <img width="446" height="245" alt="image" src="https://github.com/user-attachments/assets/4a8eca3d-6272-47ec-a058-127df74f80fb" />

### 📈 Grip Strength – Centile Curves by Age
Grip Strength Centiles
## ![2nd Dataset Centile Curve BCT](https://github.com/user-attachments/assets/76dcd8f5-b661-428b-9633-071f6cd54267)


### 📊 Body Fat – Predicted vs Actual
Body Fat Prediction
## ![3rd Dataset Residual Plot BCT](https://github.com/user-attachments/assets/828946c8-b17c-4369-8535-ac27ba26bd00)


---

## 📚 Tools & Packages

- **R (version ≥ 4.0.0)**
- `gamlss`, `gamlss.dist`, `gamlss.add`, `ggplot2`, `dplyr`, `car`, `psych`


---

## 📌 How to Reproduce

1. Install R and RStudio
2. Open the `.R` scripts under `/code/`
3.Run the scripts in sequence for each dataset

---
## 📚 References

Citations and source materials are listed in the final report PDF [`Case Study Report.pdf`](Report).

---

## 📬 Contact

**Author**: Irin Mary Thomas  
**Email**: irinthomas0@gmail.com  

