#!/bin/bash

mkdir -f ./crf_five_rel_feature_data/
mkdir -f ./crf_five_rel_models/
mkdir -f ./crf_five_rel_out/
mkdir -f ./crf_five_rel_predicted/

#Five relations: containsWork (P527_Q7725310), containsAdmin (P150), hasMember (P527_Q2088357), 
#hasChild (P40) and hasSpouse (P26)
bash iswc_experiment_crf_per_relation.sh P527_Q7725310 1.0 0.1
bash iswc_experiment_crf_per_relation.sh P150 1.0 0.2
bash iswc_experiment_crf_per_relation.sh P527_Q2088357 0.5 0.1
bash iswc_experiment_crf_per_relation.sh P40 0.5 0.1
bash iswc_experiment_crf_per_relation.sh P26 0.5 0.1

#Zero counting quantifier (negation): hasChild (P40) and hasSpouse (P26)
bash iswc_experiment_crf_per_relation_negation.sh P40 0.5 0.1
bash iswc_experiment_crf_per_relation_negation.sh P26 0.5 0.1


