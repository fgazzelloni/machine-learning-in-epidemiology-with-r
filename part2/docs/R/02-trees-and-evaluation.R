# Article sections 2.1, 3.1 and 3.2. Local seeds make this run reproducible.
source("R/01-data.R")
library(mlr3)
library(mlr3learners)
library(mlr3viz)
set.seed(20261023)
# These first trees illustrate fitting and pruning on all observations,
# as in the article; they do not estimate generalisation performance.
cart <- rpart::rpart(heart_disease ~ ., data = heart)
png("figures/01-tree.png", width = 1500, height = 1000, res = 150)
rpart.plot::rpart.plot(cart)
dev.off()
deep_cart <- rpart::rpart(heart_disease ~ ., data = heart,
                         control = rpart::rpart.control(minsplit = 2))
png("figures/02-complexity.png", width = 1200, height = 900, res = 150)
rpart::plotcp(deep_cart)
dev.off()
pruned_cart <- rpart::prune(deep_cart, cp = 0.031)
png("figures/03-pruned-tree.png", width = 1500, height = 1000, res = 150)
rpart.plot::rpart.plot(pruned_cart)
dev.off()
# The article alternates task and heart_task; use one name consistently.
heart_task <- as_task_classif(heart, target = "heart_disease", positive = "present", id = "heart")
set.seed(20261023)
split <- partition(heart_task, ratio = 2/3)
write.csv(data.frame(row_id = c(split$train, split$test),
  subset = rep(c("train", "test"), c(length(split$train), length(split$test)))), "outputs/split.csv", row.names = FALSE)
forest <- lrn("classif.ranger", predict_type = "prob", num.threads = 1)
forest$train(heart_task, row_ids = split$train)
forest_pred <- forest$predict(heart_task, row_ids = split$test)
measures <- msrs(c("classif.tpr", "classif.tnr", "classif.ppv", "classif.npv", "classif.acc"))
print(forest_pred$confusion)
print(forest_pred$score(measures))
write.csv(as.data.frame(forest_pred$confusion), "outputs/confusion.csv", row.names = FALSE)
write.csv(data.frame(measure = names(forest_pred$score(measures)),
  value = unname(forest_pred$score(measures))), "outputs/holdout-measures.csv", row.names = FALSE)
for (kind in c("roc", "threshold", "prc")) {
  ggplot2::ggsave(paste0("figures/04-", kind, ".png"),
    ggplot2::autoplot(forest_pred, type = kind), width = 7, height = 5)
}
# Section 3.2 uses a 100-tree forest, rather than the learner default above.
forest100 <- lrn("classif.ranger", predict_type = "prob", num.trees = 100, num.threads = 1)
set.seed(20261024)
forest100$train(heart_task, row_ids = split$train)
auc <- msr("classif.auc")
auc_by_subset <- data.frame(subset = c("train", "test"), auc = c(
  forest100$predict(heart_task, row_ids = split$train)$score(auc),
  forest100$predict(heart_task, row_ids = split$test)$score(auc)))
print(auc_by_subset)
write.csv(auc_by_subset, "outputs/train-test-auc.csv", row.names = FALSE)
set.seed(20261025)
cv3 <- resample(heart_task, forest100, rsmp("cv", folds = 3))
write.csv(cv3$score(auc)[, c("iteration", "classif.auc"), with = FALSE],
  "outputs/cv3.csv", row.names = FALSE)
print(cv3$aggregate(auc))
# Same repeat counts as section 3.2; no reduced demonstration budgets.
set.seed(20261026)
subsampling <- resample(heart_task, forest100, rsmp("subsampling", ratio = 2/3, repeats = 100))
set.seed(20261027)
bootstrap <- resample(heart_task, forest100, rsmp("bootstrap", repeats = 40))
resampling_scores <- data.frame(method = c("cv3", "subsampling100", "bootstrap40"),
  auc = c(cv3$aggregate(auc), subsampling$aggregate(auc), bootstrap$aggregate(auc)))
print(resampling_scores)
write.csv(resampling_scores, "outputs/resampling-summary.csv", row.names = FALSE)
capture.output(sessionInfo(), file = "outputs/session-info-core.txt")
