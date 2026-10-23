const slides = [
  {
    "title": "Machine Learning in Epidemiology with R — Part 2",
    "section": "Main session",
    "text": "Machine Learning\nin Epidemiology\nwith R — Part 2\nHeart data and neural networks\nFederica Gazzelloni\n23 October 2026\nTwo-hour online, hands-on R workshop"
  },
  {
    "title": "Learning objectives and session route",
    "section": "Main session",
    "text": "Learning objectives and session route\nMeet the heart data\nRead the saved random forest results\nPrepare inputs and build a network with Keras\nFit the network and evaluate it with mlr3\nCompare mistakes and discuss the results\nExplain the forest results, fit a neural network, and interpret its predictions."
  },
  {
    "title": "West Nile surveillance and heart disease",
    "section": "Main session",
    "text": "West Nile surveillance and heart disease\nPart 1\nPart 2\nWest Nile surveillance\nClinical measurements\nDefine a prediction unit and outcome\nOne patient and existing disease\nPreparation and evaluation\nThe same workflow, new learners\nUse the same learning and evaluation ideas with a new dataset."
  },
  {
    "title": "Meet the heart-disease data",
    "section": "Main session",
    "text": "Meet the heart-disease data\n270\npatients\noriginal predictors\n2\noutcome classes\nheart_disease: 150 absent, 120 present\nExamples: age, chest pain, cholesterol, exercise measurements\nCheckpoint: What does one row represent? Which column is the outcome?"
  },
  {
    "title": "Saved random forest results",
    "section": "Main session",
    "text": "Saved random forest results\n270 patients\n180 training patients\n90 test patients\nThe forest learned from these rows\nThese rows were kept aside\nTraining is already complete\nRead the saved predictions today\nUse the saved results today. We will not fit another random forest."
  },
  {
    "title": "Correct predictions and mistakes",
    "section": "Main session",
    "text": "Correct predictions and mistakes\nObserved outcome\nPredicted present\nPredicted absent\nPresent\n30 true positives\n7 false negatives\nAbsent\n8 false positives\n45 true negatives\nFalse positive: predicts disease for a patient whose outcome is absent.\nDiscuss: what could a missed case or a false alarm mean for a patient?"
  },
  {
    "title": "Accuracy, sensitivity and specificity",
    "section": "Main session",
    "text": "Accuracy, sensitivity and specificity\nMeasure\nWhat does it count?\nSaved result\nAccuracy\nCorrect predictions: 75 / 90\n83.3%\nSensitivity\nCases detected: 30 / 37\n81.1%\nSpecificity\nNon-cases identified: 45 / 53\n84.9%\nAccuracy alone can hide which patients the model gets wrong."
  },
  {
    "title": "Probability thresholds and the ROC curve",
    "section": "Main session",
    "text": "Probability thresholds and the ROC curve\nLowering the cut-off\nusually catches more cases.\nIt also produces\nmore false alarms.\nThe curve compares choices\nacross different cut-offs.\nDiscuss: would accuracy alone tell us which cut-off to choose?"
  },
  {
    "title": "Organise the task with mlr3",
    "section": "Main session",
    "text": "Organise the task with mlr3\nDefine the outcome, then reuse the saved training and test groups.\nlibrary(mlr3)\nheart_task <- as_task_classif(\n  heart,\n  target = \"heart_disease\",\n  positive = \"present\",\n  id = \"heart\"\n)\nsplit_record <- read.csv(\"outputs/split.csv\")\nIn notebook section 3, load the same 180 training and 90 test row numbers."
  },
  {
    "title": "Prepare numerical inputs",
    "section": "Main session",
    "text": "Prepare numerical inputs\nKeep the outcome separate from the predictors.\nTurn categories into 0/1 values and indicator columns.\nScale measurements using fitting patients only.\nCheck: ncol(x) is 22; y is 1 for present and 0 for absent.\nRun the input-preparation block in notebook section 4."
  },
  {
    "title": "A neural network learns weighted combinations",
    "section": "Main session",
    "text": "A neural network learns weighted combinations\nInputs\nHidden layers\nOutput\nEncoded measurements\nWeighted combinations\nProbability of present\nNumbers the network receives\nReLU transforms learned signals\nSigmoid maps to 0–1\nTraining adjusts weights to reduce a loss: a measure of prediction error."
  },
  {
    "title": "13 predictors become 22 encoded inputs",
    "section": "Main session",
    "text": "13 predictors become 22 encoded inputs\nInput\nHidden layer 1\nHidden layer 2\nOutput\n22 columns\n64 units, ReLU\n32 units, ReLU\n1 unit, sigmoid\n6 numeric + 3 binary\n+ 13 indicators\nDropout 0.4\nDropout 0.4\nP(disease present)\nDropout temporarily omits 40% of units during training.\nThe 13 measurements become 22 numerical input columns."
  },
  {
    "title": "Build the network with Keras",
    "section": "Main session",
    "text": "Build the network with Keras\nEach layer passes its learned signals to the next layer.\nlibrary(keras3)\nset_random_seed(20261023)\nnetwork <- keras_model_sequential(input_shape = c(22)) |>\n  layer_dense(units = 64, activation = \"relu\") |>\n  layer_dropout(rate = 0.4) |>\n  layer_dense(units = 32, activation = \"relu\") |>\n  layer_dropout(rate = 0.4) |>\n  layer_dense(units = 1, activation = \"sigmoid\")\nRun this definition after preparing x and y in the notebook."
  },
  {
    "title": "Choose how the network learns",
    "section": "Main session",
    "text": "Choose how the network learns\nThe optimiser updates weights; the loss measures prediction error.\ncompile(network,\n  optimizer = optimizer_adam(learning_rate = 0.002),\n  loss = \"binary_crossentropy\", metrics = \"accuracy\"\n)\nBinary cross-entropy measures error for this two-class outcome."
  },
  {
    "title": "Fit the network",
    "section": "Main session",
    "text": "Fit the network\nKeep 20% of the training group for validation while the network learns.\ntraining <- fit(\n  network,\n  x[split$train, ],\n  y[split$train],\n  epochs = 50,\n  batch_size = 32,\n  validation_split = 0.2,\n  verbose = 1,\n  callbacks = list(callback_early_stopping(patience = 10, restore_best_weights = TRUE))\n)\n144 patients update weights; 36 monitor learning; 90 remain for final testing."
  },
  {
    "title": "Read the training and validation loss",
    "section": "Main session",
    "text": "Read the training and validation loss\nTraining loss measures fit\non rows used for learning.\nValidation loss monitors\nrows kept out of updates.\nEarly stopping restores\nthe best validation weights.\nRun plot(training). The displayed figure is the saved workshop run."
  },
  {
    "title": "Evaluate Keras predictions with mlr3",
    "section": "Main session",
    "text": "Evaluate Keras predictions with mlr3\nPredict the 90 test patients, then compare predictions with their outcomes.\nprob <- as.numeric(predict(network, x[split$test, ], verbose = 0))\nclass <- ifelse(prob >= 0.5, \"present\", \"absent\")\nnetwork_pred <- PredictionClassif$new(\n  task = heart_task, row_ids = split$test,\n  truth = heart_task$truth(rows = split$test),\n  response = class,\n  prob = cbind(present = prob, absent = 1 - prob)\n)\nnetwork_pred$confusion\nnetwork_pred$score(msrs(c(\"classif.acc\", \"classif.tpr\", \"classif.tnr\")))\nThe same three measures let us compare the network with the saved forest."
  },
  {
    "title": "Compare the saved model results",
    "section": "Main session",
    "text": "Compare the saved model results\nMeasure\nRandom forest\nNeural network\nAccuracy\n83.3%\n85.6%\nSensitivity\n81.1%\n78.4%\nSpecificity\n84.9%\n90.6%\nThe saved network is more accurate overall, but misses one more case."
  },
  {
    "title": "Workflow and limits",
    "section": "Main session",
    "text": "Workflow and limits\nRead the saved forest results and explain its mistakes.\nPrepare inputs, then build and fit the Keras network.\nUse mlr3 to evaluate predictions on the same test patients.\nCompare accuracy and error types before drawing conclusions.\nThese teaching results establish neither clinical validation nor causation."
  },
  {
    "title": "Appendix: how a decision tree works",
    "section": "Appendix",
    "text": "Appendix: how a decision tree works\nA split asks a question\nabout one predictor.\nFollow a branch until\nyou reach a leaf.\nA leaf gives a class\nand fitted proportions.\nDefault tree: fitted on all 270 patients to illustrate learning."
  },
  {
    "title": "Appendix: deep and pruned trees",
    "section": "Appendix",
    "text": "Appendix: deep and pruned trees\nDeep tree: minsplit = 2\nPruned tree: cp = 0.031\nCompare both with the default tree. More branches can fit details of this sample."
  },
  {
    "title": "Appendix: overfitting and pruning",
    "section": "Appendix",
    "text": "Appendix: overfitting and pruning\nOverfitting learns sample\ndetails that may not repeat.\nPruning removes branches\nto limit complexity.\ncp = 0.031 retains the\narticle’s replication setting.\nCheckpoint: Why might pruning help predictions on new patients?"
  },
  {
    "title": "Appendix: precision and recall",
    "section": "Appendix",
    "text": "Appendix: precision and recall\nRecall = sensitivity.\nPrecision = positive\npredictive value.\nThe curve shows their\ntradeoff across thresholds.\nDisease frequency matters when interpreting precision and comparing datasets."
  },
  {
    "title": "Appendix: probability thresholds",
    "section": "Appendix",
    "text": "Appendix: probability thresholds\nLower threshold usually\nraises sensitivity and\nreduces specificity.\nHigher threshold usually\nreduces sensitivity and\nraises specificity.\nCheckpoint: How would lowering the threshold affect missed disease and false alarms?"
  },
  {
    "title": "Appendix: resampling",
    "section": "Appendix",
    "text": "Appendix: resampling\nCross-validation rotates which fold stays out of fitting.\nRepeated subsampling draws different training/test splits.\nBootstrap samples training rows with replacement.\nCompleted locally: 3-fold CV, 100 subsamples and 40 bootstrap repetitions."
  },
  {
    "title": "Appendix: tuning and nested cross-validation",
    "section": "Appendix",
    "text": "Appendix: tuning and nested cross-validation\nA hyperparameter controls how a model learns.\nInner resampling selects settings within training data.\nOuter folds assess the whole selection procedure.\nFull grid search and full-budget nested CV remain unexecuted. Only reduced smoke runs passed."
  },
  {
    "title": "Appendix: interpretation",
    "section": "Appendix",
    "text": "Appendix: interpretation\nApproach\nQuestion\nFeature importance\nWhich predictors contribute to this fitted model?\nFeature effects\nHow do predictions vary with a predictor?\nLocal explanation\nWhat helps explain this one prediction?\nConceptual extension. No computed feature ranking or local explanation is supplied."
  },
  {
    "title": "Appendix: synthetic observations",
    "section": "Appendix",
    "text": "Appendix: synthetic observations\nA generator learns patterns from the observed data.\nGenerate artificial records with the fitted distribution.\nCompare age summaries and outcome proportions with heart.\nGenerated rows are synthetic examples. They are not additional observed patients."
  },
  {
    "title": "Appendix: sources and reproducibility",
    "section": "Appendix",
    "text": "Appendix: sources and reproducibility\nWright et al. (2026), Machine Learning in Epidemiology\narXiv:2602.16352v1, sections 2–6\nOpenML heart-statlog, dataset 53, version 1\nLocal notebook, scripts, saved figures and output records\nSource details, timing and evidence gaps accompany this deck."
  }
];

