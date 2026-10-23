const slides = [
  {
    "title": "Introduction to Machine Learning in Epidemiology with R",
    "section": "Part 1",
    "text": "Introduction to\nMachine Learning\nin Epidemiology\nwith R\nFrom epidemiological questions to prediction, evaluation and interpretation\nFederica Gazzelloni  •  R-Ladies Rome"
  },
  {
    "title": "What machine learning means in an epidemiological context",
    "section": "Part 1",
    "text": "What machine learning means in an epidemiological context\nMachine learning asks whether patterns in observed data can make useful predictions for new observations.\nIn epidemiology, the workflow must also respect:\nThe population and setting that generated the data\nWhen predictors and outcomes become available\nSurveillance, selection and measurement processes\nThe consequences of false positives and false negatives\nPrediction quality depends on both the model and the data-generating process.\nIntroduction to Machine Learning in Epidemiology with R"
  },
  {
    "title": "From an epidemiological question to a prediction task",
    "section": "Part 1",
    "text": "From an epidemiological question to a prediction task\n1\nQuestion\nWhat decision could a prediction support?\n2\nUnit\nWho or what receives one prediction?\n3\nOutcome\nWhat event and prediction horizon matter?\n4\nPredictors\nWhat information exists at prediction time?\n5\nEvaluation\nWhich errors matter in practice?\nIllustrative workshop framing\nPredict whether reported activity will be elevated in a future period, using only information available before that period begins.\nIntroduction to Machine Learning in Epidemiology with R"
  },
  {
    "title": "Preparing data for machine learning",
    "section": "Part 1",
    "text": "Preparing data for machine learning\nKeep time honest\nCreate predictors from information already observed.\nMatch the unit\nOne row should correspond to one prediction unit.\nBuild inside resampling\nEstimate preprocessing steps from training folds only.\nIntroduction to Machine Learning in Epidemiology with R"
  },
  {
    "title": "Logistic regression as a baseline model",
    "section": "Part 1",
    "text": "Logistic regression as a baseline model\nA baseline gives the more flexible models something meaningful to beat.\nlearner_log = lrn(\"classif.log_reg\",\n  predict_type = \"prob\")\n\nlearner_log$train(task, row_ids = train_ids)\npred_log = learner_log$predict(task, row_ids = test_ids)\nWhy start here\nProduces predicted probabilities for a binary outcome\nProvides a familiar, interpretable reference point\nReveals whether added flexibility improves unseen-data performance\nThe comparison concerns prediction. Coefficients do not become causal effects automatically.\nIntroduction to Machine Learning in Epidemiology with R"
  },
  {
    "title": "Decision trees and random forests",
    "section": "Part 1",
    "text": "Decision trees and random forests\nIncreasing flexibility changes both what the model can learn and how easily we can explain it.\nQuestion\nDecision tree\nRandom forest\nHow it learns\nRecursive splits form one tree\nMany trees learn from varied samples and features\nMain strength\nEasy to inspect and explain\nOften improves prediction and stability\nMain risk\nCan change sharply with small data changes\nIndividual prediction logic becomes less transparent\nmlr3 learner\nclassif.rpart\nclassif.ranger\nModel complexity earns its place only when performance improves on data the model has not seen.\nIntroduction to Machine Learning in Epidemiology with R"
  },
  {
    "title": "Training and evaluating models with mlr3",
    "section": "Part 1",
    "text": "Training and evaluating models with mlr3\nTask\nLearner\nTrain\nPredict\nEvaluate\ntask = as_task_classif(dat, target = \"outcome\", positive = \"yes\")\nlearner = lrn(\"classif.ranger\", predict_type = \"prob\")\nrr = resample(task, learner, rsmp(\"cv\", folds = 5))\nrr$aggregate(msrs(c(\"classif.auc\", \"classif.sensitivity\",\n  \"classif.specificity\")))\nThe same task, folds and measures make model comparisons reproducible.\nIntroduction to Machine Learning in Epidemiology with R"
  },
  {
    "title": "Cross-validation and performance on unseen data",
    "section": "Part 1",
    "text": "Cross-validation and performance on unseen data\nFive-fold cross-validation rotates the test fold so every observation is evaluated once.\nFold 1\nTEST\nTRAIN\nTRAIN\nTRAIN\nTRAIN\nFold 2\nTRAIN\nTEST\nTRAIN\nTRAIN\nTRAIN\nFold 3\nTRAIN\nTRAIN\nTEST\nTRAIN\nTRAIN\nFold 4\nTRAIN\nTRAIN\nTRAIN\nTEST\nTRAIN\nFold 5\nTRAIN\nTRAIN\nTRAIN\nTRAIN\nTEST\nResampling estimates generalisation performance. It does not remove overfitting or repair a flawed split strategy.\nFor time series, repeated geography or clustered data, use folds that preserve those structures.\nIntroduction to Machine Learning in Epidemiology with R"
  },
  {
    "title": "Sensitivity, specificity, confusion matrices and ROC/AUC",
    "section": "Part 1",
    "text": "Sensitivity, specificity, confusion matrices and ROC/AUC\nIllustrative values\n\nPredicted +\nPredicted −\nObserved +\n8\nObserved −\nSensitivity = 32 / 40 = 80%\nSpecificity = 48 / 60 = 80%\nROC shows sensitivity across thresholds. AUC summarises ranking performance, not the consequences of a chosen threshold.\nIntroduction to Machine Learning in Epidemiology with R"
  },
  {
    "title": "Variable importance and model interpretation",
    "section": "Part 1",
    "text": "Variable importance and model interpretation\nIllustrative permutation importance\nPermutation importance asks:\nHow much does predictive performance worsen when one feature is disrupted?\nUse held-out data for performance-based importance\nCorrelated features can share or mask importance\nImportance ranks predictive contribution, not causal influence\nIntroduction to Machine Learning in Epidemiology with R"
  },
  {
    "title": "Prediction versus explanation and causation",
    "section": "Part 1",
    "text": "Prediction versus explanation and causation\nPrediction\nExplanation and causation\nGoal\nEstimate outcomes accurately for new observations\nGoal\nUnderstand a relationship or intervention effect\nSuccess\nStable performance on unseen data\nSuccess\nA defensible design and assumptions for inference\nA highly predictive feature may be a proxy, a consequence of disease, or a product of the surveillance system.\nGood prediction alone does not establish a cause.\nIntroduction to Machine Learning in Epidemiology with R"
  },
  {
    "title": "Limitations, bias and data quality in epidemiological machine learning",
    "section": "Part 1",
    "text": "Limitations, bias and data quality in epidemiological machine learning\nA technically correct pipeline can still produce misleading predictions when:\nCases are missed or reported differently across place and time\nThe training population differs from the population of use\nMissingness carries information that the model handles poorly\nHistorical inequities become patterns the model repeats\nPerformance drifts as surveillance and disease dynamics change\nTrust requires data checks, appropriate validation, transparent interpretation and continued monitoring."
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
  slide.src = `slides/slide-${number}.png`;
  slide.alt = `Slide ${number}: ${item.title}`;
  status.textContent = `Slide ${number} of ${slides.length} · ${item.section} · ${item.title}`;
  document.querySelector("#slide-text").textContent = item.text;
  document.title = `${item.title} | Part 1 presentation`;
  picker.value = String(current);
  if (window.location.hash !== `#slide-${number}`) window.location.hash = `slide-${number}`;
  const preload = new Image();
  preload.src = `slides/slide-${(current + 1) % slides.length + 1}.png`;
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
