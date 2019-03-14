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
  if (length(search) > 1) {
    nodes <- data.frame(t(as.matrix(filts)),
                        stringsAsFactors = FALSE) } else{
      nodes <- data.frame(as.matrix(filts),
                          stringsAsFactors = FALSE)
      names(nodes) <- toupper(search)}
  nodes$label <- colnames(y)

  nodes <- reshape2::melt(nodes, id.vars = c('label'), variable.name = 'from')
  nodes <- nodes[nodes$value > min_val | nodes$label %in% search,] #New
  nodes <- nodes[order(-nodes$value), ]
  nodes <- nodes[!duplicated(nodes[,c('label')]),]
  nodes <- nodes[-2]
  nodes$group <- ifelse(nodes$label %in% search, 'term', 'feature')
  nodes <- nodes[order(nodes$group, decreasing = TRUE), ]
  rownames(nodes) <- NULL

  #Build edges
  #x <- y[rownames(y) %in% nodes$label,colnames(y) %in% nodes$label]
  x <- y[rownames(y) %in% nodes$label,colnames(y) %in% nodes$label] #BREAKS here.
  x <- x[, order(colnames(x))]
  x <- x[order(rownames(x)), ]

  x[!upper.tri(x)] <- 0
  x <- data.frame(from = row.names(x), as.matrix(x),
                  stringsAsFactors = FALSE)
  x <- reshape2::melt(x, id.vars = c('from'), variable.name = 'to')

  edges <- subset(x, value >= min_val)
  edges$to <- as.character(edges$to)
  rownames(edges) <- NULL
  list(nodes=nodes, edges=edges)
}
