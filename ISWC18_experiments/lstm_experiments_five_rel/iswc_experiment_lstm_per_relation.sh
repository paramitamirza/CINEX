#!/bin/bash

name=$1
prob=$2

#Prepare feature data
python prepare_data_lstm.py ../crf_experiments_five_rel/crf_five_rel_feature_data/"${name}"_train_cardinality.data > ./lstm_five_rel_feature_data/train/"${name}"_train_cardinality.txt
python prepare_data_lstm.py ../crf_experiments_five_rel/crf_five_rel_feature_data/"${name}"_eval_test_cardinality.data > ./lstm_five_rel_feature_data/eval/"${name}"_eval_test_cardinality.txt
python prepare_data_lstm.py ../crf_experiments_five_rel/crf_five_rel_feature_data/"${name}"_dev_test_cardinality.data > ./lstm_five_rel_feature_data/dev/"${name}"_dev_test_cardinality.txt

#Run sequence tagging (requires Tensorflow)
cd ./sequence_tagging_bilstm_crf_char/
bash run.sh ../lstm_five_rel_feature_data/train/"${name}"_dev_test_cardinality.txt ./lstm_five_rel_feature_data/eval/"${name}"_eval_test_cardinality.txt ./lstm_five_rel_feature_data/train/"${name}"_train_cardinality.txt "${name}"
cd ../

#Convert to CRF++ output format
python combine_out_lstm.py ../crf_experiments_five_rel/crf_five_rel_out/"${name}"_cardinality.out ./lstm_five_rel_feature_data/eval/"${name}"_eval_test_cardinality.pred > ./lstm_five_rel_out/"${name}"_cardinality.lstm.out

#Evaluate
java -jar ../CINEX/CINEXEvaluation.jar --prob "${prob}" --compositional --ordinals --crfeval -i ../entity_list_five_rel/eval/val_random_"${name}".csv -p "${name}" -f ./lstm_five_rel_out/"${name}"_cardinality.lstm.out -r ./performance_lstm_five_rel.txt -o ./lstm_five_rel_predicted/"${name}"_bilstm_crf_char_crfeval.tsv

java -jar ../CINEX/CINEXEvaluation.jar --prob "${prob}" -x --compositional --ordinals --crfeval -i ../entity_list_five_rel/eval/val_random_"${name}".csv -p "${name}" -f ./lstm_five_rel_out/"${name}"_cardinality.lstm.out -r ./performance_lstm_five_rel_relaxed.txt 
