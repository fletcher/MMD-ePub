<?xml version='1.0' encoding='UTF-8'?>

<!--

HTML-to-epub converter by Fletcher T. Penney

-->

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:opf="http://www.idpf.org/2007/opf"
	xmlns:str="http://exslt.org/strings"
	exclude-result-prefixes="xsl"
	version="1.0">

	<xsl:import href="tokenize.xslt"/>

	<xsl:variable name="newline">
<xsl:text>
</xsl:text>
	</xsl:variable>
	
	<xsl:output method='xml' version="1.0" indent="yes"/>

	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes"><![CDATA[<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="BookId" version="2.0">]]></xsl:text>
		
		<xsl:apply-templates select="html/head"/>
		
		<xsl:apply-templates select="html/body"/>
		
		<xsl:text disable-output-escaping="yes"><![CDATA[</package>]]></xsl:text>
	</xsl:template>


	<xsl:template match="head">
	    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/"
	       xmlns:dcterms="http://purl.org/dc/terms/"
	       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	       xmlns:opf="http://www.idpf.org/2007/opf">
		   
		   <xsl:apply-templates select="title"/>
<!--		   <dc:language xsi:type="dcterms:RFC3066">en</dc:language> -->
		   <dc:language>en</dc:language>
		   <xsl:apply-templates select="title" mode="id"/>
		   <xsl:apply-templates select="meta" mode="author"/>
		   <xsl:apply-templates select="meta" mode="keywords"/>
	   </metadata>
	   
	   <manifest>
		   <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml" />
		   <item id="css" href="stylesheet.css" media-type="text/css" />
		   <item id="main" href="main.xhtml" media-type="application/xhtml+xml" />
		
			<xsl:apply-templates select="/html/body/figure" />
	   </manifest>
	   
	   <spine toc="ncx">
		   <itemref idref="main" />
	   </spine>
	   
	</xsl:template>

	<xsl:template match="body">
	</xsl:template>

	<xsl:template match="title">
		<dc:title>
			<xsl:value-of select="."/>
		</dc:title>
	</xsl:template>

	<xsl:template match="title" mode="id">
		<dc:identifier id="BookId">
			<xsl:value-of select="."/>
		</dc:identifier>
	</xsl:template>

	<xsl:template match="meta" mode="author">
	<xsl:if test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		'abcdefghijklmnopqrstuvwxyz') = 'author'">
		<dc:creator opf:role="aut">
			<xsl:value-of select="@content"/>
		</dc:creator>
	</xsl:if>
	</xsl:template>

	<xsl:template match="meta" mode="keywords">
	<xsl:if test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		'abcdefghijklmnopqrstuvwxyz') = 'keywords'">
		<xsl:variable name="keys">
			<xsl:call-template name="replace-substring">
				<xsl:with-param name="original">
					<xsl:value-of select="@content"/>
				</xsl:with-param>
				<xsl:with-param name="substring">
					<xsl:text>, </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="replacement">
					<xsl:text>,</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
	    <xsl:for-each select="str:tokenize(string($keys), ',')">
			<dc:subject>
	         <xsl:value-of select="." />
	 		</dc:subject>
	      </xsl:for-each>
	</xsl:if>
	</xsl:template>
	
	<xsl:template match="img">
		<xsl:variable name="href">
			<xsl:value-of select="@src"/>
		</xsl:variable>
		<xsl:variable name="file">
			<xsl:value-of select="substring-after(@src,'/')"/>
		</xsl:variable>
		<xsl:variable name="ext">
			<xsl:value-of select="substring-after(@src,'.')"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$ext ='png'">
				<item href="{$href}" id="{$file}" media-type="image/png" />
			</xsl:when>
			<xsl:when test="$ext ='jpg'">
				<item href="{$href}" id="{$file}" media-type="image/jpg" />
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>

	<!-- replace-substring routine by Doug Tidwell - XSLT, O'Reilly Media -->
	<xsl:template name="replace-substring">
		<xsl:param name="original" />
		<xsl:param name="substring" />
		<xsl:param name="replacement" select="''"/>
		<xsl:variable name="first">
			<xsl:choose>
				<xsl:when test="contains($original, $substring)" >
					<xsl:value-of select="substring-before($original, $substring)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$original"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="middle">
			<xsl:choose>
				<xsl:when test="contains($original, $substring)" >
					<xsl:value-of select="$replacement"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="last">
			<xsl:choose>
				<xsl:when test="contains($original, $substring)">
					<xsl:choose>
						<xsl:when test="contains(substring-after($original, $substring), $substring)">
							<xsl:call-template name="replace-substring">
								<xsl:with-param name="original">
									<xsl:value-of select="substring-after($original, $substring)" />
								</xsl:with-param>
								<xsl:with-param name="substring">
									<xsl:value-of select="$substring" />
								</xsl:with-param>
								<xsl:with-param name="replacement">
									<xsl:value-of select="$replacement" />
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>	
						<xsl:otherwise>
							<xsl:value-of select="substring-after($original, $substring)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>		
			</xsl:choose>				
		</xsl:variable>		
		<xsl:value-of select="concat($first, $middle, $last)"/>
	</xsl:template>	
	
</xsl:stylesheet>
