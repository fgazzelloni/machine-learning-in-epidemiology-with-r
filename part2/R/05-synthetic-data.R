# Optional extension: generate artificial patient records.
# Follow article section 6.2.5. Run from part2/.
# Use the real patient data to learn patterns for the generator.
source("R/01-data.R")
library(arf)

# Fix the random starting point so the example can be repeated.
set.seed(20261023)

# An adversarial forest learns to distinguish real from generated records
# while improving the generated examples.
generator <- adversarial_rf(heart)

# Estimate the data distribution using the fitted forest and real records.
density <- forde(generator, heart)

# Sample a new artificial table with the same number of rows as heart.
# These rows are generated examples, not additional observed patients.
synthetic_heart <- forge(density, n_synth = nrow(heart))

# Check the requested size and save the synthetic data separately.
stopifnot(nrow(synthetic_heart) == nrow(heart))
write.csv(synthetic_heart, "outputs/synthetic-heart.csv", row.names = FALSE)

# Record package versions alongside the generated data.
capture.output(sessionInfo(), file = "outputs/session-info-synthetic.txt")
