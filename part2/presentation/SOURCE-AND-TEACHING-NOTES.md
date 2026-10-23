# Part 2 presentation: sources and teaching record

23 October 2026 · Federica Gazzelloni

18 main slides and five optional appendix slides. All slides contain embedded speaker notes with explanation, transition, source and demonstration/question cues. Text and tables are editable. Supplied model figures remain raster images. The PDF is a visual copy rendered from the slides.

## Two-hour timing plan

| Minutes | Slides | Activity |
|---|---|---|
| 0–10 | 1–3 | Reconnect with Part 1 and introduce the route |
| 10–25 | 4–5 | Inspect the data in R and define the classification task |
| 25–50 | 6–8 | Fit trees, compare complexity and discuss pruning |
| 50–70 | 9–11 | Inspect the architecture and saved neural-network results |
| 70–95 | 12–14 | Fit the forest, read the confusion matrix and calculate measures |
| 95–110 | 15–17 | Explore ROC, precision–recall and probability thresholds |
| 110–120 | 18 | Discussion, limitations and questions |

Suggested allocation: 40 minutes explanation, 60 minutes R demonstration and participant practice, 20 minutes discussion. Appendix slides are follow-up study, outside the two-hour route.

## Source map

Paths below are relative to `part2/`, unless specified otherwise.

- Design: original `part1/presentation/introduction-to-ml-in-epidemiology-with-r.pptx`. All 12 reference slides were rendered and inspected. Retained Avenir Next, 16:9 geometry, navy/teal/cream palette, cover artwork, header numbering and small footer convention. The Part 2 content is a separate deck.
- Sequence and main scope: `ml-workflow-2.qmd`, sections 1–4. Extensions follow sections 5–8.
- Slides 4–5: `R/01-data.R`, `data/guide.qmd`, its included `data/README.md`, `data/processed/heart.csv` and `outputs/VALIDATION.md`.
- Slides 6–8: `R/02-trees-and-evaluation.R`; saved `figures/01-tree.png`, `02-complexity.png` and `03-pruned-tree.png`. The deep-tree illustration was additionally rendered from the supplied `minsplit = 2` expression using the prepared data, without rerunning or overwriting workshop outputs. It illustrates fitted structure only.
- Slides 9–11: `R/03-neural-network.R`, data guide, `figures/05-neural-loss.png`, `outputs/neural-loss.csv`, `neural-accuracy.csv`, `neural-predictions.csv`. Architecture and encoding explanations are conceptual. Saved run: 27 epochs and test accuracy 77/90, rounded to 0.8556 in notes.
- Slides 12–17: `R/02-trees-and-evaluation.R`, `outputs/split.csv`, `confusion.csv`, `holdout-measures.csv`, and saved `figures/04-roc.png`, `04-prc.png`, `04-threshold.png`.
- Appendix: `R/02-trees-and-evaluation.R` through `R/05-synthetic-data.R`, notebook sections 5–8, `outputs/VALIDATION.md`, `references/replication-notes.md`.
- Published workflow: Wright et al. (2026), [Machine Learning in Epidemiology, arXiv v1](https://arxiv.org/html/2602.16352v1). Article-section mapping comes from the supplied replication record. This deck does not claim independent revalidation of the paper.
- Dataset: [OpenML heart-statlog, ID 53, version 1](https://www.openml.org/d/53). Frozen metadata and source data are in `data/raw/`.

## Verified local results

The displayed matrix uses observed outcomes as rows and predicted outcomes as columns. The source CSV uses `response`, `truth`, `Freq`.

| Result | Count or calculation |
|---|---|
| True positive | 30 |
| False negative | 7 |
| False positive | 8 |
| True negative | 45 |
| Sensitivity | 30/37 = 81.1% |
| Specificity | 45/53 = 84.9% |
| Positive predictive value | 30/38 = 78.9% |
| Negative predictive value | 45/52 = 86.5% |
| Accuracy | 75/90 = 83.3% |

These are supplied locally observed random-forest holdout results. They are not article-reported values. The separate `train-test-auc.csv` concerns a 100-tree forest and is deliberately not used to label the main forest ROC. No numerical AUC is added to that plot.

## Evidence gaps and limits

- The article does not specify the 22-column encoding or scaling implementation. The workshop explicitly reconstructs these choices and fits scaling using inner training rows only.
- Initial full-dataset trees illustrate fitting. Their fitted accuracy cannot estimate new-patient performance.
- Full resolution-10 grid and full-budget nested CV have not completed. Only reduced smoke runs passed. Full random search and MBO are documented as completed in the supplied validation record.
- Feature interpretation is conceptual: no computed rankings, feature-effect plots or local explanations are supplied.
- The threshold figure shows classification error, not separate sensitivity/specificity curves. The slide explains the latter tradeoff conceptually and does not claim an optimal threshold.
- A full deep-tree overview is too dense for leaf-by-leaf screen reading. Use its structure for comparison and open the R plot when tracing leaves. The default tree is shown separately at a larger size.
- Network training remains optional and requires Python/Keras configuration. Saved outputs support the main session.
- No clinical validation, external population validation or causal identification is established. Isolated scores do not justify ranking models under differing evaluation conditions.
- The PDF is a raster visual copy because the presentation runtime's direct PDF export failed on a missing bundled font module. The PowerPoint contains editable text and tables plus original figure images.

## Preservation

Original Part 1 and workshop files were preserved. No upload or publication was performed. Existing generated website changes were left untouched.
