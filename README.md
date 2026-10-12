# Machine Learning in Epidemiology with R

A two-part R-Ladies Rome workshop series led by Federica Gazzelloni.

| Session | Focus | Start here |
| --- | --- | --- |
| Part 1 — September 2026 | How a model learns, gradient descent and West Nile virus prediction | [Part 1 materials](part1/README.md) |
| Part 2 — 23 October 2026 | Replicate the article’s heart-disease workflow | [Part 2 materials](part2/README.md) |

## Working with the materials

Download or clone this repository. Open the RStudio project for the session you
want to use: `part1/part1.Rproj` or `part2/part2.Rproj`. Keep that session folder
as the working directory so its relative paths resolve correctly.

```text
part1/
  part1.Rproj
  ml-workflow.qmd       September teaching notebook
  R/                   student practice
  exercises/           participant exercise
  solutions/           completed exercise
  data/                frozen West Nile teaching data
  presentation/        slide viewer and PowerPoint
  docs/                existing rendered September notebook and slides
  figures/             teaching figures
  outputs/             saved results
  references/          sources and reference article
part2/
  part2.Rproj
  ml-workflow-2.qmd     article-based October workshop
  R/                   data, trees, network, tuning and synthetic-data scripts
  data/                frozen OpenML heart-disease snapshot
  outputs/             observed results and validation record
  _quarto.yml          separate Part 2 rendering configuration
```

## Original workshop links

The [original September repository](https://github.com/fgazzelloni/Intro-to-ml-in-epidemiology-with-r)
and its published website remain separate. Existing attendees can continue using
the links they saved. This repository provides the newly organized series;
it does not replace or redirect the original repository.

Part 1 was copied from original commit `67316fc`. Teaching sources, data, slides
and saved results were preserved byte for byte. Part 2 implements the article’s published heart-disease workflow.
Its [validation record](part2/outputs/VALIDATION.md) distinguishes completed
runs from full-budget checks still outstanding.