const slide = document.querySelector("#slide");
const status = document.querySelector("#slide-status");
const previous = document.querySelector(".nav-button--previous");
const next = document.querySelector(".nav-button--next");
const fullscreen = document.querySelector("#fullscreen");
const picker = document.querySelector("#slide-picker");
const stage = document.querySelector(".stage");
let current = 0;
let touchStart = null;

slides.forEach((item, index) => {
  const option = document.createElement("option");
  option.value = index;
  option.textContent = `${index + 1}. ${item.title}`;
  picker.append(option);
});

function slideFromHash() {
  const match = window.location.hash.match(/^#slide-(\d+)$/);
  const number = match ? Number(match[1]) : 1;
  return Number.isInteger(number) && number >= 1 && number <= slides.length ? number - 1 : 0;
}

function showSlide(index) {
  current = (index + slides.length) % slides.length;
  const number = current + 1;
  const item = slides[current];
  slide.src = `slides/slide-${String(number).padStart(2, "0")}.png`;
  slide.alt = `Slide ${number}: ${item.title}`;
  status.textContent = `Slide ${number} of ${slides.length} · ${item.section} · ${item.title}`;
  document.querySelector("#slide-text").textContent = item.text;
  document.title = `${item.title} | Part 2 presentation`;
  picker.value = String(current);
  if (window.location.hash !== `#slide-${number}`) window.location.hash = `slide-${number}`;
  const preload = new Image();
  preload.src = `slides/slide-${String((current + 1) % slides.length + 1).padStart(2, "0")}.png`;
}
previous.addEventListener("click", () => showSlide(current - 1));
next.addEventListener("click", () => showSlide(current + 1));
picker.addEventListener("change", () => showSlide(Number(picker.value)));

document.addEventListener("keydown", (event) => {
  if (event.altKey || event.ctrlKey || event.metaKey || event.target.closest("input, select, textarea, button, a, summary, [contenteditable]")) return;
  if (["ArrowRight", "PageDown", " "].includes(event.key)) {
    event.preventDefault(); showSlide(current + 1);
  } else if (["ArrowLeft", "PageUp"].includes(event.key)) {
    event.preventDefault(); showSlide(current - 1);
  } else if (event.key === "Home") {
    event.preventDefault(); showSlide(0);
  } else if (event.key === "End") {
    event.preventDefault(); showSlide(slides.length - 1);
  } else if (event.key === "Escape" && document.documentElement.classList.contains("is-fullscreen")) {
    document.documentElement.classList.remove("is-fullscreen"); updateFullscreen();
  }
});

stage.addEventListener("touchstart", (event) => {
  touchStart = event.touches.length === 1 ? {x: event.touches[0].clientX, y: event.touches[0].clientY} : null;
}, {passive: true});
stage.addEventListener("touchend", (event) => {
  if (!touchStart) return;
  const dx = event.changedTouches[0].clientX - touchStart.x;
  const dy = event.changedTouches[0].clientY - touchStart.y;
  if (Math.abs(dx) > 50 && Math.abs(dx) > Math.abs(dy)) showSlide(current + (dx < 0 ? 1 : -1));
  touchStart = null;
}, {passive: true});
stage.addEventListener("touchcancel", () => { touchStart = null; }, {passive: true});

function updateFullscreen() {
  const active = Boolean(document.fullscreenElement || document.documentElement.classList.contains("is-fullscreen"));
  fullscreen.textContent = active ? "Exit full screen" : "Full screen";
  fullscreen.setAttribute("aria-pressed", String(active));
}
fullscreen.addEventListener("click", async () => {
  try {
    if (document.fullscreenElement) await document.exitFullscreen();
    else if (document.documentElement.classList.contains("is-fullscreen")) document.documentElement.classList.remove("is-fullscreen");
    else if (document.fullscreenEnabled && document.documentElement.requestFullscreen) await document.documentElement.requestFullscreen();
    else document.documentElement.classList.add("is-fullscreen");
  } catch {
    // Browsers that restrict native fullscreen still offer an expanded viewer.
    document.documentElement.classList.toggle("is-fullscreen");
  }
  updateFullscreen();
});
document.addEventListener("fullscreenchange", updateFullscreen);
window.addEventListener("hashchange", () => showSlide(slideFromHash()));
showSlide(slideFromHash());
