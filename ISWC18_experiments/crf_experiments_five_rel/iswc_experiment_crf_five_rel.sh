#!/bin/bash

#Five relations: containsWork (P527_Q7725310), containsAdmin (P150), hasMember (P527_Q2088357), hasChild (P40), P26 (hasSpouse)
sh iswc_experiment_crf_per_relation.sh P527_Q7725310 1.0 0.1
sh iswc_experiment_crf_per_relation.sh P150 1.0 0.2
sh iswc_experiment_crf_per_relation.sh P527_Q2088357 0.5 0.1
sh iswc_experiment_crf_per_relation.sh P40 0.5 0.1
sh iswc_experiment_crf_per_relation.sh P26 0.5 0.1

#Zero counting quantifier (negation): hasChild (P40), P26 (hasSpouse)
sh iswc_experiment_crf_per_relation_negation.sh P40 0.5 0.1
sh iswc_experiment_crf_per_relation_negation.sh P26 0.5 0.1


