# Run once from part2/; this does not configure a Python backend.
packages <- c("mlr3", "mlr3learners", "mlr3viz", "rpart", "rpart.plot", "ranger",
              "ggplot2", "precrec", "keras3", "mlr3tuning", "mlr3mbo", "DiceKriging", "rgenoud", "xgboost", "arf")
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing, repos = "https://cloud.r-project.org")
