# Source and replication record

- Wright et al. (2026), [Machine Learning in Epidemiology, arXiv v1](https://arxiv.org/html/2602.16352v1).
- [OpenML dataset 53](https://www.openml.org/d/53), version 1; saved metadata and raw data are in `data/raw/`.

The scripts retain the article's published examples and model settings. The main
lesson uses a student-facing order: read saved random forest results, then fit a
neural network with Keras and evaluate its predictions with mlr3. Tree fitting,
resampling, tuning and synthetic data remain separate extensions. Rendering the
notebook reads saved results without refitting either model.

| Article section | Workshop implementation | Status |
| --- | --- | --- |
| 1 and appendix | `R/01-data.R` | Matching OpenML data, documented category mapping |
| 2.1.3 | `R/02-trees-and-evaluation.R` | CART, deep tree, cp plot, pruning at 0.031 |
| 2.2.3 | `R/03-neural-network.R` | 22 inputs, 64/32 units, dropout 0.4, Adam 0.002, 50 epochs, batch 32, 20% validation, patience 10 |
| 3.1 and 3.2 | `R/02-trees-and-evaluation.R` | Random forest, confusion, five measures, ROC/threshold/PR, 100-tree train/test AUC, 3-fold CV, 100 subsamples, 40 bootstraps |
| 4.2 and 4.3 | `R/04-tuning.R` | Grid/random/MBO and nested CV with article budgets; full searches require explicit invocation |
| 5 | Optional follow-up discussion | No executable iml example is printed in the paper |
| 6.2.5 | `R/05-synthetic-data.R` | ARF, FORDE and FORGE |

## Workshop implementation

The scripts define data preparation, train/test objects and tuning code,
use `heart_task` consistently and set explicit seeds. Keras uses `keras3`
instead of the article's older `keras` interface, retaining the architecture
and training settings. The network now reads `outputs/split.csv` to reuse the
forest's saved training/test patients explicitly. Keras predictions are wrapped
in an mlr3 `PredictionClassif` object to evaluate both models using the same
measures. Data encoding/scaling choices are recorded in the data guide.
Random-forest threading is fixed to one for reproducibility. The initial forest
uses the learner default; the resampling examples use 100 trees, as printed.
Tuning is restricted to the training task; nested CV uses an outer and inner
10-fold design. The article's full grid has up to 10,000 configurations and is
not run during a normal notebook render.

The article reports a 100% neural-network test accuracy. That is a reported
result for its run, not an expected or guaranteed workshop result. Our outputs
are saved separately. Results depend on the random seed, data split, preprocessing and software versions.

## Validation

See [the validation record](../outputs/VALIDATION.md) for completed runs, observed scores, environment warnings and the two full-budget runs still outstanding.
