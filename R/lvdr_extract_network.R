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

lvdr_build_network <- function (tfm,
                                target,
                                n = 10) {

  nodes <- lexvarsdatr::lvdr_tfm_collocates(tfm = tfm,
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

  edges <- lexvarsdatr::lvdr_tfm_collocates(tfm = tfm,
                               target = unique(nodes$feature))

  #friends of friends.
  edges <- subset(edges, feature %in% unique(nodes$feature))

  #Extract edges in which nodes are a part. To force inclusion.
  edges_nodes <- subset(edges, term %in% target)

  edges <- edges[order(-edges$cooc), ]

  #Per node, find n*1.5 most prevalent associations.
  edges <- suppressWarnings(edges[ave(1:nrow(edges), nodes$term, FUN = seq_along) <= 1.5*n, ])

  edges <- rbind(edges, edges_nodes)
  edges <- unique(edges)

  colnames(edges) <- c('from', 'to', 'value')
  colnames(nodes) <- c('term', 'label', 'value', 'group')
  nodes <- nodes[, c('label', 'term','value', 'group')]
  edges <- edges[, c('value', 'to', 'from')]
  network <- list(nodes=nodes, edges=edges)
  return(network)
}
