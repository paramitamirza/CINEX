### Experiments on five relations

#### CRF
Please check the [`crf_experiments_five_rel/iswc_experiment_crf_five_rel.sh`](crf_experiments_five_rel/iswc_experiment_crf_five_rel.sh) bash script:
```
#!/bin/bash

#Five relations: containsWork (P527_Q7725310), containsAdmin (P150), hasMember (P527_Q2088357), 
#hasChild (P40) and P26 (hasSpouse)
sh iswc_experiment_crf_per_relation.sh P527_Q7725310 1.0 0.1
sh iswc_experiment_crf_per_relation.sh P150 1.0 0.2
sh iswc_experiment_crf_per_relation.sh P527_Q2088357 0.5 0.1
sh iswc_experiment_crf_per_relation.sh P40 0.5 0.1
sh iswc_experiment_crf_per_relation.sh P26 0.5 0.1

#Zero counting quantifier (negation): hasZeroChild (P40) and hasZeroSpouse (P26)
sh iswc_experiment_crf_per_relation_negation.sh P40 0.5 0.1
sh iswc_experiment_crf_per_relation_negation.sh P26 0.5 0.1
```
The predicted counting quantifiers for each relation are available in [`crf_experiments_five_rel/crf_five_rel_predicted/`](crf_experiments_five_rel/crf_five_rel_predicted/), in the format of tab-separated values (.tsv), e.g., for hasChild relation (wdt:P40):

![sample hasChild (P40)](hasChild.png)

#### bi-LSTM

### Experiments on ~2.5K Wikidata relations

* Please check the [`experiments_wikidata_rel/iswc_prepare_feature_all_classes.sh`](experiments_wikidata_rel/iswc_prepare_feature_all_classes.sh) bash script to prepare the feature data for all entities in a given class
* Please check the [`experiments_wikidata_rel/iswc_experiment_all_classes.sh`](experiments_wikidata_rel/iswc_experiment_all_classes.sh) bash script to run the experiments for all relations

The predicted counting quantifiers for each relation are available in [`experiments_wikidata_rel/all_rel_predicted/`](experiments_wikidata_rel/all_rel_predicted/), in the format of tab-separated values (.tsv), as for the previous five relations.
