library(tidyverse)
library(caret)
library(ggplot2)
library(pROC)

# Load data and label target
fraud_data <- read_csv("creditcard.csv") %>% 
  mutate(Class = factor(Class, levels = c(0, 1),
                        labels = c("Legit", "Fraud")))

# Visualize transaction amounts
ggplot(fraud_data, aes(x = Amount, fill = Class)) +
  geom_histogram(bins = 30, alpha = 0.7) +
  scale_x_log10() +
  labs(title = "Transaction Amount by Class")

# Train–test split (stratified)
set.seed(123)
train_index <- createDataPartition(fraud_data$Class, p = 0.8, list = FALSE)
train <- fraud_data[train_index, ]
test  <- fraud_data[-train_index, ]

# Weighted Logistic Regression
logit_model <- glm(
  Class ~ V1 + V2 + V3 + Amount,
  data = train,
  family = binomial,
  weights = ifelse(train$Class == "Fraud", 100, 1)
)

# Predicted probabilities
test$pred_prob <- predict(logit_model, test, type = "response")

# Ensure factor levels are correct
test$Class <- factor(test$Class, levels = c("Legit", "Fraud"))

# ROC curve and optimal threshold
roc_curve <- roc(test$Class, test$pred_prob, levels = c("Legit", "Fraud"))
plot(roc_curve,col="blue", print.auc = TRUE, main = "ROC Curve")

best_thresh <- coords(roc_curve, "best", ret = "threshold")$threshold
cat("Optimal Threshold:", best_thresh, "\n")

# Final classification using optimal threshold
test$pred_class <- factor(
  ifelse(test$pred_prob > best_thresh, "Fraud", "Legit"),
  levels = c("Legit", "Fraud")
)

# Confusion Matrix (final & consistent)
conf_matrix <- confusionMatrix(
  data = test$pred_class,
  reference = test$Class,
  positive = "Fraud"
)
print(conf_matrix)

# Fraud capture rate at optimal threshold
fraud_capture_rate <- test %>% 
  summarise(Fraud_Capture_Rate = mean(Class == "Fraud" & pred_class == "Fraud"))

print(fraud_capture_rate)

# Final AUC
cat("Logistic Regression AUC:", auc(roc_curve), "\n")

