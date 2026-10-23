# Worked solution to the participant exercise. Run from part1/.
# rpart fits the tree; dplyr selects the rows and columns.
library(rpart)
library(dplyr)

# Keep mosquito-season weeks and the measurements used in the exercise.
wnv <- read.csv("data/processed/wnv_state_week.csv")
wnv <- wnv %>%
  filter(week >= 18, week <= 44) %>%
  select(year, week, cases_last4, active_weeks_last8, activity_next_4w)

# Use shorter names and store the outcome as no/yes categories.
names(wnv) <- c("year", "week", "recent_cases", "recent_active_weeks", "outcome")

wnv$outcome <- factor(wnv$outcome, levels = c("no", "yes"))

# 1. Count observations with and without reported activity.
table(wnv$outcome)

# 2. Learn from earlier years and keep 2025 aside for testing.
train <- subset(wnv, year <= 2024)
test <- subset(wnv, year == 2025)

# 3. Fit a small tree using the three proposed predictors.
tree <- rpart(
  outcome ~ week + recent_cases + recent_active_weeks,
  data = train,
  method = "class",
  control = rpart.control(
    maxdepth = 3,
    minsplit = 30,
    cp = 0.005
  )
)

# 4–5. Predict the unseen observations and compare with recorded outcomes.
test$predicted <- predict(tree, newdata = test, type = "class")
table(Actual = test$outcome, Predicted = test$predicted)

# 6. Interpret what the comparison can tell us.
# The model learned associations that helped classify later observations.
# It did not prove that any predictor causes West Nile virus activity.
