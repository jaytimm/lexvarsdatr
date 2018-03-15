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
lvdr_get_family <- function (form,type="word",multiword=FALSE) {

  x <- lvdr_celex
  if (multiword == FALSE) x <- x[grepl(" ",x$Word)==FALSE,]

  if (toupper(type) == "SUF"){
    x <- subset(x,classlist=="SUF")
    x <- x[grepl(paste0("^",form,"$"),x$flatlist)==TRUE,]
    x[['fpos']]

    } else if (toupper(type) == "PRE"){
    x <- subset(x,classlist=="PRE")
    x <- x[grepl(paste0("^",form,"$"),x$flatlist)==TRUE,]
    x[['fpos']]

    } else {
    x <- x[grepl(paste0("^",form,"\\["),x$flatlist)==TRUE,]
    x[['fpos']]
    }
}


#' @export
#' @rdname LexvarFunctions
lvdr_get_associates <- function (cue) {
   x <- subset(lvdr_association,CUE==toupper(cue))
   x[['TARGET']] }
