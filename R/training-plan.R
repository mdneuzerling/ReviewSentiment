#' drake plan for model training
#'
#' @return A plan to be run with drake::make()
#' @importFrom drake trigger
#' @export
#'
training_plan <- function() {
  drake::drake_plan(
    reviews = target(
      download_and_read_data(
        file_in("https://archive.ics.uci.edu/ml/machine-learning-databases/00331/sentiment%20labelled%20sentences.zip")
      )
    ),
    vocabulary = create_vocabulary(reviews$review,
                                   doc_proportion_min = 25 / nrow(reviews)),
    vectoriser = text2vec::vocab_vectorizer(vocabulary),
    dtm_unweighted = map_to_dtm(reviews$review,
                                vectoriser = vectoriser),
    tfidf = create_tfidf(dtm_unweighted),
    dtm_tfidf_weighted = map_to_dtm(reviews$review,
                                    vectoriser = vectoriser,
                                    tfidf = tfidf),
    review_rf = randomForest::randomForest(
      x = as.matrix(dtm_tfidf_weighted),
      y = factor(reviews$sentiment),
      ntree = 500
    ),
    roc_curve = generate_roc(review_rf, positive = "good"),
    confusion_matrix = generate_confusion_matrix(review_rf),
    metrics = generate_metrics(review_rf, positive = "good"),
    output_model = {
      dir.create("artefacts", showWarnings = FALSE)
      readr::write_rds(vectoriser, file_out("artefacts/vectoriser.rds"))
      readr::write_rds(tfidf, file_out("artefacts/tfidf.rds"))
      readr::write_rds(review_rf, file_out("artefacts/review_rf.rds"))
      readr::write_rds(confusion_matrix, file_out("artefacts/confusion_matrix.rds"))
      readr::write_rds(metrics, file_out("artefacts/metrics.rds"))
      ggplot2::ggsave(file_out("artefacts/metrics.png"), roc_curve)
    }
  )
}
