#' Generate a confusion matrix from a random forest as a tibble
#'
#' @param rf A randomForest object.
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
##' @param rf A randomForest object.
#'
#' @return Tibble.
#' @export
#'
generate_metrics <- function(rf) {
  # Create our own function to avoid dependency on scales package
  percent <- function(x) paste0(round(x * 100, digits = 2), "%")
  oob <- percent(rf$err.rate[rf$ntree, "OOB"])

  roc_curve <- generate_roc(rf) # Warning: this code is duplicated in the plan
  auc <- percent(plotROC::calc_auc(roc_curve)$AUC)

  dplyr::tibble(oob = oob, auc = auc)
}
