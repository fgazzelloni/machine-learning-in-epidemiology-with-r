# Run once from part2/ for the core workshop.
packages <- c("mlr3", "mlr3learners", "mlr3viz", "rpart", "rpart.plot", "ranger",
              "ggplot2", "precrec")
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing, repos = "https://cloud.r-project.org")
