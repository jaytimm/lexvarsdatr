#Build CELEX

library(tidyverse)
celex <- read.csv("C:\\Users\\jtimm\\Google Drive\\GitHub\\packages\\lexvarsdatr\\psycho\\RawData\\celex_Baayen_et_al_1995.csv")%>%
  mutate_all(as.character)


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

CELEX <- newcelex%>%
  left_join(affTypes)%>%
  mutate(classlist = ifelse(classlist=="PRE"|classlist=="SUF",type,classlist))%>%
  select(-type)

#Output
devtools::use_data(CELEX, overwrite=TRUE)


