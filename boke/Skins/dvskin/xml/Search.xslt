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
<xsl:variable name="String_0" title="Search_Nav">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_1" title="Search_Body">
<![CDATA[
<script language="JavaScript" src="boke/Script/Dv_form.js"></script>
<script language="JavaScript" src="boke/Script/Pagination.js"></script>
<script language="JavaScript" src="boke/Script/form_calendar.js"></script>
<div class="channel_nav">
<a href="boke.asp?{$BokeName}.index.html" alt="返回{$BokeUser}首页">{$BokeUser}主页</a> >> 搜索
</div>

<div class="border1">
<div class="bokeseartools">
<form method="post" action="bokesearch.asp" name="search_form">
<input type="hidden" name="User" value="{$BokeName}">
<input type="text" name="keyword" value="{$KeyWord}" size="25"/>
<input type="radio" name="sel" value="0" checked="true">标题
<input type="radio" name="sel" value="2">内容
<input type="radio" name="sel" value="1">作者
<select name="stype">
	<option value="-1">分类</option>
	<option value="0" selected="true">文章 </option>
	<option value="1">收藏</option>
	<option value="2">书签</option>
	<option value="3">交易</option>
	<option value="4">相册</option>
</select>
<br/>
<select name="DY" onChange="populate(this,this.form.DM,this.form.DD,0);">
<option value="0">选取</option>
</select>年
<select name="DM" onChange="populate(this.form.DY,this,this.form.DD,0);">
<option value="0">选取</option>
</select>月
<select name="DD">
<option value="0">选取</option>
</select>日
<input type="submit" value="查询"/>
</form>
</div>
</div>
<br/>
<hr class="post"/>
{$searchlist}
<SCRIPT language="JavaScript">
getYears(search_form.DY,search_form.DM,search_form.DD);
Dv_Form.Set_Select(search_form.DY,{$DYear});
Dv_Form.Set_Select(search_form.DM,{$DMonth});
Dv_Form.Set_Select(search_form.DD,{$DDay});
Dv_Form.Set_Select(search_form.stype,{$Stype});
Dv_Form.Set_Radio(search_form.sel,{$SelType});
PageList({$Page},3,{$MaxRows},{$CountNum},"{$PageSearch}",1);
</SCRIPT>
]]>
</xsl:variable>
<xsl:variable name="String_2" title="Search_Loop">
<![CDATA[
<div id="bokesearch">
	<div class="title">{$Num} .<a href="boke.asp?{$BokeName}.showtopic.{$TopicID}.html" target="_blank">{$Title}</a></div>
	<div class="info">分类:<a href="boke.asp?{$BokeName}.showchannel.{$SID}.html" target="_blank">{$StypeName}</a> -- 栏目:<a href="boke.asp?{$BokeName}.showchannel.{$SID}.{$CID}.html" target="_blank">{$CatName}</a> -- 作者:<a href="dispuser.asp?id={$UserID}" target="_blank" alt="查看个人资料">{$UserName}</a> -- 发表时间:<font color="gray">{$PostTime}</font>
	</div>
</div>
<hr class="post"/>
]]>
</xsl:variable>
</xsl:stylesheet>