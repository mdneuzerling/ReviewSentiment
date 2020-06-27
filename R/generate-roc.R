#' Generate a ROC curve from the training data of a randomForest model
#'
#' In a real-life application, we wouldn't be using training data to plot our
#' ROC curve, as random forests greatly overfit on their training data. Since
#' this isn't a serious exercise in machine learning, we can get away with it.
#'
#' We're assuming a random forest used for binary classification.
#'
#' @param rf A model created with the \verb{randomForest} package.
#' @param positive Character. The value of the positive case in the binomial
#'   classification.
#'
#' @return A \verb{ggplot2} plot.
#' @export
#'
generate_roc <- function(rf, positive = "good") {
  actual <- ifelse(rf$y == positive, 1, 0)
  predicted <- rf$votes[,c(positive)]
  ggplot2::ggplot(data.frame(actual = actual, predicted = predicted),
                  ggplot2::aes(d = actual, m = predicted)) +
    plotROC::geom_roc() +
    ggplot2::coord_equal() +
    plotROC::style_roc() +
    ggplot2::ggtitle("ROC Curve")
}
