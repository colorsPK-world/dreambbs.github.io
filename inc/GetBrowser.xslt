<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes"/>
<!--
	Copyright (C) 2004,2005 AspSky.Net. All rights reserved.
	Written by dvbbs.net Lao Mi
	Web: http://www.aspsky.net/,http://www.dvbbs.net/
	Email: eway@aspsky.net
-->
<xsl:template match="/">
<xsl:element name="agent">
<xsl:attribute name="browser"><xsl:choose>
		<xsl:when test="contains(xml,'Opera')">Opera</xsl:when>
		<xsl:otherwise>
		<xsl:choose>
		<xsl:when test="contains(xml,'MSIE')">Microsoft Internet Explorer</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="contains(xml,'Netscape')">Netscape</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
				<xsl:when test="contains(xml,'Firefox')">Firefox</xsl:when>
				<xsl:otherwise><xsl:choose>
				<xsl:when test="contains(xml,'rv:')">Mozilla</xsl:when>
				<xsl:otherwise>unknown</xsl:otherwise>
			</xsl:choose>
			</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
<xsl:attribute name="version">
<xsl:choose>
		<xsl:when test="contains(xml,'Opera')"><xsl:value-of select="substring(substring-after(xml,'Opera '),0,4)"/></xsl:when>
		<xsl:otherwise>
		<xsl:choose>
		<xsl:when test="contains(xml,'MSIE')"><xsl:value-of select="substring(substring-after(xml,'MSIE '),0,4)"/></xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="contains(xml,'Netscape')"><xsl:value-of select="substring(substring-after(xml,'Netscape/'),0,6)"/></xsl:when>
			<xsl:otherwise>
				<xsl:choose>
				<xsl:when test="contains(xml,'Firefox')"><xsl:value-of select="substring(substring-after(xml,'Firefox/'),0,6)"/></xsl:when>
				<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="contains(xml,'rv:')"><xsl:value-of select="substring(substring-after(xml,'rv:'),0,6)"/></xsl:when>
						<xsl:otherwise>unknown</xsl:otherwise>
					</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
<xsl:attribute name="platform">
<xsl:choose>
<xsl:when test="contains(xml,'Windows')">Windows <xsl:if test="contains(xml,'NT 5.2')">2003</xsl:if>
<xsl:if test="contains(xml,'NT 5.1')">XP</xsl:if>
<xsl:if test="contains(xml,'Windows CE')">CE</xsl:if>
<xsl:if test="contains(xml,'NT 4.0')">NT</xsl:if>
<xsl:if test="contains(xml,'NT 5.0')">2000</xsl:if>
<xsl:if test="contains(xml,'9x')">ME</xsl:if>
<xsl:if test="contains(xml,'98')">98</xsl:if>
<xsl:if test="contains(xml,'95')">95</xsl:if>
</xsl:when>
<xsl:otherwise>
	<xsl:choose>
	<xsl:when test="contains(xml,'Win32')">Win32</xsl:when>
	<xsl:otherwise><xsl:choose>
	<xsl:when test="contains(xml,'Linux')">Linux</xsl:when>
	<xsl:otherwise><xsl:choose>
	<xsl:when test="contains(xml,'SunOS')">SunOS</xsl:when>
	<xsl:otherwise><xsl:choose>
	<xsl:when test="contains(xml,'Mac')">Mac</xsl:when>
	<xsl:otherwise>unknown</xsl:otherwise>
	</xsl:choose></xsl:otherwise>
	</xsl:choose></xsl:otherwise>
	</xsl:choose>
	</xsl:otherwise>
	</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
<xsl:attribute name="ip"><xsl:value-of select="xml/@ip"/></xsl:attribute>
<xsl:attribute name="lockip"><xsl:call-template name="checkip"/></xsl:attribute>
</xsl:element>
</xsl:template>
	<xsl:template name="checkip">
		<xsl:variable name="number1" select="substring-before(xml/@ip,'.')"></xsl:variable>
		<xsl:variable name="number2" select="substring-before(substring-after(xml/@ip,'.'),'.')"></xsl:variable>
		<xsl:variable name="number3" select="substring-before(substring-after(substring-after(xml/@ip,'.'),'.'),'.')"></xsl:variable>
		<xsl:variable name="number4" select="substring-after(substring-after(substring-after(xml/@ip,'.'),'.'),'.')"></xsl:variable>
		<xsl:choose>
		<xsl:when test="/xml/lockip[(@number1=$number1 or @number1='*') and (@number2=$number2 or @number2='*') and (@number3=$number3 or @number3='*') and (@number4=$number4 or @number4='*')]">1</xsl:when>
		<xsl:otherwise>
		<xsl:choose>
		<xsl:when test="xml/@actforip!=''"><xsl:call-template name="checkip1"/></xsl:when>
		<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="checkip1">
		<xsl:variable name="number1" select="substring-before(xml/@actforip,'.')"></xsl:variable>
		<xsl:variable name="number2" select="substring-before(substring-after(xml/@actforip,'.'),'.')"></xsl:variable>
		<xsl:variable name="number3" select="substring-before(substring-after(substring-after(xml/@actforip,'.'),'.'),'.')"></xsl:variable>
		<xsl:variable name="number4" select="substring-after(substring-after(substring-after(xml/@actforip,'.'),'.'),'.')"></xsl:variable>
		<xsl:choose>
		<xsl:when test="/xml/lockip[(@number1=$number1 or @number1='*') and (@number2=$number2 or @number2='*') and (@number3=$number3 or @number3='*') and (@number4=$number4 or @number4='*')]">1</xsl:when>
		<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>