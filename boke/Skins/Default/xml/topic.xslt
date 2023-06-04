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
<xsl:variable name="String_0" title="topic">
<![CDATA[
<script language="javascript" src="Boke/Script/Dv_form.js" type="text/javascript"></script>
<script type="text/javascript" src="boke/Edit_Plus/FCKeditor/fckeditor.js"></script>
<script language="JavaScript" src="boke/Script/Pagination.js"></script>
<center>
{$nav}
<div class="posthead">
<div class="topic_r">
	<a href="{$bokeurl}{$bokename}.showchannel.{$cat_tid}.{$cat_id}.html">{$catname}</a> | 评论({$child}) | 阅读({$hits})
</div>
<img src="{$Skins_Path}images/plus.gif" border="0" onclick="ShowList(this,'VisitList','{$Skins_Path}images/plus.gif','{$Skins_Path}images/nofollow.gif');" class="ImgOnclick" alt="查看详细访友列表"/>{$Vsisitstr}
<div id="VisitList" style="display:none;">
{$VisitList}
</div>
</div>
<br/>
<div class="topic">
	<div class="topic_r">
	{$WeekName} &nbsp;&nbsp;<img src="boke/images/weather/{$Weather_B}" alt="{$Weather_A}" align="absmiddle">&nbsp;
	</div>
<div><img src="{$Skins_Path}images/topic.gif" border="0" alt="主题">&nbsp;{$title}</div>
</div>
{$DispList}
{$replyform}
</center>
]]>
</xsl:variable>
<xsl:variable name="String_1" title="pagesearch">
<![CDATA[
<SCRIPT language="JavaScript">
PageList({$Page},3,{$MaxRows},{$CountNum},"{$PageSearch}",5);
</SCRIPT>
]]>
</xsl:variable>
<xsl:variable name="String_2" title="displist_1">
<![CDATA[
<a name="{$PostID}"></a>
<div class="postbody">
{$ReTitle}
<br/>
<span id="ShowBody" style="font-size:{$fontsize}px;line-height: {$lineheight}px;">
{$Content}
</span>
</div>
<div class="postend">
<a href="dispuser.asp?id={$UserID}" target="_blank" alt="查看个人资料">{$PostUserName}</a> 发表于：{$PostDate}
{$Edit}{$Manage}{$Delete}
</div>
<hr class="post"/>
]]>
</xsl:variable>
<xsl:variable name="String_3" title="Edit">
<![CDATA[
[<a href="Bokepostings.asp?user={$bokename}&action=edit&rootid={$RootID}&postid={$PostID}" alt="编辑">编辑</a>]
]]>
</xsl:variable>
<xsl:variable name="String_4" title="Manage">
<![CDATA[
[<a href="Bokepostings.asp?user={$bokename}&action=isbest&rootid={$RootID}&postid={$PostID}" alt="精华操作">精华</a>]
]]>
</xsl:variable>
<xsl:variable name="String_5" title="delete">
<![CDATA[
[<a href="Bokepostings.asp?user={$bokename}&action=delete&rootid={$RootID}&postid={$PostID}" alt="删除">删除</a>]
[<a href="Bokepostings.asp?user={$bokename}&action=reply&rootid={$RootID}&postid={$PostID}" alt="回复">回复</a>]
]]>
</xsl:variable>
<xsl:variable name="String_6" title="visit_str">
<![CDATA[
暂没有访客留下脚印！
]]>
</xsl:variable>
<xsl:variable name="String_7" title="visit_str">
<![CDATA[
留下您的访问印记 <a href="Bokepostings.asp?user={$bokename}&action=visit&rootid={$RootID}" title="踩一脚，在此处留下我的访问印记"><img src="{$VisitPic}" border="0"/></a>
]]>
</xsl:variable>
<xsl:variable name="String_8" title="visit_str">
<![CDATA[
访友脚印
]]>
</xsl:variable>
<xsl:variable name="String_9" title="fastreply">
<![CDATA[
<hr class="post"/>
<script language="JavaScript">
<!--
window.onload = function()
{
	var oFCKeditor = new FCKeditor( 'PostContent','100%','200px','Basic' ) ;
	oFCKeditor.BasePath	= "boke/Edit_Plus/FCKeditor/" ;
	oFCKeditor.Config['SkinPath'] = "skins/office2003/"
	oFCKeditor.ReplaceTextarea() ;
}
//-->
</script>
<center>
<div class="reply">
<table border="0" width="100%" align="center" cellpadding="4" cellspacing="2" class="table1">
<FORM METHOD="POST" ACTION="Bokepostings.asp?user={$bokename}&action=save_reply">
	<tr>
		<td height="20" colspan="2" class="reply_t1">评论/回复:</td>
	</tr>
	<tr>
		<td width="20%" class="reply_t2">用户名：</td>
		<td width="80%" class="reply_t3"><input type="text" name="PostUserName" value="{$PostUserName}" /></td>
	</tr>
	{$getcode}
	<tr>
		<td class="reply_t2">标题：</td>
		<td class="reply_t3">
		<input type="text" name="Title" size="50" onkeyup="javascript:Dv_Form.CheckLength(this,250);" value=""/>
		{$isalipay}
		</td>
	</tr>
	<tr>
		<td  class="reply_t2">内容：</td>
		<td  class="reply_t3">
		<textarea rows="4" name="PostContent" id="PostContent"></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="reply_t1" align="center" height="25px">
		<input type="hidden" name="RootID" value="{$RootID}"/>
		<input type="hidden" name="PostID" value="0"/>
		<input type="submit" value="提交信息"/>
		</td>
	</tr>
</FORM>
</table>
</div>
</center>
]]>
</xsl:variable>

