# Run from part2/ to install packages for one activity.
# Choose neural for the main Keras lesson, or tuning/synthetic for an extension.
# Examples: Rscript install-optional-packages.R neural
#           Rscript install-optional-packages.R tuning
#           Rscript install-optional-packages.R synthetic
# Match each activity to the packages it needs.
choices <- list(
  neural = "keras3",
  tuning = c("mlr3tuning", "mlr3mbo", "DiceKriging", "rgenoud", "xgboost"),
  synthetic = "arf"
)

# Read the activity name given after the script name in the terminal.
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1L || !args[[1]] %in% names(choices)) {
  stop("Choose one extension: neural, tuning or synthetic.")
}

# Install only missing packages for the chosen activity.
packages <- choices[[args[[1]]]]
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing, repos = "https://cloud.r-project.org")

# The Keras R package also needs a Python backend for training.
if (args[[1]] == "neural") message("Configure a Python backend separately with keras3::install_keras() in a fresh R session.")
