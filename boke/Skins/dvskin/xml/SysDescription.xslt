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
<xsl:variable name="String_0" title="">
<![CDATA[
{$refresh}
<div id="pagemain">
<center>
<BR/>
<div class="td1" style="width:500px;">
	<div class="td2" style="height:25px;line-height:24px;">
		&nbsp;<b>提示信息：</b>
	</div>
	<div class="td0" style="margin-left:20px;">
		{$description}
		<br/>
	</div>
	{$refreshinfro}
	<hr class="post" align="center">
	<div align="center">
		<a href="javascript:history.go(-1)">返回上一页</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#" onclick="window.close()">关闭窗口</a>
	</div>
</div>
<BR/>
</center>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_1" title=""><![CDATA[<li>{$msg}</li>]]></xsl:variable>
<xsl:variable name="String_2" title=""><![CDATA[请不要外部提交数据。]]></xsl:variable>
<xsl:variable name="String_3" title=""><![CDATA[请不要重复提交数据。]]></xsl:variable>
<xsl:variable name="String_4" title=""><![CDATA[你查看的数据不存在或参数错误！]]></xsl:variable>
<xsl:variable name="String_5" title=""><![CDATA[该用户不存在或填写的资料有误!]]></xsl:variable>
<xsl:variable name="String_6" title=""><![CDATA[您的用户名已经被注册，请重新填写!]]></xsl:variable>
<xsl:variable name="String_7" title=""><![CDATA[验证码校验失败，请返回刷新页面后再输入验证码。]]></xsl:variable>
<xsl:variable name="String_8" title=""><![CDATA[用户名不能为空或多于50个字符。]]></xsl:variable>
<xsl:variable name="String_9" title=""><![CDATA[提交的数据不合法。]]></xsl:variable>
<xsl:variable name="String_10" title=""><![CDATA[博客名称只能用英文字母和数字、下划线填写！]]></xsl:variable>
<xsl:variable name="String_11" title=""><![CDATA[填写的帐号密码不能为空！]]></xsl:variable>
<xsl:variable name="String_12" title=""><![CDATA[博客标题和说明不能为空或多于150个字符。]]></xsl:variable>
<xsl:variable name="String_13" title=""><![CDATA[您的博客已经存在或博客标识已被使用！]]></xsl:variable>
<xsl:variable name="String_14" title=""><![CDATA[您还没有 <a href="bokeapply.asp">申请个人博客</a> 或 <a href="login.asp">尚未登录论坛</a>]]></xsl:variable>
<xsl:variable name="String_15" title=""><![CDATA[您输入的博客密码错误，请重新输入。]]></xsl:variable>
<xsl:variable name="String_16" title=""><![CDATA[您成功修改了个人资料。]]></xsl:variable>
<xsl:variable name="String_17" title=""><![CDATA[您输入的新博客密码和重复输入的新密码不一致，请重新输入。]]></xsl:variable>
<xsl:variable name="String_18" title=""><![CDATA[您成功修改了博客密码。]]></xsl:variable>
<xsl:variable name="String_19" title=""><![CDATA[您成功修改了个人博客配置。]]></xsl:variable>
<xsl:variable name="String_20" title=""><![CDATA[关键字和替换文本必须填写。]]></xsl:variable>
<xsl:variable name="String_21" title=""><![CDATA[博客关键字设置成功。]]></xsl:variable>
<xsl:variable name="String_22" title=""><![CDATA[同一关键字不能设置多次。]]></xsl:variable>
<xsl:variable name="String_23" title=""><![CDATA[博客关键字删除成功。]]></xsl:variable>
<xsl:variable name="String_24" title=""><![CDATA[博客栏目设置成功。]]></xsl:variable>
<xsl:variable name="String_25" title=""><![CDATA[请输入博客栏目名称。]]></xsl:variable>
<xsl:variable name="String_26" title=""><![CDATA[博客栏目删除成功。]]></xsl:variable>
<xsl:variable name="String_27" title=""><![CDATA[频道及首页数据索引更新成功。]]></xsl:variable>
<xsl:variable name="String_28" title=""><![CDATA[暂时没有可供选取的模版。]]></xsl:variable>
<xsl:variable name="String_29" title=""><![CDATA[风格模版更改成功。]]></xsl:variable>
<xsl:variable name="String_30" title=""><![CDATA[标题不能为空或多于250个字符。]]></xsl:variable>
<xsl:variable name="String_31" title=""><![CDATA[搜索关键字不能多于250个字符。]]></xsl:variable>
<xsl:variable name="String_32" title=""><![CDATA[请选取所属类别。]]></xsl:variable>
<xsl:variable name="String_33" title=""><![CDATA[请选取所属话题。]]></xsl:variable>
<xsl:variable name="String_34" title=""><![CDATA[请选取所属的栏目，若该分类的栏目未创建请先创建栏目再进行发表操作。]]></xsl:variable>
<xsl:variable name="String_35" title=""><![CDATA[请填写正文内容。]]></xsl:variable>
<xsl:variable name="String_36" title=""><![CDATA[查找的信息不存在或没有进行该管理操作权限。]]></xsl:variable>
<xsl:variable name="String_37" title=""><![CDATA[发表成功！]]></xsl:variable>
<xsl:variable name="String_38" title=""><![CDATA[您没有权限进行回复或编辑操作。]]></xsl:variable>
<xsl:variable name="String_39" title=""><![CDATA[用户名不能为空或含有非法字符。]]></xsl:variable>
<xsl:variable name="String_40" title=""><![CDATA[所填写的用户名已经存在，请修改用户名或登陆后再进行参与评论。]]></xsl:variable>
<xsl:variable name="String_41" title=""><![CDATA[当前博客已停止注册!]]></xsl:variable>
<xsl:variable name="String_42" title=""><![CDATA[
<div class="td3">3秒后自动返回{$refreshname}...</div>
]]></xsl:variable>
<xsl:variable name="String_43" title=""><![CDATA[抱歉，您没有权限访问!]]></xsl:variable>
<xsl:variable name="String_44" title=""><![CDATA[您已在本系统注册了个人博客帐号，<a href="boke.asp">点此进入您的博客</a>，如需要开设多个博客请重新注册论坛用户。]]></xsl:variable>
<xsl:variable name="String_45" title=""><![CDATA[请在论坛 <a href="reg.asp" alt="论坛注册">注册</a> 或 <a href="login.asp" alt="论坛登录">登录</a> 后再继续申请用户博客！]]></xsl:variable>
<xsl:variable name="String_46" title=""><![CDATA[该博客用户不存在或填写的资料有误！您可以 <a href="bokeapply.asp">申请博客</a> 或 <a href="login.asp">登录论坛</a>]]></xsl:variable>
<xsl:variable name="String_47" title=""><![CDATA[恭喜您，您的个人博客已成功开通，<a href="boke.asp">点此进入您的个人博客页面</a>]]></xsl:variable>
<xsl:variable name="String_48" title=""><![CDATA[本栏目尚未添加信息]]></xsl:variable>
<xsl:variable name="String_49" title=""><![CDATA[您选择的栏目并不存在]]></xsl:variable>
<xsl:variable name="String_50" title=""><![CDATA[博客信息 删除或移动 成功]]></xsl:variable>
<xsl:variable name="String_51" title=""><![CDATA[博客文件删除成功]]></xsl:variable>
<xsl:variable name="String_52" title=""><![CDATA[当前博客已被关闭。]]></xsl:variable>
<xsl:variable name="String_53" title=""><![CDATA[当前博客已经暂停关闭。]]></xsl:variable>
<xsl:variable name="String_54" title=""><![CDATA[请先 <a href="?s=1&t={$t}&m=2">添加本频道分类</a> 后再进行信息发布操作。]]></xsl:variable>
</xsl:stylesheet>
