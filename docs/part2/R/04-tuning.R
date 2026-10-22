# Article section 4: full budgets are expensive and run only on request.
# Run with Rscript R/04-tuning.R random_search (or grid_search, mbo, nested).
source("R/01-data.R")
library(mlr3)
library(mlr3learners)
library(mlr3tuning)
library(mlr3mbo)
set.seed(20261023)
heart_task <- as_task_classif(heart, target = "heart_disease", positive = "present", id = "heart")
split <- partition(heart_task, ratio = 2/3)
# xgboost needs numeric predictors. Fixed category definitions from the data
# dictionary require no fitted preprocessing and can be encoded before CV.
encoded <- model.matrix(~ . - 1, heart[, setdiff(names(heart), "heart_disease")])
boost_task <- as_task_classif(data.frame(encoded, heart_disease = heart$heart_disease),
  target = "heart_disease", positive = "present", id = "heart_xgboost")
train_task <- boost_task$clone()$filter(split$train)
boost <- lrn("classif.xgboost", nthread = 1,
  nrounds = to_tune(1, 500), max_depth = to_tune(1, 20),
  eta = to_tune(1e-10, 1), lambda = to_tune(1e-10, 1))
mode <- commandArgs(trailingOnly = TRUE)
if (length(mode) == 0) stop("Choose grid_search, random_search, mbo or nested; see README.md.")
mode <- match.arg(mode[1], c("grid_search", "random_search", "mbo", "nested"))
measure <- msr("classif.acc")
if (mode == "nested") {
  tuned <- auto_tuner(tuner = tnr("mbo"), learner = boost,
    resampling = rsmp("cv", folds = 10), measure = measure,
    terminator = trm("evals", n_evals = 100))
  result <- resample(boost_task, tuned, rsmp("cv", folds = 10), store_models = TRUE)
  write.csv(result$score(measure)[, c("iteration", "classif.acc"), with = FALSE],
    "outputs/tuning-nested.csv", row.names = FALSE)
  print(result$aggregate(measure))
} else {
  tuner <- switch(mode, grid_search = tnr("grid_search", resolution = 10, batch_size = 20),
    random_search = tnr("random_search"), mbo = tnr("mbo"))
  budget <- switch(mode, grid_search = trm("none"),
    random_search = trm("evals", n_evals = 500), mbo = trm("evals", n_evals = 30))
  instance <- tune(tuner = tuner, task = train_task, learner = boost,
    resampling = rsmp("cv", folds = 10), measures = measure, terminator = budget)
  final <- lrn("classif.xgboost", nthread = 1)
  final$param_set$values <- instance$result_learner_param_vals
  final$train(boost_task, row_ids = split$train)
  score <- final$predict(boost_task, row_ids = split$test)$score(measure)
  print(score)
  write.csv(data.frame(accuracy = unname(score)), paste0("outputs/tuning-", mode, ".csv"), row.names = FALSE)
  saveRDS(instance$result_learner_param_vals, paste0("outputs/tuning-", mode, "-parameters.rds"))
}
capture.output(sessionInfo(), file = paste0("outputs/session-info-", mode, ".txt"))
