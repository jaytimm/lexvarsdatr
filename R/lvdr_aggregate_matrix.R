#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name lvdr_aggregate_matrix
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame
#' @import Matrix.utils Matrix
#'
#'
#' @export
#' @rdname lvdr_aggregate_matrix


lvdr_aggregate_matrix <- function(tfm,
                                  group,
                                  fun = 'sum') {

  ## Alpha order tfm terms/features
  tfm1 <-  tfm[, order(colnames(tfm))]
  tfm1 <- tfm1[order(rownames(tfm1)), ]

  ##For columns
  tfm1  <- Matrix.utils::aggregate.Matrix(x = tfm1, ## We can sort here, presumably.
                                          groupings = sort(group),
                                          fun = fun)

  tfm1 <- Matrix.utils::aggregate.Matrix(x = Matrix::t(tfm1),
                                         groupings = sort(group),
                                         fun = fun)

  t(tfm1)

  ## Assumes x~y == y~x, which we have always been assuming.
}
