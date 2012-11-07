<?xml version='1.0' encoding='UTF-8'?>

<!--

HTML-to-epub converter by Fletcher T. Penney

-->

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
	exclude-result-prefixes="xsl dc"
	version="1.0">

	<xsl:variable name="newline">
<xsl:text>
</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="link">
	</xsl:variable>
	
	<xsl:output method='xml' version="1.0" indent="yes"/>

	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE ncx PUBLIC "-//NISO//DTD ncx 2005-1//EN" "http://www.daisy.org/z3986/2005/ncx-2005-1.dtd">]]></xsl:text>

		<xsl:text disable-output-escaping="yes"><![CDATA[<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">]]></xsl:text>
		
		<xsl:apply-templates select="html/head"/>

		<xsl:apply-templates select="html/head/title"/>
		
		<xsl:apply-templates select="html/body"/>
		
		<xsl:text disable-output-escaping="yes"><![CDATA[</ncx>]]></xsl:text>
	</xsl:template>


	<xsl:template match="head">
		<head>
			<meta name="dtb:uid" content="http://fletcherpenney.net/testbook" />
			<meta name="dtb:depth" content="1" />
			<meta name="dtb:totalPageCount" content="0" />
			<meta name="dtb:maxPageNumber" content="0" />
		</head>
	</xsl:template>

	<xsl:template match="body">
		<navMap>
			<xsl:choose>
				<xsl:when test="count(child::h1) &gt; 0">
					<xsl:apply-templates select="h1" mode="h1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="h2" mode="h2"/>
				</xsl:otherwise>
			</xsl:choose>
		</navMap>
		
	</xsl:template>

	<xsl:template match="h1" mode="h1">
		<xsl:variable name="myId">
			<xsl:value-of select="generate-id(.)"/>
		</xsl:variable>
		<xsl:variable name="link">
			<xsl:value-of select="@id"/>
		</xsl:variable>
		<navPoint id="{$link}" playOrder="{1 + count(preceding-sibling::h1) + count(preceding-sibling::h2)}">
			<navLabel>
				<text><xsl:value-of select="."/></text>
			</navLabel>
			<content src="main.xhtml#{$link}"/>
			<xsl:if test="following::h2[1][preceding::h1[1]]">
				<xsl:apply-templates select="following::h2[preceding::h1[1][generate-id() = $myId]]" mode="h1"/>
			</xsl:if>
		</navPoint>
	</xsl:template>

	<xsl:template match="h2" mode="h1">
		<xsl:variable name="link">
			<xsl:value-of select="@id"/>
		</xsl:variable>
		<xsl:variable name="myId">
			<xsl:value-of select="generate-id(.)"/>
		</xsl:variable>
		<navPoint id="{$link}" playOrder="{1 + count(preceding-sibling::h1) + count(preceding-sibling::h2)}">
			<navLabel>
				<text><xsl:value-of select="."/></text>
			</navLabel>
			<content src="main.xhtml#{$link}"/>
		</navPoint>
	</xsl:template>

	<xsl:template match="h2" mode="h2">
		<xsl:variable name="myId">
			<xsl:value-of select="generate-id(.)"/>
		</xsl:variable>
		<xsl:variable name="link">
			<xsl:value-of select="@id"/>
		</xsl:variable>
		<navPoint id="{$link}" playOrder="{1 + count(preceding-sibling::h2) + count(preceding-sibling::h3)}">
			<navLabel>
				<text><xsl:value-of select="."/></text>
			</navLabel>
			<content src="main.xhtml#{$link}"/>
			<xsl:if test="following::h3[1][preceding::h2[1]]">
				<xsl:apply-templates select="following::h3[preceding::h2[1][generate-id() = $myId]]" mode="h2"/>
			</xsl:if>
		</navPoint>
	</xsl:template>

	<xsl:template match="h3" mode="h2">
		<xsl:variable name="link">
			<xsl:value-of select="@id"/>
		</xsl:variable>
		<xsl:variable name="myId">
			<xsl:value-of select="generate-id(.)"/>
		</xsl:variable>
		<navPoint id="{$link}" playOrder="{1 + count(preceding-sibling::h2) + count(preceding-sibling::h3)}">
			<navLabel>
				<text><xsl:value-of select="."/></text>
			</navLabel>
			<content src="main.xhtml#{$link}"/>
		</navPoint>
	</xsl:template>
	
	<xsl:template match="title">
		<docTitle><text>
			<xsl:value-of select="."/>
		</text></docTitle>
	</xsl:template>

</xsl:stylesheet>