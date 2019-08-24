#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name lvdr_extract_network
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame
#' @import data.table
#'
#'
#' @export
#' @rdname lvdr_extract_network

lvdr_extract_network <- function (tfm,
                                  target,
                                  n = 10,
                                  vocab = NULL) {

  nodes <- lexvarsdatr::lvdr_get_closest(tfm = tfm,
                                         target = target,
                                         n = n)

  nodes <- nodes[!duplicated(nodes[,c('feature')]),]
  nodes <- subset(nodes, !feature %in% target)
  xx <- max(nodes$cooc)
  nodes <- rbind(nodes,
                 data.frame(term = target,
                            feature = target,
                            cooc = xx))
  nodes$group <- ifelse(nodes$feature %in% target, 'term', 'feature')

  ##
  edges <- lexvarsdatr::lvdr_get_closest(tfm = tfm,
                                         target = unique(nodes$feature))

  #friends of friends.
  edges <- subset(edges, feature %in% unique(nodes$feature))

  if (vocab == NULL) {} else {
    edges <- subset(edges, feature %in% unique(vocab))
  }


  #Extract edges in which nodes are a part. To force inclusion.
  edges_nodes <- subset(edges, term %in% target)

  edges <- edges[order(-edges$cooc), ]

  #Per node, find n*1.5 most prevalent associations.
  edges <- edges[, head(.SD, n), by=term]

  edges <- rbind(edges, edges_nodes)
  edges <- unique(edges)

  colnames(edges) <- c('from', 'to', 'value')
  colnames(nodes) <- c('term', 'label', 'value', 'group')
  nodes <- nodes[, c('label', 'term','value', 'group')]
  edges <- edges[, c('value', 'to', 'from')]
  network <- list(nodes=nodes, edges=edges)
  return(network)
}
