<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no" />
	
	<xsl:template match="/">
		<xsl:apply-templates mode="copy"/>
	</xsl:template>

	<!-- copy all attributes -->
	<xsl:template match="@*" mode="copy" priority="0">
		<xsl:copy>
			<xsl:apply-templates mode="copy"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- exclude ESRI-defined attributes from the output -->
	<xsl:template match="@Sync | @Name" mode="copy" priority="1">
	</xsl:template>

	<!-- copy all elements -->
	<xsl:template match="*" mode="copy" priority="0">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="copy"/>
		</xsl:copy>
	</xsl:template>

	<!-- exclude ESRI-defined elements from the output -->
	<xsl:template match="Esri | langdata | ftname | natvform | lboundng | minalti | maxalti | eframes | browseem | assndesc | procsv | esriterm | rastxsz | rastysz | rastxu | rastyu | rastbpp | rastnodt | rastorig | rastcmap | rastcomp | rastband | rastdtyp | rastplyr | rastifor | rastityp | netinfo | cordsysn | behrmann | bonne | cassini | eckert1 | eckert2 | eckert3 | eckert4 | eckert5 | eckert6 | gallster | loximuth | mollweid | quartic | winkel1 | winkel2 | otherprj | enttypt | enttypc | attalias | attrtype | attwidth | atprecis | attscale | atoutwid | atnumdec | atindex | rdommean | rdomstdv | relinfo | subtype | mapprojp | dssize | dsoverv | sdeconn | langmeta | metextns[onlink/text() = 'http://www.esri.com/metadata/esriprof80.html'] | Binary  | theme[themekt/text() = 'REQUIRED: Reference to a formally registered thesaurus or a similar authoritative source of theme keywords.'] " mode="copy" priority="1" >
	</xsl:template>

</xsl:stylesheet>
