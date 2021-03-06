#!/bin/bash

mkdir ./lstm_five_rel_feature_data/
mkdir ./lstm_five_rel_out/
mkdir ./lstm_five_rel_predicted/

echo -e "rel\ttrain\tcq-tp\tcq-fp\tcq-total\tcq-prec\tcq-recall\tcq-f1\tcq-mae\ttp\tfp\ttotal\tprec\trecall\tf1\tpred=num\tpred>num\tpred<num\tnum\tmissing\tincrease" > ./performance_lstm_five_rel.tsv

#Five relations: containsWork (P527_Q7725310), containsAdmin (P150), hasMember (P527_Q2088357), 
#hasChild (P40) and hasSpouse (P26)
bash iswc_experiment_lstm_per_relation.sh P527_Q7725310 0.1
bash iswc_experiment_lstm_per_relation.sh P150 0.2
bash iswc_experiment_lstm_per_relation.sh P527_Q2088357 0.1
bash iswc_experiment_lstm_per_relation.sh P40 0.1
bash iswc_experiment_lstm_per_relation.sh P26 0.1

