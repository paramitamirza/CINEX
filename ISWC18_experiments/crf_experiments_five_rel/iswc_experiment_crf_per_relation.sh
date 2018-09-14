#!/bin/bash

name=$1
cutoff=$2
prob=$3

CRFPATH=/GW/D5data-8/counting_quantifier/tools/CRF++-0.58/

#Prepare training data
java -Xms2g -Xmx8g -jar ../CINEX/CINEXPreprocessing.jar -i ../entity_list_five_rel/train/train_"${name}".csv -e ../entity_list_five_rel/combtest/test_"${name}".csv -p "${name}" -w /GW/D5data-8/counting_quantifier/enwiki_20170320_pages_articles/ -f -d -h 0 -g 0 -t 2.7 --popular "${cutoff}" --npopular 10000 --compositional --numterms --ordinals -o ./crf_five_rel_feature_data/ -n 100

#Prepare development data
java -Xms2g -Xmx8g -jar ../CINEX/CINEXPreprocessing.jar -i ../entity_list_five_rel/test/test_"${name}".csv -e ../entity_list_five_rel/test/test_"${name}".csv -p "${name}"_dev -w /GW/D5data-8/counting_quantifier/enwiki_20170320_pages_articles/ -f -d --numterms --articles --ordinals -o ./crf_five_rel_feature_data/ -n 100

#Prepare evaluation data
java -Xms2g -Xmx8g -jar ../CINEX/CINEXPreprocessing.jar -i ../entity_list_five_rel/eval/val_random_"${name}".csv -e ../entity_list_five_rel/eval/val_random_"${name}".csv -p "${name}"_eval -w /GW/D5data-8/counting_quantifier/enwiki_20170320_pages_articles/ -f -d --numterms --articles --ordinals -o ./crf_five_rel_feature_data/ -n 100

#Label with CRF
java -Xms2g -Xmx8g -jar ../CINEX/CINEXClassifier.jar -c "${CRFPATH}" -p "${name}" -t ./crf_five_rel_feature_data/"${name}"_train_cardinality.data -e ./crf_five_rel_feature_data/"${name}"_eval_test_cardinality.data -m ./crf_five_rel_models/ -n 100

mv ./crf_five_rel_feature_data/"${name}"_cardinality.out ./crf_five_rel_out/

#Evaluate
java -jar ../CINEX/CINEXEvaluation.jar --prob "${prob}" --compositional --crfeval --ordinals -i ../entity_list_five_rel/eval/val_random_"${name}".csv -p "${name}" -f ./crf_five_rel_out/"${name}"_cardinality.out -r ./performance_crf_five_rel.txt -o ./crf_five_rel_predicted/"${name}".tsv

java -jar ../CINEX/CINEXEvaluation.jar --prob "${prob}" --compositional --crfeval --ordinals -i ../entity_list_five_rel/eval/val_random_"${name}".csv -p "${name}"_relaxed -f ./crf_five_rel_out/"${name}"_cardinality.out -r ./performance_crf_five_rel.txt -x  > /dev/null

#Evaluate manually annotated output file
java -jar ../CINEX/CINEXEvaluation.jar --prob "${prob}" --compositional --crfeval --ordinals -i ../entity_list_five_rel/eval/val_random_"${name}".csv -p "${name}"_manual -f ./crf_five_rel_out/manual_mention_annotation/"${name}"_ordinals_cardinality_manual.out -r ./performance_crf_five_rel_manual.txt -o ./crf_five_rel_predicted/manual_mention_annotation/"${name}"_manual.tsv

java -jar ../CINEX/CINEXEvaluation.jar --prob "${prob}" --compositional --crfeval --ordinals -i ../entity_list_five_rel/eval/val_random_"${name}".csv -p "${name}"_manual_relaxed -f ./crf_five_rel_out/manual_mention_annotation/"${name}"_ordinals_cardinality_manual.out -r ./performance_crf_five_rel_manual.txt -x  > /dev/null

