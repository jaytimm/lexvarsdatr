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

  if (multiword == FALSE) lvdr_celex <- lvdr_celex[grepl(" ",lvdr_celex$flatlist)==FALSE,]

  if (toupper(type) == "SUF"){
    x <- subset(lvdr_celex,classlist=="SUF")
    x <- lvdr_celex[grepl(paste0("^",form,"$"),lvdr_celex$flatlist)==TRUE,]
    x[['fpos']]

    } else if (toupper(type) == "PRE"){
    x <- subset(lvdr_celex,classlist=="PRE")
    x <- lvdr_celex[grepl(paste0("^",form,"$"),lvdr_celex$flatlist)==TRUE,]
    x[['fpos']]

    } else {
    x <- lvdr_celex[grepl(paste0("^",form,"\\["),lvdr_celex$flatlist)==TRUE,]
    x[['fpos']]
    }
}
