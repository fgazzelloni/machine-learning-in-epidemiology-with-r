# Source and replication record

- Wright et al. (2026), [Machine Learning in Epidemiology, arXiv v1](https://arxiv.org/html/2602.16352v1).
- [Companion repository cited in the article](https://github.com/bips-hb/epi-handbook-ml): returned HTTP 404 on 12 October 2026, including authenticated GitHub API access.
- [OpenML dataset 53](https://www.openml.org/d/53), version 1; saved metadata and raw data are in `data/raw/`.

This is an implementation of the article's published workflow, not a verified
copy of the unavailable companion code. New explanatory prose and scripts were
written for this workshop. Models and settings follow the published examples.

| Article section | Workshop implementation | Status |
| --- | --- | --- |
| 1 and appendix | `R/01-data.R` | Matching OpenML data, documented category mapping |
| 2.1.3 | `R/02-trees-and-evaluation.R` | CART, deep tree, cp plot, pruning at 0.031 |
| 2.2.3 | `R/03-neural-network.R` | 22 inputs, 64/32 units, dropout 0.4, Adam 0.002, 50 epochs, batch 32, 20% validation, patience 10 |
| 3.1 and 3.2 | `R/02-trees-and-evaluation.R` | Random forest, confusion, five measures, ROC/threshold/PR, 100-tree train/test AUC, 3-fold CV, 100 subsamples, 40 bootstraps |
| 4.2 and 4.3 | `R/04-tuning.R` | Grid/random/MBO and nested CV with article budgets; full searches require explicit invocation |
| 5 | Notebook discussion | No executable iml example is printed in the paper |
| 6.2.5 | `R/05-synthetic-data.R` | ARF, FORDE and FORGE |

## Changes required to make the examples runnable

The paper omits data preparation, seeds, train/test objects in some snippets
and parts of tuning code (shown as ellipses). The scripts add these definitions,
use `heart_task` consistently and set explicit local seeds. Keras uses `keras3`
instead of the article's older `keras` interface, retaining the architecture
and training settings. Data encoding/scaling choices are recorded in the data guide.
Random-forest threading is fixed to one for reproducibility. The initial forest
uses the learner default; the resampling examples use 100 trees, as printed.
Tuning is restricted to the training task; nested CV uses an outer and inner
10-fold design. The article's full grid has up to 10,000 configurations and is
not run during a normal notebook render.

The article reports a 100% neural-network test accuracy. That is a reported
result for its run, not an expected or guaranteed workshop result. Our outputs
are saved separately. Matching all printed numeric results requires the missing
original seeds, split, preprocessing and software environment.

## Validation

See [the validation record](../outputs/VALIDATION.md) for completed runs, observed scores, environment warnings and the two full-budget runs still outstanding.
