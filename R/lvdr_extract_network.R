#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name lvdr_extract_network
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame

#' @export
#' @rdname lvdr_extract_network

lvdr_extract_network <- function (y,
                                 search,
                                 min_val) {

  filts <- y[rownames(y) %in% search, ]

  nodes <- data.frame(t(as.matrix(filts)),
                      stringsAsFactors = FALSE)
  nodes$label <- rownames(nodes)
  nodes <- reshape2::melt(nodes, id.vars = c('label'), variable.name = 'from')
  nodes <- nodes[nodes$value > min_val,]
  nodes <- nodes[order(-nodes$value), ]
  nodes <- nodes[!duplicated(nodes[,c('label')]),]
  nodes <- nodes[-2]
  nodes$group <- ifelse(nodes$label %in% search, 'term', 'feature')
  nodes <- nodes[order(nodes$group, decreasing = TRUE), ]
  rownames(nodes) <- NULL

  #Build edges
  x <- y[nodes$label,nodes$label]
  x[!upper.tri(x)] <- 0
  x <- data.frame(from = row.names(x), as.matrix(x),
                  stringsAsFactors = FALSE)
  x <- reshape2::melt(x, id.vars = c('from'), variable.name = 'to')
  edges <- subset(x, value >= min_val)
  edges$to <- as.character(edges$to)
  rownames(edges) <- NULL
  list(nodes=nodes, edges=edges)
}
