<!-- badges: start -->
[![R build status](https://github.com/mdneuzerling/ReviewSentiment/workflows/R-CMD-check/badge.svg)](https://github.com/mdneuzerling/ReviewSentiment/actions)
<!-- badges: end -->

# ReviewSentiment

This repository associated with my blog post: [MLOps with GitHub Actions and R](https://mdneuzerling.com/post/mlops-with-github-actions-and-r/). I wanted to see if I could use just GitHub Actions and S3 to implement some sort of end-to-end automatic training, deployment and execution of a model. 

When I push new code to trunk, my unit tests are automatically run. When I create a pull request from trunk to production, my model is automatically trained, and results commented in the pull request. When I merge, my model is deployed. On a schedule, my model is executed.
