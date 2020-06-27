#' Generate a confusion matrix from a random forest as a tibble
#'
#' @param rf A model created with the \verb{randomForest} package.
#'
#' @return Tibble.
#'
#' @importFrom dplyr %>%
#' @export
#'
generate_confusion_matrix <- function(rf) {
  rf$confusion %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(error = paste0(round(100 * .data$class.error, 2), "%")) %>%
    dplyr::select(-class.error)
}

#' Generate a tibble of metrics from a random forest
#'
#' @inheritParams generate_roc
#'
#' @return Tibble.
#' @export
#'
generate_metrics <- function(rf, positive) {
  # Create our own function to avoid dependency on scales package
  percent <- function(x) round(x * 100, digits = 2)
  oob <- paste0(percent(rf$err.rate[rf$ntree, "OOB"]), "%")

  # Warning: this code is run twice in the training plan due to generate_roc
  roc_curve <- generate_roc(rf, positive)
  auc <- percent(plotROC::calc_auc(roc_curve)$AUC)

  dplyr::tibble(oob = oob, auc = auc)
}
