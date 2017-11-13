

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

getFamily(form="ism",type="SUF")
getFamily(form="inter",type="PRE")
View(getFamily(form="glass",type="N"))
