This project builds and compares Logistic Regression and Random Forest models to detect fraudulent credit card transactions in a highly imbalanced dataset. Since fraud represents only ~0.17% of transactions, traditional accuracy is misleading; hence, evaluation focuses on ROC–AUC, Recall, Precision, Balanced Accuracy, and threshold optimization. 
Libraries: caret, ggplot2, pROC, randomForest, dplyr.
Models: Logistic Regression, Random Forest.
Metrics: Confusion Matrix, ROC–AUC, Recall, Precision, F1, Balanced Accuracy.
### Data Preparation & EDA
Cleaned transaction data and converted target variable to factor (Legit, Fraud).Performed EDA to compare transaction patterns between fraud and legitimate cases.Conducted an 80–20 stratified train–test split.Addressed class imbalance using higher fraud class weights (100×).
### Logistic Regression
Trained a weighted logistic model using key PCA features (V1, V2, V3) and transaction amount.Optimized classification threshold (0.248) to improve fraud capture.
### Performance:
AUC–ROC: 0.929    Recall: 80.6%    Precision: 3.65%    Balanced Accuracy: 88.5%
### Random Forest
Implemented a Random Forest to capture non-linear patterns and feature interactions.Tuned probability threshold (0.296) for fraud detection.
### Performance:
AUC–ROC: 0.956    Recall: 84.7%     Precision: 5.20%      Balanced Accuracy: 91.0%
Random Forest emerges as the preferred model, while Logistic Regression remains a strong, interpretable benchmark.
