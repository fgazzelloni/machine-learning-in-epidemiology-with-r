## ---- article-trees ----
# Optional extension: trees, forest evaluation and resampling.
# This script refits models; the main lesson reads its saved results.
# Examples follow article sections 2.1, 3.1 and 3.2. Run from part2/.
source("R/01-data.R")
library(mlr3)
library(mlr3learners)
library(mlr3viz)

# Fix the random starting point so the example can be repeated.
set.seed(20261023)

# Start with one tree using all patients to show how its decisions work.
# This illustration does not tell us how well it predicts unseen patients.
cart <- rpart::rpart(heart_disease ~ ., data = heart)
png("figures/01-tree.png",
    width = 1500, height = 1000, res = 150)
rpart.plot::rpart.plot(cart)
invisible(dev.off())


# Allow a larger tree, then inspect how its error changes with complexity.
deep_cart <- rpart::rpart(heart_disease ~ .,
  data = heart,
  control = rpart::rpart.control(minsplit = 2)
)
png("figures/02-complexity.png",
    width = 1200, height = 900, res = 150)

rpart::plotcp(deep_cart)
invisible(dev.off())

# Pruning removes branches to simplify the tree.
# Keep the article's chosen complexity value for this example.
pruned_cart <- rpart::prune(deep_cart, cp = 0.031)
png("figures/03-pruned-tree.png",
    width = 1500, height = 1000, res = 150)

rpart.plot::rpart.plot(pruned_cart)
invisible(dev.off())

## ---- article-evaluation ----
# Define the prediction task: detect heart disease, the positive class.
heart_task <- as_task_classif(heart,
  target = "heart_disease",
  positive = "present",
  id = "heart"
)

set.seed(20261023)

# Set aside one-third of patients for testing and save their row numbers.
split <- partition(heart_task, ratio = 2 / 3)
write.csv(
  data.frame(
    row_id = c(split$train, split$test),
    subset = rep(
      c("train", "test"),
      c(
        length(split$train),
        length(split$test)
      )
    )
  ),
  "outputs/split.csv",
  row.names = FALSE
)

# A random forest combines many trees. Request probabilities as well as classes.
forest <- lrn("classif.ranger", predict_type = "prob", num.threads = 1)

# Learn from the training patients, then predict the untouched test patients.
forest$train(heart_task, row_ids = split$train)
forest_pred <- forest$predict(heart_task, row_ids = split$test)

# Evaluate sensitivity, specificity, positive and negative predictive value,
# and accuracy. Predictive values describe how often each prediction is correct.
measures <- msrs(c(
  "classif.tpr",
  "classif.tnr",
  "classif.ppv",
  "classif.npv",
  "classif.acc"
))
forest_pred$confusion
forest_pred$score(measures)

# Save the counts and scores so the main lesson can read them without training.
write.csv(as.data.frame(forest_pred$confusion),
  "outputs/confusion.csv",
  row.names = FALSE
)
write.csv(
  data.frame(
    measure = names(forest_pred$score(measures)),
    value = unname(forest_pred$score(measures))
  ),
  "outputs/holdout-measures.csv",
  row.names = FALSE
)

# Save curves showing performance across probability thresholds.
# ROC compares sensitivity with the false-positive rate.
# PRC compares precision (the share of positive predictions that are correct)
# with recall, another name for sensitivity.
for (kind in c("roc", "threshold", "prc")) {
  ggplot2::ggsave(paste0("figures/04-", kind, ".png"),
    ggplot2::autoplot(forest_pred, type = kind),
    width = 7, height = 5
  )
}

## ---- article-resampling ----
# Resampling repeats training with different samples to examine score stability.
# This extension uses the article's 100-tree forest.
forest100 <- lrn("classif.ranger",
  predict_type = "prob",
  num.trees = 100,
  num.threads = 1
)
set.seed(20261024)
forest100$train(heart_task, row_ids = split$train)

# AUC measures how well probabilities rank patients with and without disease.
# Compare training and test scores to look for overfitting.
auc <- msr("classif.auc")
auc_by_subset <- data.frame(subset = c("train", "test"), auc = c(
  forest100$predict(heart_task, row_ids = split$train)$score(auc),
  forest100$predict(heart_task, row_ids = split$test)$score(auc)
))
auc_by_subset
write.csv(auc_by_subset, "outputs/train-test-auc.csv", row.names = FALSE)
set.seed(20261025)

# Cross-validation holds out each of three groups in turn for evaluation.
cv3 <- resample(heart_task, forest100, rsmp("cv", folds = 3))
write.csv(cv3$score(auc)[, c("iteration", "classif.auc"), with = FALSE],
  "outputs/cv3.csv",
  row.names = FALSE
)
cv3$aggregate(auc)

# Subsampling repeatedly draws training subsets without replacement.
# Bootstrap samples can include the same patient more than once.
# The repeat counts below follow the article.
set.seed(20261026)
subsampling <- resample(
  heart_task,
  forest100,
  rsmp("subsampling",
    ratio = 2 / 3,
    repeats = 100
  )
)
set.seed(20261027)
bootstrap <- resample(heart_task, forest100, rsmp("bootstrap", repeats = 40))

# Compare the average AUC from the three resampling approaches.
resampling_scores <- data.frame(
  method = c("cv3", "subsampling100", "bootstrap40"),
  auc = c(cv3$aggregate(auc), subsampling$aggregate(auc), bootstrap$aggregate(auc))
)
resampling_scores
write.csv(resampling_scores, "outputs/resampling-summary.csv", row.names = FALSE)

# Record package versions alongside the results to help reproduce the run.
capture.output(sessionInfo(), file = "outputs/session-info-core.txt")
