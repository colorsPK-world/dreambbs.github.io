<?xml version="1.0" encoding="Gb2312"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" version="4.0"/>
<xsl:preserve-space elements="code"/>
<!--
	Copyright (C) 2004,2005 AspSky.Net. All rights reserved.
	Written by dvbbs.net Fssunwin
	Web: http://www.aspsky.net/,http://www.dvbbs.net/
	Email: eway@aspsky.net
-->
<xsl:variable name="String_0" title="htmlhead">
<![CDATA[
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN">
<head><title>{$boketitle}-{$bokename}{$stats}</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
<meta name="Copyright" content="{$copyright}"/>
<meta name="description" content="{$bokechildtitle}"/>
<link rel="alternate" type="application/rss+xml" title="订阅{$bokename}的信息" href="{$rssurl}" />
<link rel="home" href="{$BokeUrl}" />
<link rel="SHORTCUT ICON" href="boke/images/favicon.ico"/>
<link rel="stylesheet" rev="stylesheet" href="{$skinpath}Css/BodyStyle.css" type="text/css" media="screen" />
<script language="javascript" src="Boke/Script/Dv_Main.js" type="text/javascript"></script>
<script language="javascript" src="Boke/Script/Dv_page_inc.js" type="text/javascript"></script>
</head>
<!-- <BODY oncontextmenu="return false;" onselectstart="return false;"> -->
<body>
]]>
</xsl:variable>

<xsl:variable name="String_1" title="Footer">
<![CDATA[
<div id="footer">
<div id="nav_r">
<img src="boke/Images/boke_logo.gif" border="0" alt=""/>
</div>
Power by {$version}
<br/>
Copyright &copy; {$bokeuser} {$sysinfo}
</div>
</body>
</html>
]]>
</xsl:variable>

<xsl:variable name="String_2" title="Top">
<![CDATA[
<div class="menuskin" id="popmenu" onmouseover="DvMenu.clearhidemenu()" onmouseout="DvMenu.dynamichide(event)" style="z-index:100"></div>
<div id="topnav">
<div style="float:right;">
{$SiteUrl}&nbsp;&nbsp;&nbsp;&nbsp;
</div>
<div>
<font style="font-weight : bold ;FONT-SIZE: 22px;line-height: normal;" face="Georgia,Times">
{$boketitle}</font><br/>
&nbsp;&nbsp;&nbsp;&nbsp;{$bokechildtitle}
</div>
</div>
]]>
</xsl:variable>

<xsl:variable name="String_3" title="TopNav">
<![CDATA[
<div id="navmenu">
<div id="nav_r">
{$TopicNum}篇文章，{$FavNum}篇收藏，今日信息{$TodayNum}篇,最后更新:{$LastUpTime} {$Open}
</div>
<a href="bokeindex.asp">博客首页</a>&nbsp;&nbsp;|&nbsp;&nbsp;
{$BokeOwnerNav}
<a href="index.asp">论坛</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$bokeurl}{$bokename}.showchannel.0.html" onMouseOver="showmenu(event,'','ShowChannel_0');">文章频道</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$bokeurl}{$bokename}.showchannel.4.html" onMouseOver="showmenu(event,'','ShowChannel_4');">相册频道</a>
{$BokePayto}
</div>
]]>
</xsl:variable>

<xsl:variable name="String_4" title="LeftMenu">
<![CDATA[
<div id="leftmenu">
{$show_bokenote}
{$show_calendar}
{$show_channel}
{$show_search}
{$show_topicnews}
{$show_photos}
{$show_counts}
{$show_votes}
{$show_links}
<br/>
<a href="http://rss.iboker.com/sub/?{$bokeurl_r}{$bokename}.rss.xml" target="_blank"><img src="boke/Images/xml.gif" border="0" alt="订阅本站的 RSS 2.0 新闻组" /></a>
<br/>
<a href="http://validator.w3.org/check?uri=referer" target="_blank"><img src="boke/Images/w3c_xhtml.gif" border="0" alt=""/></a>
<br/>
<a href="http://jigsaw.w3.org/css-validator/check/referer" target="_blank"><img src="boke/Images/w3c_css.gif" border="0" alt=""/></a>
<br/>
<a href="http://www.iboker.com" target="_blank"><img src="boke/Images/boke_icon.gif" border="0" alt=""/></a>
</div>
]]>
</xsl:variable>

