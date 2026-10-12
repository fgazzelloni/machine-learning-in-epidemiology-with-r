# Part 1 — Introduction to Machine Learning in Epidemiology with R

September 2026 session: how a model learns, followed by a West Nile virus prediction workflow.

## Follow the session

1. Open `part1.Rproj` in RStudio; keep `part1/` as the working directory.
2. Run `source("install-packages.R")`, then `source("check-setup.R")`.
3. Start with the [teaching notebook](ml-workflow.qmd).
4. Work through the [student practice script](R/workshop.R).
5. Try the [exercise](exercises/workshop-exercise.R) and compare it with the [solution](solutions/workshop-exercise.R).

[Slide viewer](presentation/index.html) · [PowerPoint](presentation/introduction-to-ml-in-epidemiology-with-r.pptx) · [Rendered notebook](docs/index.html)

The [gradient descent app](app.R) is an optional interactive demonstration.
See the [data guide](data/README.md) and [sources](references/sources.md) for the evidence behind the teaching example.

The student practice requires `rpart` and `rpart.plot`. To run every section of
the instructor notebook, also install `ggplot2`, `dplyr`, `data.table`, `maps`,
`pROC`, `mlr3`, `mlr3learners` and `ranger`.

From this folder, render the teaching notebook with `quarto render`.
Its output is `docs/index.html`. The copied rendered files are the September
snapshot; copying them does not rerun the models.

[Series guide](../README.md) · [Part 2](../part2/README.md)
