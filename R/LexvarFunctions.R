#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name LexvarFunctions
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame
#' @import tidyverse


#' @export
#' @rdname LexvarFunctions
getFamily <- function (form,type) {
  if (type == "SUF"){#Not sure if this is correct. contains, not ends with.
    CELEX %>%
      filter(flatlist==form)%>%
      filter(.,grepl(paste(form,"$",sep=""),Word))%>%
      select(fpos)
    } else if (type == "PRE") {
      CELEX %>%
        filter(flatlist== form)%>%
        select(fpos)
    } else {
    CELEX %>%
      filter(flatlist == paste(form,"[",type,"]",sep=""))%>%
      select(fpos)
    }
}

#' getFamily(form="ism",type="SUF")
#' getFamily(form="inter",type="PRE")
#' View(getFamily(form="glass",type="N"))
#'


#' @export
#' @rdname LexvarFunctions
toCQL <- function(x){
  gsub('(\\w+) ([[:alpha:]]+)(_[A-Z])','<\\1&\\3x> <\\2\\!>',x)%>%
    gsub('(^[a-zA-Z-]+)(_[A-Z])','<\\1&\\2x>',.)%>%
    gsub('_Ax','_Jx',.)}
