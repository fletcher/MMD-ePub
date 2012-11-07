<?xml version='1.0' encoding='utf-8'?>

<!-- <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
-->
	
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xsl"
	version="1.0">

	<xsl:output method="xml" doctype-system="about:legacy-compat" indent="yes" encoding="UTF-8"/>

<!-- the identity template, based on http://www.xmlplease.com/xhtmlxhtml -->
<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="html">
	<html>
		<xsl:apply-templates select="@*|node()"/>
	</html>
</xsl:template>

<xsl:template match="head">
	<head>
		<link type="text/css" rel="stylesheet" href="stylesheet.css"/>
		<xsl:apply-templates select="@*|node()"/>
	</head>
</xsl:template>

<xsl:template match="script"></xsl:template>

</xsl:stylesheet>
