<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration = "yes" indent="yes" version="4.0"/>
	<!--
	Copyright (C) 2004,2005 AspSky.Net. All rights reserved.
	Written by dvbbs.net Sunwin
	-->
	<xsl:template  match="AppraiseInfo">
		<xsl:call-template name="top"/>
	</xsl:template>
	<xsl:template name ="top">
		<script language="JavaScript" src="inc/Pagination.js"></script>
		<div class="th" style="margin-top:10px;text-indent:10px;">
			  帖子评论信息
		</div>
		<div id="topicpk"  class="mainbar">
		<div>
			<span class="t1">评论主题：</span>
			<span id="pk_title">
				<a href="dispbbs.asp?boardID={post/@boardid}&amp;ID={post/@topicid}&amp;page=1">
					<xsl:value-of select="topic/@title" disable-output-escaping="yes"/>
				</a>
			</span>
			<br/>
			<span class="t2">评论对象：</span>
			<span id="pk_user">
				<xsl:value-of select="post/@username"/> | <xsl:value-of select="post/@dateandtime"/>
			</span>
			<br/>
			<span class="t3">评论言论：</span>
			<span id="pk_intro">
				<xsl:choose>
					<xsl:when test="post/@parentid =0 and post/@getmoneytype=3">
						<xsl:call-template name="checkgetmoney" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="post/@body" disable-output-escaping="yes"/>
					</xsl:otherwise>
				</xsl:choose>
			</span>
			<br/>
			<div class="clr"></div>
		</div>
		</div>
		<div id="topicpk_middle"  class="mainbar" style="padding-top:10px;padding-bottom:10px;">
			<div id="topicpk_center" style="height:47px;overflow:hidden;"><embed src="images/others/vs.swf" FlashVars="num1={post/@isagree_5}&amp;num2={post/@isagree_6}&amp;fan1=支持方&amp;fan2=反对方"  width="750" height="47" bgcolor="#DADADA" quality="high" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"/></div>
			<div id="topicpk_center" class="vsbg">
				<div id="pk_2">
					<dl style="width:auto; margin-left:60px;">
						<p align="right" style="color:#222;">反对方</p>
					</dl>
					<div id="pkcon_2">
						<xsl:apply-templates select="AppraiseList[@AType=2]"/>
					</div>
				</div>
				<div id="pk_1" style="text-align:left">
					<dl style="width:auto; margin-right:60px;">
						<p align="left">支持方</p>
					</dl>
					<div id="pkcon_1">
						<xsl:apply-templates select="AppraiseList[@AType=1]"/>
					</div>
				</div>
				<div style="clear:both;"></div>
			</div>
			<div id="topicpk_center" style="margin-bottom:10px;">
				<div id="pk_2" style="height:25px;line-height:25px;text-align:right;">
					反对方人数（<span id="acount_2"><xsl:value-of select="post/@isagree_6"/></span>）
					<span id="page_2">
						<script>
							PageList(<xsl:value-of select="AppraiseList[@AType=2]/@Page"/>,2,<xsl:value-of select="AppraiseList[@AType=2]/@PageSize"/>,<xsl:value-of select="AppraiseList[@AType=2]/@ACount"/>,"action=querylist&amp;atype=2&amp;boardid=<xsl:value-of select="post/@boardid"/>&amp;topicid=<xsl:value-of select="post/@topicid"/>&amp;postid=<xsl:value-of select="post/@postid"/>",5);
						</script>
					</span>
				</div>
				<div id="pk_1" style="height:25px;line-height:25px;text-align:left;">
					支持方人数（<span id="acount_1"><xsl:value-of select="post/@isagree_5"/></span>）
					<span id="page_1">
					<script>
						PageList(<xsl:value-of select="AppraiseList[@AType=1]/@Page"/>,2,<xsl:value-of select="AppraiseList[@AType=1]/@PageSize"/>,<xsl:value-of select="AppraiseList[@AType=1]/@ACount"/>,"action=querylist&amp;atype=1&amp;boardid=<xsl:value-of select="post/@boardid"/>&amp;topicid=<xsl:value-of select="post/@topicid"/>&amp;postid=<xsl:value-of select="post/@postid"/>",5);
					</script>
					</span>
				</div>
				<div style="clear:both;"></div>
			</div>
			<div id="topicpk_center">
				<div id="pk_0">
					<dl>
						<p align="left">中立方</p>
					</dl>
					<div id="pkcon_0">
						<xsl:apply-templates select="AppraiseList[@AType=0]"/>
					</div>
				</div>
				<div id="pk_0" style="height:25px;line-height:25px;text-align:left;">
					中立方人数（<span id="acount_0"><xsl:value-of select="post/@isagree_4"/></span>）
					<span id="page_0">
					<script>
						PageList(<xsl:value-of select="AppraiseList[@AType=0]/@Page"/>,2,<xsl:value-of select="AppraiseList[@AType=0]/@PageSize"/>,<xsl:value-of select="AppraiseList[@AType=0]/@ACount"/>,"action=querylist&amp;atype=0&amp;boardid=<xsl:value-of select="post/@boardid"/>&amp;topicid=<xsl:value-of select="post/@topicid"/>&amp;postid=<xsl:value-of select="post/@postid"/>",5);
					</script>
					</span>
				</div>
			</div>
		</div>
		<div class="mainbar3">
		</div>
		<iframe style="border:0px;width:0px;height:0px;" src="" name="TempIframe"></iframe>
	</xsl:template>
	<xsl:template match="hidepage">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
			</head>
			<script language="JavaScript">
				var ISAPI_ReWrite = 0;
			</script>
			<script language="JavaScript" src="inc/topicpk.js"></script>
			<script language="JavaScript" src="inc/Pagination.js"></script>
			<body>
				<div id="pkcon_{AppraiseList/@AType}">
					<xsl:apply-templates select="AppraiseList"/>
				</div>
				<div id="page_{AppraiseList/@AType}">
					<script>
						PageList(<xsl:value-of select="AppraiseList/@Page"/>,2,<xsl:value-of select="AppraiseList/@PageSize"/>,<xsl:value-of select="AppraiseList/@ACount"/>,"action=querylist&amp;atype=<xsl:value-of select="AppraiseList/@AType"/>&amp;boardid=<xsl:value-of select="AppraiseList/@boardid"/>&amp;topicid=<xsl:value-of select="AppraiseList/@topicid"/>&amp;postid=<xsl:value-of select="AppraiseList/@postid"/>",5);
					</script>
				</div>
				<script language="JavaScript">
					var pid = "pkcon_<xsl:value-of select="AppraiseList/@AType"/>";
					var pageid = "page_<xsl:value-of select="AppraiseList/@AType"/>";
					outputHTML(pid);
					outputHTML(pageid);
				</script>
			</body>
		</html>
	</xsl:template>
	<xsl:template  match="AppraiseList">
		<xsl:for-each select="row">
			<xsl:variable name="layer">
				<xsl:choose>
					<xsl:when test="../@Page =1"><xsl:value-of select="position()"/>楼</xsl:when>
					<xsl:otherwise><xsl:value-of select="position() + (../@Page -1) * ../@PageSize"/>楼</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="username">
			<xsl:choose>
				<xsl:when test="@userid=0">客人</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@username"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
			<div id="pkinfo">
				<dt style="padding-left:6px;"><span style="float:right; display:block; padding-right:5px;"><xsl:value-of select="$layer"/></span><xsl:value-of select="$username"/></dt>
				<div class="con line">
					<p class="t">
						<xsl:value-of select="@atitle"/>
					</p>
					<span class="b">
					<xsl:value-of select="@acontent" disable-output-escaping="yes"/>
					</span>
				</div>
				<div style="clear:both"></div>
				<div class="bottom">
					<span style="float:left; padding-left:20px;">时间：<xsl:value-of select="@datetime"/> 来自：<xsl:value-of select="@ip"/></span>
					<xsl:if test="@DeletePower=1">
					<span style="float:right;width:auto;margin:0px; padding-right:5px;">[<a href="?Action=delete&amp;atype={../@AType}&amp;boardid={../@boardid}&amp;topicid={@topicid}&amp;postid={@postid}&amp;page={../@Page}&amp;AppraiseID={@appraiseid}" target="TempIframe">删除</a>]</span>
					</xsl:if>
				</div>
				<div style="clear:both"></div>
				
			</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="checkgetmoney">
	<fieldset style="border : 1px dotted #ccc;">
	<xsl:choose>
			<xsl:when test="post/@postuserid=userinfo/@userid"><legend style="text-indent:0px;">以下内容需要支付 <b><font color="red"><xsl:value-of select="post/@getmoney" /></font></b> 个金币方可查看，这是您发布的贴子。</legend>
	<xsl:value-of select="post/@body" disable-output-escaping="yes"/></xsl:when>
			<xsl:otherwise><xsl:choose>
			<xsl:when test="userinfo/@truemaster =1"><legend style="text-indent:0px;">以下内容需要支付 <b><font color="red"><xsl:value-of select="post/@getmoney" /></font></b> 个金币方可查看，由于您是工作人员，你可以看到内容。</legend>
	<xsl:value-of select="post/@body" disable-output-escaping="yes"/></xsl:when>
			<xsl:otherwise><xsl:choose>
			<xsl:when test="post/postbuyinfo/postbuyusers = userinfo/@username"><legend style="text-indent:0px;">以下内容需要支付 <b><font color="red"><xsl:value-of select="post/@getmoney" /></font></b> 个金币方可查看，您已经购买。</legend>
	<xsl:value-of select="post/@body" disable-output-escaping="yes"/></xsl:when>
			<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="userinfo/@vipgroupuser=1 and post/postbuyinfo/@notvipbuy=0"><legend style="text-indent:0px;">以下内容需要支付 <b><font color="red"><xsl:value-of select="post/@getmoney" /></font></b> 个金币方可查看，由于您是vip用户，并且因为设置了vip用户可免购买查看，您可以直接查看。</legend>
	<xsl:value-of select="post/@body" disable-output-escaping="yes"/></xsl:when>
			<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="(post/postbuyinfo/@buyuser =',,' or contains(post/postbuyinfo/@buyuser,concat(',',userinfo/@username,','))) and userinfo/@userid !=0 "><legend style="text-indent:0px;">以下内容需要支付 <b><font color="red"><xsl:value-of select="post/@getmoney" /></font></b> 个金币方可查看，您需要购买方可看到内容。</legend>
	<input type="button" value="我要查看内容，决定购买" onclick="location.href='BuyPost.asp?action=buy&amp;boardid={post/@boardid}&amp;id={post/@topicid}&amp;ReplyID={post/@postid}&amp;PostTable={post/@posttable}'"/></xsl:when>
			<xsl:otherwise>
			<legend style="text-indent:0px;">以下内容需要支付 <b><font color="red"><xsl:value-of select="post/@getmoney" /></font></b> 个金币方可查看，您需要购买方可看到内容。</legend>
	<xsl:choose>
			<xsl:when test="userinfo/@userid !=0">楼主设置了您不可以购买。</xsl:when>
			<xsl:otherwise>您还未登录，不能购买。</xsl:otherwise>
	</xsl:choose>
			</xsl:otherwise>
	</xsl:choose>
			</xsl:otherwise>
	</xsl:choose>
			</xsl:otherwise>
	</xsl:choose>
			</xsl:otherwise>
	</xsl:choose>
			</xsl:otherwise>
	</xsl:choose>
		</fieldset>
	</xsl:template>
</xsl:stylesheet>