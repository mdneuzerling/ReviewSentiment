infert <- randomForest(
  as.factor(case) ~ .,
  data = datasets::infert,
  importance = TRUE,
  na.action = na.omit
)

test_that("Can generate a ROC curve without error", {
  expect_error(generate_roc(infert, positive = 1), NA)
})

test_that("Metrics contain one row of OOB and AUC", {
  metrics <- generate_metrics(infert, positive = 1)
  expect_equal(colnames(metrics), c("oob", "auc"))
  expect_equal(nrow(metrics), 1)
})
