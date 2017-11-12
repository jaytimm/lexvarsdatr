

##Build lexvarsdat package.

library(tidyverse)

citations <- c("Kuperman, V., Stadthagen-Gonzalez, H., & Brysbaert, M. (2012). Age-of-acquisition ratings for 30,000 English words. Behavior Research Methods, 44(4), 978-990.",
"Balota, D. A., Yap, M. J., Hutchison, K. A., Cortese, M. J., Kessler, B., Loftis, B., ... & Treiman, R. (2007). The English lexicon project. Behavior research methods, 39(3), 445-459.",
"Brysbaert, M., Warriner, A. B., & Kuperman, V. (2014). Concreteness ratings for 40 thousand generally known English word lemmas. Behavior research methods, 46(3), 904-911.",
"Nelson, D. L., McEvoy, C. L., & Schreiber, T. A. (2004). The University of South Florida free association, rhyme, and word fragment norms. Behavior Research Methods, Instruments, & Computers, 36(3), 402-407.",
"Baayen, R. H., Piepenbrock, R., & Gulikers, L. (1995). The CELEX lexical database [webcelex]. Philadelphia, PA: University of Pennsylvania, Linguistic Data Consortium.")


association <- read.csv("C:\\Users\\jason\\Google Drive\\GitHub\\packages\\lexvarsdatr\\psycho\\RawData\\association_Nelson&McEvoy_2004.csv")

aoa <- read.csv("C:\\Users\\jason\\Google Drive\\GitHub\\packages\\lexvarsdatr\\psycho\\RawData\\aoa_Kuperman_et_al_2012.csv")%>%
  select(Word,Rating.Mean,Rating.SD)%>%
  rename(aoaRating=Rating.Mean,aoaSD=Rating.SD)

conc <- read.csv("C:\\Users\\jason\\Google Drive\\GitHub\\packages\\lexvarsdatr\\psycho\\RawData\\concrete_Brysbaert_et_al_2014.csv")%>%
  select(Word,Conc.M,Conc.SD,SUBTLEX)%>%
  rename(concRating=Conc.M,concSD=Conc.SD,freqSUBTLEX=SUBTLEX)

lexdec <- read.csv("C:\\Users\\jason\\Google Drive\\GitHub\\packages\\lexvarsdatr\\psycho\\RawData\\lexdec_Balota_et_al_2007.csv")%>%
  select(Word,Pron,NMorph,POS,I_Mean_RT,I_SD,I_NMG_Mean_RT,I_NMG_SD)%>%
  rename(lexdecRT=I_Mean_RT, lexdecSD=I_SD,nmgRT = I_NMG_Mean_RT, nmgSD=I_NMG_SD)

full1 <- full_join(lexdec,aoa)%>%
  full_join(conc)

full2 <- full1 %>%
  filter(complete.cases(.))


#Build CELEX

celex <- read.csv("C:\\Users\\jason\\Google Drive\\GitHub\\packages\\lexvarsdatr\\psycho\\RawData\\celex_Baayen_et_al_1995.csv")%>%
  mutate_all(as.character)

#clelx$FlatSA <- gsub(

celex$Flat <- ifelse(celex$Flat=="",paste(celex$Word,"[",celex$Class,"]",sep=""),celex$Flat)
celex[is.na(celex)] <- "X"
celex[celex == ""] <- "X"
celex$ids <- rownames(celex)

ids <- rep(celex$ids,nchar(celex$FlatSA))
flatlist <- sapply(celex$Flat, strsplit,'\\+')%>%
  unlist
classlist <- sapply(celex$FlatSA, strsplit,'+')%>%
  unlist()

newcelex <- cbind(ids,classlist,flatlist)%>%
  as.data.frame()%>%
  mutate(classlist=as.character(classlist),flatlist=as.character(flatlist))%>%
  left_join(celex)%>%
  group_by(ids)%>%
  #mutate(seq=group_indices(.,ids))
  mutate(seqs=row_number(ids))%>%
  ungroup()%>%
  mutate(flatlist=sub("\\]\\[.*$", "]", flatlist),fpos = paste(Word,"_",Class,sep=""))


for (i in 1:nrow(newcelex)){
  if (newcelex$classlist[i]=="A" & newcelex$seqs[i]==1) {
    newcelex$classlist[i] <- "PRE"}
  if (newcelex$classlist[i]=="A" & newcelex$seqs[i]>1) {
    newcelex$classlist[i] <- "SUF"}}

newcelex$transtype <- ifelse(newcelex$classlist=="PRE"| newcelex$classlist=="SUF", gsub(".*\\[(.*)\\].*", "\\1",newcelex$flatlist),"X")

newcelex$flatlist <- ifelse(newcelex$classlist=="PRE"| newcelex$classlist=="SUF", gsub("\\[.*\\]","",newcelex$flatlist),newcelex$flatlist)


#Need to make uniform all POS ids.  Cross to universal POS list.
#How to get morph families by affix (-type), eg. And morph family size by form.


#In README, redo AoA plot of accumulative lexicon-size over time.

#Understand import business with package build - and why you need to call library.

#Clean affix types
affs <- subset(newcelex, classlist=="PRE"|classlist=="SUF")

affTypes <- table(affs$classlist,affs$flatlist)%>%
  data.frame()%>%
  spread(Var1,Freq)%>%
  mutate(type=ifelse(PRE >SUF,"PRE","SUF"))%>%
  rename(flatlist=Var2)%>%
  select(-PRE,-SUF)

lastcelex <- newcelex%>%
  left_join(affTypes)%>%
  mutate(classlist = ifelse(classlist=="PRE"|classlist=="SUF",type,classlist))%>%
  select(-type)





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
