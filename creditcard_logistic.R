library(tidyverse)
library(caret)
library(ggplot2)
fraud_data <- read_csv("creditcard.csv") %>% 
  mutate(Class = factor(Class, levels = c(0, 1), labels = c("Legit", "Fraud")))
#Visualizing the distribution of transaction amounts for fraud vs. legitimate transactions.
ggplot(fraud_data, aes(x = Amount, fill = Class)) +
  geom_histogram(bins = 30, alpha = 0.7) +
  scale_x_log10() +
  labs(title = "Transaction Amount by Class")
#split data
set.seed(123)
train_index <- createDataPartition(fraud_data$Class, p = 0.8, list = FALSE)
train <- fraud_data[train_index, ]
test <- fraud_data[-train_index, ]
# Train model
model <- glm(Class ~ V1 + V2 + V3 + Amount, 
             data = train, 
             family = "binomial",
             weights = ifelse(train$Class == "Fraud", 100, 1))
# Predictions
test$pred_prob <- predict(model, test, type = "response")
test$pred_class <- factor(ifelse(test$pred_prob > 0.5, "Fraud", "Legit"), 
                          levels = c("Legit", "Fraud"))
# Ensuring Class is a factor with matching levels
test$Class <- factor(test$Class, levels = c("Legit", "Fraud"))

# Fixing levels if they don't match (e.g., typo in "Fraud")
levels(test$pred_class) <- levels(test$Class)

#  confusion matrix
conf_matrix <- confusionMatrix(
  data = test$pred_class,
  reference = test$Class,
  positive = "Fraud"
)
print(conf_matrix)
#roc curve 
library(pROC)
roc_curve <- roc(test$Class, test$pred_prob, levels = c("Legit", "Fraud"))
plot(roc_curve, print.auc = TRUE)
best_thresh <- coords(roc_curve, "best", ret = "threshold")$threshold
test$pred_class_optim <- ifelse(test$pred_prob > best_thresh, "Fraud", "Legit")
test %>% 
  filter(pred_prob > 0.07) %>% 
  summarise(Fraud_Capture_Rate = mean(Class == "Fraud"))
cat("Logistic Regression AUC:", auc(roc_curve), "\n")