<xsl:variable name="String_10" title="edit">
<![CDATA[
<hr class="post"/>
<script language="javascript" src="Boke/Script/Dv_form.js" type="text/javascript"></script>
<script language="javascript" src="Boke/Script/Sel_calendar.js" type="text/javascript"></script>
<script type="text/javascript" src="boke/Edit_Plus/FCKeditor/fckeditor.js"></script>
<center>
<div class="reply">
<table border="0" width="100%" align="center" cellpadding="4" cellspacing="2" class="table1">
<FORM METHOD="POST" ACTION="{$action}" name="PostForm" onSubmit="return CheckPostForm(this);">
	<tr>
		<td height="20" colspan="2" class="reply_t1">发表/评论/回复:</td>
	</tr>
	<tr>
		<td width="20%" class="reply_t2">用户名：</td>
		<td width="80%" class="reply_t3"><input type="text" name="PostUserName" value="{$PostUserName}"/>
		{$isalipay}</td>
	</tr>
	{$getcode}
	<tr>
		<td class="reply_t2">标题：</td>
		<td class="reply_t3">
		<input type="text" name="Title" size="50" onkeyup="javascript:Dv_Form.CheckLength(this,250);" value="{$Title}"/>
		日期：<INPUT TYPE="text" NAME="DDateTime" value="{$PostData}" onfocus="show_cele_date(DDateTime,'','',DDateTime)"/>
		</td>
	</tr>
	{$TopicFunction1}
	{$Show_Payto}
	{$Show_Upload}
	{$Show_PostContent}
	{$TopicFunction2}
	{$TopicFunction3}
	<tr>
		<td colspan="2" class="reply_t1" align="center" height="25px">
		<input type="hidden" name="RootID" value="{$RootID}"/>
		<input type="hidden" name="PostID" value="{$PostID}"/>
		<input type="submit" name="submit" value="提交信息"/>
		</td>
	</tr>
</FORM>
</table>
</div>
</center>
<br/>
<script language="JavaScript">
<!--
function Chang(picurl,V,S)
	{
		picurl=picurl.split("|");
		picurl=picurl[0];
		var pic=S+picurl
		if (picurl!=''){
		document.getElementById(V).src=pic;
		}
	}
//-->
</script>
]]>
</xsl:variable>

