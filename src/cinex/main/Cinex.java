package cinex.main;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.zip.GZIPInputStream;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

import cinex.helper.GenerateFeatures;
import cinex.helper.WikipediaArticle;

public class Cinex {
	
	public static void main(String[] args) throws IOException {
		
		Options options = getEvalOptions();
		
		CommandLineParser parser = new DefaultParser();
		HelpFormatter formatter = new HelpFormatter();
		CommandLine cmd;
		
		try {
			cmd = parser.parse(options, args);
            
		} catch (ParseException e) {
			System.err.println(e.getMessage());
			formatter.printHelp("CINEX", options);
			
			System.exit(1);
			return;
		}
		
		String dirFeature = "./";
		
		String dirModels = "./crf_models";
		if (cmd.hasOption("m")) {
			dirModels = cmd.getOptionValue("models");
		}
		String dirCRF = cmd.getOptionValue("crf");
		
		String propName = cmd.getOptionValue("prop");
		String className = cmd.getOptionValue("class");
		String entityLabel = "";
		String sourceText = "";
		if (cmd.hasOption("u")) {
			WikipediaArticle wa = new WikipediaArticle();
			entityLabel = wa.entityLabel(cmd.getOptionValue("url"));
			sourceText = wa.fetchWikiArticleMediaWiki(cmd.getOptionValue("url"));
			
		} else {
			try(BufferedReader br = new BufferedReader(new FileReader(cmd.getOptionValue("input")))) {
			    StringBuilder sb = new StringBuilder();
			    String line = br.readLine();
	
			    while (line != null) {
			        sb.append(line);
			        sb.append(System.lineSeparator());
			        line = br.readLine();
			    }
			    entityLabel = "Unknown";
			    sourceText = sb.toString();
			}
		}
//		System.out.println(sourceText);
		
		String entityId = "Qtest";
		String count = "0";
		boolean training = false;
		boolean nummod = true;
		boolean ordinal = true;
		boolean numterms = true;
		boolean articles = true;
		boolean negation = true;
		boolean compositional = false;
		boolean negTrain = false;
		boolean quantifiers = false;
		boolean pronouns = false;
		
		long startTime = System.currentTimeMillis();
		System.out.print("Generate feature file (in column format) for CRF++... ");
		
		PrintStream err = System.err;
		System.setErr(new PrintStream(new OutputStream() {
		    @Override public void write(int b) throws IOException {}
		}));
		GenerateFeatures ext = new GenerateFeatures(dirFeature, propName + "_" + className,
//				wiki, 
				sourceText,
				entityId, count, 
//				curId, 
//				freqNum,
        		training,
//        		ignoreHigher, ignoreHigherLess, 
//        		infThreshold, countDist,
//        		isIgnoreFreq, maxCount,
        		nummod, ordinal, numterms, 
        		articles, quantifiers, pronouns,
        		compositional,
        		negation, negTrain);
		ext.run();
		System.setErr(err);
		long endTime   = System.currentTimeMillis();
		float totalTime = (endTime - startTime)/(float)1000;
		System.out.println("done [ " + totalTime + " sec].");
		
		String featureDataPath = dirFeature + "/" + propName + "_" + className + "_test_cardinality.data";
		
		if (Files.isDirectory(Paths.get(dirModels))) {
			
			File f = new File(dirModels + "/" + propName + "_" + className + ".model.gz");
			if (f.exists() && !f.isDirectory()) { 
				extractModelFile(dirModels + "/" + propName + "_" + className + ".model.gz");
			}
			
			File modelFile = new File(dirModels + "/" + propName + "_" + className + ".model");
			if (modelFile.exists()) {
			
				Classifier cl = new Classifier(propName + "_" + className, dirCRF, dirModels);
				
				//Test model
				cl.testModel(featureDataPath);
				
				String crfOutPath = featureDataPath.replace("_test_cardinality.data", "_cardinality.out");			
				BufferedReader br = new BufferedReader(new FileReader(crfOutPath));
				
				Evaluation eval = new Evaluation();
				eval.predictCRF(entityLabel, propName, className, crfOutPath, 0.1);
				
				Files.deleteIfExists(new File(featureDataPath).toPath());
				Files.deleteIfExists(new File(crfOutPath).toPath());
				
			} else {
				System.err.println("The model file " + dirModels + "/" + propName + "_" + className + ".model" + " doesn't exist!");
			}
			
		} else {
			System.err.println("Directory containing CRF++ models doesn't exist!");
			formatter.printHelp("CINEX", options);
		}
		
	}
	
	private static void extractModelFile(String gzipPath) throws IOException {
		FileInputStream fis = new FileInputStream(gzipPath);
		GZIPInputStream gzis = new GZIPInputStream(fis);	

		byte[] buffer = new byte[1024];
        int length;
        
        FileOutputStream fos = new FileOutputStream(gzipPath.replace(".gz", ""));
        while ((length = gzis.read(buffer)) > 0) {
            fos.write(buffer, 0, length);
        }	
        
        fos.close();
        gzis.close();
        fis.close();
	}
	
	public static Options getEvalOptions() {
		Options options = new Options();
		
		Option input = new Option("i", "input", true, "Input text file (.txt) path");
		input.setRequired(false);
		options.addOption(input);
		
		Option inputUrl = new Option("u", "url", true, "Input Wikipedia URL");
		inputUrl.setRequired(true);
		options.addOption(inputUrl);
		
		Option wdproperty = new Option("p", "prop", true, "Wikidata property");
		wdproperty.setRequired(true);
		options.addOption(wdproperty);
		
		Option wdclass = new Option("c", "class", true, "Wikidata class");
		wdclass.setRequired(true);
		options.addOption(wdclass);
		
		Option crf = new Option("r", "crf", true, "CRF++ directory path");
		crf.setRequired(true);
		options.addOption(crf);
		
		Option model = new Option("m", "models", true, "Directory containing CRF++ models for relations");
		model.setRequired(true);
		options.addOption(model);
		
		return options;
	}

}
