# CINEX (Counting INformation EXtraction)

Information extraction traditionally focuses on extracting relations between identifiable entities, such as **<[Monterey](https://www.wikidata.org/wiki/Q108072), [isLocatedIn](https://www.wikidata.org/wiki/Property:P131), [California](https://www.wikidata.org/wiki/Q99)>**. Yet, texts often also contain **counting information**, stating that a subject is in a specific relation with a number of objects, without mentioning the objects themselves, for example, *“The U.S. state of California is divided into 58 counties.”*. 

Such **counting quantifiers** can help in a variety of tasks such as query answering or knowledge base curation, but are neglected by prior work. We develop the first full-fledged system for extracting counting information from text, called **CINEX**, which predict counting quantifiers given a pair of **<subject, relation>**, e.g., **<[California](https://www.wikidata.org/wiki/Q99), [hasCounties](https://www.wikidata.org/wiki/Property:P150), 58>**. 

We employ distant supervision using fact counts from a knowledge base as training seeds, and leverage CRF-based sequence tagging models to identify counting information in the text. Experiments with five human-evaluated relations show that CINEX can achieve 60% average precision for extracting counting information. In a large-scale experiment, we demonstrate the potential for knowledge base enrichment by applying CINEX to 2,474 frequent relations in Wikidata. CINEX can assert the existence of 2.5M facts for 110 distinct relations, which is 28% more than the existing Wikidata facts for these relations.

### Requirements
* Java Runtime Environment (JRE) 1.7.x or higher

##### Text processing tools:
* [Stanford CoreNLP 3.7.x](http://stanfordnlp.github.io/CoreNLP/) or higher -- a suite of core NLP tools. The .jar file should be included in the classpath.

##### Other libraries and tools:
* [JSON-java](https://mvnrepository.com/artifact/org.json/json) - JSON for Java
* [Apache Commons CLI](https://commons.apache.org/proper/commons-cli/) - an API for parsing command line options passed to programs.
* [CRF++](https://taku910.github.io/crfpp/): Yet Another CRF toolkit

### ISWC 2018 Experiments

Please check [`ISWC18_experiments/`](ISWC18_experiments/), as well as the following publication, for more information about data used, experimental details and results.

##### Publication
Paramita Mirza, Simon Razniewski, Fariz Darari and Gerhard Weikum. *Enriching Knowledge Bases with Counting Quantifiers*. In Proceedings of ISWC 2018. [[pdf]](https://arxiv.org/pdf/1807.03656.pdf)

### ACL 2017 Experiments

Please check [`Relation Cardinality Extraction`](https://github.com/paramitamirza/RelationCardinalityExtraction), as well as the following publication, for more information about data used, experimental details and results.

##### Publication
Paramita Mirza, Simon Razniewski, Fariz Darari and Gerhard Weikum. *Cardinal Virtues: Extracting Relation Cardinalities from Text*. In Proceedings of ACL 2017 (short paper). [[pdf]](http://aclweb.org/anthology/P/P17/P17-2055.pdf)

### Contact
For more information please contact [Paramita Mirza](http://paramitamirza.com/) (paramita135@gmail.com).