<xsl:variable name="String_5" title="Main">
<![CDATA[
<!-- 页面主体 -->
<div id="main">
{$Main}<span style="float:left;">&nbsp;&nbsp;&nbsp;&nbsp;全部选中 <input type="checkbox" name="chkall" value="on" onclick="CheckAll(this.form);"/></span>
</div>
]]>
</xsl:variable>

<xsl:variable name="String_6" title="topic">
<![CDATA[
<div class="topic">
	<div class="topic_r">
	{$PostDate} &nbsp;&nbsp;<img src="boke/images/weather/{$Weather_B}" alt="{$Weather_A}" align="absmiddle">&nbsp;
	</div>
<a href="{$bokeurl}{$bokename}.showtopic.{$TopicID}.html" target="_blank"><img src="{$Skins_Path}images/topic.gif" border="0" alt="开新窗口访问该主题"></a>&nbsp;<a href="{$bokeurl}{$bokename}.showtopic.{$TopicID}.html">{$topic}</a>
</div>
<div class="postbody">
{$Content}
</div>
<div class="postend"><a href="dispuser.asp?id={$UserID}" target="_blank" alt="查看个人资料">{$PostUserName}</a> 发表于 <a href="{$bokeurl}{$bokename}.showchannel.{$cat_tid}.{$cat_id}.html">{$PChannel}</a> | <a href="{$bokeurl}{$bokename}.showtopic.{$TopicID}.html">评论({$Childs})</a> | 引用(0) <INPUT TYPE="checkbox" NAME="checkboxall">批量删除</div>
<hr class="post"/><br/>
]]>
</xsl:variable>

<xsl:variable name="String_7" title="show_bokenote">
<![CDATA[
<!-- 最新公告 -->
<div class="border1">
<div class="lefttitle">最新公告</div>
<div class="msg">
{$bokenote}
</div>
</div>
<br/>
]]>
</xsl:variable>
<xsl:variable name="String_8" title="show_channel">
<![CDATA[
<!-- 频道栏目 -->
<div class="border1">
<div class="lefttitle">频道栏目</div>
<div class="msg" id="show_channel" style="padding: 3 3 3 20;">
{$bokechannel}
</div>
</div>
<script language="JavaScript">
<!--
//0=文章,1=收藏,2=链接,3=交易,4=相册
Show_channeldata();

function Show_channeldata(){
	var Channels=["文章","收藏","链接","交易","相册"];
	var ChannelData="";
	var ChannelPay="{$ChannelPay}";
	for (var i=0;i<5;i++){
		//if (i!=2){
		var Obj = Dvbbs.Objects("ShowChannel_"+i);
		if (Obj){
			if (i==3 && ChannelPay!=''){
			ChannelData = "<b>"+ChannelPay+"</b>"+ Obj.innerHTML;
			}else{
			ChannelData = "<b>"+Channels[i]+"</b>"+ Obj.innerHTML;
			}
			Dvbbs.Objects("show_channel").innerHTML += ChannelData;
		};
		//}
	};
}
//-->
</script>
<br/>
]]>
</xsl:variable>
<xsl:variable name="String_9" title="show_search">
<![CDATA[
<!-- 站内搜索 -->
<div class="border1">
<div class="lefttitle">查询</div>
<form method="post" action="bokesearch.asp">
<div class="msg">
<input type="hidden" name="User" value="{$bokename}">
<input type="text" name="keyword" value="" size="25"/>
<br/>
<input type="radio" name="sel" value="0" checked="true">标题
<input type="radio" name="sel" value="1">作者
<select name="stype">
	<option value="-1">分类</option>
	<option value="0" selected="true">文章 </option>
	<option value="1">收藏</option>
	<option value="2">书签</option>
	<option value="3">交易</option>
	<option value="4">相册</option>
</select>
<input type="submit" value="查询"/>
</div>
</form>
</div>
<br/>
]]>
</xsl:variable>
<xsl:variable name="String_10" title="show_topicnews">
<![CDATA[
<!-- 最新文章 -->
<div class="border1">
<div class="lefttitle">最新评论</div>
<div class="msg">
{$boketopicnews}
</div>
</div>
<br/>
]]>
</xsl:variable>