<xsl:variable name="String_11" title="edit_AboutTopic1">
<![CDATA[
	<tr>
		<td class="reply_t2">选取分类：</td>
		<td class="reply_t3">
		<Select Name="sType" Size="1" onchange="OchangeSel_Cat('Catid',this.value);">
		<Option value="-1">选择类别</Option>
		<Option value="0">文章</Option>
		<Option value="1">收藏</Option>
		<Option value="2">链接</Option>
		<Option value="3">交易</Option>
		<Option value="4">相册</Option>
		</Select>
		<Select Name="sCatID" Size="1">
		<Option value="-1">选择话题</Option>
		{$sCatList}
		</Select>
		<Select Name="Catid" ID="Catid" Size="1">
		<Option value="-1">所属栏目</Option>
		</Select>
		</td>
	</tr>
]]>
</xsl:variable>
<xsl:variable name="String_12" title="edit_AboutTopic2">
<![CDATA[
{$TitleNote}
<SCRIPT language="JavaScript">
	Dv_Form.Set_Select("sType","{$stype}");
	Dv_Form.Set_Select("Lock","{$Lock}");
	Dv_Form.Set_Select("Best","{$Best}");
	Dv_Form.Weather_Select("Weather","{$Weather}","WeatherSrc","boke/images/weather/");

	OchangeSel_Cat("Catid","{$stype}","{$Cat_Val}");
</SCRIPT>
]]>
</xsl:variable>
<xsl:variable name="String_13" title="edit_Aboutupload">
<![CDATA[
	<tr>
		<td class="reply_t2">文件上传：<input type="hidden" name="upfilerename" value=""/></td>
		<td class="reply_t3">
		<iframe name="UPLOADFRAME" frameborder="0" width="100%" height="24" scrolling="no" src="BokeUpload.asp?mode=UploadForm"></iframe></td>
	</tr>
]]>
</xsl:variable>
<xsl:variable name="String_14" title="edit_Aboutupload">
<![CDATA[
<div class="visituser">{$VisitName}<br/><img src="{$VisitPic}" border="0" alt="来源IP：{$VisitIP};访问时间：{$VisitTime}"/></div>
]]>
</xsl:variable>
<xsl:variable name="String_15" title="edit_link">
<![CDATA[
	<tr>
		<td class="reply_t2">链接地址：</td>
		<td class="reply_t3"><input type="text" name="PostContent" value="{$Content}" size="60"/></td>
	</tr>
]]>
</xsl:variable>
<xsl:variable name="String_16" title="edit_body">
<![CDATA[
	<tr>
		<td class="reply_t2">内容：</td>
		<td class="reply_t3">
		<textarea rows="4" name="PostContent" id="PostContent">{$Content}</textarea>		
		UBB标签：<a href="javascript:onclick=PlayUbb('PostContent','FLASH');" alt="添加 FLASH 动画">[FLASH]</a>
		<a href="javascript:onclick=PlayUbb('PostContent','RM');" alt="添加 RM 媒体文件">[RM]</a>
		<a href="javascript:onclick=PlayUbb('PostContent','MP');" alt="添加 MEDIA PLAYER 媒体文件">[MP]</a>
		<a href="javascript:onclick=PlayUbb('PostContent','QT');" alt="">[QT]</a>
		<a href="javascript:onclick=put_ubb('PostContent','CODE');" alt="源程序标记">[CODE]</a>
		</td>
	</tr>
<script language="JavaScript">
<!--
	window.onload = function()
{
	var oFCKeditor = new FCKeditor( 'PostContent','100%','350px','{$Editmode}' ) ;
	oFCKeditor.BasePath	= "boke/Edit_Plus/FCKeditor/" ;
	oFCKeditor.Config['SkinPath'] = "skins/office2003/"
	oFCKeditor.ReplaceTextarea() ;
}
//-->
</script>

]]>
</xsl:variable>
<xsl:variable name="String_17" title="edit_titlenote">
<![CDATA[
	<tr>
		<td  class="reply_t2">输入摘要：</td>
		<td  class="reply_t3">[<a href="javascript:onclick=GetNode('PostContent','PostTitleNote',{$maxlen});" alt="从正文提取摘要">提取摘要</a>]<br/>
		<textarea style="width:95%;height:50px;" name="PostTitleNote" id="PostTitleNote">{$PostTitleNote}</textarea>
		</td>
	</tr>
]]>
</xsl:variable>
<xsl:variable name="String_18" title="edit_titlenote">
<![CDATA[
	<tr>
		<td  class="reply_t2">链接图片：</td>
		<td  class="reply_t3">
		<input type="text" name="PostTitleNote" value="{$PostTitleNote}" size="60" onkeyup="javascript:Dv_Form.CheckLength(this,250);"/>
		</td>
	</tr>
]]>
</xsl:variable>

