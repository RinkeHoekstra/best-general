<?php


$verdict_path = $argv[1];
$xsl = $argv[2];

// NB should not have an .xml extension!
$outfile = $argv[3];

$xslDoc = new DOMDocument();
$xslDoc->load($xsl);

$output = "<add>\n";

$global_count = 0;
$count = 0;

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
   
	$count += 1;

	if($count == 5000){
		$old_global_count = $global_count;
		$global_count += $count;
		
		$output .= "\n</add>";

		if($handle = fopen($outfile."_".$old_global_count."-".$global_count.".xml","w")){
			echo "\nWriting output to file (in UTF-8) ".$target;
			fputs($handle,utf8_encode($output));
			echo "... done.\n";
			fclose($handle);
		}
		
		$count = 0;
		$output = "<add>\n";
	}

}

$old_global_count = $global_count;
$global_count += $count;

$output .= "\n</add>";

if($handle = fopen($outfile."_".$old_global_count."-".$global_count.".xml","w")){
	echo "\nWriting output to file (in UTF-8) ".$target;
	fputs($handle,utf8_encode($output));
	echo "... done.\n";
	fclose($handle);
}



?>