#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name lvdr_extract_network
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame
#' @import data.table
#' @export
#' @rdname lvdr_get_closest
#'


lvdr_get_closest <- function (tfm,
                              target = NULL,
                              n = NULL,
                              include_targ = FALSE) { #y = NULL -> full collocate data frame.
  tfm <- as(tfm, 'dgCMatrix')

  if(is.null(target)) {ft <- tfm} else {
    ft <- tfm[rownames(tfm) %in% target, , drop = FALSE]}

  m <- Matrix::summary(ft)

  nodes <- data.table::data.table(term = rownames(ft)[m$i],
                                  feature = colnames(ft)[m$j],
                                  cooc = m$x,
                                  stringsAsFactors = FALSE)

  data.table::setorder(nodes, term, -cooc)
  data.table::setkey(nodes, term)#

  if(is.null(n)){} else {
    nodes <- nodes[, head(.SD, n), by=term]}

  if(include_targ) {nodes <- subset(nodes, term != feature)}

  return(nodes)
}
