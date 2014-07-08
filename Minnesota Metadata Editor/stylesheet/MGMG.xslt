<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- An xsl template for displaying geospatial metadata specifically formatted for metadata create
	with the Minnesota Metadata Editor and using the Minnesota Geographic Metadata Guidelines.

	Revision History: 
	Original template created for a previous metadata editor.
	Created 7/26/2000 Susanne Maeder, LMIC; Last Revision 6/06/2002 SRM
	Additional input from Aleta Vienneau, ESRI; Alison Slaats, Metropolitan Council; Pete Olson, LMIC

	Modification for this MME version:
	Updated Dec 2011 Jim Gonsoski, MDA
	Updated June 2012 Jon Hoekenga, Matt McGuire and Mark Kotz, Met Council and Zeb Thomas, DNR -->
	
	
	
	
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
		<xsl:variable name="prefix"       select="substring-before($text, 'http://')" />
		<xsl:variable name="urlremaining" select="substring-after($text, 'http://')" />
		<!-- ==== OUTPUT EVERYTHING UP TO "HTTP" (IF ANY) ============== -->
		<xsl:value-of select="$prefix" disable-output-escaping="yes"/>
		<xsl:choose>
			<!-- ===== NO URL : OUTPUT TEXT ============================== -->
			<xsl:when test="not($urlremaining)">
				<xsl:value-of select="$text" disable-output-escaping="yes"/>
			</xsl:when>
			<!-- ===== SPACE AFTER URL: OUTPUT LINK AND PARSE REMAINING == -->
			<xsl:when test="contains($urlremaining,' ')">
				<xsl:variable name="url" select="substring-before($urlremaining,' ')" />
				<xsl:variable name="remaining" select="substring-after($urlremaining,$url)" />
				<xsl:call-template name="WriteHTTPLink" >
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
				<xsl:variable name="url" select="$urlremaining" />
				<xsl:variable name="remaining" select="''" />
				<xsl:call-template name="WriteHTTPLink" >
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
				<xsl:variable name="url" select="substring-before($urlremaining,' ')" />
				<xsl:variable name="remaining" select="substring-after($urlremaining,$url)" />
				<xsl:call-template name="WriteFTPLink" >
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
				<xsl:variable name="url" select="$urlremaining" />
				<xsl:variable name="remaining" select="''" />
				<xsl:call-template name="WriteFTPLink" >
					<xsl:with-param name="url">
						<xsl:value-of select="$url"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="WriteHTTPLink">
		<xsl:param name="url" />
		<xsl:variable name="lastc" select="substring($url,string-length($url),1)" />
		<xsl:choose>
			<xsl:when test="$lastc='.' or $lastc=',' or $lastc='?' or $lastc='!'">
				<a target="_blank" href="http://{substring($url,1,string-length($url)-1)}">
					<xsl:value-of select="substring($url,1,string-length($url)-1)" />
				</a>
				<xsl:value-of select="$lastc" />
			</xsl:when>
			<xsl:otherwise>
				<a target="_blank" href="http://{$url}">
					<xsl:value-of select="$url" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="WriteFTPLink">
		<xsl:param name="url" />
		<xsl:variable name="lastc" select="substring($url,string-length($url),1)" />
		<xsl:choose>
			<xsl:when test="$lastc='.' or $lastc=',' or $lastc='?' or $lastc='!'">
				<a target="_blank" href="ftp://{substring($url,1,string-length($url)-1)}">
					<xsl:value-of select="substring($url,1,string-length($url)-1)" />
				</a>
				<xsl:value-of select="$lastc" />
			</xsl:when>
			<xsl:otherwise>
				<a target="_blank" href="ftp://{$url}">
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
		<title> Metadata: 
		<xsl:value-of select="metadata/idinfo/citation/citeinfo/title"/>
		</title>		
		<div class="mgmg">
			<A name="thetop"/>
			<font face= "calibri">
				<center>
					<font size = "6">
						<B>
							<BR/>
							<xsl:value-of select="metadata/idinfo/citation/citeinfo/title"/>
						</B>
					</font>
				</center>
				<BR/>
				<font size = "2" color="939393">


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
				</font> <BR/>
				<HR/>					
					

				

				<font size = "3" face= "calibri">Go to Section:</font> <BR/>
				<B>
					<font size = "3"> 1. </font>
					<A HREF="#Identification_Information">
						<font size="3">Overview</font>
					</A>
					<BR/>

					<font size = "3"> 2. </font>
					<A HREF="#Data_Quality_Information">
						<font size="3">Data Quality</font>
					</A>
					<BR/>

				</B>
				<font size = "3" color="939393">  3. </font>
				<font size="3" color="939393">Data Organization</font>
				<BR/>
				<B>

					<font size = "3">  4. </font>
					<A HREF="#Spatial_Reference_Information">
						<font size="3">Coordinate System</font>
					</A>
					<BR/>

					<font size = "3">  5. </font>
					<A HREF="#Entity_and_Attribute_Information">
						<font size="3">Attributes</font>
					</A>
					<BR/>

					<font size = "3"> 6. </font>
					<A HREF="#Distribution_Information">
						<font size="3">Distribution</font>
					</A> - <A HREF="#ordering"><font color = "#B40404">Get Data</font></A>
					<BR/>

					<font size = "3">  7. </font>
					<A HREF="#Metadata_Reference_Information">
						<font size="3">Metadata Reference</font>
					</A>
					<BR/>
					<BR/>
				</B>





				<!-- Section 1: Identification -->
				<table border="0" cellspacing="0" cellpadding="5" >
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top"> </td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top"> </td>
					</tr>
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top">
							<A NAME="Identification_Information"> </A>
							<font size="5" color="353518">
								<b> Section 1</b>
							</font>
						</td>

						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top">
							<font size="5" color="353518">
								<b> Overview</b>
							</font>
						</td>
					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B> Originator </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3" />
							<xsl:call-template name="ReplaceHTTPLinks">
								<xsl:with-param name="text" select="metadata/idinfo/citation/citeinfo/origin"/>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B> Title </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:call-template name="ReplaceHTTPLinks">
								<xsl:with-param name="text" select="metadata/idinfo/citation/citeinfo/title"/>
							</xsl:call-template>
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B> Abstract </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/descript/abstract"/>
							</xsl:call-template>
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Purpose </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/descript/purpose"/>
							</xsl:call-template>
						</td>

					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Time Period of Content Date </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:call-template name="FormatDate">
								<xsl:with-param name="date" select="metadata/idinfo/timeperd/timeinfo/sngdate/caldate"/>
							</xsl:call-template>
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Currentness Reference </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/timeperd/current"/>
							</xsl:call-template>
						</td>

					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Progress </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:call-template name="ReplaceHTTPLinks">
								<xsl:with-param name="text" select="metadata/idinfo/status/progress"/>
							</xsl:call-template>
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Maintenance and Update Frequency </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:value-of select="metadata/idinfo/status/update" />
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Spatial Extent of Data </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:call-template name="ReplaceHTTPLinks">
								<xsl:with-param name="text" select="metadata/idinfo/descript/supplinf"/>
							</xsl:call-template>
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Bounding Coordinates </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:value-of select="metadata/idinfo/spdom/bounding/westbc" />
							<br/>
							<xsl:value-of select="metadata/idinfo/spdom/bounding/eastbc" />
							<br/>
							<xsl:value-of select="metadata/idinfo/spdom/bounding/northbc" />
							<br/>
							<xsl:value-of select="metadata/idinfo/spdom/bounding/southbc" />
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Place Keywords </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:value-of select="metadata/idinfo/keywords/place/placekey" />
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Theme Keywords </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:value-of select="metadata/idinfo/keywords/theme/themekey" />
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Theme Keyword Thesaurus </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:call-template name="ReplaceHTTPLinks">
								<xsl:with-param name="text" select="metadata/idinfo/keywords/theme/themekt"/>
							</xsl:call-template>
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Access Constraints </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/accconst"/>
							</xsl:call-template>
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Use Constraints </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/useconst"/>
							</xsl:call-template>
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Contact Person Information </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3" /> <xsl:value-of select="metadata/idinfo/ptcontac/cntinfo/cntperp/cntper" />,
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
						</td>
					</tr>


					<!--Test for Browse Graphic. If this field is not filled in, the output defaults to 'none available'. 
			If there is a link, it will hotlink to the record and put in the standard 'Click to view a data sample' language. -->
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Browse Graphic  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<xsl:choose>
								<xsl:when test="metadata/idinfo/browse/browsen[. != '']">
									<xsl:if test="contains(metadata/idinfo/browse/browsen, '://')">
										<font size="3" />
										<A href="{metadata/idinfo/browse/browsen}">
											Click to view a data sample
										</A>
									</xsl:if>

									<xsl:if test="not (contains(metadata/idinfo/browse/browsen, '://'))">
										<font size="3" />
										<xsl:value-of select="metadata/idinfo/browse/browsen" />
									</xsl:if>
								
								</xsl:when>
								<xsl:otherwise>
									<font size="3" /> None available
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>

					
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Associated Data Sets </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/idinfo/crossref/citeinfo/title"/>
							</xsl:call-template>
						</td>
					</tr>

					<!--  This provides extra white space before the next section heading -->
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="2"/>
							<br/>
						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="2"/>
						</td>
					</tr>




					<!--  Section 2. Data Quality Information  -->
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top"> </td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top"> </td>
					</tr>
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top">
							<font size="5" color="353518">
								<A Name="Data_Quality_Information" />
								<b> Section 2</b>
							</font>
						</td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top" colspan="2">
							<font size="5" color="353518">
								<b> Data Quality</b>
							</font>
						</td>

					</tr>
					
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Attribute Accuracy </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/dataqual/attracc/attraccr"/>
							</xsl:call-template>
						</td>

					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Logical Consistency  </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/dataqual/logic"/>
							</xsl:call-template>
						</td>

					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Completeness </B>

						</td>
						<td valign="baseline" width="80%" colspan="4">
							<font size="3" />
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/dataqual/complete"/>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Horizontal Positional Accuracy </B>

						</td>
						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/dataqual/posacc/horizpa/horizpar"/>
							</xsl:call-template>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="metadata/dataqual/posacc/vertacc/vertaccr[. != '']">
							<tr>
								<td align="left"  width="20%"  valign="top">
									<font size="3"/>

									<B>  Vertical Positional Accuracy </B>

								</td>

								<td valign="baseline" width="80%" colspan="4">
									<font size="3" />
									<xsl:call-template name="PreserveLineBreaks">
										<xsl:with-param name="text" select="metadata/dataqual/posacc/vertacc/vertaccr"/>
									</xsl:call-template>
								</td>

							</tr>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Lineage  </B>

						</td>

						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/dataqual/lineage/procstep/procdesc"/>
							</xsl:call-template>
						</td>
					</tr>

					<!--  This provides extra white space before the next section heading -->
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="2"/>
							<br/>
						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="2"/>
						</td>
					</tr>




					<!--  Section 3. Spatial Data Organization -->
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top">  </td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top"> </td>
					</tr>
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top">
							<font size="5" color="787862">
								<A Name="Spatial_Data_Organization_Information" />
								Section 3
							</font>
						</td>
						<td bgcolor ="#DFDBCF" align="left"  width="40%"  valign="top" colspan="2">
							<font size="5" color="787862">
								Spatial Data Organization (not used in this metadata)
							</font>
						</td>
					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
						</td>
					</tr>

					<!--  This provides extra white space before the next section heading -->
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="2"/>
							<br/>
						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="2"/>
						</td>
					</tr>





					<!--  Section 4. Spatial Reference Information  -->
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top"> </td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top"> </td>
					</tr>
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top">
							<font size="5" color="353518">
								<A Name="Spatial_Reference_Information" />
								<b> Section 4</b>
							</font>
						</td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top" colspan="2">
							<font size="5" color="353518">
								<b> Coordinate System</b>
							</font>
						</td>

					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Horizontal Coordinate Scheme  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:value-of select="metadata/spref/horizsys/planar/gridsys/gridsysn" />
						</td>
					</tr>

					<xsl:if test="metadata/spref/horizsys/planar/gridsys/utm/utmzone[. != '']">
						<tr>
							<td align="left"  width="20%"  valign="top">
								<font size="3"/>

								<B>  UTM Zone Number  </B>

							</td>
							<td align="left"  width="80%"  valign="top" colspan="4">
								<font size="3"/>
								<xsl:value-of select="metadata/spref/horizsys/planar/gridsys/utm/utmzone" />
							</td>
						</tr>
					</xsl:if>


					<xsl:if test="metadata/spref/horizsys/planar/gridsys/spcs/spcszone[. != '']">
						<tr>
							<td align="left"  width="20%"  valign="top">
								<font size="3"/>

								<B> SPCS Zone Identifier </B>

							</td>
							<td align="left"  width="80%"  valign="top" colspan="4">
								<font size="3"/>
								<xsl:value-of select="metadata/spref/horizsys/planar/gridsys/spcs/spcszone" />
							</td>
						</tr>
					</xsl:if>

					<xsl:if test="metadata/spref/horizsys/planar/gridsys/mgmg4coz[. != '']">
						<tr>
							<td align="left"  width="20%"  valign="top">
								<font size="3"/>

								<B> County Coordinate Zone Identifier </B>

							</td>
							<td align="left"  width="80%"  valign="top" colspan="4">
								<font size="3"/>
								<xsl:value-of select="metadata/spref/horizsys/planar/gridsys/mgmg4coz" />
							</td>
						</tr>
					</xsl:if>


					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B>  Horizontal Datum  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:value-of select="metadata/spref/horizsys/geodetic/horizdn" />
						</td>
					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3"/>

							<B> Horizontal Units  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3" />
							<xsl:value-of select="metadata/spref/horizsys/planar/planci/plandu" />
						</td>
					</tr>


					<xsl:if test="metadata/spref/horizsys/planar/planci/coordrep/absres[. != '']">
						<tr>
							<td align="left"  width="20%"  valign="top">
								<font size="3"/>

								<B> Cell Width </B>

							</td>
							<td align="left"  width="80%"  valign="top" colspan="4">
								<font size="3"/>
								<xsl:value-of select="metadata/spref/horizsys/planar/planci/coordrep/absres" />
							</td>
						</tr>
					</xsl:if>

					<xsl:if test="metadata/spref/horizsys/planar/planci/coordrep/ordres[. != '']">
						<tr>
							<td align="left"  width="20%"  valign="top">
								<font size="3"/>

								<B> Cell Height </B>

							</td>
							<td align="left"  width="80%"  valign="top" colspan="4">
								<font size="3"/>
								<xsl:value-of select="metadata/spref/horizsys/planar/planci/coordrep/ordres" />
							</td>
						</tr>
					</xsl:if>


					<!--  This provides extra white space before the next section heading -->
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="2"/>
							<br/>
						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="2"/>
						</td>
					</tr>






					<!--   Section 5: Entity and Attribute Information  -->
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top"> </td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top"> </td>
					</tr>
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top">
							<font size="5" color="353518">
								<A Name="Entity_and_Attribute_Information" />
								<b> Section 5</b>
							</font>
						</td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top" colspan="2">
							<font size="5" color="353518">
								<b> Attributes</b>
							</font>
						</td>

					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Overview </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3" />
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/eainfo/overview/eaover"/>
							</xsl:call-template>
						</td>

					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Detailed Citation </B>

						</td>
						<td valign="baseline" width="80%" colspan="4">
							<font size="3" />

							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/eainfo/overview/eadetcit"/>
							</xsl:call-template>
						</td>
					</tr>
					
					
					
					
					
					<!-- TABLE DETAILS -->
					<tr>
						<td align="left" width="20%" valign="top">
							<B> Table Detail: </B>
						</td>
						<td valign="baseline" width="80%" colspan="4">
						</td>
					</tr>
				</table>

				<!-- Each table is stored within a separate detailed tag -->
				<xsl:for-each select="metadata/eainfo/detailed">
					<table border="1">
						<!--<caption>
                <b><xsl:value-of select="enttyp/enttypl" /></b>
                <xsl:if test="enttyp/enttypd"> - <xsl:value-of select="enttyp/enttypd" /></xsl:if>
                <xsl:if test="enttyp/enttypds"> (<xsl:value-of select="enttyp/enttypds" />)</xsl:if>
              </caption>-->
						<tr>
							<td align="center" colspan="4">
								<b>
									<xsl:value-of select="enttyp/enttypl"></xsl:value-of>
								</b>
								<!-- Table Name -->
								<xsl:if test="enttyp/enttypd">
									- <xsl:value-of select="enttyp/enttypd"></xsl:value-of>
								</xsl:if>
								<!-- Table Definition -->
								<xsl:if test="enttyp/enttypds">
									(<xsl:value-of select="enttyp/enttypds"></xsl:value-of>)
								</xsl:if>
								<!-- Table Definition Source -->
							</td>
						</tr>

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
										<font size="2">
											<xsl:value-of select="attrlabl"></xsl:value-of>
										</font>
									</td>
									<!-- Field Name -->
									<td>
										<!-- Valid Values -->
										<font size="2">
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
										</font>
									</td>
									<td>
										<font size="2">
											<xsl:value-of select="attrdef"></xsl:value-of>
										</font>
									</td>
									<!-- Definition -->
									<td>
										<font size="2">
											<xsl:value-of select="attrdefs"></xsl:value-of>
										</font>
									</td>
									<!-- Definition Source -->
								</tr>
								<xsl:for-each select="attrdomv/edom">
									<!-- Add each enumerated domain value as a row -->
									<tr>
										<td></td>
										<td>
											<font size="2">
												<xsl:value-of select="edomv"></xsl:value-of>
											</font>
										</td>
										<td>
											<font size="2">
												<xsl:value-of select="edomvd"></xsl:value-of>
											</font>
										</td>
										<td>
											<font size="2">
												<xsl:value-of select="edomvds"></xsl:value-of>
											</font>
										</td>
									</tr>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:if>
					</table>
					<br></br>
				</xsl:for-each>

				<table border="0" cellspacing="0" cellpadding="5">


					<!--  This provides extra white space before the next section heading -->
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="2"/>
							<br/>
						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="2"/>
						</td>
					</tr>




					<!--  Section 6. Distribution Information  -->
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top"> </td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top">  </td>
					</tr>
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top">
							<font size="5" color="353518">
								<A Name="Distribution_Information"></A>
								<b> Section 6</b>
							</font>
						</td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top" colspan="2">
							<font size="5" color="353518">
								<b> Distribution</b>
							</font>
						</td>

					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Publisher  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:value-of select="metadata/idinfo/citation/citeinfo/pubinfo/publish" />
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Publication Date  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:call-template name="FormatDate">
								<xsl:with-param name="date" select="metadata/idinfo/citation/citeinfo/pubdate"/>
							</xsl:call-template>
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Contact Person Information </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/> <xsl:value-of select="metadata/distinfo/distrib/cntinfo/cntperp/cntper" />,
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
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Distributor's Data Set Identifier  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:value-of select="metadata/distinfo/resdesc" />
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Distribution Liability  </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/distinfo/distliab"/>
							</xsl:call-template>
						</td>

					</tr>
					
					<tr>
						<td align="left"  width="20%"  valign="top">
							<A Name="ordering" />
							<font color="#990000" />
							<font size="3" />

							<B>  Ordering Instructions  </B>

						</td>

						<td valign="baseline" width="80%" colspan="4">
							<font size="3"/>
							<xsl:call-template name="PreserveLineBreaks">
								<xsl:with-param name="text" select="metadata/distinfo/stdorder/ordering"/>
							</xsl:call-template>
						</td>
					</tr>



					<!--Test for online linkage. If this field is not filled in, the output defaults to 'none available'. 
			            If there is a link, it will hotlink to the record and put in the standard 'I AGREE...' language. -->
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>
								<font color = "#B40404">Online Linkage</font>
							</B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<xsl:choose>
								<xsl:when test="metadata/idinfo/citation/citeinfo/onlink[. != '']">


									<xsl:if test="contains(metadata/idinfo/citation/citeinfo/onlink, '://')">
										<font size="3" />
										<A href="{metadata/idinfo/citation/citeinfo/onlink}"> I AGREE</A>
										to the notice in "Distribution Liability" above. Clicking to agree will either begin the download process or link to download information. See "Ordering Instructions" above for details.
									</xsl:if>

									<xsl:if test="not (contains(metadata/idinfo/citation/citeinfo/onlink, '://'))">
										<font size="3" />
										<xsl:value-of select="metadata/idinfo/citation/citeinfo/onlink" />
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<font size="3" /> None available
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>



					<!--  This provides extra white space before the next section heading -->
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="2"/>
							<br/>
						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="2"/>
						</td>
					</tr>




					<!--  Section 7. Metadata Information -->
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top">  </td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top">  </td>
					</tr>
					<tr>
						<td bgcolor ="#DFDBCF" align="left"  width="20%"  valign="top">
							<font size="5" color="353518">
								<A Name="Metadata_Reference_Information" />
								<b> Section 7</b>
							</font>
						</td>
						<td bgcolor ="#DFDBCF" align="left"  width="80%"  valign="top" colspan="2">
							<font size="5" color="353518">
								<b> Metadata Reference</b>
							</font>
							<font size="3" />
						</td>

					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Metadata Date  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:call-template name="FormatDate">
								<xsl:with-param name="date" select="metadata/metainfo/metd"/>
							</xsl:call-template>
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Contact Person Information </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/> <xsl:value-of select="metadata/metainfo/metc/cntinfo/cntperp/cntper" />,
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
						</td>
					</tr>

					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Metadata Standard Name  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:value-of select="metadata/metainfo/metstdn" />
						</td>
					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Metadata Standard Version  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3"/>
							<xsl:value-of select="metadata/metainfo/metstdv" />
						</td>
					</tr>
					<tr>
						<td align="left"  width="20%"  valign="top">
							<font size="3" />

							<B>  Metadata Standard Online Linkage  </B>

						</td>
						<td align="left"  width="80%"  valign="top" colspan="4">
							<font size="3" />
							<A TARGET="viewer">
								<xsl:attribute name="HREF" >
									<xsl:value-of select="metadata/metainfo/metextns/onlink" />
								</xsl:attribute>
								<xsl:value-of select="metadata/metainfo/metextns/onlink" />
							</A>
						</td>
					</tr>

				</table>

				<p/>
				<hr/>
				<font size = "2"/> This page last updated:
				<xsl:call-template name="FormatDate">
					<xsl:with-param name="date" select="metadata/metainfo/metd"/>
				</xsl:call-template>
				<br/> <A HREF="#Top"> Go back to top</A><p/>



			</font>



		</div>
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

