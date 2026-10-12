# Validation — 12 October 2026

## Completed

- Raw ARFF checksum agrees with the saved OpenML metadata.
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
The notebook reruns the core workflow; saved network and tuning outputs come from separate runs.
Package versions for the completed full runs are in the accompanying session-info files.

## Not executed at full budget

The resolution-10 grid (up to 10,000 configurations) and the 10 x 10 nested-CV
workflow with 100 evaluations per inner search remain available in the script.
Only their smaller smoke runs were executed. They are not reported as complete replications.

## Environment notes

The installed mlr3learners/XGBoost combination completed the runs but emitted
XGBoost deprecation warnings about legacy parameter passing. A future XGBoost
release may require an updated mlr3learners version. MBO invoked its built-in
random-forest surrogate fallback during this run. ARF ran sequentially without
a registered parallel backend. Neither warning was treated as a model result.

The authors' companion repository returned 404. Unpublished seeds, data
preparation and environment cannot be verified; see the replication record.
