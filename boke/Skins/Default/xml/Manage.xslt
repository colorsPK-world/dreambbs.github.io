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
<xsl:variable name="String_0" title="login">
<![CDATA[
<script language="javascript" src="Boke/Script/Dv_form.js" type="text/javascript"></script>
<div id="pagemain">
<center>
<div class="td1" style="width:600px;height:140px">
<div class="td2" style="line-height:24px;height:25px;">&nbsp;<b>管理登录</b></div>
<form method="post" action="?Action=Login" name="apply">
<div style="width:40%;float:left;padding-left:10px;"><BR/>
{$UserMsg}
<BR />
请输入您的博客密码登录！
</div>
<div style="width:40%;float:left;border-left:1px #B3B3B3 dashed;padding-left:10px;"><BR/>
<ul>
<li>博客密码：<input type="password" name="PassWord"/></li>
<li>
验&nbsp;&nbsp;证&nbsp;码：{$Dv_GetCode}<!--<input type="text" name="codestr" maxlength="4" size="4">&nbsp;<img src="DV_getcode.asp">-->
</li>
</ul>
<BR/>
<input type="submit" value="登录个人博客管理"/>
<BR/><BR/>
</div>
<input type="hidden" value="{$ComeUrl}" name="f">
</form>
</div>
</center>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_1" title="strings"><![CDATA[欢迎 <b>{$UserName}</b> 登录用户博客管理！]]>
</xsl:variable>
<xsl:variable name="String_2" title="TopNav">
<![CDATA[
<LINK REL="stylesheet" type="text/css" href="Boke/Skins/Default/Css/UserManage.css"/>
<div id="navmenu">
<div id="nav_r">
<a href="BokeManage.asp">管理首页</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="{$bokeurl}{$bokename}.index.html">我的博客</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="BokeApply.asp?Action=Logout">退出管理</a>
</div>

<a href="?s=1&t=1">文章</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="?s=1&t=2">收藏</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="?s=1&t=3">链接</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="?s=1&t=4">交易</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="?s=1&t=5">相册</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="?s=2">评论</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="?s=3">文件</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="?s=4">模板</a>&nbsp;&nbsp;|&nbsp;&nbsp;
<a href="?s=5">个人配置</a>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_3" title="LeftMenu">
<![CDATA[
<div id="leftmenu" Style="text-align:left;">
<style>
#leftmenu ul{
	list-style-position : ;
	list-style-type : circle;
	margin:0 0 0 5px;
	padding:0 0 0 0px;
}
#leftmenu ul li{
	margin:0 0 0 25px;
}
</style>
<ul>
<B>快捷操作</B>
<li><a href="BokeManage.asp?s=1&t=1&m=1">发表文章</a></li>
<li><a href="BokeManage.asp?s=1&t=2&m=1">添加收藏</a></li>
<li><a href="BokeManage.asp?s=1&t=3&m=1">添加链接</a></li>
<li><a href="BokeManage.asp?s=1&t=4&m=1">发布交易</a></li>
<li><a href="BokeManage.asp?s=1&t=5&m=1">添加相册</a></li>
<li><a href="?s=5&t=3">博客设置</a></li>
<li><a href="?s=5&t=4">关键字设置</a></li>
<li><a href="?s=6&t=1">频道及博客索引更新</a></li>
<li><a href="?s=7&t=0">博客数据统计</a></li>
</ul>
</div>
]]>
</xsl:variable>

<xsl:variable name="String_4" title="Main">
<![CDATA[
<div id="main" style="text-align:left;">
<div style="margin-left:20px;">
欢迎进入您的博客管理，使用各项功能前请仔细阅读相关页面的说明，最后操作完成后记得退出管理，祝您使用愉快。
<BR />
<BR />
<B>使用小帖士</B>
<li>请随时关注您的个人博客，检查其中网友发表内容是否合法</li>
<li>文章、收藏、链接均可进行预设分类操作，添加信息时将相关的信息归入对应的分类中</li>
<li>预设部分常用的关键字及其链接，在显示的文章中碰到对应的关键字会自动为其添加超级链接</li>
<li>部分功能可关闭或不显示，如博客交易功能可关闭、栏目或文章可定义不显示等</li>
<BR />
<BR />
{$sysmessage}
</div>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_5" title="Main_UserInput">
<![CDATA[
<div id="main" style="text-align:left;">
{$UserAction}管理&nbsp;&nbsp;→&nbsp;&nbsp;<a href="{$UserAction_1}&m=1">添加{$UserAction}</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="{$UserAction_1}&m=2">{$UserAction}栏目管理</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="{$UserAction_1}&m=3">{$UserAction}信息管理</a>
<BR />
<BR />
{$UserInputInfo}
</div>
]]>
</xsl:variable>
<xsl:variable name="String_6" title="Main_UserSetting">
<![CDATA[
<div id="main" style="text-align:left;">
个人配置&nbsp;&nbsp;→&nbsp;&nbsp;<a href="?s=5&t=1">个人资料</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="?s=5&t=2">博客密码</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="?s=5&t=3">博客设置</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="?s=5&t=4">关键字设置</a>
<BR />
<BR />
{$UserSettingInfo}
</div>
]]>
</xsl:variable>
<xsl:variable name="String_7" title="Main_UserSetting_Info">
<![CDATA[
<div class="topic">
个人资料修改
</div>
<div style="margin-left:20px;">
<BR />
说明：更多详细资料修改请到 <a href="mymodify.asp" target="_blank">论坛用户资料修改</a>
<BR />
<BR />
<FORM METHOD=POST ACTION="?s=5&t=1&Action=Save">
<li>博客标识：
{$BokeName}</li>
<li>用户笔名：
<input type="text" name="NickName" value="{$NickName}"/></li>
<li>博客标题：
<input type="text" name="BokeTitle" value="{$BokeTitle}"/></li>
<li>博客说明：
<input type="text" name="BokeCTitle" value="{$BokeCTitle}"/>
* 不超过250字节</li>
<li>博客公告：<BR /><textarea name="BokeNote" cols="40" rows="5">{$BokeNote}</textarea></li><BR /><BR />
<input type="submit" name="submit" value="修改资料">
</FORM>
</div>
]]>
</xsl:variable>

<xsl:variable name="String_8" title="Main_UserSetting_PassWord">
<![CDATA[
<div class="topic">
博客密码修改
</div>
<div style="margin-left:20px;">
<BR />
说明：此处密码为您登陆个人博客管理所需密码
<BR />
<BR />
<FORM METHOD=POST ACTION="?s=5&t=2&Action=Save">
<li>博客密码：
<input type="password" name="PassWord"/></li>
<li>新的密码：
<input type="password" name="nPass"/></li>
<li>重复输入：
<input type="password" name="rnPass"/></li><BR /><BR />
<input type="submit" name="submit" value="修改密码">
</FORM>
</div>
]]>
</xsl:variable>

<xsl:variable name="String_9" title="Main_UserSetting_Setting">
<![CDATA[
<script language="javascript" src="Boke/Script/Dv_form.js" type="text/javascript"></script>
<div class="topic">博客站点设置</div>
<br/>
<form method=post action="?s=5&t=3&Action=Save" name="setting">
	<div id="mainlist">
	<div class="set0">
		<div class="Set1">博客站点分类：</div>
		<div class="Set2">
			<Select Name="SysCatID" Size="1">{$CatList}</Select>
		</div>
	</div>
	<div class="set0">
		<div class="Set1">是否允许他人访问：</div>
		<div class="Set2"><input type="radio" name="Setting0" value="0"/> 否 <input type="radio" name="Setting0" value="1"/> 是</div>
	</div>
<!-- 	<div class="set0">
		<div class="Set1">默认编辑器选择：</div>
		<div class="Set2"><input type="radio" name="Setting1" value="0"/> 编辑器1 <input type="radio" name="Setting1" value="1"/> 编辑器2</div>
	</div> -->
	<div class="set0">
		<div class="Set1">自动截取段落数：</div>
		<div class="Set2"><input type="text" size="5" name="Setting2" value="{$Setting2}"/> 字（当摘要内容为空时，自动按设置截取内容作为摘要）</div>
	</div>
	<div class="set0">
		<div class="Set1">显示最新评论数：</div>
		<div class="Set2"><input type="text" size="5" name="Setting3" value="{$Setting3}"/> 条</div>
	</div>
	<div class="set0">
		<div class="Set1">是否允许评论：</div>
		<div class="Set2"><input type="radio" name="Setting4" value="0"/> 否 <input type="radio" name="Setting4" value="1"/> 是</div>
	</div>
	<div class="set0">
		<div class="Set1">用户评论后返回页面：</div>
		<div class="Set2"><input type="radio" name="Setting5" value="0"> 博客系统首页 <input type="radio" name="Setting5" value="1"/> 用户博客首页 <input type="radio" name="Setting5" value="2"/> 评论主题</div>
	</div>
	<div class="set0">
		<div class="Set1">首页显示文章数：</div>
		<div class="Set2"><input type="text" size="5" name="Setting6" value="{$Setting6}"/> 条</div>
	</div>
	<div class="set0">
		<div class="Set1">列表每页显示文章数：</div>
		<div class="Set2"><input type="text" size="5" name="Setting7" value="{$Setting7}"/> 条</div>
	</div>
	<div class="set0">
		<div class="Set1">文章每页显示评论数：</div>
		<div class="Set2"><input type="text" size="5" name="Setting8" value="{$Setting8}"/> 条</div>
	</div>
	<div class="set0">
		<div class="Set1">字体默认大小：</div>
		<div class="Set2"><input type="text" size="5" name="Setting9" value="{$Setting9}"/> px</div>
	</div>
	<div class="set0">
		<div class="Set1">文字默认行间距：</div>
		<div class="Set2"><input type="text" size="5" name="Setting10" value="{$Setting10}"/> px</div>
	</div>
	<div class="set0">
		<div class="Set1">文章显示脚印个数：</div>
		<div class="Set2"><input type="text" size="5" name="Setting11" value="{$Setting11}"/> 个</div>
	</div>
	<div class="set0">
		<div class="Set1">脚印图片（男）：</div>
		<div class="Set2">
			<input type="text" size="20" name="Setting12" value="{$Setting12}" id="Setting12"/>
			<select onchange="Chang(this.value,'DiaryFootMart1','boke/images/sex/','Setting12')">
				<option value="">选取脚印图标
				<option value="sex1.gif" >sex1.gif</option>
				<option value="sex2.gif" >sex2.gif</option>
				<option value="footmark1.gif" >footmark1.gif</option>
				<option value="footmark3.gif" >footmark3.gif</option>
				<option value="footmark5.gif" >footmark5.gif</option>
			</select>
			&nbsp;<img id=DiaryFootMart1 src="{$Setting12}" border="0" alt="访客脚印图片">
		</div>
	</div>
	<div class="set0">
		<div class="Set1">脚印图片（女）：</div>
		<div class="Set2">
			<input type="text" size="20" name="Setting13" value="{$Setting13}" id="Setting13">
			<select onchange="Chang(this.value,'DiaryFootMart2','boke/images/sex/','Setting13')">
				<option value="">选取脚印图标
				<option value="sex3.gif" >sex3.gif</option>
				<option value="sex4.gif" >sex4.gif</option>
				<option value="footmark2.gif" >footmark2.gif</option>
				<option value="footmark4.gif" >footmark4.gif</option>
				<option value="footmark6.gif" >footmark6.gif</option>
			</select>
			&nbsp;<img id="DiaryFootMart2" src="{$Setting13}" border="0" alt="访客脚印图片">
		</div>
	</div>
	<div class="set0">
		<div class="Set1">博客交易功能：</div>
		<div class="Set2"><input type="radio" name="Setting14" value="0"/> 关闭 <input type="radio" name="Setting14" value="1"/> 开放</div>
	</div>
	<div class="set0">
		<div class="Set1">交易模块链接文字：</div>
		<div class="Set2"><input type="text" size="20" name="Setting15" value="{$Setting15}"/> * 如Dopod数码专卖</div>
	</div>
	<br />
	<br />
	<div class="set0">
		<div class="Set1"><input type="submit" name="submit" value="修改设置"/></div>
	</div>
</div>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--
	Dv_Form.Set_Radio('Setting0','{$Setting0}');
	Dv_Form.Set_Radio('Setting1','{$Setting1}');
	Dv_Form.Set_Radio('Setting4','{$Setting4}');
	Dv_Form.Set_Radio('Setting5','{$Setting5}');
	Dv_Form.Set_Radio('Setting14','{$Setting14}');
	function Chang(picurl,V,S,F)
	{
		var pic=S+picurl
		if (picurl!=''){
		document.getElementById(V).src=pic;
		setting[F].value=pic;
		}
	}
//-->
</SCRIPT>
]]>
</xsl:variable>
<xsl:variable name="String_10" title="Main_UserSetting_KeyWord">
<![CDATA[
<div class="topic">
博客关键字设置
</div>
<div style="margin-left:20px;">
<BR />
说明：您博客中发表的文章或评论含有您所设置的关键字则会自动进行替换和加上链接，新增的关键字对之前发表的文章无效，您可编辑某篇文章以便其支持您最新设置的关键字
<BR />
<BR />
<FORM METHOD=POST ACTION="?s=5&t=4&Action=Save">
<input type="hidden" value="{$KeyID}" name="KeyID"/>
<li>关 键 字：
<input type="text" name="KeyWord" value="{$KeyWord}"/></li>
<li>替换文本：
<input type="text" name="nKeyWord" value="{$nKeyWord}"/></li>
<li>链接地址：
<input type="text" name="LinkUrl" value="{$LinkUrl}"/>
<input type="checkbox" name="NewWindows" value="1" {$NewWindows}>
新窗口打开</li>
<li>链接标题：
<input type="text" name="LinkTitle" value="{$LinkTitle}"/>
<input type="submit" name="submit" value="提交关键字">
</li>
</FORM>
<div id="mainlist">
<hr>
<ul>
<li class="Set3"><B>关键字</B></li>
<li class="Set3"><B>替换文本</B></li>
<li class="Set4"><B>链接地址</B></li>
<li class="Set3"><B>管理操作</B></li>
</ul>

<hr>
{$KeyWordList}
</div>
</div>
<SCRIPT LANGUAGE="JavaScript">
<!--
	function alertreadme(str,url){
	{
		if(confirm(str)){
		location.href=url;
		return true;
		}return false;}
	}
//-->
</SCRIPT>
]]>
</xsl:variable>
<xsl:variable name="String_11" title="Main_UserInput_Topic">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_12" title="Main_UserInput_Cat">
<![CDATA[
<script language="javascript" src="Boke/Script/Dv_form.js" type="text/javascript"></script>
<div class="topic">
{$UserAction}栏目管理
</div>
<BR />
<div style="margin-left:20px;">
<FORM METHOD=POST ACTION="{$UserAction_1}&m=2&Action=Save">
<input type="hidden" value="{$uCatID}" name="uCatID"/>
<li>栏目类别：
<Select Name="sType" Size="1">
<Option value="0">文章</Option>
<Option value="1">收藏</Option>
<Option value="2">链接</Option>
<Option value="3">交易</Option>
<Option value="4">相册</Option>
</Select>
</li>
<li>栏目名称：
<input type="text" name="uCatTitle" value="{$uCatTitle}"/>
<input type="checkbox" name="IsView" value="1" {$IsView}>
是否开放</li>
<li>栏目说明：
<input type="text" name="uCatNote" value="{$uCatNote}"/>
<input type="submit" name="submit" value="提交栏目设置">
</li>
</FORM>
</div>
<div id="mainlist">
<hr>
<ul>
<li class="Set3"><B>栏目</B></li>
<li class="Set5"><B>说明</B></li>
<li class="Set3"><B>管理操作</B></li>
</ul>
<hr>
{$InfoList}
</div>
<SCRIPT LANGUAGE="JavaScript">
<!--
	Dv_Form.Set_Select('sType','{$uType}');
	function alertreadme(str,url){
	{
		if(confirm(str)){
		location.href=url;
		return true;
		}return false;}
	}
//-->
</SCRIPT>
]]>
</xsl:variable>
<xsl:variable name="String_13" title="Main_UserInput_mTopic">
<![CDATA[
<script language="JavaScript" src="boke/Script/Pagination.js"></script>
<script type="text/javascript" language="javascript">
function CheckAll(form)  {
  for (var i=0;i<form.elements.length;i++)    {
    var e = form.elements[i];
    if (e.name != 'chkall')       e.checked = form.chkall.checked; 
   }
  }
</script>
<div class="topic">
{$UserAction}管理
</div>
<BR />
<FORM METHOD=POST ACTION="?s=1&t={$t}&m=3">
关键字：<input type="text" size="15" name="KeyWord" value="{$KeyWord}">
<input type="submit" value="查询" name="submit">
</FORM>

<div class="list_top">
<div class="list1">
<B>选项</B>
</div>
<div class="list2">
<B>标题</B>
</div>
<div class="list3">
<B>类别</B>
</div>
<div class="list4">
<B>时间</B>
</div>
<div class="list3">
<B>操作</B>
</div>
</div>
<FORM METHOD=POST ACTION="?s=1&t={$t}&m=3&Action=Del">
{$InfoList}
<div class="list_body">
<hr class="post">
<div class="list1">
<input type="checkbox" name="chkall" value="on" onclick="CheckAll(this.form);"/>
</div>
<div class="list3" style="text-align:left;">
全选
</div>
<div class="list2" style="text-align:left;">
<input type="radio" value="0" name="iTopic" checked>
删除
<input type="radio" value="1" name="iTopic">
移动到
<Select Name="uCatID" Size="1">
<Option value="-1">请选择栏目</Option>
<Option value="0">未归类</Option>
{$uCatList}
</Select>
</div>
<div class="list3" style="text-align:left;">
<input type="submit" name="action" value="执行操作" onclick="if(confirm('确定执行选定的操作吗?')==false)return false;" />
</div>
</div>
</FORM>
<SCRIPT language="JavaScript">
PageList({$Page},3,{$MaxRows},{$CountNum},"{$PageSearch}",1);
</SCRIPT>
]]>
</xsl:variable>

<xsl:variable name="String_14" title="Main_Other">
<![CDATA[
]]>
</xsl:variable>

<xsl:variable name="String_15" title="Main_Other">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_16" title="Main_Other">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_17" title="Main_Other">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_18" title="Main_SkinSetting">
<![CDATA[
<script language="javascript" src="Boke/Script/Dv_form.js" type="text/javascript"></script>
<script language="JavaScript" src="boke/Script/Pagination.js"></script>
<div id="main" style="text-align:left;">
<form method="post" action="?s=4&action=Saveskin" name="Skinsform">
<table border="0" cellpadding="3" cellspacing="0" align="center" Style="width:98%">
<tr><td><input type="submit" value="提交保存"></td></tr>
</table>
<hr/>
<table border="0" cellpadding="3" cellspacing="0" align="center" Style="width:98%">
<tr>
{$skin_list}
</tr>
</table>
</form>
<SCRIPT language="JavaScript">
PageList({$Page},3,{$MaxRows},{$CountNum},"{$PageSearch}",1);
Dv_Form.Set_Radio("Skinid","{$S_id}");
</SCRIPT>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_19" title="Main_SkinSetting_list1">
<![CDATA[
<td align="center" width="25%">
<img src="{$ViewLogo}" alt="" border="0px" width="80px" height="60px"/><br/>
{$S_Name}
<input type="radio" name="Skinid" value="{$S_id}"/>
</td>
]]>
</xsl:variable>
<xsl:variable name="String_20" title="Main_SkinSetting_list2">
<![CDATA[
</tr><tr>
]]>
</xsl:variable>
<xsl:variable name="String_21" title="Main_UserInput_mTopic_list2">
<![CDATA[
<div class="list_body">
<div class="list1">
<input type="checkbox" name="TopicID" value="{$EditID}"/>
</div>
<div class="list2" style="text-align:left;">
<a href="{$bokeurl}{$bokename}.showtopic.{$topicid}.html" target="_blank">{$Topic}</a>
</div>
<div class="list3">
{$cat}
</div>
<div class="list4" style="text-align:left;">
{$DateTime}
</div>
<div class="list3">
<a href="Bokepostings.asp?user={$bokename}&action=edit&rootid={$topicid}&postid={$postid}">编辑</a> | <a href="?s=1&t={$t}&m=3&Action=Del&TopicID={$topicid}&iTopic=0">删除</a>
</div>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_22" title="Main_UserInput_mPost">
<![CDATA[
<script language="JavaScript" src="boke/Script/Pagination.js"></script>
<script type="text/javascript" language="javascript">
function CheckAll(form)  {
  for (var i=0;i<form.elements.length;i++)    {
    var e = form.elements[i];
    if (e.name != 'chkall')       e.checked = form.chkall.checked; 
   }
  }
</script>
<div id="main" style="text-align:left;">
<div class="topic">
评论管理
</div>
<BR />
<FORM METHOD=POST ACTION="?s=2">
关键字：<input type="text" size="15" name="KeyWord" value="{$KeyWord}">
<input type="submit" value="查询" name="submit">
</FORM>

<div class="list_top">
<div class="list1">
<B>选项</B>
</div>
<div class="list2">
<B>内容</B>
</div>
<div class="list3">
<B>作者</B>
</div>
<div class="list4">
<B>时间</B>
</div>
<div class="list3">
<B>操作</B>
</div>
</div>
<FORM METHOD=POST ACTION="?s=2&Action=Del">
{$InfoList}
<div class="list_body">
<hr class="post">
<div class="list1">
<input type="checkbox" name="chkall" value="on" onclick="CheckAll(this.form);"/>
</div>
<div class="list3" style="text-align:left;">
全选
</div>
<div class="list2" style="text-align:left;">
<input type="radio" value="0" name="iTopic" checked>
删除
</div>
<div class="list3" style="text-align:left;">
<input type="submit" name="action" value="执行操作" onclick="if(confirm('确定执行选定的操作吗?')==false)return false;" />
</div>
</div>
</FORM>
<SCRIPT language="JavaScript">
PageList({$Page},3,{$MaxRows},{$CountNum},"{$PageSearch}",1);
</SCRIPT>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_23" title="Main_UserInput_mPost_list2">
<![CDATA[
<div class="list_body">
<div class="list1">
<input type="checkbox" name="TopicID" value="{$EditID}"/>
</div>
<div class="list2" style="text-align:left;">
<a href="{$bokeurl}{$bokename}.showtopic.{$topicid}.{$postid}.html" target="_blank">{$Topic}</a>
</div>
<div class="list3">
{$cat}
</div>
<div class="list4" style="text-align:left;">
{$DateTime}
</div>
<div class="list3">
<a href="Bokepostings.asp?user={$bokename}&action=edit&rootid={$topicid}&postid={$postid}">编辑</a> | <a href="?s=2&Action=Del&TopicID={$postid}&iTopic=0">删除</a>
</div>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_24" title="Main_UserFile">
<![CDATA[
<script language="JavaScript" src="boke/Script/Pagination.js"></script>
<div id="main" style="text-align:left;">
文件管理&nbsp;&nbsp;→&nbsp;&nbsp;<a href="?s=3&m=1">所有文件</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="?s=3&m=2">图片</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="?s=3&m=3">压缩</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="?s=3&m=4">文档</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="?s=3&m=5">媒体</a>
<BR />
<BR />
<div class="topic">
{$ActionInfo}文件管理
</div>
<BR />
<FORM METHOD=POST ACTION="?s=3">
关键字：<input type="text" size="15" name="KeyWord" value="{$KeyWord}">
<input type="submit" value="查询" name="submit">
</FORM>
<hr class="post">
<FORM METHOD=POST ACTION="?s=3&Action=Del">
{$topiclist}
</FORM>
<SCRIPT language="JavaScript">
function CheckAll(form)  {
  for (var i=0;i<form.elements.length;i++)    {
    var e = form.elements[i];
    if (e.name != 'chkall')       e.checked = form.chkall.checked; 
   }
  }
</SCRIPT>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_25" title="cat_photo">
<![CDATA[
<table border="0" cellpadding="3" cellspacing="0" align="center" Style="width:98%">
<tr>
{$photo_list}
</tr>
</table>
<div class="list_body">
<hr class="post">
<div class="list1">
<input type="checkbox" name="chkall" value="on" onclick="CheckAll(this.form);"/>
</div>
<div class="list3" style="text-align:left;">
全选
</div>
<div class="list2" style="text-align:left;">
<input type="radio" value="0" name="iTopic" checked>
删除
</div>
<div class="list3" style="text-align:left;">
<input type="submit" name="action" value="执行操作" onclick="if(confirm('确定执行选定的操作吗?')==false)return false;" />
</div>
</div>
<SCRIPT LANGUAGE="JavaScript">
<!--
PageList({$Page},3,{$MaxRows},{$CountNum},"{$PageSearch}",1);
//-->
</SCRIPT>
]]>
</xsl:variable>

<xsl:variable name="String_26" title="cat_photo">
<![CDATA[
<td align="center" width="25%">
<div class="photo1">
<a href="{$ViewPhoto}" target="_blank"><img src="{$ViewPhoto}" alt="点击查看或下载文件" Style="border:1px solid #C0C0C0" width="{$width}px" height="{$height}px"/></a>
<div class="photo2">
《 {$topic} 》
<br/><input type="checkbox" name="fileid" value="{$fileid}">
{$PostDate} -- <a href="?s=3&Action=Del&fileid={$fileid}&iTopic=0">删除</a>
</div>
</div>
</td>
]]>
</xsl:variable>
<xsl:variable name="String_27" title="cat_photo">
<![CDATA[
</tr><tr>
]]>
</xsl:variable>
<xsl:variable name="String_28" title="sys_count">
<![CDATA[
<div id="main" style="text-align:left;">
<div class="topic">博客站点数据统计和更新</div>
<br/>
	<fieldset title="提示">
	<legend>&nbsp;提示&nbsp;</legend>
	以下操作不需要经常执行！
	</fieldset>
<br/>
<table border="0" width="98%" align="center" cellpadding="4" cellspacing="2" class="table3">
<tr><td width="10%" class="td1"><input type="button" name="act" value="博客个人笔名更新" onclick="location.href='?s=7&t=1'"/></td><td align="left" width="90%" class="td2">将发表过的信息更新为当前使用的笔名。</td></tr>
<tr><td class="td1"><input type="button" name="act" value="更新分栏文章数据" onclick="location.href='?s=7&t=2'"/></td><td class="td2">重新统计分栏的文章数。</td></tr>
<tr><td class="td1"><input type="button" name="act" value="更新博客总数据" onclick="location.href='?s=7&t=3'"/></td><td class="td2">更新个人博客总统计数据</td></tr>
</table>
</div>
]]>
</xsl:variable>
</xsl:stylesheet>