#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name LexvarFunctions
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame

#' @export
#' @rdname LexvarFunctions
lvdr_get_family <- function (form,type="word",
                             multiword=FALSE,
                             toupper=FALSE,
                             include_pos=FALSE) {

  x <- lvdr_celex
  if (multiword == FALSE) x <- x[grepl(" ",x$Word)==FALSE,]

  if (toupper(type) == "SUF"){
    x <- subset(x,classlist=="SUF")
    x <- x[grepl(paste0("^",form,"$"),x$flatlist)==TRUE,]
    y <- x[['fpos']]

    } else if (toupper(type) == "PRE"){
    x <- subset(x,classlist=="PRE")
    x <- x[grepl(paste0("^",form,"$"),x$flatlist)==TRUE,]
    y <- x[['fpos']]

    } else {
    x <- x[grepl(paste0("^",form,"\\["),x$flatlist)==TRUE,]
    y <- x[['fpos']]
    }

  if (toupper) y <- toupper(y)
  if (!include_pos) y <- gsub ("_.*$","",y)
    y
}


#' @export
#' @rdname LexvarFunctions
lvdr_get_associates <- function (cue, toupper=FALSE) {
   x <- subset(lvdr_association,CUE==toupper(cue))
   if(!toupper) tolower(x[['TARGET']])
   x[['TARGET']]}


#' @export
#' @rdname LexvarFunctions
lvdr_build_network <- function (search) {

  nodes <- unique(c(lvdr_association$CUE, lvdr_association$TARGET))
  search_id <- subset(nodes, nodes %in% search)

  cues <- lvdr_association[lvdr_association$CUE %in% search_id,]

  hops <- unique(c(cues$CUE, cues$TARGET))

  search_edges1 <- lvdr_association[lvdr_association$CUE %in% cues$CUE,]
  search_edges2 <- lvdr_association[lvdr_association$CUE %in% cues$TARGET & lvdr_association$TARGET %in% cues$TARGET,]

  edges <- rbind(search_edges1, search_edges2)

  search_nodes <- as.data.frame(unique(c(search_edges1$CUE, search_edges1$TARGET)))
  colnames(search_nodes)[1] <- 'label'
  search_nodes$id <- 1:nrow(search_nodes)
  search_nodes$label <- as.character(search_nodes$label)

  search_edges <- merge(edges,search_nodes, by.x= 'CUE', by.y = 'label')
  search_edges <- merge(search_edges,search_nodes, by.x= 'TARGET', by.y = 'label')

  search_edges <- search_edges[,c('id.x','id.y','X_P')]
  colnames(search_edges) <- c('from','to','weight')

  out <- list("nodes" = search_nodes, "edges" = search_edges)
  return(out)
}
