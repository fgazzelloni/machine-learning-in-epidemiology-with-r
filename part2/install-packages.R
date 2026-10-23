# Run from part2/ before the session to install the core R packages.
# Keras is installed separately; see the session guide.
packages <- c(
  "mlr3", "mlr3learners", "mlr3viz", "rpart", "rpart.plot", "ranger",
  "ggplot2", "precrec"
)

# Leave existing packages in place and install only those that are missing.
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing, repos = "https://cloud.r-project.org")