<xsl:variable name="String_11" title="show_photos">
<![CDATA[
<!-- 最新图库 -->
<div class="border1">
<div class="lefttitle">最新图库</div>
<div class="msg">
{$bokephotos}
</div>
</div>
<br/>
]]>
</xsl:variable>
<xsl:variable name="String_12" title="show_links">
<![CDATA[
<!-- 友情链接 -->
<div class="border1">
<div class="lefttitle">最新链接</div>
<div class="msg">
{$bokelinks}
</div>
</div>
<br/>
]]>
</xsl:variable>

<xsl:variable name="String_13" title="show_counts">
<![CDATA[
<!-- 博客统计 -->
<div class="border1">
<div class="lefttitle">博客统计</div>
<div class="msg">
{$bokecounts}
</div>
</div>
<br/>
]]>
</xsl:variable>

<xsl:variable name="String_14" title="show_votes">
<![CDATA[
<!-- 参与投票 -->
<!--
<div class="border1">
<div class="lefttitle">参与投票</div>
<div class="msg">
{$bokevotes}
</div>
</div>
<br/>
-->
]]>
</xsl:variable>

<xsl:variable name="String_15" title="show_calendar">
<![CDATA[
<!-- 日历 -->
<!--
<div class="border1">
<div class="msg">
{$bokecalendar}
</div>
</div>
<br/>
-->
]]>
</xsl:variable>

