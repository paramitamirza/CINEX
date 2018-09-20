import sys
import urllib.parse
import os

dirname = sys.argv[1]

cq_id = int(1)
cinex_ent_prefix = "https://cinex.cs.ui.ac.id/entity/"
cinex_prop_prefix = "https://cinex.cs.ui.ac.id/ns#"
wd_ent_prefix = "http://www.wikidata.org/entity/"
wd_prop_prefix = "http://www.wikidata.org/prop/direct/"

for f in os.listdir(dirname):
    if ".tsv" in f:
        filename = dirname + "/" + f
        wd_prop = f.split('.')[0].split('_')[0]

        predicted = open(filename, "r")

        for line in predicted.readlines():
            cols = line.strip().split('\t')

            wd_id = cols[0]
            wiki = cols[1]
            wdlabel = cols[2].replace('_', ' ')
            wdlabel = urllib.parse.unquote(urllib.parse.unquote(wdlabel))
            predcq = cols[4]
            conf = cols[5]
            cqtype = cols[6]
            evidence = cols[7]

            evidence = evidence.replace("[", "[[")
            evidence = evidence.replace("]", "]]")
            evidence = evidence.replace("-LRB-", "(")
            evidence = evidence.replace("-RRB-", ")")
            evidence = evidence.replace("-LCB-", "{")
            evidence = evidence.replace("-RCB-", "}")
            evidence = evidence.replace("-LSB-", "[")
            evidence = evidence.replace("-RSB-", "]")
            
            print ("<" + wiki + "> <http://schema.org/about> <" + wd_ent_prefix + wd_id + "> .")
            print ("<" + wd_ent_prefix + wd_id + "> <http://www.w3.org/2000/01/rdf-schema#label> \"" + wdlabel + "\" .")
            print ("<" + cinex_ent_prefix + "CQ" + str(cq_id) + "> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <" + cinex_prop_prefix + cqtype + "> .")
            print ("<" + cinex_ent_prefix + "CQ" + str(cq_id) + "> <" + cinex_prop_prefix + "subject> <" + wd_ent_prefix + wd_id + "> .")
            print ("<" + cinex_ent_prefix + "CQ" + str(cq_id) + "> <" + cinex_prop_prefix + "property> <" + wd_prop_prefix + wd_prop + "> .")
            print ("<" + cinex_ent_prefix + "CQ" + str(cq_id) + "> <" + cinex_prop_prefix + "predictedCount> \"" + predcq + "\"^^<http://www.w3.org/2001/XMLSchema#integer> .")
            print ("<" + cinex_ent_prefix + "CQ" + str(cq_id) + "> <" + cinex_prop_prefix + "confidenceScore> \"+" + conf + "\"^^<http://www.w3.org/2001/XMLSchema#decimal> .")
            print ("<" + cinex_ent_prefix + "CQ" + str(cq_id) + "> <" + cinex_prop_prefix + "evidence> \"" + evidence + "\" .")
            print ("<" + cinex_ent_prefix + "CQ" + str(cq_id) + "> <" + cinex_prop_prefix + "evidenceSource> <" + wiki + "> .")
            print ("")

            cq_id += 1
