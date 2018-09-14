#!/bin/bash

name=$1
cutoff=$2
prob=$3

CRFPATH=/GW/D5data-8/counting_quantifier/tools/CRF++-0.58/

#Prepare training data -- assumed done
java -Xms2g -Xmx8g -jar ../CINEX/CINEXPreprocessing.jar -i ../entity_list_five_rel/train/train_"${name}".csv -e ../entity_list_five_rel/combtest/test_"${name}".csv -p "${name}" -w /GW/D5data-8/counting_quantifier/enwiki_20170320_pages_articles/ -f -d -h 0 -g 0 -t 2.7 --popular "${cutoff}" --npopular 10000 --compositional --numterms --ordinals -o ./crf_five_rel_feature_data/ -n 100

#Prepare evaluation data
java -Xms2g -Xmx8g -jar ../CINEX/CINEXPreprocessing.jar -i ../entity_list_five_rel/eval/val_novalue_"${name}".csv -e ../entity_list_five_rel/eval/val_novalue_"${name}".csv -p "${name}"_eval_neg -w /GW/D5data-8/counting_quantifier/enwiki_20170320_pages_articles/ -f -d --numterms --ordinals --negation -o ./crf_five_rel_feature_data/ -n 100

#Label with CRF
java -Xms2g -Xmx8g -jar ../CINEX/CINEXClassifier.jar -c "${CRFPATH}" -p "${name}"_neg -t ./crf_five_rel_feature_data/"${name}"_train_cardinality.data -e ./crf_five_rel_feature_data/"${name}"_eval_neg_test_cardinality.data -m ./crf_five_rel_models/ -n 100

mv ./crf_five_rel_feature_data/"${name}"_neg_cardinality.out ./crf_five_rel_out/

#Evaluate
java -jar ../CINEX/CINEXEvaluation.jar --prob "${prob}" --zero --crfeval -i ../entity_list_five_rel/eval/val_novalue_"${name}".csv -p "${name}" -f ./crf_five_rel_out/"${name}"_neg_cardinality.out -r ./performance_crf_five_rel_neg.txt -o ./crf_five_rel_predicted/"${name}"_neg.tsv