<xsl:variable name="String_16" title="show_channel">
<![CDATA[
<!--博客频道列表-->

<div class="Menu_popup" id="ShowChannel_{$cat_tid}">
<div class="menuitems">
{$channellist}
</div>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_17" title="show_channellist">
<![CDATA[
<li><a href="{$bokeurl}{$bokename}.showchannel.{$cat_tid}.{$cat_id}.html" alt="">{$channelname}</a></li>
]]>
</xsl:variable>

<xsl:variable name="String_18" title="show_Topiclist">
<![CDATA[
<script language="JavaScript" src="boke/Script/Pagination.js"></script>
{$nav}
{$topiclist}
<SCRIPT language="JavaScript">
PageList({$Page},3,{$MaxRows},{$CountNum},"{$PageSearch}",5);
</SCRIPT>
]]>
</xsl:variable>
<xsl:variable name="String_19" title="channel_nav">
<![CDATA[
<div class="channel_nav">
<a href="{$bokeurl}{$bokename}.index.html" alt="返回{$bokeuser}首页">{$bokeuser}主页</a> >> <a href="{$bokeurl}{$bokename}.showchannel.{$cat_tid}.html">{$stype}</a> >> <a href="{$bokeurl}{$bokename}.showchannel.{$cat_tid}.{$cat_id}.html">{$catname}</a> >> {$stats}
</div>
<br/>
<div class="channel_intro">{$Channel_Intro}</div>
]]>
</xsl:variable>
<xsl:variable name="String_20" title="cat_photo">
<![CDATA[
<table border="0" cellpadding="3" cellspacing="0" align="center" Style="width:98%">
<tr>
{$photo_list}
</tr>
</table>
]]>
</xsl:variable>

<xsl:variable name="String_21" title="cat_photo">
<![CDATA[
<td align="center" width="25%">
<div class="photo1">
<a href="{$bokeurl}{$bokename}.showtopic.{$TopicID}.html"><img src="{$ViewPhoto}" alt="" Style="border:1px solid #C0C0C0" width="{$width}px" height="{$height}px"/></a>
<div class="photo2">
《 {$topic} 》
<br/>{$PostUserName} -- {$PostDate}
</div>
</div>
</td>
]]>
</xsl:variable>
<xsl:variable name="String_22" title="cat_photo">
<![CDATA[
</tr><tr>
]]>
</xsl:variable>
<xsl:variable name="String_23" title="boke_link">
<![CDATA[
<li><a href="{$linkurl}" target="_blank">{$linkname}</a></li>
]]>
</xsl:variable>
<xsl:variable name="String_24" title="boke_photo">
<![CDATA[
<div class="photo1">
<a href="{$bokeurl}{$bokename}.showtopic.{$TopicID}.html"><img src="{$ViewPhoto}" alt="" Style="border:1px solid #C0C0C0" width="{$width}px" height="{$height}px"/></a>
<div class="photo2">
《 {$topic} 》
</div>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_25" title="boke_postnews">
<![CDATA[
<li><a href="{$bokeurl}{$bokename}.showtopic.{$TopicID}.{$PostID}.html#{$PostID}">{$title}</a><br/>{$postusername}</li>
]]>
</xsl:variable>
<xsl:variable name="String_26" title="boke_bokecounts">
<![CDATA[
<li>今日数:{$TodayNum}</li>
<li>文章数:{$TopicNum}</li>
<li>收藏数:{$FavNum}</li>
<li>图片数:{$PhotoNum}</li>
<li>评论数:{$PostNum}</li>
<li>开设时间:{$JoinBokeTime}</li>
<li>更新时间:{$LastUpTime}</li>
]]>
</xsl:variable>
<xsl:variable name="String_27" title="IS_BokeOwnerNav">
<![CDATA[
<a href="BokeManage.asp" target="_blank" title="管理我的个人博客">管理博客</a>&nbsp;&nbsp;|&nbsp;&nbsp;
]]>
</xsl:variable>
<xsl:variable name="String_28" title="Not_BokeOwnerNav">
<![CDATA[
<a href="BokeApply.asp">申请博客</a>&nbsp;&nbsp;|&nbsp;&nbsp;
]]>
</xsl:variable>
<xsl:variable name="String_29" title="other_BokeOwnerNav">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_30" title="BokePayto">
<![CDATA[
&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$bokeurl}{$bokename}.showchannel.3.html" onMouseOver="showmenu(event,'','ShowChannel_3');">{$PaytoStr}</a>
]]>
</xsl:variable>
<xsl:variable name="String_31" title="BokePayto">
<![CDATA[
交易频道
]]>
</xsl:variable>
<xsl:variable name="String_32" title="BokeNone">
<![CDATA[
<ul>
<li><B>错误信息</B>：该博客用户不存在或填写的资料有误！
</ul>
]]>
</xsl:variable>
<xsl:variable name="String_33" title="TopNav_Sys">
<![CDATA[
<div id="navmenu">
<div id="nav_r">
{$BokeOwnerNav}
<a href="index.asp">进入论坛</a>
</div>
<a href="bokeindex.asp">博客首页</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$ibokeurl}show_user.html">博客索引</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$ibokeurl}show_topic.html">话题索引</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$ibokeurl}show_topic.1.html">文章</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$ibokeurl}show_topic.2.html">收藏</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$ibokeurl}show_topic.5.html">相册</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$ibokeurl}show_topic.3.html">书签</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$ibokeurl}show_topic.4.html">交易</a>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_34" title="iBokeOwnerNav">
<![CDATA[
<a href="{$bokeurl}{$bokename}.index.html">我的博客</a>&nbsp;&nbsp;|&nbsp;&nbsp;
]]>
</xsl:variable>
<xsl:variable name="String_35" title="SiteUrl">
<![CDATA[
{$SiteUrl}
]]>
</xsl:variable>
<xsl:variable name="String_36" title="BokeStats">
<![CDATA[
<a href="Bokepostings.asp?user={$bokename}&action=bokestats"><img src="{$skinpath}images/stat_open.gif" border="0" alt="将当前开放状态的博客设为关闭状态。"/></a>
]]>
</xsl:variable>
<xsl:variable name="String_37" title="BokeStats">
<![CDATA[
<a href="Bokepostings.asp?user={$bokename}&action=bokestats"><img src="{$skinpath}images/stat_close.gif" border="0" alt="将当前关闭状态的博客设为开放状态。"/></a>

]]>
</xsl:variable>
</xsl:stylesheet>
