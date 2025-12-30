library(ranger)

# Create RF training subset FROM TRAIN DATA 
fraud_train_idx <- which(train$Class == "Fraud")
legit_train_idx <- which(train$Class == "Legit")

set.seed(123)

fraud_train_sample <- fraud_train_idx
legit_train_sample <- sample(
  legit_train_idx,
  size = min(length(legit_train_idx), 10 * length(fraud_train_idx))
)

rf_train <- train[c(fraud_train_sample, legit_train_sample), ]

# Ensure factor levels
rf_train$Class <- factor(rf_train$Class, levels = c("Legit", "Fraud"))
test$Class     <- factor(test$Class, levels = c("Legit", "Fraud"))

# Train Random Forest 
rf_model <- ranger(
  Class ~ V1 + V2 + V3 + Amount,
  data = rf_train,
  probability = TRUE,
  num.trees = 300,
  mtry = 2,
  min.node.size = 10,
  importance = "impurity"
)

# RF predicted probabilities on FULL test set
rf_pred_prob <- predict(rf_model, data = test)$predictions[, "Fraud"]

# ROC + optimal threshold for RF
roc_rf <- roc(test$Class, rf_pred_prob, levels = c("Legit", "Fraud"))
plot(roc_rf, col = "red", lwd = 2, add = TRUE)

best_thresh_rf <- coords(roc_rf, "best", ret = "threshold")$threshold
cat("RF Optimal Threshold:", best_thresh_rf, "\n")

# Final RF predictions
rf_pred_class <- factor(
  ifelse(rf_pred_prob > best_thresh_rf, "Fraud", "Legit"),
  levels = c("Legit", "Fraud")
)

# RF Confusion Matrix
cm_rf <- confusionMatrix(
  data = rf_pred_class,
  reference = test$Class,
  positive = "Fraud"
)
print(cm_rf)

cat("Random Forest AUC:", auc(roc_rf), "\n")

#model comparison 
comparison <- data.frame(
  Model = c("Logistic Regression", "Random Forest"),
  AUC = c(
    as.numeric(auc(roc_curve)),
    as.numeric(auc(roc_rf))
  ),
  Recall = c(
    conf_matrix$byClass["Sensitivity"],
    cm_rf$byClass["Sensitivity"]
  ),
  Precision = c(
    conf_matrix$byClass["Precision"],
    cm_rf$byClass["Precision"]
  ),
  F1 = c(
    conf_matrix$byClass["F1"],
    cm_rf$byClass["F1"]
  )
)

print(comparison)

