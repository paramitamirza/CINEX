#!/bin/bash

name=$1

CRFPATH=/GW/D5data-8/counting_quantifier/tools/CRF++-0.58/

mkdir -p ./all_rel_feature_data/
mkdir -p ./all_rel_models/
mkdir -p ./all_rel_eval_out/
mkdir -p ./all_rel_out/
mkdir -p ./all_rel_predicted/

gunzip ./all_class_feature_data/"${name}"_test_cardinality.data.gz

for f in ./entity_list_all_rel/train_all/"${name}"/*
do
    class="${name}"
    prop=${f##*/}
    prop=${prop%.*}
    prop="${prop/-min1/}"
    prop="${prop/class-entities-/}"
    prop=${prop%-*}
    prop=${prop%-*}
    
    relname="${prop}_${class}"
    proplbl=$(python decode_wikidata_id.py ${prop})
    classlbl=$(python decode_wikidata_id.py ${class})
    rellbl="${proplbl}__${classlbl}"

    evalfile="${f/min1/eval}"
    evalfile="${evalfile/\/train_/\/eval_}"
    all=./entity_list_all_rel/classes_all/"${class}"-all.tsv

    size=$(wc -l < $f)
    sizeall=$(wc -l < $all)

    #Only if there are at least 20 entities in the dataset... otherwise not worth all the hassle.
    if [ "${size}" -ge "20" ]; then

        echo "Processing ${relname}..."

        #Prepare training data
        if [ "${size}" -ge "8000" ]; then
            java -Xms2g -Xmx8g -jar ../CINEX/CINEXPreprocessing.jar -i "${f}" -e "${evalfile}" -p "${relname}" -w /GW/D5data-8/counting_quantifier/enwiki_20170320_pages_articles/ -f -d -h 0 -g 0 -t 2.7 --popular 0.5 --npopular 10000 --compositional --numterms --ordinals -o ./all_rel_feature_data/ -n 100 &> /dev/null
        else
            java -Xms2g -Xmx8g -jar ../CINEX/CINEXPreprocessing.jar -i "${f}" -e "${evalfile}" -p "${relname}" -w /GW/D5data-8/counting_quantifier/enwiki_20170320_pages_articles/ -f -d -h 0 -g 0 -t 2.7 --popular 1.0 --npopular 10000 --compositional --numterms --ordinals -o ./all_rel_feature_data/ -n 100 &> /dev/null
        fi

        #Label with CRF - eval data
        java -Xms2g -Xmx8g -jar ../CINEX/CINEXClassifier.jar -c "${CRFPATH}" -p "${relname}" -t ./all_rel_feature_data/"${relname}"_train_cardinality.data -e ./all_rel_feature_data/"${relname}"_test_cardinality.data -m ./all_rel_models/ -n 100 &> /dev/null

        #Label with CRF - all data
        java -Xms2g -Xmx8g -jar ../CINEX/CINEXClassifier.jar -c "${CRFPATH}" -p "${relname}" -e ./all_class_feature_data/"${name}"_test_cardinality.data -m ./all_rel_models/ -n 100 > /dev/null

        mv ./all_rel_feature_data/"${relname}"_cardinality.out ./all_rel_eval_out/
        mv ./all_class_feature_data/"${relname}"_cardinality.out ./all_rel_out/

        #Evaluate - eval data
        java -jar ../CINEX/CINEXEvaluation.jar --prob 0.1 --compositional --crfeval --ordinals --zero -i "${evalfile}" -p "${relname} ${rellbl}" -f ./all_rel_eval_out/"${relname}"_cardinality.out -r ./performance_crf_all_rel_eval.txt &> /dev/null

        java -jar ../CINEX/CINEXEvaluation.jar --prob 0.1 --compositional --crfeval --ordinals --zero -i "${evalfile}" -p "${relname} ${rellbl}" -f ./all_rel_eval_out/"${relname}"_cardinality.out -r ./performance_crf_all_rel_eval_relaxed.txt -x  &> /dev/null

        #Evaluate - all data
        java -jar ../CINEX/CINEXEvaluation.jar --prob 0.1 --compositional --crfeval --ordinals --zero -i "${f}" -a "${all}" -p "${relname} ${rellbl}" -f ./all_rel_out/"${relname}"_cardinality.out -r ./performance_crf_all_rel.txt -o ./all_rel_predicted/"${relname}"_"${rellbl}".tsv &> /dev/null


        rm -f ./all_rel_feature_data/"${relname}"_train_cardinality.data
        gzip -f ./all_rel_feature_data/"${relname}"_test_cardinality.data
        gzip -f ./all_rel_eval_out/"${relname}"_cardinality.out
        gzip -f ./all_rel_out/"${relname}"_cardinality.out
        gzip -f ./all_rel_models/"${relname}".model

        if [ ! -s ./all_rel_predicted/"${relname}"_"${rellbl}".tsv ] ; then
            rm -f ./all_rel_predicted/"${relname}"_"${rellbl}".tsv
        fi

    else
        echo "Not enough data for ${relname}."        
    fi

done

gzip -f ./all_class_feature_data/"${name}"_test_cardinality.data
