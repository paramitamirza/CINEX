### Experiments on five relations
Please check the `crf_experiments_five_rel/iswc_experiment_crf_five_rel.sh` bash script:
```
#!/bin/bash

sh iswc_experiment_crf_per_relation.sh P527_Q7725310 1.0 0.1
sh iswc_experiment_crf_per_relation.sh P150 1.0 0.2
sh iswc_experiment_crf_per_relation.sh P527_Q2088357 0.5 0.1
sh iswc_experiment_crf_per_relation.sh P40 0.5 0.1
sh iswc_experiment_crf_per_relation.sh P26 0.5 0.1

sh iswc_experiment_crf_per_relation_negation.sh P40 0.5 0.1
sh iswc_experiment_crf_per_relation_negation.sh P26 0.5 0.1
```
The predicted counting quantifiers for each relation are available in [`crf_experiments_five_rel/crf_five_rel_predicted`](crf_experiments_five_rel/crf_five_rel_predicted/).
