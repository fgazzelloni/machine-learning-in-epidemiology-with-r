# Machine Learning in Epidemiology with R

A two-part R-Ladies Rome workshop series led by Federica Gazzelloni.

## Start here

- [Part 1 README](part1/README.md)
- [Part 2 README](part2/README.md)
- [RStudio project for both parts](machine-learning-in-epidemiology-with-r.Rproj)

## Repository structure

```text
.
├── machine-learning-in-epidemiology-with-r.Rproj
├── index.qmd                     # workshop home
├── about.qmd                    # instructor profile
├── resources.qmd                 # source article and book
├── part1/                       # Part 1 workshop
│   ├── README.md
│   ├── ml-workflow.qmd
│   ├── R/
│   ├── data/
│   ├── presentation/
│   ├── outputs/
│   └── references/
├── part2/                       # October workshop
│   ├── README.md
│   ├── ml-workflow-2.qmd
│   ├── R/
│   ├── data/
│   ├── outputs/
│   └── references/
└── _site/                       # rendered Quarto output
```

## Notes

- Open `machine-learning-in-epidemiology-with-r.Rproj` in RStudio. This single project contains both parts.
- From a fresh project session, run `setwd("part1")` or `setwd("part2")` before running that part’s scripts; their paths are relative to the session folder.
- The original Part 1 workshop repository and its published website remain separate.
- Part 1 preserves the Part 1 teaching materials; Part 2 retains the article workflow and validation notes for locally observed results.

## Build the website

Run `quarto render` from the repository root. The complete website is written to `_site/`, the folder used by the deployment workflow. Older `docs/` and `do/` outputs are not the current preview.
