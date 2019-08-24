
#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name lvdr_quick_cosine
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame
#' @import data.table
#'
#'
#' @export
#' @rdname lvdr_quick_cosine


lvdr_quick_cosine <- function (tfm,
                               target,
                               n = 10,
                               vocab = NULL) {  # Add vocab parameter.
  
  if (vocab == NULL) {} else {
    tfm <- tfm[rownames(tfm) %in% unique(vocab),]
  }
  
  cos_sim <- text2vec::sim2(x = tfm, 
                            y = tfm[target, , drop = FALSE], 
                            method = "cosine", 
                            norm = "l2")

  x1 <- head(sort(cos_sim[,1], decreasing = TRUE), n+1)
  
  y1 <- data.frame(term1 = target,
                   term2 = names(x1),
                   value = round(x1, 3),
                   stringsAsFactors = FALSE,
                   row.names = NULL)
  
  subset(y1, term1 != term2)
}