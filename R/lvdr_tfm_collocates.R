#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name lvdr_extract_network
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame

#' @export
#' @rdname lvdr_tfm_collocates
#' 


lvdr_tfm_collocates <- function (tfm, 
                                 target = NULL, 
                                 n = NULL) { #y = NULL -> full collocate data frame.
  
  if(is.null(target)) {ft <- tfm} else {
    ft <- tfm[rownames(tfm) %in% target, , drop = FALSE]}
  
  m <- Matrix::summary(ft)
  
  nodes <- data.frame(term = rownames(ft)[m$i], 
                      feature = colnames(ft)[m$j],
                      cooc = m$x,
                      stringsAsFactors = FALSE)
  
  nodes <- subset(nodes, term != feature)
  nodes <- nodes[order(nodes$term, -nodes$cooc), ]
  
  if(is.null(n)){} else {
    nodes <- nodes[ave(1:nrow(nodes), nodes$term, FUN = seq_along) <= n, ]}
  return(nodes)
}
