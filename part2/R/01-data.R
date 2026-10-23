# Article section 1 and appendix: heart-statlog, OpenML 53, version 1.
# Run from part2/. All preprocessing choices are listed in data/README.md.

# Read the file as text. ARFF stores column descriptions before the data.
arff <- readLines("data/raw/heart-statlog.arff")

# Find the line marking the beginning of the patient records.
start <- grep("^@data", arff, ignore.case = TRUE)

# Join the patient lines and read them as a table.
# The records have no column names; we add those below.
heart <- read.csv(
  text = paste(arff[(start + 1):length(arff)],
               collapse = "\n"),
  header = FALSE, strip.white = TRUE
)

# Give the 13 measurements and the outcome readable column names.
names(heart) <- c(
  "age", "sex", "chest_pain", "resting_blood_pressure",
  "serum_cholesterol", "fasting_blood_sugar", "resting_ecg",
  "max_heart_rate","exercise_induced_angina", "ST_depression",
  "ST_slope", "num_major_vessels","thal", "heart_disease"
)

# Stop if we do not have 270 patients, 14 columns and no missing values.
stopifnot(nrow(heart) == 270L, ncol(heart) == 14L, !anyNA(heart))

# A factor tells R that values represent categories.
# Replace the sex codes with labels: 0 = female, 1 = male.
heart$sex <- factor(heart$sex, c(0, 1), c("female", "male"))

# Label the four chest-pain categories in code order, from 1 to 4.
heart$chest_pain <- factor(
  heart$chest_pain, 1:4,
  c("typical angina", "atypical angina",
    "non-anginal pain", "asymptomatic")
)

# Fasting blood sugar above 120 mg/dL: 0 = false, 1 = true.
heart$fasting_blood_sugar <- factor(
  heart$fasting_blood_sugar,
  c(0, 1),
  c("false", "true")
)

# Label the resting electrocardiogram (ECG) results, coded 0, 1 and 2.
heart$resting_ecg <- factor(
  heart$resting_ecg, 0:2,
  c("normal", "ST-T wave abnormality", "left ventricular hypertrophy")
)

# Chest pain during exercise: 0 = no, 1 = yes.
heart$exercise_induced_angina <- factor(
  heart$exercise_induced_angina,
  c(0, 1),
  c("no", "yes")
)

# Label the slope of the ECG ST segment at peak exercise, coded 1 to 3.
heart$ST_slope <- factor(heart$ST_slope, 1:3,
                         c("upsloping", "flat", "downsloping"))

# Label the thal test results: 3 = normal, 6 = fixed defect,
# 7 = reversible defect.
heart$thal <- factor(
  heart$thal,
  c(3, 6, 7),
  c("normal", "fixed defect", "reversible defect")
)

# The outcome already uses absent/present labels. Store it as a factor.
heart$heart_disease <- factor(heart$heart_disease,
                              c("absent", "present"))

# Keep measurements and the vessel count as numbers.
# ST_depression measures the ECG change during exercise relative to rest.
numeric_columns <- c(
  "age", "resting_blood_pressure", "serum_cholesterol",
  "max_heart_rate", "ST_depression", "num_major_vessels"
)

# Apply the same numeric conversion to each selected column.
heart[numeric_columns] <- lapply(heart[numeric_columns], as.numeric)

# Check that labelling introduced no missing values and that the outcome
# still contains 150 absent and 120 present cases.
stopifnot(
  !anyNA(heart),
  identical(
    as.integer(table(heart$heart_disease)),
    c(
      150L,
      120L
    )
  )
)

# Create folders for later results and plots if they do not already exist.
dir.create("outputs", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)

# Save the prepared table separately, leaving the raw file unchanged.
write.csv(heart, "data/processed/heart.csv", row.names = FALSE)
