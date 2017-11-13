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
    newcelex %>%
      filter(flatlist==form)%>%
      filter(.,grepl(paste(form,"$",sep=""),Word))%>%
      select(fpos)
    } else if (type == "PRE") {
      newcelex %>%
        filter(flatlist== form)%>%
        select(fpos)
    } else {
    newcelex %>%
      filter(flatlist == paste(form,"[",type,"]",sep=""))%>%
      select(fpos)
    }
}

#' getFamily(form="ism",type="SUF")
#' getFamily(form="inter",type="PRE")
#' View(getFamily(form="glass",type="N"))
