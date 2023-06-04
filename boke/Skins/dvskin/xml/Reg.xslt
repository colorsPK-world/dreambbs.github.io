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
<xsl:variable name="String_0" title="reg">
<![CDATA[
<script language="javascript" src="Boke/Script/Dv_form.js" type="text/javascript"></script>
<script language="JavaScript">
<!--
function CheckForm(theForm){
	if (theForm.NickName.value.length=="") {
		alert("提示：\n\n用户笔名必需填写！");
		theForm.NickName.focus();
		return false;
	};
	if (theForm.BokeName.value.length=="") {
		alert("提示：\n\n博客名称必需填写！");
		theForm.BokeName.focus();
		return false;
	};
	if (theForm.BokePassWord.value.length=="") {
		alert("提示：\n\n博客密码必需填写！");
		theForm.BokePassWord.focus();
		return false;
	};
	if (theForm.BokeTitle.value.length=="") {
		alert("提示：\n\n博客标题必需填写！");
		theForm.BokeTitle.focus();
		return false;
	};

	if (theForm.BokeCTitle.value.length=="") {
		alert("提示：\n\n博客说明必需填写！");
		theForm.BokeCTitle.focus();
		return false;
	};
	if (theForm.codestr){
		if (theForm.codestr.value.length=="") {
			alert("提示：\n\n验证码必需填写！");
			theForm.codestr.focus();
			return false;
		};
	}

return (true);
}
//-->
</script>
<div id="pagemain">
<center>
<div class="td1" style="width:600px;">
<form method="post" action="?action=savereg" name="apply" onSubmit="return CheckForm(this);">
<div class="td2" style="height:25px;line-height:24px;">
&nbsp;<B>{$RegMsg}</B>
</div>
&nbsp;<B>说明</B>：<BR />&nbsp;① 用户笔名显示于您发表的博客文章中；<BR />&nbsp;② 博客标识建议简短好记，用于分配系统二级域名(需系统支持)或用户直接访问参数；<BR />&nbsp;③ 博客密码用于您博客的管理，建议和论坛密码不同。
<BR />
<hr class="post">
&nbsp;<B>快速申请</B>：
<div class="td0" style="margin-left:20px;">
<li>博客标识：<input type="text" name="BokeName" onkeyup="javascript:Dv_Form.CheckEnglish(this);"/> <input type="submit" value="立刻激活您的博客"></li>
<li>博客标识只能使用英文字母、数字及下划"_"填写。</li><li><U>快速注册中博客密码即为您的论坛密码，用户笔名即为您的论坛用户名。</U></li><li>建议您激活博客后使用 论坛密码 到个人博客管理中修改相应的个人配置。</li>
</div>
</form>
<form method="post" action="?action=savereg" name="apply" onSubmit="return CheckForm(this);">
<hr class="post">
&nbsp;<B>常规申请</B>：
<div class="td0" style="margin-left:20px;">
<li>用户笔名：<input type="text" name="NickName"/></li>
<li>博客标识：<input type="text" name="BokeName" onkeyup="javascript:Dv_Form.CheckEnglish(this);"/> * 只能使用英文字母、数字及下划"_"填写。</li>
<li>博客密码：<input type="password" name="BokePassWord"/></li>
<li>博客标题：<input type="text" name="BokeTitle" size="50" onkeyup="javascript:Dv_Form.CheckLength(this,150);"/></li>
<li>博客说明：<input type="text" name="BokeCTitle" size="50" onkeyup="javascript:Dv_Form.CheckLength(this,150);"/></li>
</div><BR/>
<center><input type="submit" value="申 请"/>&nbsp;&nbsp;<input type="reset" value="重 置"/></center>
</form>
</div>
</center>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_1" title="">
<![CDATA[
<li>
验&nbsp;&nbsp;证&nbsp;码：{$Dv_GetCode}<!--<input type="text" name="codestr" maxlength="4" size="4">&nbsp;<img src="DV_getcode.asp" height="12">-->
</li>
]]>
</xsl:variable>
<xsl:variable name="String_2" title="">
<![CDATA[

]]>
</xsl:variable>
<xsl:variable name="String_3" title="">
<![CDATA[

]]>
</xsl:variable>
<xsl:variable name="String_4" title="strings"><![CDATA[]]>
</xsl:variable>
<xsl:variable name="String_5" title="strings">
<![CDATA[
的博客
]]>
</xsl:variable>
<xsl:variable name="String_6" title="strings"><![CDATA[欢迎 <b>{$UserName}</b> 申请论坛博客！]]>
</xsl:variable>
<xsl:variable name="String_7" title="strings">
<![CDATA[
我很懒，什么也没留下
]]>
</xsl:variable>
</xsl:stylesheet>
