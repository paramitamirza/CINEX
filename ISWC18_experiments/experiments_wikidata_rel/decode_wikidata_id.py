import json
import urllib2
import sys

response1 = urllib2.urlopen("https://www.wikidata.org/w/api.php?action=wbgetentities&props=labels&ids=" + sys.argv[1] + "&languages=en&format=json")
data1 = json.load(response1) 
if "entities" in data1: label1 = data1["entities"][sys.argv[1]]["labels"]["en"]["value"]
print unicode(label1.replace(' ', '_')).encode('utf8')
