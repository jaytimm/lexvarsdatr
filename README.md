lexvarsdatr
===========

A collection of psycholinguistic/behavioral data, collated from supplemental materials and public databases. Data included in package:

| Data                           | Source                                                                                                                                                                                                            |
|:-------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| CELEX - English lemma database | Baayen, R. H., Piepenbrock, R., & Gulikers, L. (1995). The CELEX lexical database \[webcelex\]. *Philadelphia, PA: University of Pennsylvania, Linguistic Data Consortium*.                                       |
| Lexical decision and naming    | Balota, D. A., Yap, M. J., Hutchison, K. A., Cortese, M. J., Kessler, B., Loftis, B., ... & Treiman, R. (2007). The English lexicon project. *Behavior research methods*, 39(3), 445-459.                         |
| Concreteness ratings           | Brysbaert, M., Warriner, A. B., & Kuperman, V. (2014). Concreteness ratings for 40 thousand generally known English word lemmas. *Behavior research methods*, 46(3), 904-911.                                     |
| AoA ratings                    | Kuperman, V., Stadthagen-Gonzalez, H., & Brysbaert, M. (2012). Age-of-acquisition ratings for 30,000 English words. *Behavior Research Methods*, 44(4), 978-990.                                                  |
| Word association               | Nelson, D. L., McEvoy, C. L., & Schreiber, T. A. (2004). The University of South Florida free association, rhyme, and word fragment norms. *Behavior Research Methods, Instruments, & Computers*, 36(3), 402-407. |

``` r
library(lexvarsdatr) #devtools::install_github("jaytimm/lexvarsdatr")
```

Some basic query functions
--------------------------

### CELEX

``` r
lexvarsdatr::lvdr_get_family(form="think")
##  [1] "bethink_V"     "doublethink_N" "freethinker_N" "rethink_N"    
##  [5] "rethink_V"     "think_N"       "think_V"       "thinkable_A"  
##  [9] "thinker_N"     "think-tank_N"  "unthinkable_A"
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

### Word association

``` r
lexvarsdatr::lvdr_get_associates(cue='think')
##  [1] "brain"       "mind"        "thought"     "study"       "concentrate"
##  [6] "idea"        "ponder"      "learn"       "hard"        "know"       
## [11] "knowledge"   "school"      "smart"       "cogitate"    "contemplate"
## [16] "do"          "memory"      "plan"        "problem"     "talk"       
## [21] "try"         "wonder"
```
