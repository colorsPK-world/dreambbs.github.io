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
<xsl:variable name="String_0" title="index_main">
<![CDATA[
<style>
@import url({$skinpath}Css/IndexStyle.css);
</style>
<center>
<div class="pageall">
<!-- 主体内容开始 -->
{$Page_Main}
<!-- 主体内容结束 -->
</div>
</center>
<div style="clear:both"><br/></div>
]]>
</xsl:variable>
<xsl:variable name="String_1" title="index">
<![CDATA[
<div class="PageRow" style="background-color:#fff">
<!--第一行：公告 -->
{$Part_TopNotice}

<!--第一行：公告新闻 -->
{$Part_TopNews}
</div>
<hr class="dashed"/>
<!--第二行：搜索栏-->
<div class="PageRow">
{$SearchTool}
</div>
<hr class="dashed"/>
<!--第三行：博客排行-->
<div class="pagerow">
	<li class="part" style="padding-right:6px;">
		{$Page_NewJoinBoker}
	</li>
	<li class="part" style="padding-right:6px;">
		{$Page_HotBoker}
	</li>
	<li class="part">
		{$Page_UpBoker}
	</li>
</div>
<hr class="dashed"/>
<!--第六行：子栏目2-->
<div class="pagerow">
	<div class="partleft">
		{$Page_NewTopicList}
	</div>
	<div class="partright">
	
		{$Page_WeekPostList}

	</div>
</div>
<div class="pagerow">
	<hr class="dashed"/>
	<div class="partleft">
		{$Page_NewPostList}
	</div>
	<div class="partright">
		{$Page_NewLinkList}
	</div>
</div>
<hr class="dashed"/>
<!--第五行：博客图片-->
<div class="pagerow">
<div id="photolist">
	<div class="title"><img src="{$skinpath}images/photo_title.gif" border="0" align="absMiddle"/>&nbsp;博客相册</div>
	{$Page_Photos}
</div>
</div>
<!--第四行：博客分类目录-->
<hr class="dashed"/>
<div class="pagerow">
<div id="TopNotice" style="width:29%;">
	<div class="noticeicon"><img src="{$skinpath}images/notice.gif"></div>
	<div class="noticetitle">系统信息</div>
	<div class="msg">
		{$SystemInfo}
	</div>
</div>
	<div style="float:right;width:535px;">
	<div id="bokeclass">
		<div style="border-left:10px solid #56B1F5;margin:2px;">
		<div class="title1">博客索引</div>
		</div>
		<div class="msg">
		{$SysCat}
		</div>
		<div style="border-left:10px solid #91BE06;margin:2px;">
		<div class="title1">话题索引</div>
		</div>
		<div class="msg">
		{$SysChatCat}
		</div>
	</div>
	</div>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_2" title="index">
<![CDATA[
	<div id="bokeclass">
		<div style="border-left:10px solid #56B1F5;margin:2px;">
			<div class="title1">博客索引</div>
		</div>
		<div class="msg">
			{$SysCat}
		</div>
	</div>
	<div class="pagerow">
	<hr class="dashed"/>
	<div class="classinfo"><a href="{$ibokeurl}show_user.html">博客用户索引</a>&nbsp;→&nbsp;{$Descriptions}</div>
	<hr class="dashed"/>
	</div>
	<div class="pagerow">
	{$BokeUserList}
	</div>
]]>
</xsl:variable>
<xsl:variable name="String_3" title="index">
<![CDATA[
	<script language="JavaScript" src="boke/Script/Pagination.js"></script>
	{$BokeChatCat}
	<div class="pagerow">
	<hr class="dashed"/>
	<div class="classinfo"><a href="{$ibokeurl}show_topic.html">话题索引</a>&nbsp;→&nbsp;{$Descriptions}{$Descriptions_a}</div>
	<hr class="dashed"/>
	</div>
	<div class="pagerow">
	{$BokeTopicList}
	<hr class="dashed"/>
	<SCRIPT language="JavaScript">
		PageList({$Page},3,{$MaxRows},{$CountNum},"{$PageSearch}",5);
	</SCRIPT>
	</div>
]]>
</xsl:variable>

<xsl:variable name="String_4" title="Page_PhotoList">
<![CDATA[
<div class="showphotos">
{$PhotoLine}
</div>
]]>
</xsl:variable>

<xsl:variable name="String_5" title="Part_TopNotice">
<![CDATA[
<div id="TopNotice">
	<div class="noticeicon" ><img src="{$skinpath}images/notice.gif"></div>
	<div class="noticetitle">用户信息</div>
	<div class="msg">
		{$UserInfo}
	</div>
</div>	
]]>
</xsl:variable>

<xsl:variable name="String_6" title="Part_TopNews">
<![CDATA[
<div id="TopNews">
	<div class="newsicon"><img src="{$skinpath}images/news.gif"></div>
	<div class="newstitle">新 闻</div>
	<div class="msg">
		{$TopNewsMsg}
	</div>
</div>
]]>
</xsl:variable>

<xsl:variable name="String_7" title="SearchTool">
<![CDATA[
<form method="post" ACTION="?show_topic" onSubmit="this.action = '?show_topic.'+this.stype.options[this.stype.selectedIndex].value+'.html'">
	<div class="search">
		关键字：
		<input type="text" name="searchword"/>
		<input type="radio" name="sel" value="0" checked="true">标题
		<input type="radio" name="sel" value="1">作者
		<select name="stype">
		<option value="">分类</option>
		<option value="1" selected="true">文章 </option>
		<option value="2">收藏</option>
		<option value="3">书签</option>
		<option value="4">交易</option>
		<option value="5">相册</option>
		</select>
	</div>
	<div class="searchright" style="">		<input style="border:0px" src="{$skinpath}images/searchgo.gif" type="image" alt="查 找" align="absMiddle"/>
</div>
</form>
]]>
</xsl:variable>

<xsl:variable name="String_8" title="Page_NewJoinBoker">
<![CDATA[
<!-- 新博客用户 -->
<div class="border0">
	<div class="toptitle1"><img src="{$skinpath}images/icon_green.gif" border="0" align="absMiddle"/>&nbsp;新博客用户</div>
	<div class="msg">
		{$Page_NewJoinBoker}
	</div>
</div>
]]>
</xsl:variable>

<xsl:variable name="String_9" title="Page_HotBoker">
<![CDATA[
<!-- 热门博客 -->
<div class="border0">
	<div class="toptitle2"><img src="{$skinpath}images/icon_orange.gif" border="0" align="absMiddle"/>&nbsp;热门博客</div>
	<div class="msg">
		{$Page_HotBoker}
	</div>
</div>
]]>
</xsl:variable>

<xsl:variable name="String_10" title="Page_UpBoker">
<![CDATA[
<!-- 推荐博客 -->
	<div class="border0">
		<div class="toptitle3"><img src="{$skinpath}images/icon_blue.gif" border="0" align="absMiddle"/>&nbsp;博客更新</div>
		<div class="msg">
			{$Page_UpBoker}
		</div>
	</div>
]]>
</xsl:variable>

<xsl:variable name="String_11" title="Page_NewTopicList">
<![CDATA[
<!-- 最新文章 -->
<table cellSpacing="0" cellPadding="2" border="0" width="98%" align="center">
<tr>
	<td class="t_left" width="8px" height="25px"><img src="{$skinpath}images/subject_left.gif"/></td>
	<td class="t_title" width="94px"><img src="{$skinpath}images/new_article.gif" align="absMiddle"/> 最新信息</td>
	<td class="t_title" width="*"><span style="float:right;">|</span>标&nbsp;&nbsp;&nbsp;&nbsp;题</td>
	<td class="t_title" width="85px"><span style="float:right;">|</span>作者</td>
	<td class="t_title" width="100px">更新时间</td>
	<td class="t_right" width="8px"><img src="{$skinpath}images/subject_right.gif"/></td>
</tr>
{$Page_NewTopicList}
</table>
]]>
</xsl:variable>

<xsl:variable name="String_12" title="Page_NewPostList">
<![CDATA[
<!-- 最新评论 -->
<table cellSpacing="0" cellPadding="2" border="0" width="98%" align="center">
<tr>
	<td class="t_left" width="8px" height="25px"><img src="{$skinpath}images/reply_left.gif"/></td>
	<td class="t_title1" width="94px"><img src="{$skinpath}images/new_reply.gif" align="absMiddle"/> 最新评论</td>
	<td class="t_title1" width="*"><span style="float:right;">|</span>标&nbsp;&nbsp;&nbsp;&nbsp;题</td>
	<td class="t_title1" width="85px"><span style="float:right;">|</span>作者</td>
	<td class="t_title1" width="100px">更新时间</td>
	<td class="t_right" width="8px"><img src="{$skinpath}images/reply_right.gif"/></td>
</tr>
{$Page_NewPostList}
</table>
]]>
</xsl:variable>
<xsl:variable name="String_13" title="SysCat">
<![CDATA[
<!-- 分类导航 -->
{$SysCat}
]]>
</xsl:variable>
<xsl:variable name="String_14" title="SysChatCat">
<![CDATA[
<!-- 话题导航 -->
{$SysChatCat}
]]>
</xsl:variable>
<xsl:variable name="String_15" title="Main_System_Post">
<![CDATA[

]]>
</xsl:variable>
<xsl:variable name="String_16" title="Main_System_Photos">
<![CDATA[

]]>
</xsl:variable>
<xsl:variable name="String_17" title="Main_System_msg1">
<![CDATA[
</div>
]]>
</xsl:variable>
<xsl:variable name="String_18" title="Main_System_msg2">
<![CDATA[
]]>
</xsl:variable>
<!-- 数据列表 -->
<xsl:variable name="String_19" title="Msg_NewJoinBoker">
<![CDATA[
<span class="list_left">
<img src="{$skinpath}images/top_num{$num}.gif" border="0" align="absMiddle"/>&nbsp;<a href="{$bokeurl}{$Boke_Name}.index.html" target="_blank">{$Boke_Title}</a>
</span>
<span class="list_right">
	{$Boke_User}
</span>
]]>
</xsl:variable>
<xsl:variable name="String_20" title="Msg_HotBoker">
<![CDATA[
<span class="list_left">
	<a href="{$bokeurl}{$Boke_Name}.index.html" target="_blank">{$Boke_Title}</a>
</span>
<span class="list_right">
	{$Boke_User}
</span>
]]>
</xsl:variable>
<xsl:variable name="String_21" title="Msg_TopBoker">
<![CDATA[
<span class="list_left">
	<a href="{$bokeurl}{$Boke_Name}.index.html" target="_blank">{$Boke_Title}</a>
</span>
<span class="list_right">
	{$Boke_User}
</span>
]]>
</xsl:variable>

<xsl:variable name="String_22" title="Page_NewTopicList">
<![CDATA[
<tr>
<td></td>
<td class="t_body1">{$CatName}</td>
<td class="t_body1" align="left"><a href="{$bokeurl}Userid_{$UserID}.showtopic.{$TopicID}.html" alt="浏览该主题" target="_blank">{$Title}</a></td>
<td class="t_body1"><a href="boke.asp?userid={$UserID}" title="进入作者博客" target="_blank"><b>{$PostUser}</b></a></td>
<td class="t_body1">{$LastPostTime}</td>
<td></td>
</tr>
]]>
</xsl:variable>
<xsl:variable name="String_23" title="Page_NewTopicList">
<![CDATA[
<tr>
<td></td>
<td class="t_body1">{$CatName}</td>
<td class="t_body1" align="left"><a href="{$bokeurl}Userid_{$UserID}.showtopic.{$TopicID}.html" alt="浏览该主题" target="_blank">{$Title}</a></td>
<td class="t_body1"><b>{$PostUser}</b></td>
<td class="t_body1">{$LastPostTime}</td>
<td></td>
</tr>
]]>
</xsl:variable>
<xsl:variable name="String_24" title="Page_SysCats">
<![CDATA[
<a href="{$ibokeurl}show_user.{$catid}.html">{$CatName}</a>&nbsp;&nbsp;
]]>
</xsl:variable>
<xsl:variable name="String_25" title="Page_SysChatCats">
<![CDATA[
<a href="{$ibokeurl}show_topic.{$t}.{$catid}.html">{$CatName}</a>&nbsp;&nbsp;
]]>
</xsl:variable>
<xsl:variable name="String_26" title="Page_SignPhoto">
<![CDATA[
<li>
<div class="photo">
<a href="{$bokeurl}Userid_{$UserID}.showtopic.{$TopicID}.html" target="_blank"><img src="{$ViewPhoto}" border="0" width="115" height="100"/></a>
</div>
</li>
]]>
</xsl:variable>
<xsl:variable name="String_27" title="Page_SysPhotolist1">
<![CDATA[
<table border="0" cellpadding="3" cellspacing="0" align="center" Style="width:98%">
<tr>
{$photo_list}
</tr>
</table>
]]>
</xsl:variable>
<xsl:variable name="String_28" title="Page_SysPhotolist2">
<![CDATA[
<td align="center" width="25%">

<table border="0" width="100%" height="100%" cellspacing="1" class="table2">
	<tr>
		<td height="20px" colspan="4" class="t_title2">《 {$Title} 》</td>
	</tr>
	<tr>
		<td colspan="4" class="td2" style="text-align:center;">
		<a href="{$bokeurl}Userid_{$UserID}.showtopic.{$TopicID}.html" target="_blank"><img src="{$ViewPhoto}" border="0" width="115" height="100"/></a>
		</td>
	</tr>
	<tr>
		<td width="20%" class="td1">作者</td>
		<td width="30%" class="td2"><a href="boke.asp?UserID={$UserID}" title="浏览作者博客" target="_blank">{$UserName}</a></td>
		<td width="20%" class="td1">时间</td>
		<td width="30%" class="td2">{$DateTime}</td>
	</tr>
	<tr>
		<td class="td1">大小</td>
		<td class="td2" colspan="3">{$FileSize} KB</td>
	</tr>
</table>
</td>
]]>
</xsl:variable>
<xsl:variable name="String_29" title="other">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_30" title="Page_Syscat">
<![CDATA[
<script language="JavaScript" src="boke/Script/Pagination.js"></script>
<br/>
<table cellSpacing="0" cellPadding="2" border="0" width="98%" align="center">
<tr>
	<td class="t_left" width="8px" height="25px"><img src="{$skinpath}images/subject_left.gif"/></td>
	<td class="t_title" width="85px"><span style="float:right;">|</span>分类</td>
	<td class="t_title" width="*"><span style="float:right;">|</span>博客名称</td>
	<td class="t_title" width="100px"><span style="float:right;">|</span>用户</td>
	<td class="t_title" width="45px"><span style="float:right;">|</span>文章</td>
	<td class="t_title" width="45px"><span style="float:right;">|</span>评论</td>
	<td class="t_title" width="45px"><span style="float:right;">|</span>收藏</td>
	<td class="t_title" width="45px"><span style="float:right;">|</span>图片</td>
	<td class="t_title" width="100px">创建时间</td>
	<td class="t_right" width="8px"><img src="{$skinpath}images/subject_right.gif"/></td>
</tr>
{$Page_BokeUserList}
</table>
<SCRIPT language="JavaScript">
PageList({$Page},3,{$MaxRows},{$CountNum},"{$PageSearch}",5);
</SCRIPT>
]]>
</xsl:variable>
<xsl:variable name="String_31" title="Page_Syscat">
<![CDATA[
<tr>
<td></td>
<td class="t_body1">{$CatName}</td>
<td class="t_body1">
<a href="{$bokeurl}{$BokeSn}.index.html" title="浏览该用户博客" target="_blank">{$BokeTitle}</a>
</td>
<td class="t_body1"><a href="dispuser.asp?userid={$UserID}" title="浏览该用户资料" target="_blank"><b>{$BokeUser}</b></a></td>
<td class="t_body1">{$TopicNum}</td>
<td class="t_body1">{$PostNum}</td>
<td class="t_body1">{$FavNum}</td>
<td class="t_body1">{$PhotoNum}</td>
<td class="t_body1">{$JoinTime}</td>
<td></td>
</tr>
]]>
</xsl:variable>
<xsl:variable name="String_32" title="Page_SysTopiclist">
<![CDATA[
<div class="cat_title">
<div class="cat_note">评论({$Child}) | 阅读({$Hits})</div>
{$Num}. <a href="{$bokeurl}Userid_{$UserID}.showtopic.{$TopicID}.html" target="_blank">{$Title}</a>
</div>
<div class="cat_end">
分类：[{$CatName}] -- 作者：<a href="boke.asp?UserID={$UserID}" title="浏览作者博客" target="_blank">{$UserName}</a> -- 发表时间：<font color="gray">{$PostTime}</font>
</div>
<hr class="dashed"/>
]]>
</xsl:variable>
<xsl:variable name="String_33" title="Page_SysLinklist">
<![CDATA[
<div class="cat_title">
<div class="cat_note">{$Logo}</div>
{$Num}. <a href="{$bokeurl}Userid_{$UserID}.showtopic.{$TopicID}.html" target="_blank">{$Title}</a>
</div>
<div class="cat_end">
分类：[{$CatName}] -- 添加者：<a href="boke.asp?UserID={$UserID}" title="浏览作者博客" target="_blank">{$UserName}</a> -- 添加时间：<font color="gray">{$PostTime}</font> -- 点击(<font color="red">{$Hits}</font>)
</div>
<hr class="dashed"/>
]]>
</xsl:variable>
<xsl:variable name="String_34" title="Page_SysChatCat">
<![CDATA[
	<div id="bokeclass">
		<div style="border-left:10px solid #56B1F5;margin:2px;">
			<div class="title1">话题索引</div>
		</div>
		<div class="msg">
			{$SysCat}
		</div>
	</div>
]]>
</xsl:variable>

<xsl:variable name="String_35" title="Page_WeekPostList">
<![CDATA[
<!-- 本周热评 -->
<div class="border0">
	<div class="toptitle1"><img src="{$skinpath}images/icon_green.gif" border="0" align="absMiddle"/>&nbsp;本周热评</div>
	<div class="msg">
		{$Page_WeekPostList}
	</div>
</div>
]]>
</xsl:variable>

<xsl:variable name="String_36" title="Page_NewLinkList">
<![CDATA[
<!-- 最新书签 -->
<div class="border0">
	<div class="toptitle2"><img src="{$skinpath}images/icon_orange.gif" border="0" align="absMiddle"/>&nbsp;最新书签</div>
	<div class="msg">
		{$Page_NewLinkList}
	</div>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_37" title="Msg_WeekPostList">
<![CDATA[
<span class="list_left_a">
	{$num}.&nbsp;<a href="{$bokeurl}Userid_{$UserID}.showtopic.{$TopicID}.html" target="_blank" title="{$PostUser}发表于{$LastPostTime},共有{$Child}个评论">{$Title}</a>
</span>
]]>
</xsl:variable>
<xsl:variable name="String_38" title="Msg_NewLinkList">
<![CDATA[
<span class="list_left_a">
	{$num}.&nbsp;<a href="{$bokeurl}Userid_{$UserID}.showtopic.{$TopicID}.html" target="_blank" title="{$PostUser}添加于{$LastPostTime}">{$Title}</a>
</span>
]]>
</xsl:variable>
<xsl:variable name="String_39" title="SystemInfo">
<![CDATA[
	<div style="margin-left:20px;clear:both;">
		<li>今日信息：{$TodayNum}</li>
		<li>博客用户：{$UserNum}</li>
		<li>博客文章：{$TopicNum}</li>
		<li>博客收藏：{$FavNum}</li>
		<li>博客图片：{$PhotoNum}</li>
		<li>信息评论：{$PostNum}</li>
	</div>
]]>
</xsl:variable>
<xsl:variable name="String_40" title="UserInfo_Login">
<![CDATA[<BR/>
<div style="margin-left:8px;">
<FORM METHOD=POST ACTION="login.asp?action=chk">
论坛用户：<input tyep="text" name="username" size="12" /><BR/>
论坛密码：<input type="password" name="password" size="12" /><BR/>
{$GetCode}
登录保存：<select name="CookieDate"><option value="0" selected="selected">不保存</option><option value="1">保存一天</option><option value="2">保存一月</option><option value="3">保存一年</option></select><BR/><BR/>
<input type="hidden" value="bokeindex.asp" name="comeurl">
<input type="submit" name="submit" value="登录系统" />
</FORM>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_41" title="UserInfo_isLogin">
<![CDATA[
	<div style="margin-left:20px;clear:both;">
		<li>欢迎 <B>{$UserName}</B> 进入博客</li>
		<li>今日信息：{$TodayNum}</li>
		<li>个人文章：{$TopicNum}</li>
		<li>个人图片：{$PhotoNum}</li>
		<li>信息评论：{$PostNum}</li>
		<li>{$UserMsg}</li>
	</div>
]]>
</xsl:variable>
<xsl:variable name="String_42" title="UserInfo_GetCode">
<![CDATA[
验 证 码：{$Dv_GetCode}<!--<input type="text" name="codestr" size="4" /> <img src="DV_getcode.asp" alt="验证码" height="18px;" align="middle"/>--><BR/>
]]>
</xsl:variable>
<xsl:variable name="String_43" title="UserInfo_a">
<![CDATA[
<a href="{$bokeurl}{$bokename}.index.html">个人博客</a>&nbsp;&nbsp;<a href="bokemanage.asp">博客管理</a>
]]>
</xsl:variable>
<xsl:variable name="String_44" title="UserInfo_b">
<![CDATA[
<a href="bokeapply.asp" title="点击激活您的个人博客"><font color="blue">在本站激活您的个人博客</font></a>
]]>
</xsl:variable>
<xsl:variable name="String_45" title="msg3">
<![CDATA[
所有信息列表
]]>
</xsl:variable>
<xsl:variable name="String_46" title="msg3">
<![CDATA[
→&nbsp;{$showcat}
]]>
</xsl:variable>
</xsl:stylesheet>