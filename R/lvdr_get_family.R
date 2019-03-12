#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name lvdr_get_family
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame

#' @export
#' @rdname lvdr_get_family
lvdr_get_family <- function (form,
                             type="word",
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
