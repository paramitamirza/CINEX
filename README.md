# CINEX (Counting INformation EXtraction)

Information extraction traditionally focuses on extracting relations between identifiable entities, such as **<Monterey, locatedIn, California>**. Yet, texts often also contain **counting information**, stating that a subject is in a specific relation with a number of objects, without mentioning the objects themselves, for example, *“The U.S. state of California is divided into 58 counties.”*. 

Such counting quantifiers can help in a variety of tasks such as query answering or knowledge base curation, but are neglected by prior work. We develop the first full-fledged system for extracting counting information from text, called CINEX, which predict such **counting quantifiers**, e.g., **<California, numberOfAdminDivision, 58>**. 

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

#### Publication
Paramita Mirza, Simon Razniewski, Fariz Darari and Gerhard Weikum. *Enriching Knowledge Bases with Counting Quantifiers*. In Proceedings of ISWC 2018. [[pdf]](https://arxiv.org/pdf/1807.03656.pdf)

_! Whenever making reference to this resource please cite the paper in the Publication section. !_

### Contact
For more information please contact [Paramita Mirza](http://paramitamirza.com/) (paramita135@gmail.com).
