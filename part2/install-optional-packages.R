# Run from part2/. Choose only the extension you intend to use.
# Examples: Rscript install-optional-packages.R neural
#           Rscript install-optional-packages.R tuning
#           Rscript install-optional-packages.R synthetic
choices <- list(neural = "keras3",
                tuning = c("mlr3tuning", "mlr3mbo", "DiceKriging", "rgenoud", "xgboost"),
                synthetic = "arf")
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1L || !args[[1]] %in% names(choices)) {
  stop("Choose one extension: neural, tuning or synthetic.")
}
packages <- choices[[args[[1]]]]
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing, repos = "https://cloud.r-project.org")
if (args[[1]] == "neural") message("Configure a Python backend separately with keras3::install_keras() in a fresh R session.")
