<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="xml" indent="yes" omit-xml-declaration = "yes" version="4.0"  encoding="gb2312" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
	<!--
	Copyright (C) 2004,2007 AspSky.Net. All rights reserved.
	Written by dvbbs.net Sunwin
	-->

	<xsl:template match="/rss">
		<xsl:variable name="pagetitle">
			<xsl:call-template name="title" />
		</xsl:variable>
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
				<style type="text/css" rel="stylesheet">
					a { color:#000000; text-decoration: none;border-bottom:1px dotted;}
					a:hover { color:#ff0000; text-decoration: blink; }
					body { margin-top:10px; margin-bottom:30px; text-align:center; font-family:Verdana,Simsun; font-size:10pt; line-height: 140%; }
					#block { margin:0px auto; width:96%;min-width:780px; text-align:left; }
					#nav {
					margin:10px auto; width:96%;min-width:780px; text-align:left;padding:5px;
					word-wrap : break-word ;word-break : break-all ;
					border: 1px solid #FFF3E8;background:#FFFAF4;
					}
					td { font-family:Verdana,Simsun; font-size: 12px; line-height: 1.45em; }
					hr { height:0px;border :0px;border-top: #808080 1px solid;width : 100%;}
					h1 { font-size: 16px;padding:0px;margin:0px;}
					h2 { font-size: 14px; margin: 0px; }
					.red {color:red;}
					.time { color: green; font-family:"Verdana"; font-size:12px; }
					.sort { color:#999999; }
					.gray,.gray a{ color: #808080; }
					.title,.title a{color:#0099FF;}

					#board{
					margin:5px; padding:0px; list-style-type:none;
					}
					#rsstopic{
					margin:5px;
					word-wrap : break-word ;word-break : break-all ;
					}
					.stats{
					color:#FF6600;
					}
					#rsstopic .topicinfo{
					margin-left:35px;
					}
					#board li,#rsstopic li{
					margin:10px;
					}

					#block  .posttitle{
					border-top: 1px solid;border-left: 1px solid;border-right: 1px solid;
					word-wrap : break-word ;word-break : break-all ;
					}
					#block .postname,#block .postbody{
					border-bottom: 1px solid;border-left: 1px solid;border-right: 1px solid;
					}
					#block .postname{
					background:#7DD5FF;color:white;
					}
					#block .postbody{
					text-indent : 20pt; min-height:150px;margin-bottom:2px;
					word-wrap : break-word ;word-break : break-all ;
					}
					#block .posttitle,#block .postname,#block .postbody{
					border-color:#7DD5FF;padding:6px;width:98%px;
					}
					#block .pf{
					float:right;
					}
					#visittype{
					margin:15px; padding:5px; list-style-type:none;
					}
					#pagestr{
					margin:5px;
					}
					#pagestr a{
					border:none;
					}
					#visittype li{float:left;width:100px;}
					div.quote {margin : 5px 20px; border : 1px solid #cccccc; padding : 5px;background : #f3f3f3; line-height : normal;}
					div.htmlcode {margin : 5px 20px; border : 1px solid #cccccc;padding : 5px;background : #fdfddf;font-size : 14px;
					font-family : tahoma, 宋体, fantasy;font-style : oblique;line-height : normal;}
					div.info {border:1px dotted #95B0CD; padding : 5px;line-height : normal; background :#EFF7FF;}
					div.info ul.info { margin:0px; padding:0px; list-style-type:none; padding-left:0px; }
					div.info ul.info li{
					background-color : #D7EBF7;margin:2px;padding:2px;
					}
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
				<title><xsl:value-of select="$pagetitle"/></title>
				<script language = "javaScript" src = "inc/Main82.js" type="text/javascript"></script>
			</head>
			<body>
				<div id="block" style="line-height: normal;font-size:10pt">
					<div style="float:right;width:auto;">
						<xsl:call-template name="visilinks"/>
					</div>
					<p style="margin-top: 0px; margin-bottom: -6px;">
						<strong style="font-size:24pt"><font class="stats">Rss</font>  &amp; SiteMap</strong>
					</p>
					<p style="margin-top: 2px;">
						<a href="{channel/link}" target="_blank" class="gray">
							<xsl:value-of select="channel/title" />
						</a>
						<font class="time">
							<u>
								<xsl:value-of select="channel/link" />
							</u>
						</font>
					</p>
					<div style="border: 1px solid #FFF3E8;padding:5px;margin:6px;">
						<font class="sort">
							<xsl:value-of select="channel/description" />
						</font>
					</div>
					<xsl:variable name="xslFeedUrl">
						<xsl:value-of select="concat('feed', substring-after(channel/Currentlink, 'http'),'')" />
					</xsl:variable>
				</div>
				<xsl:call-template name="nav" />
				<div id="block">
					<xsl:choose>
						<xsl:when test="channel/item/@type='board'">
							<ul id="board">
								<xsl:apply-templates select="channel/item" />
							</ul>
						</xsl:when>
						<xsl:when test="channel/item/@type='topic'">
							<!-- 分页信息-->
							<div id="pagestr">
								<xsl:call-template name="PageList">
									<xsl:with-param name="Page" select="channel/@page"/>
									<xsl:with-param name="PageCount" select="channel/@pagecount"/>
									<xsl:with-param name="MaxRows" select="channel/@pagesize"/>
									<xsl:with-param name="CountNum" select="channel/@count"/>
									<xsl:with-param name="PageStr">
										<xsl:choose>
											<xsl:when test="channel/@isapiwrite = 1">
												<xsl:value-of select="concat(channel/@forum_url,'dv_rss_',channel/@visittype,'_',channel/@boardid)" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat(channel/@pageurl,'&amp;boardid=',channel/@boardid)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="pv">page</xsl:with-param>
								</xsl:call-template>
							</div>
							<ol>
								<xsl:apply-templates select="channel/item" />
							</ol>
							<!-- 分页信息-->
							<div id="pagestr">
								<xsl:call-template name="PageList">
								<xsl:with-param name="Page" select="channel/@page"/>
								<xsl:with-param name="PageCount" select="channel/@pagecount"/>
								<xsl:with-param name="MaxRows" select="channel/@pagesize"/>
								<xsl:with-param name="CountNum" select="channel/@count"/>
								<xsl:with-param name="PageStr">
									<xsl:choose>
										<xsl:when test="channel/@isapiwrite = 1">
											<xsl:value-of select="concat(channel/@forum_url,'dv_rss_',channel/@visittype,'_',channel/@boardid)" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat(channel/@pageurl,'&amp;boardid=',channel/@boardid)" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="pv">page</xsl:with-param>
							</xsl:call-template>
							</div>
						</xsl:when>
						<xsl:when test="channel/item/@type='post'">
							<!-- 分页信息-->
							<div id="pagestr">
								<xsl:call-template name="PageList">
									<xsl:with-param name="Page" select="channel/@star"/>
									<xsl:with-param name="PageCount" select="channel/@pagecount"/>
									<xsl:with-param name="MaxRows" select="channel/@pagesize"/>
									<xsl:with-param name="CountNum" select="channel/@count"/>
									<xsl:with-param name="PageStr">
										<xsl:choose>
											<xsl:when test="channel/@isapiwrite = 1">
												<xsl:value-of select="concat(channel/@forum_url,'dv_rss_',channel/@visittype,'_',channel/@boardid,'_',channel/@id,'_',channel/@page)" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat(channel/@pageurl,'&amp;boardid=',channel/@boardid,'&amp;id=',channel/@id,'&amp;page=',channel/@page)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="pv">star</xsl:with-param>
								</xsl:call-template>
							</div>
							<div class="posttitle">
								<span style="float:right">
									<xsl:choose>
										<xsl:when test="channel/@isapiwrite = 1">
											<a href="{//channel/@forum_url}dispbbs_{//channel/@boardid}_{//channel/@id}_{//channel/@page}_{//channel/@star}.html">[浏览完整版]</a>
										</xsl:when>
										<xsl:otherwise>
											<a href="{//channel/@forum_url}dispbbs.asp?boardid={//channel/@boardid}&amp;id={//channel/@id}&amp;page={//channel/@page}&amp;star={//channel/@star}">[浏览完整版]</a>
										</xsl:otherwise>
									</xsl:choose>
								</span>
								<span class="title">
									<h1>
										标题：<xsl:value-of select="//channel/@topic" disable-output-escaping="yes"/>
									</h1>
								</span>
							</div>
							<xsl:apply-templates select="channel/item" />
							<!-- 分页信息-->
							<div id="pagestr">
								<xsl:call-template name="PageList">
									<xsl:with-param name="Page" select="channel/@star"/>
									<xsl:with-param name="PageCount" select="channel/@pagecount"/>
									<xsl:with-param name="MaxRows" select="channel/@pagesize"/>
									<xsl:with-param name="CountNum" select="channel/@count"/>
									<xsl:with-param name="PageStr">
										<xsl:choose>
											<xsl:when test="channel/@isapiwrite = 1">
												<xsl:value-of select="concat(channel/@forum_url,'dv_rss_',channel/@visittype,'_',channel/@boardid,'_',channel/@id,'_',channel/@page)" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat(channel/@pageurl,'&amp;boardid=',channel/@boardid,'&amp;id=',channel/@id,'&amp;page=',channel/@page)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="pv">star</xsl:with-param>
								</xsl:call-template>
							</div>
						</xsl:when>
					</xsl:choose>
				</div>
				<div id="block">
					<hr />
					<div style="float:right;width:auto;text-align:right;">
						<xsl:value-of select="channel/copyright" disable-output-escaping="yes"/>
						<br/><xsl:value-of select="channel/powered" disable-output-escaping="yes"/>
						<br/><font class="gray">Processed in <xsl:value-of select="channel/@runtime" /> s, <xsl:value-of select="channel/@sqlquerynum" /> queries.</font>
					</div>
					<div align="center">
						<xsl:call-template name="visilinks"/>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="visilinks">
		<ul id="visittype">
			<xsl:choose>
				<xsl:when test="channel/@isapiwrite = 1">
					<li>
						<font class="stats">[Full]</font>
						<a href="{//channel/@forum_url}" class="gray">完整版</a>
					</li>
					<li>
						<font class="stats">[Rss]</font>
						<a href="{//channel/@forum_url}dv_rss_xml.html" class="gray" target="_blank">订阅</a>
					</li>
					<li>
						<font class="stats">[Xml]</font>
						<a href="{//channel/@forum_url}dv_rss_xslt.html" class="gray">无图版</a>
					</li>
					<li>
						<font class="stats">[Xhtml]</font>
						<a href="{//channel/@forum_url}dv_rss_xhtml.html" class="gray">无图版</a>
					</li>
				</xsl:when>
				<xsl:otherwise>
					<li>
						<font class="stats">[Full]</font>
						<a href="{//channel/@forum_url}" class="gray">完整版</a>
					</li>
					<li>
						<font class="stats">[Rss]</font>
						<a href="{//channel/@forum_url}dv_rss.asp?s=xml" class="gray" target="_blank">订阅</a>
					</li>
					<li>
						<font class="stats">[Xml]</font>
						<a href="{//channel/@forum_url}dv_rss.asp?s=xslt" class="gray">无图版</a>
					</li>
					<li>
						<font class="stats">[Xhtml]</font>
						<a href="{//channel/@forum_url}dv_rss.asp?s=xhtml" class="gray">无图版</a>
					</li>
				</xsl:otherwise>
			</xsl:choose>
		</ul>
	</xsl:template>
	<xsl:template match="item">
		<xsl:choose>
			<xsl:when test="@type='board'">
				<xsl:call-template name="boardlist" />
			</xsl:when>
			<xsl:when test="@type='topic'">
				<xsl:call-template name="topiclist" />
			</xsl:when>
			<xsl:when test="@type='post'">
				<xsl:call-template name="postlist" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="title">
		<xsl:if test="channel/@id !=0"><xsl:value-of select="channel/@topic" /> ← </xsl:if>
		<xsl:if test="channel/@boardid !=0"><xsl:value-of select="channel/@boardtype" disable-output-escaping="yes"/> ← </xsl:if>
		<xsl:value-of select="channel/title" />
	</xsl:template>
	<xsl:template name="nav">
		<xsl:choose>
			<xsl:when test="channel/@isapiwrite = 1">
				<div id="nav"> ◎ <a href="{channel/@forum_url}dv_rss_{channel/@visittype}.html" class="title"><xsl:value-of select="channel/title" /></a><xsl:if test="channel/@boardid !=0"> → <a href="{channel/@forum_url}dv_rss_{channel/@visittype}_{channel/@boardid}_{channel/@page}.html" class="title"><xsl:value-of select="channel/@boardtype" disable-output-escaping="yes"/></a></xsl:if><xsl:if test="channel/@id !=0"> → <font class="title"><xsl:value-of select="channel/@topic" /></font></xsl:if></div>
			</xsl:when>
			<xsl:otherwise>
				<div id="nav"> ◎ <a href="{channel/@pageurl}" class="title"><xsl:value-of select="channel/title" /></a><xsl:if test="channel/@boardid !=0"> → <a href="{channel/@pageurl}&amp;boardid={channel/@boardid}&amp;page={channel/@page}" class="title"><xsl:value-of select="channel/@boardtype" disable-output-escaping="yes"/></a></xsl:if><xsl:if test="channel/@id !=0"> → <font class="title"><xsl:value-of select="channel/@topic" /></font></xsl:if></div>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<xsl:template name="topiclist">
		<!--主题显示模板-->
		<li id="rsstopic">
			<xsl:choose>
				<xsl:when test="@istop &gt; 0">
					<span class="stats">[置顶]</span>
				</xsl:when>
				<xsl:when test="@isbest=1">
					<span class="stats">[精华]</span>
				</xsl:when>
				<xsl:when test="@locktopic=1">
					<span class="stats">[锁定]</span>
				</xsl:when>
				<xsl:when test="@isvote=1">
					<span class="stats">[投票]</span>
				</xsl:when>
				<xsl:when test="@child &gt; 20">
					<span class="stats">[热门]</span>
				</xsl:when>
			</xsl:choose>
			<a href="{link}" class="title">
				<xsl:value-of select="title" disable-output-escaping="yes"/>
			</a>
			<span class="topicinfo sort"> -- <xsl:value-of select="author"/> ( <font class="stats"><xsl:value-of select="@child"/></font> 回复 / <xsl:value-of select="@hits"/> 点击) <font class="time"><xsl:value-of select="pubDate"/></font></span>
			<span class="gray">
				[<a href="{bbslink}" target="_blank" title="点击进入完整模式">浏览</a>]
			</span>
		</li>
	</xsl:template>
	<xsl:template name="postlist">
		<!--帖子显示模板-->
		<xsl:variable name="layer">
			<xsl:choose>
				<xsl:when test="//channel/@star =1">
					<xsl:value-of select="position()"/>楼
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="position() + ceiling((//channel/@star -1) * //channel/@pagesize)"/>楼
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			<div class="postname">
				<div class="pf"><xsl:value-of select="$layer"/></div>
				<b><xsl:value-of select="author"/> </b> 发表于：<xsl:value-of select="pubDate"/>
			</div>
			<div class="postbody">
				<xsl:if test="title != '' and position() &lt; 0">
					<h2>Re：<xsl:value-of select="title"/></h2>
				</xsl:if>
				<xsl:value-of select="description" disable-output-escaping="yes"/>
				<div style="clear:both;"></div>
			</div>
	</xsl:template>
	<xsl:template name="boardlist">
		<!--版块显示模板-->
		<xsl:variable name="childstyle">
			<xsl:text>margin-left:</xsl:text>
			<xsl:value-of select="@depth * 50"/>
			<xsl:text>px;</xsl:text>
			<xsl:choose>
				<xsl:when test="@depth mod 2 = 0">
					<xsl:text>list-style-type:circle;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>list-style-type:square;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<li style="{$childstyle}">
			<xsl:choose>
				<xsl:when test="@depth = 0">
					<b>
						<a href="{link}">
							<xsl:value-of select="title" disable-output-escaping="yes"/>
						</a>
					</b>
				</xsl:when>
				<xsl:otherwise>
					<a href="{link}" class="title">
						<xsl:value-of select="title" disable-output-escaping="yes"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
			(<span class="red" title="共有{@child}下级版面！"><xsl:value-of select="@child"/></span>) --- <span class="gray">[<a href="{bbslink}" target="_blank" title="点击进入完整模式">浏览</a>]</span>
		</li>
	</xsl:template>
	<xsl:template name="PageList">
		<xsl:param name="Page"/>
		<!--当前页码-->
		<xsl:param name="MaxRows"/>
		<!--每页记录数-->
		<xsl:param name="CountNum"/>
		<!--总记录数-->
		<xsl:param name="PageStr"/>
		<!--链接参数-->
		<xsl:param name="PageCount"/>
		<xsl:param name="pv"/>
		<xsl:param name="n" select="8"/>
		<xsl:variable name="i">
			<xsl:choose>
				<xsl:when test="$Page &lt; floor($n div 2) + 1 ">1</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$Page - floor($n div 2)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Endpage">
			<xsl:choose>
				<xsl:when test="$i + $n -1 &lt; $PageCount ">
					<xsl:value-of select="$i + $n -1 "/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$PageCount"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		共<xsl:value-of select="$CountNum"/> 条记录, 每页显示 <xsl:value-of select="$MaxRows"/> 条, 页签:
		<xsl:if test="$Page &gt; $n+1">
			<xsl:choose>
				<xsl:when test="channel/@isapiwrite = 1">
					<a href="{$PageStr}_1_count{$CountNum}.html">[1]</a>...
				</xsl:when>
				<xsl:otherwise>
					<a href="{$PageStr}&amp;{$pv}=1&amp;count={$CountNum}">[1]</a>...
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:call-template name="showonepage">
			<xsl:with-param name="i" select="$i"/>
			<xsl:with-param name="endpage" select="$Endpage"/>
			<xsl:with-param name="PageStr" select="$PageStr"/>
			<xsl:with-param name="CountNum" select="$CountNum"/>
			<xsl:with-param name="pv" select="$pv"/>
			<xsl:with-param name="Page" select="$Page"/>
		</xsl:call-template>
		<xsl:if test="$PageCount &gt; ceiling($n+$Page)">
			<xsl:choose>
				<xsl:when test="channel/@isapiwrite = 1">
					...<a href="{$PageStr}_{$PageCount}_count{$CountNum}.html">[<xsl:value-of select="$PageCount"/>]</a>
				</xsl:when>
				<xsl:otherwise>
					...<a href="{$PageStr}&amp;{$pv}={$PageCount}&amp;count={$CountNum}">[<xsl:value-of select="$PageCount"/>]</a>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template name="showonepage">
		<xsl:param name="i"/>
		<xsl:param name="endpage"/>
		<xsl:param name="PageStr"/>
		<xsl:param name="CountNum"/>
		<xsl:param name="pv"/>
		<xsl:param name="Page"/>
			<xsl:if test="$Page != $i">
				<xsl:choose>
					<xsl:when test="channel/@isapiwrite = 1"><a href="{$PageStr}_{$i}_count{$CountNum}.html">[<xsl:value-of select="$i"/>]</a></xsl:when>
					<xsl:otherwise><a href="{$PageStr}&amp;{$pv}={$i}&amp;count={$CountNum}">[<xsl:value-of select="$i"/>]</a></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$Page = $i">
				<xsl:choose>
					<xsl:when test="channel/@isapiwrite = 1">
						<a href="{$PageStr}_{$i}_count{$CountNum}.html" class="red">
							[<xsl:value-of select="$i"/>]
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$PageStr}&amp;{$pv}={$i}&amp;count={$CountNum}" class="red">
							[<xsl:value-of select="$i"/>]
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$endpage &gt; $i">
				<xsl:call-template name="showonepage">
					<xsl:with-param name="i" select="$i+1"/>
					<xsl:with-param name="endpage" select="$endpage"/>
					<xsl:with-param name="PageStr" select="$PageStr"/>
					<xsl:with-param name="CountNum" select="$CountNum"/>
					<xsl:with-param name="pv" select="$pv"/>
					<xsl:with-param name="Page" select="$Page"/>
				</xsl:call-template>
		</xsl:if>
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