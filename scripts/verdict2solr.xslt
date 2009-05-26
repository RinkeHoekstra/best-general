<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:metalex="http://www.metalex.eu/schema#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:rnl="http://www.rechtspraak.nl/namespaces/duit01" xmlns:rnlrdf="http://www.rechtspraak.nl/rdf#" version="1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="yes" media-type="xml" indent="yes"/>
	<xsl:preserve-space elements="text"/>
	
	<xsl:variable name="rnlns" select="'http://www.rechtspraak.nl/rdf#'"/>
	<xsl:variable name="rnlprefix" select="'rnl_'"/>
	<xsl:variable name="metalexns" select="'http://www.metalex.eu/schema#'"/>
	<xsl:variable name="metalexprefix" select="'metalex_'"/>
	
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
		<xsl:element name="doc">
			<xsl:if test="rnl:status">
				<xsl:element name="field">
					<xsl:attribute name="name">status</xsl:attribute>
					<xsl:copy-of select="rnl:status/text()"/>
				</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>status</xsl:attribute>
					<xsl:value-of select="$rnlns"/><xsl:copy-of select="rnl:status/text()"/>
				</xsl:element>
			</xsl:if>
			<xsl:element name="field">
				<xsl:attribute name="name">ljn</xsl:attribute>
				<xsl:copy-of select="rnl:ljn/text()"/>
			</xsl:element>
			<xsl:element name="field">
				<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>ljn</xsl:attribute>
				<xsl:value-of select="$rnlns"/><xsl:copy-of select="rnl:ljn/text()"/>
			</xsl:element>
			<xsl:element name="field">
				<xsl:attribute name="name">src</xsl:attribute>
				http://www.rechtspraak.nl/ljn.asp?ljn=<xsl:copy-of select="rnl:ljn/text()"/>
			</xsl:element>
			<xsl:element name="field">
				<xsl:attribute name="name"><xsl:value-of select="$metalexprefix"/>src</xsl:attribute>
				http://www.rechtspraak.nl/ljn.asp?ljn=<xsl:copy-of select="rnl:ljn/text()"/>
			</xsl:element>
			<xsl:if test="rnl:instantie_naam">
				<xsl:element name="field">
					<xsl:attribute name="name">instantie</xsl:attribute>
					<xsl:copy-of select="rnl:instantie_naam/text()"/>
				</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>instantie</xsl:attribute>
					<xsl:choose>
						<xsl:when test="rnl:instantie_naam/text() = $kantongerecht_dh">
						Kantongerecht_Den_Haag
					</xsl:when>
						<xsl:when test="rnl:instantie_naam/text() = $gerechtshof_dh">
						<xsl:value-of select="$rnlns"/>Gerechtshof_Den_Haag
					</xsl:when>
						<xsl:when test="rnl:instantie_naam/text() = $rechtbank_dh">
						<xsl:value-of select="$rnlns"/>Rechtbank_Den_Haag
					</xsl:when>
						<xsl:when test="rnl:instantie_naam/text() = $kantongerecht_db">
						<xsl:value-of select="$rnlns"/>Kantongerecht_Den_Bosch
					</xsl:when>
						<xsl:when test="rnl:instantie_naam/text() = $gerechtshof_db">
						<xsl:value-of select="$rnlns"/>Gerechtshof_Den_Bosch
					</xsl:when>
						<xsl:when test="rnl:instantie_naam/text() = $rechtbank_db">
						<xsl:value-of select="$rnlns"/>Rechtbank_Den_Bosch
					</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$rnlns"/><xsl:value-of select="translate(string(rnl:instantie_naam/text()),' +.','___')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:zittingsplaats">
				<xsl:element name="field">
					<xsl:attribute name="name">zittingsplaats</xsl:attribute>
					<xsl:copy-of select="rnl:zittingsplaats/text()"/>
				</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>zittingsplaats</xsl:attribute>
					<xsl:choose>
						<xsl:when test="rnl:zittingsplaats/text() = $dh">
						<xsl:value-of select="$rnlns"/>Den_Haag
					</xsl:when>
						<xsl:when test="rnl:zittingsplaats/text() = $db">
						<xsl:value-of select="$rnlns"/>Den_Bosch
					</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$rnlns"/><xsl:value-of select="translate(string(rnl:zittingsplaats/text()),' +.','___')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:datum_uitspraak">
				<xsl:element name="field">
					<xsl:attribute name="name">datum_uitspraak</xsl:attribute>
					<xsl:copy-of select="substring(rnl:datum_uitspraak/text(),7,4)"/>-<xsl:copy-of select="substring(rnl:datum_uitspraak/text(),4,2)"/>-<xsl:copy-of select="substring(rnl:datum_uitspraak/text(),1,2)"/>T00:00:00Z</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>datum_uitspraak</xsl:attribute>
					<xsl:copy-of select="substring(rnl:datum_uitspraak/text(),7,4)"/>-<xsl:copy-of select="substring(rnl:datum_uitspraak/text(),4,2)"/>-<xsl:copy-of select="substring(rnl:datum_uitspraak/text(),1,2)"/>T00:00:00Z</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:datum_gepubliceerd">
				<xsl:element name="field">
					<xsl:attribute name="name">datum_gepubliceerd</xsl:attribute>
					<xsl:copy-of select="substring(rnl:datum_gepubliceerd/text(),7,4)"/>-<xsl:copy-of select="substring(rnl:datum_gepubliceerd/text(),4,2)"/>-<xsl:copy-of select="substring(rnl:datum_gepubliceerd/text(),1,2)"/>T00:00:00Z</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>datum_gepubliceerd</xsl:attribute>
					<xsl:copy-of select="substring(rnl:datum_gepubliceerd/text(),7,4)"/>-<xsl:copy-of select="substring(rnl:datum_gepubliceerd/text(),4,2)"/>-<xsl:copy-of select="substring(rnl:datum_gepubliceerd/text(),1,2)"/>T00:00:00Z</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:zaaknummers">
				<xsl:element name="field">
					<xsl:attribute name="name">zaaknummers</xsl:attribute>
					<xsl:copy-of select="rnl:zaaknummers/text()"/>
				</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>zaaknummers</xsl:attribute>
					<xsl:copy-of select="rnl:zaaknummers/text()"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:rechtsgebied_rechtspraak">
				<xsl:element name="field">
					<xsl:attribute name="name">rechtsgebied_rechtspraak</xsl:attribute>
					<xsl:copy-of select="rnl:rechtsgebied_rechtspraak/text()"/>
				</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>rechtsgebied_rechtspraak</xsl:attribute>
					<xsl:value-of select="$rnlns"/><xsl:value-of select="translate(string(rnl:rechtsgebied_rechtspraak/text()),' +.','___')"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:sector_toon">
				<xsl:element name="field">
					<xsl:attribute name="name">sector_toon</xsl:attribute>
					<xsl:copy-of select="rnl:sector_toon/text()"/>
				</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>sector_toon</xsl:attribute>
					<xsl:value-of select="$rnlns"/><xsl:value-of select="translate(string(rnl:sector_toon/text()),' +.','___')"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:procedure_soort">
				<xsl:element name="field">
					<xsl:attribute name="name">procedure_soort</xsl:attribute>
					<xsl:copy-of select="rnl:procedure_soort/text()"/>
				</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>procedure_soort</xsl:attribute>
					<xsl:value-of select="$rnlns"/><xsl:value-of select="translate(string(rnl:procedure_soort/text()),' +.','___')"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:indicatie">
				<xsl:element name="field">
					<xsl:attribute name="name">indicatie</xsl:attribute>
					<xsl:copy-of select="rnl:indicatie/text()"/>
				</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>indicatie</xsl:attribute>
					<xsl:copy-of select="rnl:indicatie/text()"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="rnl:kop">
				<xsl:element name="field">
					<xsl:attribute name="name">kop</xsl:attribute>
					<xsl:copy-of select="rnl:kop/text()"/>
				</xsl:element>
				<xsl:element name="field">
					<xsl:attribute name="name"><xsl:value-of select="$rnlprefix"/>kop</xsl:attribute>
					<xsl:copy-of select="rnl:kop/text()"/>
				</xsl:element>
			</xsl:if>
			<xsl:element name="field">
				<xsl:attribute name="name">uitspraak_anoniem</xsl:attribute>
				<xsl:copy-of select="rnl:uitspraak_anoniem/text()"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
