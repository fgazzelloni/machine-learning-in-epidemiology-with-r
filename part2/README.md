# Part 2 — Replicate the article workflow

We use the 270-patient heart-disease dataset matching
Wright et al. (2026), with 13 predictors and an absent/present outcome.

1. Open `machine-learning-in-epidemiology-with-r.Rproj` from the repository root in RStudio, then run `setwd("part2")` in the Console. Open the project afresh before switching parts so the Console starts at the repository root.
2. Run `source("install-packages.R")` once, then `source("check-setup.R")`.
3. Follow [ml-workflow-2.qmd](ml-workflow-2.qmd).
4. Follow sections 1–4 during the main session. Use sections 5–8 as extensions.

The main session covers the data, trees, a neural-network demonstration using saved results, and evaluation. Resampling, tuning, interpretation and synthetic data provide follow-up practice. Full neural-network training is optional.

| Script | Article workflow |
| --- | --- |
| [01-data.R](R/01-data.R) | Frozen OpenML data and category definitions |
| [02-trees-and-evaluation.R](R/02-trees-and-evaluation.R) | Trees, pruning, random forest, evaluation and resampling |
| [03-neural-network.R](R/03-neural-network.R) | Published neural-network architecture and training settings |
| [04-tuning.R](R/04-tuning.R) | Grid/random/MBO tuning and nested cross-validation |
| [05-synthetic-data.R](R/05-synthetic-data.R) | ARF, FORDE and FORGE |

Render the complete website with `quarto render` from the repository root; output is written to `_site/`. Neural-network, full tuning and
synthetic-data scripts are separate runs. Full tuning retains the article budgets
and can take much longer than the two-hour session.

## Optional extensions

From `part2/`, install only the dependencies you need:

```bash
Rscript install-optional-packages.R neural
Rscript install-optional-packages.R tuning
Rscript install-optional-packages.R synthetic
```

### Keras setup

Install the neural-network dependency with `Rscript install-optional-packages.R neural`, then configure a supported Python backend using
`keras3::install_keras()` in a fresh R session. Alternatively, select an existing
compatible Python environment before loading Keras. See the
[official Keras for R setup guide](https://keras3.posit.co/articles/getting_started.html).
Backend installation is a separate step from installing the R package.

The core workflow, neural network, full random/MBO searches and synthetic-data
example have been run. See [validation results](outputs/VALIDATION.md) for the
results and remaining full-budget checks.

## Scope and provenance

These scripts implement the published examples. The [data guide](data/README.md)
and [replication record](references/replication-notes.md) document data preparation,
implementation choices and completed checks. The article's printed scores
are not guaranteed for a different split or environment.

[Series guide](../README.md) · [Part 1](../part1/README.md)
