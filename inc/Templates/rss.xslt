<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration = "yes" indent="yes" version="4.0"/>
	<!--
	Copyright (C) 2004,2007 AspSky.Net. All rights reserved.
	Written by dvbbs.net Sunwin
	-->

	<xsl:template match="/rss">
		<html>
			<head>
				<style type="text/css" rel="stylesheet">
					body { margin-top:10px; margin-bottom:30px; text-align:center; font-family:Verdana,Simsun; font-size: 9pt; line-height: 140%; }
					#block { margin:0px auto; width:660px; text-align:left; }
					td { font-family:Verdana,Simsun; font-size: 12px; line-height: 1.45em; }
					hr { height:1px;}
					h1 { font-size: 16px; padding-bottom: 0px; margin-bottom: 0px; }
					h2 { font-size: 14px; margin-bottom: 0px; }

					.time { color: green; font-family:"Verdana"; font-size:12px; }
					.sort { color:#999999; }
					.gray { color: #808080; }
					.desc { background:#f3f3f3;padding:5px;}

					a { color:#000000; text-decoration: underline; }
					a:hover { color:#ff0000; text-decoration: underline; }
				</style>
				<script type="text/javascript">
					function copyRss(url)
					{
					if (window.clipboardData.setData("Text",window.location.href)){
					alert("RSS地址已复制到粘贴板");
					}else{
					alert("RSS地址无法复制，请自己复制地址栏");
					}
					}
				</script>
				<title>
					<xsl:value-of select="channel/title" />
				</title>
			</head>
			<body>
				<div id="block">
					<center>
						<a href="{channel/link}" target="_blank">
							<img border="0" src="{channel/image/url}" alt="{channel/image/title}"/>
						</a>
					</center>
					<h1>
						<a href="{channel/link}" target="_blank">
							<xsl:value-of select="channel/title" />
						</a>
					</h1>
					<div class="gray">
						说明：您可以使用 RSS 阅读器或聚合器来订阅本页面。<a href="javascript:copyRss();">复制地址</a>
					</div>
					<xsl:variable name="xslFeedUrl">
						<xsl:value-of select="concat('feed', substring-after(channel/Currentlink, 'http'),'')" />
					</xsl:variable>
					<hr />
					<xsl:apply-templates select="channel/item" />
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="item">
		<h2>
			<a href="{link}" target="_blank">
				<xsl:value-of select="title" />
			</a>
		</h2>
		<div class="desc">
			<xsl:call-template name="outputContent" />
			<br/>
			<xsl:if test="category != ''">
				<font class="sort">
					<xsl:value-of select="category" />, 作者: <xsl:value-of select="author" />,
				</font>
				<font class="time">
					更新日期: <xsl:value-of select="pubDate" />
				</font>
				<br/>
			</xsl:if>
			<a href="{link}" target="_blank">阅读全文...</a>
		</div>
	</xsl:template>
	
	<xsl:template name="outputContent">
		<xsl:choose>
			<xsl:when test="xhtml:body" xmlns:xhtml="http://www.w3.org/1999/xhtml">
				<xsl:copy-of select="xhtml:body/*"/>
			</xsl:when>
			<xsl:when test="xhtml:div" xmlns:xhtml="http://www.w3.org/1999/xhtml">
				<xsl:copy-of select="xhtml:div"/>
			</xsl:when>
			<xsl:when test="description">
				<xsl:value-of select="description" disable-output-escaping="yes"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>