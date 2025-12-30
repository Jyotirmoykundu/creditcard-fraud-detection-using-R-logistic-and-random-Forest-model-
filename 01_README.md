Tools: R, ggplot2, caret, logistic regression, ROC, AUC.
Loaded and cleaned transaction data, converting the target variable (Class) into a factor (Legit/Fraud) and applied
exploratory data analysis to visualize the distribution of transaction amounts for fraud vs. legitimate transactions.
Split data into 80% training and 20% test sets stratified by Class and assigned higher weight (100x) to fraud cases to handle
imbalance.
Trained a logistic regression model using key PCA-derived features (V1, V2, V3) and transaction amount. Interpreted
coefficients.
Used precision-recall trade-offs (confusion matrix) and AUC-ROC (0.929 score),AUC-ROC: 0.929, indicating excellent model performance.
Optimized the threshold to capture 92% of frauds while keeping precision at 35%. 
Visualized transaction patterns and prediction performance using advanced ggplot2 and ROC plots.
threshold tuning can be applied according to the business needs.
applied random forest method for comparing and 
both the logit and rf model perfomes excellently very well with rf model having AUC(0.957) slighlty better than logit model AUC(0.951).
we pick Random Forest if we need the highest possible detection rate (even slight improvements matter).
we choose logistic model if we need to explain decisions.
