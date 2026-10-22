# Article section 1 and appendix: heart-statlog, OpenML 53, version 1.
# Run from part2/. All preprocessing choices are listed in data/README.md.
arff <- readLines("data/raw/heart-statlog.arff")
start <- grep("^@data", arff, ignore.case = TRUE)
heart <- read.csv(text = paste(arff[(start + 1):length(arff)], collapse = "\n"),
                  header = FALSE, strip.white = TRUE)
names(heart) <- c("age", "sex", "chest_pain", "resting_blood_pressure",
  "serum_cholesterol", "fasting_blood_sugar", "resting_ecg", "max_heart_rate",
  "exercise_induced_angina", "ST_depression", "ST_slope", "num_major_vessels",
  "thal", "heart_disease")
stopifnot(nrow(heart) == 270L, ncol(heart) == 14L, !anyNA(heart))
heart$sex <- factor(heart$sex, c(0, 1), c("female", "male"))
heart$chest_pain <- factor(heart$chest_pain, 1:4,
  c("typical angina", "atypical angina", "non-anginal pain", "asymptomatic"))
heart$fasting_blood_sugar <- factor(heart$fasting_blood_sugar, c(0, 1), c("false", "true"))
heart$resting_ecg <- factor(heart$resting_ecg, 0:2,
  c("normal", "ST-T wave abnormality", "left ventricular hypertrophy"))
heart$exercise_induced_angina <- factor(heart$exercise_induced_angina, c(0, 1), c("no", "yes"))
heart$ST_slope <- factor(heart$ST_slope, 1:3, c("upsloping", "flat", "downsloping"))
heart$thal <- factor(heart$thal, c(3, 6, 7), c("normal", "fixed defect", "reversible defect"))
heart$heart_disease <- factor(heart$heart_disease, c("absent", "present"))
numeric_columns <- c("age", "resting_blood_pressure", "serum_cholesterol",
                     "max_heart_rate", "ST_depression", "num_major_vessels")
heart[numeric_columns] <- lapply(heart[numeric_columns], as.numeric)
stopifnot(!anyNA(heart), identical(as.integer(table(heart$heart_disease)), c(150L, 120L)))
dir.create("outputs", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)
write.csv(heart, "data/processed/heart.csv", row.names = FALSE)
