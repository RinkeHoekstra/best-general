<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:metalex="http://www.metalex.eu/schema#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:rnl="http://www.rechtspraak.nl/namespaces/duit01" xmlns:rnlrdf="http://www.rechtspraak.nl/rdf#" xmlns:ljn="http://www.rechtspraak.nl/ljn.asp?ljn=">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="yes" media-type="xml" indent="yes"/>

	<xsl:preserve-space elements="text"/>
	
	<xsl:template match="/">
			<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="rnl:uitspraak">
		<xsl:variable name="kantongerecht_dh">Kantongerecht 's-Gravenhage</xsl:variable>
		<xsl:variable name="gerechtshof_dh">Gerechtshof 's-Gravenhage</xsl:variable>
		<xsl:variable name="rechtbank_dh">Rechtbank 's-Gravenhage</xsl:variable>
		<xsl:variable name="kantongerecht_db">Kantongerecht 's-Hertogenbosch</xsl:variable>
		<xsl:variable name="gerechtshof_db">Gerechtshof 's-Hertogenbosch</xsl:variable>
		<xsl:variable name="rechtbank_db">Rechtbank 's-Hertogenbosch</xsl:variable>
		
		<xsl:variable name="db">'s-Hertogenbosch</xsl:variable>
		<xsl:variable name="dh">'s-Gravenhage</xsl:variable>
		
		
		<xsl:element name="rnlrdf:Uitspraak">
			<xsl:attribute name="rdf:about">http://www.rechtspraak.nl/ljn.asp?ljn=<xsl:copy-of select="rnl:ljn/text()"/></xsl:attribute>
			<xsl:if test="rnl:status">
			<xsl:element name="rnlrdf:status">
				<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#<xsl:copy-of select="rnl:status/text()"/></xsl:attribute>
			</xsl:element>
			</xsl:if>
			<xsl:element name="rnlrdf:ljn"><xsl:copy-of select="rnl:ljn/text()"/></xsl:element>
			<xsl:element name="metalex:src">http://www.rechtspraak.nl/ljn.asp?ljn=<xsl:copy-of select="rnl:ljn/text()"/></xsl:element>

			<xsl:if test="rnl:instantie_naam">
				<xsl:element name="rnlrdf:instantie">
				<xsl:choose>
					<xsl:when test="rnl:instantie_naam/text() = $kantongerecht_dh">
						<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#Kantongerecht_Den_Haag</xsl:attribute>
					</xsl:when>
					<xsl:when test="rnl:instantie_naam/text() = $gerechtshof_dh">
						<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#Gerechtshof_Den_Haag</xsl:attribute>
					</xsl:when>
					<xsl:when test="rnl:instantie_naam/text() = $rechtbank_dh">
						<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#Rechtbank_Den_Haag</xsl:attribute>
					</xsl:when>
					<xsl:when test="rnl:instantie_naam/text() = $kantongerecht_db">
						<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#Kantongerecht_Den_Bosch</xsl:attribute>
					</xsl:when>
					<xsl:when test="rnl:instantie_naam/text() = $gerechtshof_db">
						<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#Gerechtshof_Den_Bosch</xsl:attribute>
					</xsl:when>
					<xsl:when test="rnl:instantie_naam/text() = $rechtbank_db">
						<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#Rechtbank_Den_Bosch</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#<xsl:value-of select="translate(string(rnl:instantie_naam/text()),' +.','___')"/></xsl:attribute>
					</xsl:otherwise>					
				</xsl:choose>


				</xsl:element>
			</xsl:if>

			<xsl:if test="rnl:zittingsplaats">
				<xsl:element name="rnlrdf:zittingsplaats">
				<xsl:choose>
					<xsl:when test="rnl:zittingsplaats/text() = $dh">
						<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#Den_Haag</xsl:attribute>
					</xsl:when>
					<xsl:when test="rnl:zittingsplaats/text() = $db">
						<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#Den_Bosch</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#<xsl:value-of select="translate(string(rnl:zittingsplaats/text()),' +.','___')"/></xsl:attribute>
					</xsl:otherwise>					
				</xsl:choose>


				</xsl:element>
			</xsl:if>

			
				
		
			
			<xsl:if test="rnl:datum_uitspraak">
			<xsl:element name="rnlrdf:datum_uitspraak"><xsl:copy-of select="rnl:datum_uitspraak/text()"/></xsl:element>
			</xsl:if>
			<xsl:if test="rnl:datum_gepubliceerd">
			<xsl:element name="rnlrdf:datum_gepubliceerd"><xsl:copy-of select="rnl:datum_gepubliceerd/text()"/></xsl:element>
			</xsl:if>
			<xsl:if test="rnl:zaaknummers">
			<xsl:element name="rnlrdf:zaaknummers"><xsl:copy-of select="rnl:zaaknummers/text()"/></xsl:element>
			</xsl:if>
			<xsl:if test="rnl:rechtsgebied_rechtspraak">
			<xsl:element name="rnlrdf:rechtsgebied_rechtspraak">
				<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#<xsl:value-of select="translate(string(rnl:rechtsgebied_rechtspraak/text()),' +.','___')"/></xsl:attribute>
			</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:sector_toon">
			<xsl:element name="rnlrdf:sector_toon">
				<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#<xsl:value-of select="translate(string(rnl:sector_toon/text()),' +.','___')"/></xsl:attribute>
			</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:procedure_soort">
			<xsl:element name="rnlrdf:procedure_soort">
				<xsl:attribute name="rdf:resource">http://www.rechtspraak.nl/rdf#<xsl:value-of select="translate(string(rnl:procedure_soort/text()),' +.','___')"/></xsl:attribute>
			</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:indicatie">
			<xsl:element name="rnlrdf:indicatie"><xsl:copy-of select="rnl:indicatie/text()"/></xsl:element>
			</xsl:if>
			<xsl:if test="rnl:kop">
			<xsl:element name="rnlrdf:kop"><xsl:copy-of select="rnl:kop/text()"/></xsl:element>
			</xsl:if>

		</xsl:element>
	</xsl:template>


</xsl:stylesheet>
