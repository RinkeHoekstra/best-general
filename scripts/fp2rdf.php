<?php

	/*
	//	Convert fingerprint (concept) files in 'display' format to RDF/Turtle files.
	//  Convert case files in 'display' format to RDF/Turtle files.
	//
	// 	Author: Rinke Hoekstra
	//	Date: 	20090317
	*/

	$target = $argv[1];
	$concept_path = $argv[2];
	$case_path = $argv[3];
	$verdict_path = $argv[4];
		
	$concept_nr_to_name = array();
	$concept_number = "";
	
	$tort_uri = "http://www.best-project.nl/owl/tort-ontology.owl";
	$tort_prefix = "to";
	
	$this_prefix = "tv";
	
	$best_uri = "http://www.best-project.nl/owl/best.owl";
	$best_prefix = "best";
	
	$ljn_uri = "http://www.rechtspraak.nl/ljn";
	$ljn_prefix = "ljn";
	
	// Add headers
	$output = add_turtle_headers($target);
	// Add owl:Ontology resource and necessary imports
	$output .= add_owl_header($target);
	// Add property definitions
	$output .= add_property_defs();
	// Add class definitions
	$output .= add_class_defs();
	
	
	
	// Generate concept definitions
	foreach (new DirectoryIterator($concept_path) as $fileInfo) {
	    if($fileInfo->isDot()) continue;
		if($fileInfo->getFileName()==".DS_Store") continue;
		
	    echo "Parsing: " . $fileInfo->getPath() . "/". $fileInfo->getFilename(). "\n";
		
		if ($handle = fopen($fileInfo->getPath(). "/". $fileInfo->getFilename(),"rb")) {
			if(substr($fileInfo->getFilename(),0,2)!="fp") {
				$concept_string = $fileInfo->getFileName();
			} else {
				$concept_string = rtrim(fgets($handle),"\n");
				$concept_number = substr($fileInfo->getFileName(),2);
				
			}
			
			// Replace all offending characters with underscores in local concept name (uri), and add namespace prefix.
			$offending_characters = array(" ",",",".");
	        $uri= $this_prefix.":".str_replace($offending_characters,"_",$concept_string);
	
			// If the current concept is one defined in a 'fp' file, it has a number
			// Add the mapping between numer and uri to the concept_nr_to_name array,
			// and reset the concept number to an empty string.
			if($concept_number != ""){
				$concept_nr_to_name[$concept_number] = $uri;
				$concept_number = "";
			}
			echo "Creating concept ".$concept_string." (".$uri.")\n";
			
			$output .= $uri."\n\t a\t skos:Concept, ".$best_prefix.":Concept ;\n";
			
			$labels = "\t rdfs:label\t";
			$fp		= "\t ".$tort_prefix.":fingerprint\t (";
			
	        while(!feof($handle)){
	         $infracs=explode("\t", rtrim(fgets($handle)));
	         if($infracs[1]!="" && $infracs[0]!= ""){
				// Add an rdfs:label
				$labels .= " \"".$infracs[1]."\"@nl,\n\t\t\t";
				
				// Add to to:fingerprint
				$fp 	.= "[ ".$tort_prefix.":weight \"".ltrim($infracs[0])."\"^^xsd:integer; ".$tort_prefix.":value \"".$infracs[1]."\"@nl ]\n\t\t\t";
	         };
        	}; 
			// Remove the superfluous comma, tab and newline characters
 			$labels = rtrim($labels, ",\t\n");
			$fp = rtrim($fp, "\t\n");
			// Add closing bracket
			$fp .= ")";
			
			// NB: FINGERPRINTS NOT SWITCHED OFF!
			// Add rdfs:labels, and to:fingerprints, close the turtle statement, and add nice newlines.
			$output .= $labels.";\n".$fp.".\n\n";
			// Don't add fingerprint for now
			// $output .= $labels.".\n\n";
			
        	fclose($handle);
      	}
	}

	// Generate case definitions
	foreach (new DirectoryIterator($case_path) as $fileInfo) {
	    if($fileInfo->isDot()) continue;
		if($fileInfo->getFileName()==".DS_Store") continue;
		
	    echo "Parsing: " . $fileInfo->getPath() . "/". $fileInfo->getFilename(). "\n";
		
		if ($handle = fopen($fileInfo->getPath(). "/". $fileInfo->getFilename(),"rb")) {
			$case_string = $fileInfo->getFileName();
			
			// Replace all offending characters with underscores in local case name (uri), and add namespace prefix.
			$offending_characters = array(" ",",",".");
	        $uri= $this_prefix.":".str_replace($offending_characters,"_",$case_string);
	
			echo "Creating case ".$case_string." (".$uri.") as owl:Class\n";
			
			$output .= $uri."\n\t a\t owl:Class ;\n";
			$output .= "\t rdfs:subClassOf\t ".$best_prefix.":Case ;\n";
			
			// Retrieve concepts from case filename
			$concept_numbers = explode(" ",rtrim(fgets($handle),"\n"));
			
			// Add equivalent class restriction on case for the enumeration of concepts.

			$output .= "\t owl:equivalentClass\n";
			$output .= "\t\t [ a\t owl:Class ;\n";
			$output .= "\t\t   owl:intersectionOf (\n";
			foreach($concept_numbers as $concept_number){
				$output .= "\t\t\t [ a\t owl:Restriction ; \n";
				$output .= "\t\t\t   owl:hasValue\t ".$concept_nr_to_name[$concept_number]." ; \n";
				$output .= "\t\t\t   owl:onProperty\t ".$best_prefix.":described_by ;\n";
				$output .= "\t\t\t ]\n";
			}
			$output .= "\t\t\t)\n\t\t ] .\n\n\n";
			
			// For each ljn number in the case file, create an instance of skos:Concept and the recently created case number.
			// The instance has an ljn number as its identifier.
			while(!feof($handle)){
	         $verdict = rtrim(fgets($handle));
			 if($verdict!="") {
			 	$verdict_uri = $ljn_prefix.":".$verdict;
				$output .= $verdict_uri."\t a\t skos:Concept , ".$uri." .\n\n";
		 	 }
			 
			}
			
        	fclose($handle);
      	}
	}	
	
	
	// Create links between verdicts and concepts.
	foreach (new DirectoryIterator($verdict_path) as $fileInfo) {
	    if($fileInfo->isDot()) continue;
		if($fileInfo->getFileName()==".DS_Store") continue;
		if(substr($fileInfo->getFileName(),0,15)!="verdictslist.fp") continue;
		$verdicts = "";
	    echo "Parsing: " . $fileInfo->getPath() . "/". $fileInfo->getFilename(). "\n";
		
		$concept_number = substr($fileInfo->getFileName(),15);
		
		$uri = $concept_nr_to_name[$concept_number];
		echo $uri;
		if ($handle = fopen($fileInfo->getPath(). "/". $fileInfo->getFilename(),"rb")) {
			$output .= $uri."\n\t ".$best_prefix.":describes\t ";
			while(!feof($handle)){
				$verdict = rtrim(fgets($handle));
				 if($verdict!="") {
				 	$verdict_uri = $ljn_prefix.":".$verdict;
					$verdicts .= $verdict_uri." ,";
			 	 }
			}
	
			$verdicts = rtrim($verdicts, ",");
			$verdicts .= ".\n\n";
	
			$output .= $verdicts;
		}
		fclose($handle);
	}	
	
	if($handle = fopen($target,"w")){
		echo "\nWriting output to file (in UTF-8) ".$target;
		fputs($handle,utf8_encode($output));
		echo "... done.\n";
		fclose($handle);
	}
	
	
	function add_turtle_headers($target) {
		global $tort_prefix,$tort_uri,$best_prefix,$best_uri,$ljn_prefix,$ljn_uri,$this_prefix;
		
		// $text .= "# Specify baseURI for TopBraid's convenience...\n";
		// $text .= "# baseURI: http://www.best-project.nl/owl/".$target." \n";
		// $text .= "@base \t\t<http://www.best-project.nl/owl/".$target."> .\n\n"; 
		
		// Set default namespaces and prefix
		$text = "";
		
		$text .= "@prefix rdf:\t <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
		$text .= "@prefix rdfs:\t <http://www.w3.org/2000/01/rdf-schema#> .\n";
		$text .= "@prefix xsd:\t <http://www.w3.org/2001/XMLSchema#> .\n";
		$text .= "@prefix owl:\t <http://www.w3.org/2002/07/owl#> .\n";
		$text .= "@prefix skos:\t <http://www.w3.org/2004/02/skos/core#> .\n";
		
		// Set current namespace + prefix
		$text .= "@prefix ".$tort_prefix.":\t <".$tort_uri."#> .\n";
		$text .= "@prefix ".$best_prefix.":\t <".$best_uri."#> .\n";
		$text .= "@prefix ".$ljn_prefix.":\t <".$ljn_uri."#> .\n";
		
		$text .= "@prefix ".$this_prefix.":\t <http://www.best-project.nl/owl/".$target."#> .\n\n";
		//$text .= "# Specify default namespace for TopBraid's convenience...\n";
		$text .= "@prefix :\t <http://www.best-project.nl/owl/".$target."#> .\n\n";
		
		return $text;
	}
	
	
	function add_owl_header($target){
		global $tort_uri;
		
		$text = "";
		
		$text .= "<http://www.best-project.nl/owl/".$target.">\n";
		$text .= "\t a\t owl:Ontology;\n";
		$text .= "\t owl:imports\t <http://www.w3.org/2004/02/skos/core> ;\n";
		$text .= "\t owl:imports\t <".$tort_uri."> .\n\n";
		
		return $text;
		
	}
	
	function add_property_defs(){
		global $tort_prefix,$best_prefix;
		
		$text = "";
		$text .= $tort_prefix.":fingerprint\t a\t owl:ObjectProperty .\n";
		$text .= $tort_prefix.":value\t a\t owl:DatatypeProperty .\n\n";
		$text .= $best_prefix.":described_by\t a\t owl:ObjectProperty .\n\n";
		$text .= $best_prefix.":describes\t a\t owl:ObjectProperty ;\n";
		$text .= "\t\t owl:inverseOf\t ".$best_prefix.":described_by .\n\n";
		
		return $text;
	}
	
	function add_class_defs() {
		global $best_prefix;
		
		$text = "";
		$text .= $best_prefix.":Case\t a\t owl:Class .\n";
		$text .= $best_prefix.":Concept\t a\t owl:Class .\n";
		// $text .= $best_prefix.":Verdict\t a\t owl:Class .\n\n";

		return $text;
	}


?>