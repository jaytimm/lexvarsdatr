

##Build lexvarsdat package.

library(tidyverse)

citations <- c("Kuperman, V., Stadthagen-Gonzalez, H., & Brysbaert, M. (2012). Age-of-acquisition ratings for 30,000 English words. Behavior Research Methods, 44(4), 978-990.",
"Balota, D. A., Yap, M. J., Hutchison, K. A., Cortese, M. J., Kessler, B., Loftis, B., ... & Treiman, R. (2007). The English lexicon project. Behavior research methods, 39(3), 445-459.",
"Brysbaert, M., Warriner, A. B., & Kuperman, V. (2014). Concreteness ratings for 40 thousand generally known English word lemmas. Behavior research methods, 46(3), 904-911.",
"Nelson, D. L., McEvoy, C. L., & Schreiber, T. A. (2004). The University of South Florida free association, rhyme, and word fragment norms. Behavior Research Methods, Instruments, & Computers, 36(3), 402-407.",
"Baayen, R. H., Piepenbrock, R., & Gulikers, L. (1995). The CELEX lexical database [webcelex]. Philadelphia, PA: University of Pennsylvania, Linguistic Data Consortium.")


lvdr_association <- read.csv("C:\\Users\\jason\\Google Drive\\GitHub\\packages\\lexvarsdatr\\psycho\\RawData\\association_Nelson&McEvoy_2004.csv")%>%
  #mutate_if(is.factor,as.character) %>%
  mutate_at(c('NORMED','TARGET','CUE','TH','TPS','QPS','QH'),trimws) %>%
  mutate(CUE = gsub(' ', '_', CUE),
         TARGET = gsub(' ', '_', TARGET))


colnames(lvdr_association) <- gsub("\\.","_",colnames(lvdr_association))

aoa <- read.csv("C:\\Users\\jtimm\\Google Drive\\GitHub\\packages\\lexvarsdatr\\psycho\\RawData\\aoa_Kuperman_et_al_2012.csv")%>%
  select(Word,Rating.Mean,Rating.SD)%>%
  rename(aoaRating=Rating.Mean,aoaSD=Rating.SD)

conc <- read.csv("C:\\Users\\jtimm\\Google Drive\\GitHub\\packages\\lexvarsdatr\\psycho\\RawData\\concrete_Brysbaert_et_al_2014.csv")%>%
  select(Word,Conc.M,Conc.SD,SUBTLEX)%>%
  rename(concRating=Conc.M,concSD=Conc.SD,freqSUBTLEX=SUBTLEX)

lexdec <- read.csv("C:\\Users\\jtimm\\Google Drive\\GitHub\\packages\\lexvarsdatr\\psycho\\RawData\\lexdec_Balota_et_al_2007.csv")%>%
  select(Word,Pron,NMorph,POS,I_Mean_RT,I_SD,I_NMG_Mean_RT,I_NMG_SD)%>%
  rename(lexdecRT=I_Mean_RT, lexdecSD=I_SD,nmgRT = I_NMG_Mean_RT, nmgSD=I_NMG_SD)


lvdr_behav_data <- full_join(lexdec,aoa)%>%
  full_join(conc)%>%
  mutate_if(is.factor,as.character)%>%
  arrange(Word)

lvdr_association_sparse <- lvdr_association %>%
  tidytext::cast_sparse(CUE,
                        TARGET,
                        X_P)


setwd("C:\\Users\\jason\\Google Drive\\GitHub\\packages\\lexvarsdatr")
##Output
devtools::use_data(lvdr_association_sparse, overwrite=TRUE)
devtools::use_data(lvdr_association, overwrite=TRUE)
devtools::use_data(lvdr_behav_data, overwrite=TRUE)