<xsl:variable name="String_19" title="displist_2">
<![CDATA[
<div class="retopic"><img src="{$Skins_Path}images/reply.gif" border="0" alt="评论">&nbsp;{$RTitle}</div>
]]>
</xsl:variable>
<xsl:variable name="String_20" title="edit_other">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_21" title="edit_other">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_22" title="edit_other">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_23" title="edit_other">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_24" title="edit_other">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_25" title="edit_other">
<![CDATA[
]]>
</xsl:variable>
<xsl:variable name="String_26" title="edit_upload">
<![CDATA[
<BODY oncontextmenu="return false;" onselectstart="return false;">
<script>
var upset = {$upset};
if (top.location==self.location){
	top.location="boke.asp"
}
function uploadframe(num)
{
	var obj=parent.document.getElementById("UPLOADFRAME");
	if (obj){
	if (parseInt(obj.height)+num>=24) {
		obj.height = parseInt(obj.height) + num;
		document.getElementById("Setupload").style.display="";
		document.getElementById("allupload").style.display="none";
	}
	}
}
function setid()
{
	str='';
	if(!window.form.upcount.value)
	window.form.upcount.value=1;
	if(window.form.upcount.value>upset){
	alert("您最多只能同时上传"+upset+"个文件!");
	window.form.upcount.value = upset;
	setid();
	}
	else{
	for(i=1;i<=window.form.upcount.value;i++)
	str+='文件'+i+':<input type="file" name="file'+i+'" style="width:200px"/><br/>';
	window.upid.innerHTML=str+'<br/>';
	var num=i*16
	var obj=parent.document.getElementById("UPLOADFRAME");
	if (parseInt(obj.height)+num>=24) {
		obj.height = 24 + num;	
	}
	}
}
</script>
<form name="form" method="post" action="Bokeupload.asp?user={$bokename}&mode=SaveUpload" enctype="multipart/form-data">
<table border="0" cellspacing="0" cellpadding="0" style="width:100%;height:100%">
<tr>
<Input type="hidden" name="act" value="upload"/>
<TD id="upid" valign="top" align="left" class="reply_t3">
<input type="file" name="file1" width="120px" value="" size="25"/></TD>
<td valign="top" width="*" align="left" class="reply_t3">
<input type="submit" name="Submit" value="上传" onclick="parent.document.PostForm.submit.disabled=true"/>
</td>
<td id="allupload" valign="top" align="left" class="reply_t3">
</td>
<td valign="top" align="left" class="reply_t3">
<div id="Setupload" style="display:none" align="left">
</div>
</td>
</tr>
</table>
</form>
<script language="JavaScript">
<!--
if (upset > 1){
var tempstr1='<input type="button" name="setload" onClick="uploadframe(0);" value="批量上传"/>';
var tempstr2='设置个数<input type="text" value="1" name="upcount" size="1" maxlength="1"/><input type="button" name="Button" onClick="setid();" value="设定"/>';
document.getElementById("allupload").innerHTML=tempstr1;
document.getElementById("Setupload").innerHTML=tempstr2;
}
//-->
</script>
</body>
</html>
]]>
</xsl:variable>
<xsl:variable name="String_27" title="edit_Saveupload">
<![CDATA[
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<td class="reply_t3" valign="top" height="40" align="left">
{$SucMsg}
</td>
</tr>
</table>
</body>
</html>
]]>
</xsl:variable>

