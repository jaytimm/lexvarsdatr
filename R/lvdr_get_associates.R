#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name lvdr_get_associates
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame



#' @export
#' @rdname lvdr_get_associates
lvdr_get_associates <- function (cue, toupper=FALSE) {
   x <- subset(lvdr_association,CUE==toupper(cue))
   if(!toupper) tolower(x[['TARGET']])
   x[['TARGET']]}

