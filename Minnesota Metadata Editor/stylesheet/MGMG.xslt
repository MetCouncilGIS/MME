<?xml-stylesheet type="text/xsl" href="#"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- An xsl template for displaying geospatial metadata specifically formatted for metadata create
	with the Minnesota Metadata Editor and using the Minnesota Geographic Metadata Guidelines.
  
  This stylesheet automatically converts URL links embedded in text fields into HTML HyperLinks using <a> tags.
  It also preserves line breaks embedded in the text fields.

	Revision History: 
	Original template created for a previous metadata editor.
	Created 7/26/2000 Susanne Maeder, LMIC; Last Revision 6/06/2002 SRM
	Additional input from Aleta Vienneau, ESRI; Alison Slaats, Metropolitan Council; Pete Olson, LMIC

	Modification for this MME version:
	Updated Dec 2011 Jim Gonsoski, MDA
	Updated June 2012 Jon Hoekenga, Matt McGuire and Mark Kotz, Met Council and Zeb Thomas, DNR 
    Updated July 2014 Jim Gonsoski, Met Council
	Updated January 2017 Mike Dolbow, Mitch Schaps, Sally Wakefield, MnGeo. Overhaul of HTML to better meet accessibility standards.
	Updated April 2017 Mike Dolbow, additional accessibility enhancements.
  -->
	<xsl:output method="html" encoding="ISO-8859-1" indent="no" standalone="yes" />
	<xsl:template name="PreserveLineBreaks">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text,'&#xA;')">
				<xsl:call-template name="ReplaceLinks">
					<xsl:with-param name="text">
						<xsl:value-of select="substring-before($text,'&#xA;')"/>
					</xsl:with-param>
				</xsl:call-template>
				<br/>
				<xsl:call-template name="PreserveLineBreaks">
					<xsl:with-param name="text">
						<xsl:value-of select="substring-after($text,'&#xA;')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ReplaceLinks">
					<xsl:with-param name="text">
						<xsl:value-of select="$text"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ReplaceHTTPLinks">
		<xsl:param name="text" />
    <!-- JAG 6/14 modified to handle 'https' links as well as 'http' per MnGeo request-->
		<xsl:variable name="prefix"       select="substring-before($text, 'http')" />
		<xsl:variable name="urlremaining" select="substring-after($text, 'http')" />
		<!-- ==== OUTPUT EVERYTHING UP TO "HTTP" (IF ANY) ============== -->
		<xsl:value-of select="$prefix" disable-output-escaping="yes"/>
		<xsl:choose>
			<!-- ===== NO URL : OUTPUT TEXT ============================== -->
			<xsl:when test="not($urlremaining)">
				<xsl:value-of select="$text" disable-output-escaping="yes"/>
			</xsl:when>
			<!-- ===== SPACE AFTER URL: OUTPUT LINK AND PARSE REMAINING == -->
			<xsl:when test="contains($urlremaining,' ')">
        <!-- JAG 6/14 Added back in the explicit 'http' prefix to the link per MnGeo request-->
				<xsl:variable name="url" select="concat('http',substring-before($urlremaining,' '))" />
				<xsl:variable name="remaining" select="substring-after($urlremaining,$url)" />
				<xsl:call-template name="WriteLink" >
					<xsl:with-param name="url">
						<xsl:value-of select="$url"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="$remaining">
					<xsl:call-template name="ReplaceHTTPLinks">
						<xsl:with-param name="text" select="$remaining" />
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<!-- ===== URL BUT NO SPACE: OUTPUT REST AS LINK ============= -->
			<xsl:otherwise>
        <!-- JAG 6/14 Added back in the explicit 'http' prefix to the likn per MnGeo request-->
				<xsl:variable name="url" select="concat('http',$urlremaining)" />
				<xsl:variable name="remaining" select="''" />
				<xsl:call-template name="WriteLink" >
					<xsl:with-param name="url">
						<xsl:value-of select="$url"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ReplaceLinks">
		<xsl:param name="text" />
		<xsl:variable name="prefix"       select="substring-before($text, 'ftp://')" /> 
		<xsl:variable name="urlremaining" select="substring-after($text, 'ftp://')" />
		<!-- ==== OUTPUT EVERYTHING UP TO "HTTP" (IF ANY) ============== -->
		<xsl:value-of select="$prefix" disable-output-escaping="yes"/>
		<xsl:choose>
			<!-- ===== NO URL : OUTPUT TEXT ============================== -->
			<xsl:when test="not($urlremaining)">
				<xsl:call-template name="ReplaceHTTPLinks">
					<xsl:with-param name="text">
						<xsl:value-of select="$text"/>
					</xsl:with-param>
				</xsl:call-template>
				<!--<xsl:value-of select="$text" disable-output-escaping="yes"/>-->
			</xsl:when>
			<!-- ===== SPACE AFTER URL: OUTPUT LINK AND PARSE REMAINING == -->
			<xsl:when test="contains($urlremaining,' ')">
        <!-- JAG 6/14 Added back in the explicit 'ftp://' prefix per MnGeo request-->
				<xsl:variable name="url" select="concat('ftp://',substring-before($urlremaining,' '))" />
				<xsl:variable name="remaining" select="substring-after($urlremaining,$url)" />
				<xsl:call-template name="WriteLink" >
					<xsl:with-param name="url">
						<xsl:value-of select="$url"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="$remaining">
					<xsl:call-template name="ReplaceLinks">
						<xsl:with-param name="text" select="$remaining" />
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<!-- ===== URL BUT NO SPACE: OUTPUT REST AS LINK ============= -->
			<xsl:otherwise>
        <!-- JAG 6/14 Added back in the explicit 'ftp://' prefix per MnGeo request-->
				<xsl:variable name="url" select="concat('ftp://',$urlremaining)" />
				<xsl:variable name="remaining" select="''" />
				<xsl:call-template name="WriteLink" >
					<xsl:with-param name="url">
						<xsl:value-of select="$url"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="WriteLink">
		<xsl:param name="url" />
		<xsl:variable name="lastc" select="substring($url,string-length($url),1)" />
		<xsl:choose>
			<xsl:when test="$lastc='.' or $lastc=',' or $lastc='?' or $lastc='!'">
				<a target="_blank" href="{substring($url,1,string-length($url)-1)}">
					<xsl:value-of select="substring($url,1,string-length($url)-1)" />
				</a>
				<xsl:value-of select="$lastc" />
			</xsl:when>
			<xsl:otherwise>
				<a target="_blank" href="{$url}">
					<xsl:value-of select="$url" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="FormatDate">
		<xsl:param name="date"/>
		<xsl:variable name="year">
			<xsl:value-of select="substring($date,1,4)"/>
		</xsl:variable>
		<xsl:variable name="month">
			<xsl:value-of select="substring($date,5,2)"/>
		</xsl:variable>
		<xsl:variable name="day">
			<xsl:value-of select="substring($date,7,2)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="(string-length($date)=4)">
				<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:when test="(string-length($date)=6)">
				<xsl:value-of select="$month"/>
				<xsl:value-of select="'/'"/>
				<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:when test="(string-length($date)=8)">
				<xsl:value-of select="$month"/>
				<xsl:value-of select="'/'"/>
				<xsl:value-of select="$day"/>
				<xsl:value-of select="'/'"/>
				<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$date"/>
			</xsl:otherwise>		
		</xsl:choose>
	</xsl:template>

	<xsl:template name= "mgmg" match="/">
	<html lang="en">
		<head>
			<font face= "calibri">			
				<title> 
					Metadata: <xsl:value-of select="metadata/idinfo/citation/citeinfo/title"/>
				</title>
			</font>
			<meta name="viewport" content="width=device-width, initial-scale=1.0" />
			<style type="text/css">
				body {
					color: #000020;
					background-color: #FFFFFF;
				}
				h1 {
				}
				.center {
					text-align: center;
					margin-top: 5px;
					margin-bottom: 5px;
				}
				div.box {
					margin-left: 1em;
				}
				div.hide {
					display: none;
				}
				div.show {
					display: block;
				}
				span.hide {
					display: none;
				}
				span.show {
					display: inline-block;
				}
				.backToTop a {
					color: #DDDDDD;
					font-style: italic;
					font-size: 0.85em;
					}
				.head {
					font-size: 1.3em;
				}
				a:link {
					color: #098EA6;
					font-weight: normal;
					text-decoration: none;
				}
				a:visited {
					color: #098EA6;
					text-decoration: none;
				}
				a:link:hover, a:visited:hover {
					color: #007799;
					background-color: #C6E6EF;
				}
				 a:focus, a:hover {
				   background-color: #C6E6EF;
				   text-decoration: none
				 }
				h2 {
					background: #dfdbcf;
					padding: 0px 0px 0px 10px;
				}
				h2 a {
				}
				h3 {
				}
				tr {
					vertical-align: top;
					border: 1px solid black;
				}
				th {
					text-align: left;
					background: #dddddd;
					vertical-align: bottom;
				}
				td {
					color: black;
					vertical-align: top;
					border: 1px solid black;
				}
					td.description {
					background: white;
				}
				div.mgmgel {
					padding: 5px 0px 0px 10px;
                    display: table;
					font-size: 1em;
                }
                div.mgmgel span:nth-child(1){
					display: table-cell;
					width: 30%;
					font-weight: bold;
                }
				@media(min-width:600px){
					div.mgmgel span:nth-child(1){width: 300px}
				}
                div.mgmgel span:nth-child(2){
					display: table-cell;
                }
				.unused {
					color:787862;
				}
				table {
					margin: 0px 10px 0px 10px;
					border: 1px solid black;
					font-size: .9em;
				}
				div.smallish {
					font-size: .8em;
					color:939393;
				}
			</style>
		</head>
		<body>
			<font face= "calibri">
			<div class="mgmg">
				<A name="thetop"/>
				<center>
					<h1>
						<xsl:value-of select="metadata/idinfo/citation/citeinfo/title"/>
					</h1>
				</center>
				<div class="smallish">
					<center>
						This page last updated:
						<xsl:call-template name="FormatDate">
							<xsl:with-param name="date" select="metadata/metainfo/metd"/>
						</xsl:call-template>
					</center>
					<center>
						Metadata created using <A href="{metadata/metainfo/metextns/onlink}">
							<xsl:value-of select="metadata/metainfo/metstdn" />
						</A>
					</center>
				</div>
				<BR/>
				<HR/>					
					
				<span>Go to Section:</span> <BR/>
				<ol>
				  <li><a href="#Identification_Information">Overview</a></li>
				  <li><a href="#Data_Quality_Information">Data Quality</a></li>
				  <li class="unused">Data Organization</li>
				  <li><a href="#Spatial_Reference_Information">Coordinate System</a></li>
				  <li><a href="#Entity_and_Attribute_Information">Attributes</a></li>
				  <li><a href="#Distribution_Information">Distribution</a> - <a href="#ordering"><font color = "#B40404">Get Data</font></a></li>
				  <li><a href="#Metadata_Reference_Information">Metadata Reference</a></li>
				</ol>
				
				<!-- Section 1: Identification -->
				<h2>
					<A NAME="Identification_Information"> </A>
					Section 1: Overview
				</h2>
				<div class="mgmgel">
					<span>Originator:</span>
					<span>
						<xsl:call-template name="ReplaceHTTPLinks">
								<xsl:with-param name="text" select="metadata/idinfo/citation/citeinfo/origin"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Title: 
					</span>
					<span>
						<xsl:call-template name="ReplaceHTTPLinks">
								<xsl:with-param name="text" select="metadata/idinfo/citation/citeinfo/title"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Abstract: 
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/descript/abstract"/>
						</xsl:call-template>
						<br />
					</span>
				</div>	
				<br />
				<div class="mgmgel">
					<span>
						Purpose: 
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/descript/purpose"/>
						</xsl:call-template>
					</span>
				</div>			
				<br />
				<div class="mgmgel">
					<span>
						Time Period of Content Date:
					</span>
					<span>
						<xsl:call-template name="FormatDate">
								<xsl:with-param name="date" select="metadata/idinfo/timeperd/timeinfo/sngdate/caldate"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Currentness Reference: 
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
							<xsl:with-param name="text" select="metadata/idinfo/timeperd/current"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Progress: 
					</span>
					<span>
						<xsl:call-template name="ReplaceHTTPLinks">
								<xsl:with-param name="text" select="metadata/idinfo/status/progress"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Maintenance and Update Frequency:
					</span>
					<span>
						<xsl:value-of select="metadata/idinfo/status/update" />
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Spatial Extent of Data:  
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/descript/supplinf"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Bounding Coordinates:  
					</span>
					<span>
						<xsl:value-of select="metadata/idinfo/spdom/bounding/westbc" />
						<br/>
						<xsl:value-of select="metadata/idinfo/spdom/bounding/eastbc" />
						<br/>
						<xsl:value-of select="metadata/idinfo/spdom/bounding/northbc" />
						<br/>
						<xsl:value-of select="metadata/idinfo/spdom/bounding/southbc" />
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Place Keywords:
					</span>
					<span>
						<xsl:value-of select="metadata/idinfo/keywords/place/placekey" />
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Theme Keywords:
					</span>
					<span>
						<xsl:value-of select="metadata/idinfo/keywords/theme/themekey"/>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Theme Keyword Thesaurus: 
					</span>
					<span>
						<xsl:call-template name="ReplaceHTTPLinks">
								<xsl:with-param name="text" select="metadata/idinfo/keywords/theme/themekt"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Access Constraints:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/accconst"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Use Constraints:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/useconst"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Contact Person Information: 
					</span>
					<span>
						<xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntperp/cntper" />,
							<xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntpos" /> <br/>
							<xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntperp/cntorg" /> <br/>
							<xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntaddr/address" /> <br/>
							<xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntaddr/city" />,
							<xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntaddr/state" />
							<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
							<xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntaddr/postal" /> <br/>
							Phone: <xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntvoice" /> <br/>
							<xsl:if test="metadata/idinfo/ptcontac/cntinfo/cntfax[. != '']">
								Fax: <xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntfax" /> <br/>
							</xsl:if>
							Email: <A href="mailto:{metadata/idinfo/ptcontac/cntinfo/cntemail}">
								<xsl:value-of select ="metadata/idinfo/ptcontac/cntinfo/cntemail"/>
							</A>
					</span>
				</div>
				<br />
					<!--Test for Browse Graphic. If this field is not filled in, the output defaults to 'none available'. 
			If there is a link, it will hotlink to the record and put in the standard 'Click to view a data sample' language. -->
				<div class="mgmgel">
					<span>
						Browse Graphic:  
					</span>
					<span>
					<xsl:choose>
						<xsl:when test="metadata/idinfo/browse/browsen[. != '']">
							<xsl:if test="contains(metadata/idinfo/browse/browsen, '://')">
								<A href="{metadata/idinfo/browse/browsen}">Click to view a data sample</A>.
								<br />
							</xsl:if>
							<xsl:if test="not (contains(metadata/idinfo/browse/browsen, '://'))">
								<xsl:value-of select="metadata/idinfo/browse/browsen" />
								<br />
							</xsl:if>
								<xsl:value-of select="metadata/idinfo/browse/browsed" />
								<br />
						</xsl:when>
						<xsl:otherwise>
							None available
							<br />
						</xsl:otherwise>
					</xsl:choose>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Associated Data Sets:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/crossref/citeinfo/title"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				
				<h2>
					<a name="Data_Quality_Information" />
					Section 2: Data Quality
				</h2>
				<div class="mgmgel">
					<span>
						Attribute Accuracy: 
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/dataqual/attracc/attraccr"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Logical Consistency:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/dataqual/logic"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Completeness:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/dataqual/complete"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Horizontal Positional Accuracy:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/dataqual/posacc/horizpa/horizpar"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<xsl:choose>
					<xsl:when test="metadata/dataqual/posacc/vertacc/vertaccr[. != '']">
						<div class="mgmgel">
							<span>
								Vertical Positional Accuracy:
							</span>
							<span>
								<xsl:call-template name="PreserveLineBreaks">
									<xsl:with-param name="text" select="metadata/dataqual/posacc/vertacc/vertaccr"/>
								</xsl:call-template>
							</span>
						</div>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose><br />
				<div class="mgmgel">
					<span>
						Lineage:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/dataqual/lineage/procstep/procdesc"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<!--  Section 3. Spatial Data Organization -->
				<h2 class="unused">
					<a name="Spatial_Data_Organization_Information" />
					Section 3: Spatial Data Organization (not used in this metadata)
				</h2> 
				<br />
				
				<!--  Section 4. Spatial Reference Information  -->
				<h2>
					<a name="Spatial_Reference_Information" />
					Section 4: Coordinate System
				</h2> 
				<div class="mgmgel">
					<span>
						Horizontal Coordinate Scheme:
					</span>
					<span>
						<xsl:value-of select="metadata/spref/horizsys/planar/gridsys/gridsysn" />
					</span>
				</div><br />
				<xsl:if test="metadata/spref/horizsys/planar/gridsys/utm/utmzone[. != '']">
					<div class="mgmgel">
						<span>
							UTM Zone Number:
						</span>
						<span>
							<xsl:value-of select="metadata/spref/horizsys/planar/gridsys/utm/utmzone" />
						</span>
					</div><br />
				</xsl:if>
				<xsl:if test="metadata/spref/horizsys/planar/gridsys/spcs/spcszone[. != '']">
					<div class="mgmgel">
						<span>
							SPCS Zone Identifier:
						</span>
						<span>
							<xsl:value-of select="metadata/spref/horizsys/planar/gridsys/spcs/spcszone" />
						</span>
					</div><br />
				</xsl:if>
				<xsl:if test="metadata/spref/horizsys/planar/gridsys/mgmg4coz[. != '']">
					<div class="mgmgel">
						<span>
							County Coordinate Zone Identifier:
						</span>
						<span>
							<xsl:value-of select="metadata/spref/horizsys/planar/gridsys/mgmg4coz" />
						</span>
					</div><br />
				</xsl:if>
				<!--Horizontal Datum and Unit Information -->
				<div class="mgmgel">
					<span>
						Horizontal Datum:
					</span>
					<span>
						<xsl:value-of select="metadata/spref/horizsys/geodetic/horizdn" />
					</span>
				</div><br />
				<div class="mgmgel">
					<span>
						Horizontal Units:
					</span>
					<span>
						<xsl:value-of select="metadata/spref/horizsys/planar/planci/plandu" />
					</span>
				</div><br />
				<!--Vertical Datum and Unit Information -->
				<div class="mgmgel">
					<span>
						Vertical Datum:
					</span>
					<span>
						<xsl:value-of select="metadata/spref/vertdef/altsys/altdatum" />
					</span>
				</div><br />
				<div class="mgmgel">
					<span>
						Vertical Units:
					</span>
					<span>
						<xsl:value-of select="metadata/spref/vertdef/altsys/altunits" />
					</span>
				</div><br />
				<!--Depth Datum and Unit Information -->
				<div class="mgmgel">
					<span>
						Depth Datum:
					</span>
					<span>
						<xsl:value-of select="metadata/spref/vertdef/depthsys/depthdn" />
					</span>
				</div><br />
				<div class="mgmgel">
					<span>
						Depth Units:
					</span>
					<span>
						<xsl:value-of select="metadata/spref/vertdef/depthsys/depthdu" />
					</span>
				</div><br />
				<xsl:if test="metadata/spref/horizsys/planar/planci/coordrep/absres[. != '']">
					<div class="mgmgel">
						<span>
							Cell Width:
						</span>
						<span>
							<xsl:value-of select="metadata/spref/horizsys/planar/planci/coordrep/absres" />
						</span>
					</div><br />
				</xsl:if>
				<xsl:if test="metadata/spref/horizsys/planar/planci/coordrep/ordres[. != '']">
					<div class="mgmgel">
						<span>
							Cell Height:
						</span>
						<span>
							<xsl:value-of select="metadata/spref/horizsys/planar/planci/coordrep/ordres" />
						</span>
					</div><br />
				</xsl:if>	
				<h2>
					<a name="Entity_and_Attribute_Information" />
					Section 5: Attributes
				</h2>
				<div class="mgmgel">
					<span>
						Overview:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
							<xsl:with-param name="text" select="metadata/eainfo/overview/eaover"/>
						</xsl:call-template>
					</span>
				</div><br />
				<div class="mgmgel">
					<span>
						Detailed Citation:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
							<xsl:with-param name="text" select="metadata/eainfo/overview/eadetcit"/>
						</xsl:call-template>
					</span>
				</div><br />
				<div class="mgmgel">
					<span>
						Table Detail:
					</span>
				</div>
				<!-- Each table is stored within a separate detailed tag. The table title and description should not be in a table row, however. -->
				<xsl:for-each select="metadata/eainfo/detailed">
					<table>
					<caption>
					<b><xsl:value-of select="enttyp/enttypl" /></b> <!-- Table Name -->
					<xsl:if test="enttyp/enttypd"> - <xsl:value-of select="enttyp/enttypd" /></xsl:if> <!-- Table Definition -->
					<xsl:if test="enttyp/enttypds"> (<xsl:value-of select="enttyp/enttypds" />)</xsl:if><!-- Table Definition Source -->
					</caption>
						<xsl:if test="attr">
							<!-- If attributes are included for this table, add them to the table -->
							<tr>
								<th>Field Name</th>
								<th>Valid Values</th>
								<th>Definition</th>
								<th>Definition Source</th>
							</tr>

							<xsl:for-each select="attr">
								<tr>
									<td>
											<xsl:value-of select="attrlabl"></xsl:value-of>
									</td>
									<!-- Field Name -->
									<td>
										<!-- Valid Values -->
											<xsl:choose>
												<xsl:when test="attrdomv/edom">
													<i>enumerated</i>
												</xsl:when>
												<xsl:when test="attrdomv/rdom">
													<xsl:value-of select="attrdomv/rdom/rdommin"></xsl:value-of> to <xsl:value-of select="attrdomv/rdom/rdommax"></xsl:value-of>
												</xsl:when>
												<xsl:otherwise>
													<center>-</center>
												</xsl:otherwise>
											</xsl:choose>
									</td>
									<td>
										<xsl:value-of select="attrdef"></xsl:value-of>
									</td>
									<!-- Definition -->
									<td>
										<xsl:value-of select="attrdefs"></xsl:value-of>
									</td>
									<!-- Definition Source -->
								</tr>
								<xsl:for-each select="attrdomv/edom">
									<!-- Add each enumerated domain value as a row -->
									<tr>
										<td></td>
										<td>
											<xsl:value-of select="edomv"></xsl:value-of>
										</td>
										<td>
											<xsl:value-of select="edomvd"></xsl:value-of>
										</td>
										<td>
											<xsl:value-of select="edomvds"></xsl:value-of>
										</td>
									</tr>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:if>
					</table>
				</xsl:for-each>
				<!--  Section 6. Distribution Information  -->
				<h2>
					<a name="Distribution_Information" />
					Section 6: Distribution
				</h2>
				<div class="mgmgel">
					<span>
						Publisher:
					</span>
					<span>
						<xsl:value-of select="metadata/idinfo/citation/citeinfo/pubinfo/publish" />
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Publication Date:
					</span>
					<span>
						<xsl:call-template name="FormatDate">
								<xsl:with-param name="date" select="metadata/idinfo/citation/citeinfo/pubdate"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Contact Person Information:
					</span>
					<span>
							<xsl:value-of select="metadata/distinfo/distrib/cntinfo/cntperp/cntper" />,
							<xsl:value-of select="metadata/distinfo/distrib/cntinfo/cntpos" /> <br/>
							<xsl:value-of select="metadata/distinfo/distrib/cntinfo/cntperp/cntorg" /> <br/>
							<xsl:value-of select="metadata/distinfo/distrib/cntinfo/cntaddr/address" /> <br/>
							<xsl:value-of select="metadata/distinfo/distrib/cntinfo/cntaddr/city" />,
							<xsl:value-of select="metadata/distinfo/distrib/cntinfo/cntaddr/state" />
							<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
							<xsl:value-of select="metadata/distinfo/distrib/cntinfo/cntaddr/postal" /> <br/>
							Phone: <xsl:value-of select="metadata/distinfo/distrib/cntinfo/cntvoice" /> <br/>
							<xsl:if test="metadata/distinfo/distrib/cntinfo/cntfax[. != '']">
								Fax: <xsl:value-of select="metadata/distinfo/distrib/cntinfo/cntfax" /> <br/>
							</xsl:if>
							Email: <A href="mailto:{metadata/distinfo/distrib/cntinfo/cntemail}">
								<xsl:value-of select ="metadata/distinfo/distrib/cntinfo/cntemail"/>
							</A>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Distributor's Data Set Identifier:
					</span>
					<span>
						<xsl:value-of select="metadata/distinfo/resdesc" />
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Distribution Liability:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/distinfo/distliab"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						<a name="ordering" />
						Ordering Instructions:
					</span>
					<span>
						<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/distinfo/stdorder/ordering"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						<font color = "#B40404">Online Linkage:</font>
					</span>
					<span>
					<!--Test for online linkage. If this field is not filled in, the output defaults to 'none available'. 
			            If there is a link, it will hotlink to the record and put in the standard 'I AGREE...' language. -->
						<xsl:choose>
							<xsl:when test="metadata/idinfo/citation/citeinfo/onlink[. != '']">
								<xsl:if test="contains(metadata/idinfo/citation/citeinfo/onlink, '://')">
										<A href="{metadata/idinfo/citation/citeinfo/onlink}"> I AGREE</A>
											to the notice in "Distribution Liability" above. Clicking to agree will either begin the download process, link to a service, or provide more instructions. See "Ordering Instructions" above for details.
								</xsl:if>
								<xsl:if test="not (contains(metadata/idinfo/citation/citeinfo/onlink, '://'))">
										<xsl:value-of select="metadata/idinfo/citation/citeinfo/onlink" />
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								None available
							</xsl:otherwise>
						</xsl:choose>
					</span>
				</div>
				<br />
				<!--  Section 7. Metadata Information -->
				<h2>
					<a name="Metadata_Reference_Information" />
					Section 7: Metadata Reference
				</h2>
				<div class="mgmgel">
					<span>
						Metadata Date:
					</span>
					<span>
						<xsl:call-template name="FormatDate">
								<xsl:with-param name="date" select="metadata/metainfo/metd"/>
						</xsl:call-template>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Contact Person Information:
					</span>
					<span>
						<xsl:value-of select="metadata/metainfo/metc/cntinfo/cntperp/cntper" />,
						<xsl:value-of select="metadata/metainfo/metc/cntinfo/cntpos" /> <br/>
						<xsl:value-of select="metadata/metainfo/metc/cntinfo/cntperp/cntorg" /> <br/>
						<xsl:value-of select="metadata/metainfo/metc/cntinfo/cntaddr/address" /> <br/>
						<xsl:value-of select="metadata/metainfo/metc/cntinfo/cntaddr/city" />,
						<xsl:value-of select="metadata/metainfo/metc/cntinfo/cntaddr/state" />
						<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
						<xsl:value-of select="metadata/metainfo/metc/cntinfo/cntaddr/postal" /> <br/>
						Phone: <xsl:value-of select="metadata/metainfo/metc/cntinfo/cntvoice" /> <br/>
						<xsl:if test="metadata/metainfo/metc/cntinfo/cntfax[. != '']">
						Fax: <xsl:value-of select="metadata/metainfo/metc/cntinfo/cntfax" /> <br/>
						</xsl:if>
						Email: <A href="mailto:{metadata/metainfo/metc/cntinfo/cntemail}">
						<xsl:value-of select="metadata/metainfo/metc/cntinfo/cntemail"/>
						</A>
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Metadata Standard Name:
					</span>
					<span>
						<xsl:value-of select="metadata/metainfo/metstdn" />
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Metadata Standard Version:
					</span>
					<span>
						<xsl:value-of select="metadata/metainfo/metstdv" />
					</span>
				</div>
				<br />
				<div class="mgmgel">
					<span>
						Metadata Standard Online Linkage:
					</span>
					<span>
						<A TARGET="viewer">
								<xsl:attribute name="HREF" >
									<xsl:value-of select="metadata/metainfo/metextns/onlink" />
								</xsl:attribute>
								<xsl:value-of select="metadata/metainfo/metextns/onlink" />
							</A>
					</span>
				</div>
				<br />
				<!--End of sections of regular MME style HTML formatting -->
				<p/>
				<hr/>
				<div class="smallish"> This page last updated:
				<xsl:call-template name="FormatDate">
					<xsl:with-param name="date" select="metadata/metainfo/metd"/>
				</xsl:call-template>
				<br/> <A HREF="#Top"> Go back to top</A><p/>
				<em class="unused">Created with <a href="https://github.com/MetropolitanCouncil/MME">MGMG stylesheet</a> version 2017.04.25.1</em>
				</div>

	</div>
	</font>
	</body>
	</html>
	</xsl:template>

	<xsl:template name="MGMG_styles">
		<style type="text/css" id="internalStyle">
			body.mgmg {
			color: #000020;
			background-color: #FFFFFF;
			}
			h1.mgmg {
			}
			.center {
			text-align: center;
			margin-top: 5px;
			margin-bottom: 5px;
			}
			div.box {
			margin-left: 1em;
			}
			div.hide {
			display: none;
			}
			div.show {
			display: block;
			}
			span.hide {
			display: none;
			}
			span.show {
			display: inline-block;
			}
			.backToTop a {
			color: #DDDDDD;
			font-style: italic;
			font-size: 0.85em;
			}
			.head {
			font-size: 1.3em;
			}
			a:link {
			color: #098EA6;
			font-weight: normal;
			text-decoration: none;
			}
			a:visited {
			color: #098EA6;
			text-decoration: none;
			}
			a:link:hover, a:visited:hover {
			color: #007799;
			background-color: #C6E6EF;
			}
			h2.mgmg a {
			}
			h3.mgmg {
			}
			tr.mgmg {
			vertical-align: top;
			}
			th.mgmg {
			text-align: left;
			background: #dddddd;
			vertical-align: bottom;
			font-size: 0.8em;
			}
			td.mgmg {
			background: #EEEEEE;
			color: black;
			vertical-align: top;
			font-size: 0.8em;
			}
			td.description {
			background: white;
			}
		</style>
	</xsl:template>
</xsl:stylesheet>


