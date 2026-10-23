# Validation — 12 October 2026

## Completed

- The original data file uses ARFF (Attribute–Relation File Format), a text format that describes column names and types, followed by one patient per row. “Raw” means the downloaded file before workshop preparation. Its checksum (a fingerprint of the file contents) matches the saved OpenML metadata, confirming that the file has not changed.
- 270 complete rows; 13 predictors; target counts 150 absent and 120 present.
- Train/test split: 180/90 disjoint rows covering all patients.
- Default/deep/pruned trees, confusion matrix, five classification measures and three evaluation plots.
- Three-fold CV, 100 subsampling repetitions and 40 bootstrap repetitions at the article's settings.
- Neural network with 22 inputs and the article's architecture/training settings: early stopping after 27 epochs; test accuracy 0.8556. TensorFlow 2.21.0, Python Keras 3.12.4, R keras3 1.5.1.
- Bayesian tuning: all 30 configurations, ten-fold inner CV; held-out accuracy 0.7889.
- Random search: all 500 configurations, ten-fold inner CV; held-out accuracy 0.8111.
- Grid and nested-CV execution paths: reduced smoke runs (grid resolution 2, two folds; nested two evaluations and two inner/outer folds).
- ARF/FORDE/FORGE: 270 synthetic observations, saved separately from real data.
- R scripts parse, notebook executes and renders with its results and figures.

These are locally observed results, not replacements for the article's reported results.
The original notebook reran the core workflow; saved network and tuning outputs came from separate runs.
The teaching route was revised on 23 October 2026: the current notebook reads saved
forest and network results when rendered. Students fit the network interactively;
the tree, forest and resampling script remains a separate extension.
Package versions for the completed full runs are in the accompanying session-info files.

## Not executed at full budget

The resolution-10 grid (up to 10,000 configurations) and the 10 x 10 nested-CV
workflow with 100 evaluations per inner search remain available in the script.
Only their smaller smoke runs were executed. They are not reported as complete replications.

## Environment notes

The installed mlr3learners/XGBoost combination completed the runs but emitted
XGBoost deprecation warnings about legacy parameter passing. MBO invoked its built-in
random-forest surrogate fallback during this run. ARF ran sequentially without
a registered parallel backend.

## Teaching-route checks — 23 October 2026

- The revised notebook and supporting pages render successfully using saved results; no forest or network is trained during rendering.
- The live notebook blocks match the corresponding sections of `R/03-neural-network.R`.
- The saved split contains 180 training patients and 90 test patients, with no overlap. Both models use these same test patients.
- Neural-network preparation produces 22 numerical inputs. Scaling uses only the 144 fitting patients, keeping the 36 validation patients and 90 test patients separate.
- Saved Keras predictions can be evaluated with `mlr3::PredictionClassif`: accuracy 85.6%, sensitivity 78.4%, specificity 90.6%. Forest accuracy is 83.3%, sensitivity 81.1%, specificity 84.9%.
- The revised live training path has not been retrained during this review. The current command-line R session did not locate a configured Keras Python backend. Confirm Keras setup before the live session; the historical training results above remain saved-run results.
