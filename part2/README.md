# Part 2 — From random forest results to neural networks

We use clinical measurements from 270 patients to distinguish heart disease
from its absence. During the session, we will read the saved random forest
results, fit a neural network with Keras, and evaluate its predictions with
`mlr3`. We will not fit another random forest.

## Before the session

1. Open `machine-learning-in-epidemiology-with-r.Rproj` in RStudio.
2. In a fresh project session, run `setwd("part2")` in the Console.
3. Install the workshop packages once:

   ```r
   source("install-packages.R")
   install.packages("keras3")
   ```

4. In a fresh R session, configure Keras with `keras3::install_keras()`.
   This sets up the Python software Keras uses for training. If you already
   have a compatible environment, use that instead. Follow the
   [Keras for R setup guide](https://keras3.posit.co/articles/getting_started.html).
5. Run `source("check-setup.R")` to check the core packages and data.
   This check does not test the Keras backend. Before the session, also check
   that `library(keras3)` and `keras3::keras_model_sequential(input_shape = c(22))`
   work in your selected environment.

Installation is preparation for the session; it does not need to interrupt
the lesson.

## During the session

Open [the teaching notebook](ml-workflow-2.qmd) and follow sections 1–7:

1. Meet the heart data.
2. Explain the saved random forest predictions and mistakes.
3. Use `mlr3` to define the task and reuse the saved training/test groups.
4. Prepare numerical inputs for the network.
5. Build the network with Keras.
6. Fit it and examine training and validation loss.
7. Evaluate its predictions with `mlr3` and compare with the forest.

Run the code blocks in order in RStudio. Network fitting is a live activity;
rendering the webpage uses saved results and does not train either model.
The saved comparison remains a reference when your own results differ.

The [complete neural-network script](R/03-neural-network.R) contains the same
steps, followed by code to save a new run's results. Running that complete
script replaces the saved neural-network CSV files and loss figure. Use the
notebook blocks during the lesson if you want to keep the recorded results.

## After the session

Choose a question to explore further:

| Question | Script |
| --- | --- |
| How do trees and pruning work? How stable are the scores across samples? | [Trees, evaluation and resampling](R/02-trees-and-evaluation.R) |
| Can we improve predictions by changing model settings? | [Tuning](R/04-tuning.R) |
| Can generated records resemble the original patients? | [Synthetic data](R/05-synthetic-data.R) |

The tree/evaluation script refits the forest and runs resampling; it is separate
from the main lesson. Full tuning can take much longer than the workshop.
Install extra packages only when you choose an extension:

```bash
Rscript install-optional-packages.R tuning
Rscript install-optional-packages.R synthetic
```

## Sources and reproducibility

The examples draw on Wright et al. (2026). The [data guide](data/README.md),
[replication record](references/replication-notes.md) and
[validation results](outputs/VALIDATION.md) contain the source details, exact
settings and recorded checks. Saved scores describe individual runs, rather
than guaranteed performance.

To build the website, run `quarto render` from the repository root. The current
output folder is `_site/`.

[Series guide](../README.md) · [Part 1](../part1/README.md)
