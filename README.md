lexvarsdatr
===========

A collection of psycholinguistic/behavioral data, collated from supplemental materials and public databases.

``` r
library(lexvarsdatr) #devtools::install_github("jaytimm/lexvarsdatr")
```

Data included in package:

| Data                           | Source                                                                                                                                                                                                            |
|:-------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| CELEX - English lemma database | Baayen, R. H., Piepenbrock, R., & Gulikers, L. (1995). The CELEX lexical database \[webcelex\]. *Philadelphia, PA: University of Pennsylvania, Linguistic Data Consortium*.                                       |
| Lexical decision and naming    | Balota, D. A., Yap, M. J., Hutchison, K. A., Cortese, M. J., Kessler, B., Loftis, B., ... & Treiman, R. (2007). The English lexicon project. *Behavior research methods*, 39(3), 445-459.                         |
| Concreteness ratings           | Brysbaert, M., Warriner, A. B., & Kuperman, V. (2014). Concreteness ratings for 40 thousand generally known English word lemmas. *Behavior research methods*, 46(3), 904-911.                                     |
| AoA ratings                    | Kuperman, V., Stadthagen-Gonzalez, H., & Brysbaert, M. (2012). Age-of-acquisition ratings for 30,000 English words. *Behavior Research Methods*, 44(4), 978-990.                                                  |
| Word association               | Nelson, D. L., McEvoy, C. L., & Schreiber, T. A. (2004). The University of South Florida free association, rhyme, and word fragment norms. *Behavior Research Methods, Instruments, & Computers*, 36(3), 402-407. |

### lvdr\_behav\_data

For convenience, response times in lexical decision/naming, concreteness ratings, and AoA ratings have been collated into a single data frame, `lex_behav_data`. Approximately 18K word forms are included in all three data sets.

``` r
library(tidyverse)
lexvarsdatr::lvdr_behav_data %>%
  na.omit %>%
  head
##           Word            Pron NMorph   POS lexdecRT lexdecSD  nmgRT
## 5       abacus       "a.b@.k@s      1    NN    964.4      489 792.69
## 6      abandon      @.b"an.4@n      1 VB|NN   695.72   220.41 623.96
## 9  abandonment @.b"an.4@n.m@nt      2    NN   771.09   229.53 794.70
## 18  abbreviate    @.br"i.vi.et      3    VB   795.03   316.55 708.44
## 19       abide         @.b"aId      1    VB   773.21   276.41 633.83
## 21     abiding      @.b"aI4.IN      2 JJ|VB   784.67   243.05 620.16
##     nmgSD aoaRating aoaSD concRating concSD freqSUBTLEX
## 5  200.19      8.69  3.77       4.52   1.12          12
## 6   98.25      8.32  2.75       2.54   1.45         413
## 9   256.3     10.27  2.57       2.54   1.29          49
## 18 156.29      9.95  2.07       2.59   1.53           1
## 19 145.25      9.50  3.11       1.68   0.86         138
## 21  99.42     10.30  4.01       2.07   1.13          25
```

### lvdr\_celex

The English lemma portion of the CELEX database can be accessed as `lvdr_celex`. Morphological families can be extracted for both word forms and affixes with the `lvdr_get_family` function.

``` r
lexvarsdatr::lvdr_get_family(form="think",multiword = TRUE)
##  [1] "bethink_V"       "doublethink_N"   "freethinker_N"  
##  [4] "rethink_N"       "rethink_V"       "think_N"        
##  [7] "think_V"         "thinkable_A"     "thinker_N"      
## [10] "think of_V"      "think out_V"     "think over_V"   
## [13] "think-tank_N"    "think through_V" "think up_V"     
## [16] "unthinkable_A"
```

``` r
lexvarsdatr::lvdr_get_family(type="SUF",form="wise")
##  [1] "anticlockwise_A"      "anticlockwise_ADV"    "breadthwise_ADV"     
##  [4] "breadthwise_A"        "broadwise_ADV"        "clockwise_ADV"       
##  [7] "clockwise_A"          "coastwise_A"          "coastwise_ADV"       
## [10] "contrariwise_ADV"     "counterclockwise_A"   "counterclockwise_ADV"
## [13] "crabwise_ADV"         "crosswise_ADV"        "crosswise_A"         
## [16] "edgewise_ADV"         "endwise_ADV"          "leastwise_ADV"       
## [19] "lengthwise_ADV"       "longwise_ADV"         "nowise_ADV"          
## [22] "otherwise_ADV"        "slantwise_ADV"        "slantwise_A"
```

### lvdr\_association

The South Florida word association data set lives in `lvdr_association`. A description of variables included in the normed data set, as well as methodologies, can be found [here](http://w3.usf.edu/FreeAssociation/). The `lvdr_get_associates` function enables quick access to word associates for a given cue; associates are listed in descending order (per subject responses).

``` r
lexvarsdatr::lvdr_get_associates(cue='think')
##  [1] "brain"       "mind"        "thought"     "study"       "concentrate"
##  [6] "idea"        "ponder"      "learn"       "hard"        "know"       
## [11] "knowledge"   "school"      "smart"       "cogitate"    "contemplate"
## [16] "do"          "memory"      "plan"        "problem"     "talk"       
## [21] "try"         "wonder"
```

Additional querying functionality for both the CELEX and word association data sets is forthcoming.
