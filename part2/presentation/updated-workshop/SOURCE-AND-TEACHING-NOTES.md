# Part 2 presentation — revised teaching route

23 October 2026 · Federica Gazzelloni

Use `heart-data-neural-networks.pptx` for the current workshop. Its matching PDF
is a visual copy. The earlier presentation and its teaching record remain in
the parent directory unchanged.

The revised presentation contains 19 main slides and 10 appendix slides. Main
slides follow the current notebook: read saved random forest results, prepare
inputs, build and fit a Keras neural network, and evaluate its predictions with
mlr3. All slides have speaker notes. The original cover artwork, Avenir Next
font, colours, slide dimensions, figures and editable table style are retained.

## Two-hour session

| Minutes | Slides | Activity |
| --- | --- | --- |
| 0–15 | 1–4 | Introduce the question and inspect the heart data |
| 15–35 | 5–8 | Read the saved forest matrix, three measures and ROC curve |
| 35–55 | 9–10 | Define the mlr3 task, reuse the saved split and prepare inputs |
| 55–75 | 11–14 | Explain the network, build it in Keras and compile it |
| 75–95 | 15–16 | Fit the network and inspect training and validation loss |
| 95–115 | 17–18 | Evaluate Keras predictions with mlr3 and compare the saved runs |
| 115–120 | 19 | Discuss the results and conclude |

Slides 20–29 are follow-up material: trees/pruning, precision–recall,
thresholds, resampling, tuning, interpretation, synthetic records and sources.
They are outside the two-hour route. Do not run the tree/evaluation script in
the main session: it refits the forest and runs resampling.

The Keras R package and a working Python backend must be configured before the
session. The current command-line R session did not locate that backend during
the notebook review. Live training has not been rehearsed in this presentation
update. Saved results support discussion if a participant cannot train locally.

## Notebook and source map

Paths below are relative to `part2/`.

| Slides | Notebook section | Supporting files |
| --- | --- | --- |
| 1–4 | Introduction and 1 | `R/01-data.R`, `data/README.md`, `data/processed/heart.csv` |
| 5–8 | 2 | `outputs/split.csv`, `confusion.csv`, `holdout-measures.csv`, `figures/04-roc.png` |
| 9 | 3 | `R/03-neural-network.R`, `neural-task` block |
| 10 | 4 | `neural-inputs` block; `data/README.md` |
| 11–14 | 5 | `neural-build` block |
| 15–16 | 6 | `neural-fit`, `neural-history`, `figures/05-neural-loss.png` |
| 17–18 | 7 | `neural-predict`, `outputs/neural-predictions.csv` and saved forest scores |
| 19 | Main lesson conclusion | `ml-workflow-2.qmd`, `README.md` |
| 20–29 | Where to go next | `R/02-trees-and-evaluation.R` through `R/05-synthetic-data.R`, replication and validation records |

Slides show short code excerpts; run the complete notebook blocks in order.
The task slide loads the split record; the complete notebook block constructs
the train/test row lists. The build and compile slides divide the same
`neural-build` block into two steps. Keras fits the network directly;
`PredictionClassif` brings its predictions into mlr3 for evaluation.

## Saved comparison

Both saved models use the same 90 test patients. These are recorded local runs,
not guaranteed results for a new run or independent clinical validation.

| Measure | Random forest | Neural network |
| --- | --- | --- |
| Accuracy | 75/90 = 83.3% | 77/90 = 85.6% |
| Sensitivity | 30/37 = 81.1% | 29/37 = 78.4% |
| Specificity | 45/53 = 84.9% | 48/53 = 90.6% |
| Missed cases | 7 | 8 |
| False alarms | 8 | 5 |

The saved network has two more correct predictions overall, but one more
missed case. Discuss both the total score and the types of mistake. One small
split does not establish that one method is generally better.

The confusion-matrix slide displays recorded outcomes in rows and predictions
in columns. The notebook displays the transpose; the counts are the same.
The loss figure is explicitly labelled as the saved run. Students use
`plot(training)` to inspect their own run.

## Provenance and checks

- Workflow source: Wright et al. (2026), [Machine Learning in Epidemiology, arXiv v1](https://arxiv.org/html/2602.16352v1).
- Data: [OpenML heart-statlog, dataset 53, version 1](https://www.openml.org/d/53), with the frozen data and metadata under `data/raw/`.
- Model architecture and settings retain the workshop implementation. The 22-column encoding and fitting-only scaling are explicit reconstruction choices; see `data/README.md` and `references/replication-notes.md`.
- Numbers were checked against the saved CSV files. No model was retrained to update the deck.
- Every slide was rendered and visually reviewed. The exported PowerPoint passed package, geometry, font and import checks and retains eight native editable tables.
- The PDF contains high-resolution slide images. The presentation runtime's direct PDF exporter could not resolve its bundled Helvetica module, so the visual PDF was assembled from the final slide renders. Use the PowerPoint to edit slide text or tables.
- No upload or publication was performed. The original PowerPoint, PDF and teaching record were preserved.
