<?php


$verdict_path = $argv[1];
$xsl = $argv[2];
$outfile = $argv[3];

$xslDoc = new DOMDocument();
$xslDoc->load($xsl);

$output = "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"
xmlns:owl=\"http://www.w3.org/2002/07/owl#\" xmlns:ljn=\"http://www.rechtspraak.nl/ljn#\" xml:base=\"http://www.best-project.nl/owl/verdicts.owl\" xmlns=\"http://www.best-project.nl/owl/verdicts.owl#\">\n";

$output .= "<owl:Ontology rdf:about=\"http://www.best-project.nl/owl/verdicts.owl\">\n";
$output .= "\t\t<owl:imports rdf:resource=\"http://www.rechtspraak.nl/rdf\"/>\n";
$output .= "</owl:Ontology>\n\n";

foreach (new DirectoryIterator($verdict_path) as $fileInfo) {
    if($fileInfo->isDot()) continue;
	if($fileInfo->getFileName()==".DS_Store") continue;
	if(!strpos($fileInfo->getFileName(),'.xml')) continue;
	
	echo "Parsing ".$fileInfo->getFileName()."\n";
	
	$xml = $fileInfo->getPath(). "/". $fileInfo->getFilename();



   $xmlDoc = new DOMDocument();
   $xmlDoc->load($xml);

   $proc = new XSLTProcessor();
   $proc->importStylesheet($xslDoc);

   $output .= $proc->transformToXML($xmlDoc);
   
   
}

$output .= "\n</rdf:RDF>";

if($handle = fopen($outfile,"w")){
	echo "\nWriting output to file (in UTF-8) ".$target;
	fputs($handle,utf8_encode($output));
	echo "... done.\n";
	fclose($handle);
}



?>