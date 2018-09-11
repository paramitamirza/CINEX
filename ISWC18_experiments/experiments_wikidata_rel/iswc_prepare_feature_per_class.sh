#!/bin/bash

name=$1
cutoff=$2
prob=$3

CRFPATH=/GW/D5data-8/counting_quantifier/tools/CRF++-0.58/

mkdir ./all_class_feature_data/

#Prepare evaluation data
java -Xms2g -Xmx8g -jar ../CINEX/CINEXPreprocessing.jar -i ./entity_list_all_rel/classes_all/"${name}"-all.tsv -e ./entity_list_all_rel/classes_all/"${name}"-all.tsv -p "${name}" -w /GW/D5data-8/counting_quantifier/enwiki_20170320_pages_articles/ -f -d --numterms --articles --ordinals --negation -o ./all_class_feature_data/ -n 100

gzip ./all_class_feature_data/"${name}"_test_cardinality.data


