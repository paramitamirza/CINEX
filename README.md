# CINEX (Counting INformation EXtraction)

Information extraction traditionally focuses on extracting relations between identifiable entities, such as **<[Monterey](https://www.wikidata.org/wiki/Q108072), [isLocatedIn](https://www.wikidata.org/wiki/Property:P131), [California](https://www.wikidata.org/wiki/Q99)>**. Yet, texts often also contain **counting information**, stating that a subject is in a specific relation with a number of objects, without mentioning the objects themselves, for example, *“The U.S. state of California is divided into 58 counties.”*. 

Such **counting quantifiers** can help in a variety of tasks such as query answering or knowledge base curation, but are neglected by prior work. We develop the first full-fledged system for extracting counting information from text, called **CINEX**, which predict counting quantifiers given a pair of **<subject, relation>**, e.g., **<[California](https://www.wikidata.org/wiki/Q99), [hasCounties](https://www.wikidata.org/wiki/Property:P150), 58>**. 

We employ distant supervision using fact counts from a knowledge base as training seeds, and leverage CRF-based sequence tagging models to identify counting information in the text. Experiments with five human-evaluated relations show that CINEX can achieve 60% average precision for extracting counting information. In a large-scale experiment, we demonstrate the potential for knowledge base enrichment by applying CINEX to 2,474 frequent relations in Wikidata. CINEX can assert the existence of 2.5M facts for 110 distinct relations, which is 28% more than the existing Wikidata facts for these relations.

The predicted counting quantifiers for (selected 37) Wikidata relations, by running the learned models on all entities in a class given a Wikidata property-class pair (e.g., all child of humans), can be queried at [`https://cinex.cs.ui.ac.id/`](https://cinex.cs.ui.ac.id/). For instance, ["How many spouses does Isaac Newton have?"](https://tinyurl.com/ydbtddj9) or ["Does Wikidata contain all children of George HW Bush?"](http://tinyurl.com/y6vzr5b9).

### Installing and Running CINEX

#### Requirements
* Java Runtime Environment (JRE) 1.7.x or higher
* [CRF++](https://taku910.github.io/crfpp/): Yet Another CRF toolkit

#### Maven 
To build the fat (executable) JAR:
* Install the WS4J library in your local Maven repo, e.g., `mvn install:install-file -Dfile=./lib/ws4j-1.0.1.jar -DgroupId=edu.cmu.lti -DartifactId=ws4j -Dversion=1.0.1 -Dpackaging=jar`
* Run `mvn package` to build the executable JAR file (in `target/CINEX-<version>.jar`).

CINEX is also available on [Maven Central](https://search.maven.org/artifact/com.github.paramitamirza/CINEX/1.0.1/jar). Please add the following dependency in your `pom.xml`.
```
<dependency>
  <groupId>com.github.paramitamirza</groupId>
  <artifactId>CINEX</artifactId>
  <version>1.0.1</version>
</dependency>
```
#### Usage
```
usage: CINEX
 -u,--url <arg>      Input Wikipedia URL   
 -i,--input <arg>    (Optional) Input text file (.txt) path
 -p,--prop <arg>     Wikidata property ID
 -c,--class <arg>    Wikidata class ID
 -m,--models <arg>   Directory containing CRF++ models for relations
 -r,--crf <arg>      CRF++ directory path
``` 
As the source text, the URL of a Wikipedia article must be provided, optionally, a cleaner source text can also be given as a text file. A pair of Wikidata <property, class> IDs (e.g., <P40, Q5> denoting a child-of-human relation) is required, as well as the path to a directory containing the corresponding model* (P40_Q5.model.gz). Finally, CRF++ must be installed, and its path must also be given. For example:
```
java -Xmx2G -jar ./target/CINEX-<version>.jar 
	-u https://en.wikipedia.org/wiki/Robin_Williams 
	-p P26 -c Q5 -m ./crf_models 
	--crf /home/paramita/Projects/counting_quantifier/tools/CRF++-0.58/
```
which gives as a result:
```
The predicted counting quantifier of spouse of Robin_Williams (class: human) is: 3
	confidence score: 0.116744
	evidence (type: ordinal): Williams married his [third] wife , graphic designer Susan Schneider , 
				  on October 22 , 2011 , in St. Helena , California .
```
*) Please find the list of available models in [`resources/CRF_models.tsv`](resources/CRF_models.tsv), all model files can be downloaded from [here](http://people.mpi-inf.mpg.de/~paramita/cinex_crf_models/).

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