<xsl:variable name="String_28" title="linklist">
<![CDATA[

<div class="topic1">
{$LinkeLogo}
名称：<a href="{$bokeurl}{$bokename}.showtopic.{$TopicID}.html" target="_blank">{$topic}</a>
</div>
<div class="postend" style="text-align:left;">
<div class="topic_r">
<a href="dispuser.asp?id={$UserID}" target="_blank" alt="查看个人资料">{$PostUserName}</a> 添加于：{$PostDate}
{$Edit}{$Manage}{$Delete}
</div>
点击：{$hits}
</div>
<hr class="post"/><br/>
]]>
</xsl:variable>
<xsl:variable name="String_29" title="linklist">
<![CDATA[
<div class="topic_r">
<a href="{$bokeurl}{$bokename}.showtopic.{$TopicID}.html" target="_blank"><img src="{$LinkImg}" border="0" alt="链接图标"/></a>
</div>
]]>
</xsl:variable>
<xsl:variable name="String_30" title="delete">
<![CDATA[
[<a href="Bokepostings.asp?user={$bokename}&action=delete&rootid={$RootID}&postid={$PostID}" alt="删除">删除</a>]
]]>
</xsl:variable>
<xsl:variable name="String_31" title="alipay">
<![CDATA[
&nbsp;<a href="javascript:Dvbbs_foralipay('PostContent');"><img src="boke/images/alipay/icon_alipay.gif" border="0" alt="生成一个支付宝交易，支付宝买卖交易，免费、安全、快速！"></a>
]]>
</xsl:variable>
<xsl:variable name="String_32" title="alipay_a">
<![CDATA[
	<tr>
		<td width="20%" class="reply_t2">支付宝帐号：<BR/>或填写有效Email地址&nbsp;&nbsp;</td>
		<td width="80%" class="reply_t3"><input type="text" name="alipay_seller" size="20" value="{$paytomail}"/>
		未注册支付宝请在买家交易后查收激活邮件</td>
	</tr>
	<tr>
		<td width="20%" class="reply_t2">商品名称：<BR/><a href="http://server.dvbbs.net/dvbbs/alipay/s.htm" target="_blank"><font color="blue">支付宝交易帮助</font></a>&nbsp;&nbsp;</td>
		<td width="80%" class="reply_t3"><input type="text" name="alipay_subject" size="30"/>
		&nbsp;&nbsp;价格&nbsp;<input type="text" name="alipay_price" size="10" value="0"/> 元
		</td>
	</tr>
	<tr>
		<td width="20%" class="reply_t2">邮费承担方：</td>
		<td width="80%" class="reply_t3">
			<input type=radio ID="ialipay_transport" name="ialipay_transport" value="3" onclick="document.getElementById('alipay_mail').disabled=true; document.getElementById('alipay_express').disabled=true;alipay_transport.value=3;"> 虚拟物品不需邮递&nbsp;&nbsp;
			<input type=radio ID="ialipay_transport" name="ialipay_transport" checked value="1" onclick="document.getElementById('alipay_mail').disabled=true; document.getElementById('alipay_express').disabled=true;alipay_transport.value=1;"> 卖家承担运费&nbsp;&nbsp;
			<input type=radio ID="ialipay_transport" name="ialipay_transport" value="2" onclick="document.getElementById('alipay_mail').disabled=false; document.getElementById('alipay_express').disabled=false;alipay_transport.value=2;"> 买家承担运费<BR>
			<input type="hidden" value="1" ID="alipay_transport">
			平邮&nbsp;<input type=text ID="alipay_mail" name="alipay_mail" style="width:45px" size=25 disabled> 元 &nbsp;&nbsp;
			快递&nbsp;<input type=text ID="alipay_express" name="alipay_express" style="width:45px" size=25 disabled> 元 (不填为平邮)</td>
	</tr>
	<tr>
		<td width="20%" class="reply_t2">演示地址：</td>
		<td width="80%" class="reply_t3"><input type="text" name="alipay_demo" size="30" value="http://"/>
		商品说明请填写于信息内容中</td>
	</tr>
	<tr>
		<td width="20%" class="reply_t2">联系方式：</td>
		<td width="80%" class="reply_t3">淘宝旺旺&nbsp;<input type="text" name="alipay_ww" size="10"/>&nbsp;&nbsp;腾讯QQ&nbsp;<input type="text" name="alipay_qq" size="9"/>
		让买家在线联系您</td>
	</tr>
]]>
</xsl:variable>
<xsl:variable name="String_33" title="topic_11">
<![CDATA[
	<tr>
		<td class="reply_t2">搜索关键字：</td>
		<td class="reply_t3"><input type="text" name="SearchKey" size="50" onkeyup="javascript:Dv_Form.CheckLength(this,250);" value="{$SearchKey}"/>(不能超过250个字符，用逗号分割)
		</td>
	</tr>
	<tr>
		<td class="reply_t2">选取状态：</td>
		<td class="reply_t3">
		<Select Name="Lock" Size="1">
		<Option value="0">正常</Option>
		<Option value="1">认证</Option>
		<Option value="2">关闭</Option>
		<Option value="3">隐藏</Option>
		</Select>
		<Select Name="Best" Size="1">
		<Option value="0">普通</Option>
		<Option value="1">精华</Option>
		</Select>
		<Select Name="Weather" Size="1" onchange="Chang(this.value,'WeatherSrc','boke/images/weather/')">{$WeatherList}
		</Select>
		<img id="WeatherSrc" src="boke/images/weather/sun.gif" border="0">
		</td>
	</tr>
]]>
</xsl:variable>
<xsl:variable name="String_34" title="getcode">
<![CDATA[
	<tr>
		<td class="reply_t2">验&nbsp;&nbsp;证&nbsp;码：</td>
		<td class="reply_t3">{$Dv_GetCode}<!--<input type="text" name="codestr" maxlength="4" size="4"/>&nbsp;<img name="codepic" src="DV_getcode.asp" onclick="this.src='DV_getcode.asp'" alt="点击更换验证码！"/>--></td>
	</tr>
]]>
</xsl:variable>
</xsl:stylesheet>

