<?xml version='1.0' encoding='UTF-8'?>

<!--

HTML-to-epub converter by Fletcher T. Penney

-->

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
	exclude-result-prefixes="xsl"
	version="1.0">

	<xsl:variable name="newline">
<xsl:text>
</xsl:text>
	</xsl:variable>
	
	<xsl:output method='xml' version="1.0" indent="yes"/>

	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes"><![CDATA[<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="dcidid" version="3.0">]]></xsl:text>
		
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
		   <dc:language xsi:type="dcterms:RFC3066">en</dc:language>
		   <xsl:apply-templates select="title" mode="id"/>
		   <xsl:apply-templates select="meta" mode="author"/>
		   <xsl:apply-templates select="meta" mode="keywords"/>
	   </metadata>
	   
	   <manifest>
		   <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml" />
		   <item id="css" href="stylesheet.css" media-type="text/css" />
		   <item id="main" href="main.xhtml" media-type="application/xhtml+xml" />
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
		<dc:identifier>
			<xsl:value-of select="."/>
		</dc:identifier>
	</xsl:template>

	<xsl:template match="meta" mode="author">
	<xsl:if test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		'abcdefghijklmnopqrstuvwxyz') = 'author'">
		<dc:creator>
			<xsl:value-of select="@content"/>
		</dc:creator>
	</xsl:if>
	</xsl:template>

	<xsl:template match="meta" mode="keywords">
	<xsl:if test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
		'abcdefghijklmnopqrstuvwxyz') = 'keywords'">
		<dc:subject>
			<xsl:value-of select="@content"/>
		</dc:subject>
	</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>