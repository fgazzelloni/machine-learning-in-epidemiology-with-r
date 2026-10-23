# Part 1 — Introduction to Machine Learning in Epidemiology with R

This session covers how a model learns, followed by a West Nile virus prediction workflow.

## Follow the session

1. Open `machine-learning-in-epidemiology-with-r.Rproj` from the repository root in RStudio, then run `setwd("part1")` in the Console. Open the project afresh before switching parts so the Console starts at the repository root.
2. Run `source("install-packages.R")`, then `source("check-setup.R")`.
3. Start with the [teaching notebook](ml-workflow.qmd).
4. Work through the [student practice script](R/workshop.R).
5. Try the [exercise](exercises/workshop-exercise.R) and compare it with the [solution](solutions/workshop-exercise.R).

[Slide viewer](presentation/index.html) · [PDF](presentation/introduction-to-ml-in-epidemiology-with-r.pdf) · [Rendered notebook](docs/index.html)

The [gradient descent app](app.R) is an optional interactive demonstration.
See the [data guide](data/README.md) and [sources](references/sources.md) for the evidence behind the teaching example.

The student practice requires `rpart` and `rpart.plot`. To run every section of
the instructor notebook, also install `ggplot2`, `dplyr`, `data.table`, `maps`,
`pROC`, `mlr3`, `mlr3learners` and `ranger`.

Render the complete website with `quarto render` from the repository root.
The current website output is `_site/`. The copied rendered files are the original workshop
snapshot; copying them does not rerun the models.

[Series guide](../README.md) · [Part 2](../part2/README.md)
