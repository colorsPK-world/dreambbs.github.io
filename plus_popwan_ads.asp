<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="Plus_popwan/cls_setup.asp"-->
<%
	Dim Action

	Dim Errmsg
	Dim NewsConfigFile
	Dim popwan_ads,Forum_Api,AdsList
	
	Dvbbs.LoadTemplates("")
	Dvbbs.Stats = "投放广告推广"
	Dvbbs.Nav()
	Dvbbs.Head_var 0,0,Plus_Popwan.Program,"plus_popwan_ads.asp"
	Dvbbs.ActiveOnline()
	action = Request("action")
	Page_main()

	If action<>"frameon" Then
		Dvbbs.Footer
	End If
	Dvbbs.PageEnd()

'页面右侧内容部分
Sub Page_Center()
	If Not (Dvbbs.master Or Dvbbs.GroupSetting(70)="1") Then
		Dvbbs.AddErrcode(28)
		Dvbbs.ShowErr()
	End If

	Dim act
	Act = Request("act")

	NewsConfigFile = Plus_Popwan.FilePath(Plus_Popwan.CachePath&"Temp_Plus_popwan_ads.config")
	ChkForum_api()

	Page_main1()

	Select Case Act
		Case "addads"	'发布广告位
			Addads()
		Case "saveads"	'保存广告位
			Call saveads()
		Case "adslist"	'我的广告位
			Call MyAdsList()
		Case "editads"  '编辑广告位
			Call Editads()
		Case "saveeditads"  '保存编辑广告位
			Call SaveEditads()
		Case "restore"	'清掉广告
			Call Restore()
		Case Else
			Addads()
	End Select

End Sub

Sub Page_main1()
%>
<style type="text/css">
table {width:100%;}
td {padding-left:5px;}
</style>
<table cellspacing="0" cellpadding="0" class="pw_tb1">
<tr><th>游戏联盟说明</th></tr>
<tr><td>
<ul>
<li>说明①：广告位名称唯一，不能重复；</li>
<li>说明②：请注意<font color="green">选择在页面中显示的位置</font>。</li>
</ul>
</td></tr>
<tr><td>
<a href="?act=addads">发布广告位</a>
| <a href="?act=adslist">我的广告位</a>
| <a href="?act=restore">清掉广告</a>
</td></tr>
</table><br/>
<%
End Sub

'添加/编辑广告位
Sub Addads()
%>
<style>
#adsize_label span{color:red;}
</style>
<script language="JavaScript">
function _setdemo(v){
	var obj = document.getElementById('ads_setdemo');
	if (obj){
		obj.src = "<%=Plus_Popwan.Folder%>images/ads_set"+v+".gif";
	}
}
</script>

<table cellspacing="0" cellpadding="0" class="pw_tb1">
<form method="post" action="?act=saveads" name="adsform">
<tr><th colspan="2" style="text-align:center;">发布广告位信息(<font class="font2">以下为必填项</font>)</th></tr>
<tr><td align="right">广告位信息演示：</td>
<td width="85%"><div id="adsshow"></div></td>
</tr>
<tr>
<td width="15%" align="right">广告位名称：</td>
<td width="85%">
<input type="text" name="zonename" size="20" value=""/>(例如：xxx网站顶部广告位) 
<br/>
<font class="font1"></font>
</td>
</tr>
<tr>
<td  align="right">广告形式：</td>
<td>
<input type="radio" name="format" class="radio" value="1"/>文字广告  <input type="radio" name="format" checked="true" class="radio"  value="2"/>图片广告
</td>
</tr>
<tr>
<td  align="right">广告代码：</td>
<td>
<textarea name="zonedesc" style="width:96%;height:80px;"></textarea>
<br/><button name="pw" onclick="window.open('http://union.popwan.com/my/site/spread/<%=Plus_Popwan.ConfigNode.getAttribute("siteid")%>','popwanads');">获取广告代码</button>
</td>
</tr>
<tr>
<td  align="right">广告显示位置：</td>
<td>
<div style="float:left;width:40%;">
<input type="checkbox" name="getskinid" value="1" class="checkbox"/>论坛默认广告<font class="font1">：（除具体版面内容以外的页面）</font>
<br/>
选择显示的版面<font class="font1">：（请按 CTRL 键进行多选）</font>
<select name="getboard" style="width:98%;" size="12" multiple="true">
<%
	Dim node,BoardNode,ii
	Set BoardNode=Application(Dvbbs.CacheName&"_boardlist").cloneNode(True)
	For each node in BoardNode.documentElement.getElementsByTagName("board")
		Response.Write "<option value="""&node.getAttribute("boardid")&""">"
		Select Case node.getAttribute("depth")
			Case 0
				Response.Write "╋"
			Case 1
				Response.Write "&nbsp;&nbsp;├"
		End Select
		If node.getAttribute("depth")>1 Then
			For ii=2 To node.getAttribute("depth")
				Response.Write "&nbsp;&nbsp;│"
			Next
			Response.Write "&nbsp;&nbsp;├"
		End If
		Response.Write node.getAttribute("boardtype")
		Response.Write "</option>"&vbNewline
	Next
%>
</select>
<br/>
</div>
<div style="float:left;width:20%;">
<font class="green">选择在页面中显示的位置</font>
<br/>
页面顶部广告位：<input type="radio" name="adsset" value="1" class="radio" onclick="_setdemo(this.value);"/><br/>
页面底部广告位：<input type="radio" name="adsset" value="2" class="radio" onclick="_setdemo(this.value);"/><br/>
<!-- 页面文字广告位：<input type="radio" name="adsset" value="6" class="radio" onclick="_setdemo(this.value);"/><br/>
帖间随机文字广告位：<input type="radio" name="adsset" value="5" class="radio" onclick="_setdemo(this.value);"/><br/> -->
帖子楼主顶部广告位：<input type="radio" name="adsset" value="7" class="radio" onclick="_setdemo(this.value);"/><br/>
帖子楼主左边广告位：<input type="radio" name="adsset" value="8" class="radio" onclick="_setdemo(this.value);"/><br/>
帖子楼主右边广告位：<input type="radio" name="adsset" value="9" class="radio" onclick="_setdemo(this.value);"/><br/>
帖子楼主底部广告位：<input type="radio" name="adsset" value="10" class="radio" onclick="_setdemo(this.value);"/><br/>
</div>
<div style="float:left;width:36%;height:220px;">
<img id="ads_setdemo" src="<%=Plus_Popwan.Folder%>images/ads_set.gif" border="0" alt="广告位置预览"/>
</div>
</td>
</tr>
<tr><td colspan="2" align="center">
<input type="submit" name="submit" value="发布我的广告位"/>
</td></tr>
</form>
</table>
<%
End Sub

'保存广告位信息
Sub SaveAds()
	Dim zonename,format,adsize,getboard,adsset,zonedesc
	Dim homepage
	zonename = Trim(Request.Form("zonename")) '广告位名称
	format = Trim(Request.Form("format")) '广告形式
	getboard = Trim(Request.Form("getboard")) '选择显示的版面
	adsset = Trim(Request.Form("adsset"))
	zonedesc  = Trim(Request.Form("zonedesc")) '广告代码
	'提交信息验证
	If zonename=""or Len(zonename)<1 or Len(zonename)>32 Then
		Errmsg=ErrMsg + "<BR/>广告位名称不能为空或超过32个字符！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If
	If format="" or Not IsNumeric(format) Then
		Errmsg=ErrMsg + "<BR/>请正确选择广告形式！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If
	If zonedesc="" Then
		Errmsg=ErrMsg + "<BR/>广告代码不能为空！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If
	If adsset = "" or Not Isnumeric(adsset) Then
		Errmsg=ErrMsg + "<BR/>请选取广告在页面中显示的位置！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If
	If format = "1" and (adsset="3" or adsset="4") Then
		Errmsg=ErrMsg + "<BR/>文字广告类型，不能设置在浮动或右下固定广告位！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If

	'是否显示在首页类型
	homepage = Request.Form("getskinid") '在首页:1 论坛默认广告

		Set AdsList = popwan_ads.selectNodes("ads[@name='"&zonename&"']")
		If AdsList.Length>0 Then
			Errmsg=ErrMsg + "<BR/>广告位名称不能有重复！"
			Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
			Exit Sub
		End If
		Set AdsList = popwan_ads.selectNodes("ads[@adsset='"&adsset&"' and @getboard='"&getboard&"' ]")
		If AdsList.Length>0 Then
			Errmsg=ErrMsg + "<BR/>已经有该相同设置的广告信息，请不要重复新增设置！"
			Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
			Exit Sub
		End If

		'创建一个新的广告数据节点
		Set AdsList = popwan_ads.appendChild(Forum_Api.createNode(1,"ads",""))
		AdsList.setAttribute "createtime",Now()
		AdsList.setAttribute "updatetime",Now()

	AdsList.setAttribute "name",zonename
	AdsList.setAttribute "format",format
	AdsList.setAttribute "homepage",homepage
	AdsList.setAttribute "adsset",adsset
	AdsList.setAttribute "getboard",getboard
	AdsList.setAttribute "zonedesc",zonedesc

		Update_Forum_Api()
		UpdateAdsSeting()
		Dvbbs.Dvbbs_suc("发布广告位成功！")
End Sub

'我的广告位
Sub MyAdsList()
	Set AdsList = popwan_ads.selectNodes("ads")
	If AdsList.Length=0 Then
		Errmsg=ErrMsg + "<BR/>暂未有广告位数据！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If
	Dim Node
%>
<br/>
<table cellspacing="0" cellpadding="0" class="pw_tb1">
<tr><th colspan="7" style="text-align:center;" colspan="4">我的广告位信息</th></tr>
<tr>
<td class="td2 title" >广告位名称</td>
<td class="td2 title" width="10%">广告位形式</td>
<td class="td2 title" width="15%">创建时间</td>
<td class="td2 title" width="15%">更新时间</td>
<td class="td2 title" >操作</td>
</tr>
<%
	For Each Node In AdsList
%>
<tr>
<td><%=Node.getAttribute("name")%></td> 
<td><%=adssettype(Node.getAttribute("adsset"))%></td>
<td>
<%
If IsDate(Node.getAttribute("createtime")) Then
Response.Write Formatdatetime(Node.getAttribute("createtime"),0)
Else
Response.Write Node.getAttribute("createtime")
End If
%></td>
<td>
<%
If IsDate(Node.getAttribute("updatetime")) Then
Response.Write Formatdatetime(Node.getAttribute("updatetime"),0)
Else
Response.Write Node.getAttribute("updatetime")
End If
%></td>
<td><a href="?act=editads&name=<%=Node.getAttribute("name")%>">编辑</a></td>
</tr>
<%
	Next
%>
</table>
<%
Set AdsList = Nothing
End Sub
Function adssettype(num)
	Select Case num
		Case "1" : adssettype = "页面顶部"
		Case "2" : adssettype = "页面底部"
		Case "7" : adssettype = "帖子楼主顶部"
		Case "8" : adssettype = "帖子楼主左边"
		Case "9" : adssettype = "帖子楼主右边"
		Case "10" : adssettype = "帖子楼主底部"
		Case Else
			adssettype = "未知"
	End Select
End Function

'编辑广告位
Sub Editads()
	Dim adzoneid
	Adzoneid = Request.QueryString("name")
	If Adzoneid<>"" Then
		Set AdsList = popwan_ads.selectSingleNode("ads[@name='"&Adzoneid&"']")
		If AdsList is Nothing  Then
			Errmsg=ErrMsg + "<BR/>您需要编辑的广告位不存在！"
			Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
			Exit Sub
		End If
	End If
%>
<style>
#adsize_label span{color:red;}
</style>
<table cellspacing="0" cellpadding="0" class="pw_tb1">
<form method="post" action="?act=saveeditads" name="adsform">
<tr><th colspan="2" style="text-align:center;">编辑广告位信息(<font class="font2">以下为必填项</font>)</th></tr>
<tr><td align="right">广告位信息演示：</td>
<td width="85%"><div id="adsshow"></div></td>
</tr>
<tr>
<td width="15%" align="right">广告位名称：</td>
<td width="85%">
<input type="text" name="zonename" size="20" value="<%=AdsList.getAttribute("name")%>" disabled/>(例如：xxx网站顶部广告位) 
<br/>
<font class="font1"></font>
</td>
</tr>
<tr>
<td  align="right">广告形式：</td>
<td>
<input type="radio" name="format" class="radio" value="1"/>文字广告  <input type="radio" name="format" checked="true" class="radio"  value="2"/>图片广告
</td>
</tr>
<tr>
<td  align="right">广告代码：</td>
<td>
<textarea name="zonedesc" style="width:96%;height:80px;"><%=AdsList.getAttribute("zonedesc")%></textarea>
<br/><button name="pw" onclick="alert('打开游戏广告联盟代码页面。');">获取广告代码</button>
</td>
</tr>
<tr>
<td  align="right">广告显示位置：</td>
<td>
<div style="float:left;width:40%;">
<input type="checkbox" name="getskinid" value="1" class="checkbox"/>论坛默认广告<font class="font1">：（除具体版面内容以外的页面）</font>
<br/>
选择显示的版面<font class="font1">：（请按 CTRL 键进行多选）</font>
<select name="getboard" style="width:98%;" size="12" multiple="true">
<%
	Dim node,BoardNode,ii
	Set BoardNode=Application(Dvbbs.CacheName&"_boardlist").cloneNode(True)
	For each node in BoardNode.documentElement.getElementsByTagName("board")
		Response.Write "<option value="""&node.getAttribute("boardid")&""">"
		Select Case node.getAttribute("depth")
			Case 0
				Response.Write "╋"
			Case 1
				Response.Write "&nbsp;&nbsp;├"
		End Select
		If node.getAttribute("depth")>1 Then
			For ii=2 To node.getAttribute("depth")
				Response.Write "&nbsp;&nbsp;│"
			Next
			Response.Write "&nbsp;&nbsp;├"
		End If
		Response.Write node.getAttribute("boardtype")
		Response.Write "</option>"&vbNewline
	Next
%>
</select>
<br/>
</div>
<div style="float:left;width:20%;">
<font class="green">选择在页面中显示的位置</font>
<br/>
页面顶部广告位：<input type="radio" name="adsset" value="1" class="radio" onclick="_setdemo(this.value);"/><br/>
页面底部广告位：<input type="radio" name="adsset" value="2" class="radio" onclick="_setdemo(this.value);"/><br/>
<!-- 页面文字广告位：<input type="radio" name="adsset" value="6" class="radio" onclick="_setdemo(this.value);"/><br/>
帖间随机文字广告位：<input type="radio" name="adsset" value="5" class="radio" onclick="_setdemo(this.value);"/><br/> -->
帖子楼主顶部广告位：<input type="radio" name="adsset" value="7" class="radio" onclick="_setdemo(this.value);"/><br/>
帖子楼主左边广告位：<input type="radio" name="adsset" value="8" class="radio" onclick="_setdemo(this.value);"/><br/>
帖子楼主右边广告位：<input type="radio" name="adsset" value="9" class="radio" onclick="_setdemo(this.value);"/><br/>
帖子楼主底部广告位：<input type="radio" name="adsset" value="10" class="radio" onclick="_setdemo(this.value);"/><br/>
</div>
<div style="float:left;width:36%;height:220px;">
<img id="ads_setdemo" src="<%=Plus_Popwan.Folder%>images/ads_set.gif" border="0" alt="广告位置预览"/>
</div>
</td>
</tr>
<tr><td colspan="2" align="center">
<input type="submit" name="submit" value="确认"/>
</td></tr>
</form>
</table>
<script language="JavaScript">
function _setdemo(v){
	var obj = document.getElementById('ads_setdemo');
	if (obj){
		obj.src = "<%=Plus_Popwan.Folder%>images/ads_set"+v+".gif";
	}
}
chkcheckbox(document.adsform.getskinid,'<%=AdsList.getAttribute("homepage")%>');
ChkSelected(document.adsform.getboard,'<%=AdsList.getAttribute("getboard")%>');
chkradio(document.adsform.adsset,'<%=AdsList.getAttribute("adsset")%>');
_setdemo('<%=AdsList.getAttribute("adsset")%>');
</script>
<%
End Sub

'保存广告位设置
Sub SaveEditads()
	Dim zonename,format,adsize,getboard,adsset,zonedesc
	Dim homepage
	zonename = Trim(Request.Form("zonename")) '广告位名称
	format = Trim(Request.Form("format")) '广告形式
	getboard = Trim(Request.Form("getboard")) '选择显示的版面
	adsset = Trim(Request.Form("adsset"))
	zonedesc  = Trim(Request.Form("zonedesc")) '广告代码
	'提交信息验证
	If format="" or Not IsNumeric(format) Then
		Errmsg=ErrMsg + "<BR/>请正确选择广告形式！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If
	If zonedesc="" Then
		Errmsg=ErrMsg + "<BR/>广告代码不能为空！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If
	If adsset = "" or Not Isnumeric(adsset) Then
		Errmsg=ErrMsg + "<BR/>请选取广告在页面中显示的位置！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If
	If format = "1" and (adsset="3" or adsset="4") Then
		Errmsg=ErrMsg + "<BR/>文字广告类型，不能设置在浮动或右下固定广告位！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If

	'是否显示在首页类型
	homepage = Request.Form("getskinid") '在首页:1 论坛默认广告

	Set AdsList = popwan_ads.selectSingleNode("ads[@adzoneid="&Adzoneid&"]")
	If AdsList is Nothing  Then
		Errmsg=ErrMsg + "<BR/>您需要编辑的广告位不存在！"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub
	End If
		AdsList.setAttribute "updatetime",Now()
	AdsList.setAttribute "format",format
	AdsList.setAttribute "homepage",homepage
	AdsList.setAttribute "adsset",adsset
	AdsList.setAttribute "getboard",getboard
	AdsList.setAttribute "zonedesc",zonedesc
	Update_Forum_Api()
	UpdateAdsSeting()
	Dvbbs.Dvbbs_suc("广告位置修改成功！")
End Sub


'测试用
Sub Restore()
	Set Forum_Api = Server.CreateObject("Msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
	Forum_Api.LoadXml("<forum_api/>")
	Set popwan_ads = Forum_Api.documentElement.appendChild(Forum_Api.createNode(1,"popwan_ads",""))
	popwan_ads.setAttribute "memberid",""
	popwan_ads.setAttribute "email",""
	popwan_ads.setAttribute "password",""
	popwan_ads.setAttribute "nickname",""
	popwan_ads.setAttribute "webname",""
	Update_Forum_Api()
End Sub

Sub ChkForum_api()
	Set Forum_Api = Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
	If Not Forum_Api.load(NewsConfigFile) Then
		Creat_Forum_Api()
	Else
		Set Forum_Api = Server.CreateObject("Msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
		Forum_Api.load(NewsConfigFile)
		Set popwan_ads = Forum_Api.documentElement.selectSingleNode("popwan_ads")
	End If
End Sub

Sub Creat_Forum_Api()
	Set Forum_Api = Server.CreateObject("Msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
	Forum_Api.LoadXml("<forum_api/>")
	Set popwan_ads = Forum_Api.documentElement.appendChild(Forum_Api.createNode(1,"popwan_ads",""))
	popwan_ads.setAttribute "memberid",""
	popwan_ads.setAttribute "email",""
	popwan_ads.setAttribute "password",""
	popwan_ads.setAttribute "nickname",""
	popwan_ads.setAttribute "webname",""
	Update_Forum_Api()
End Sub

Sub Update_Forum_Api()
	Forum_Api.save NewsConfigFile
	Set Forum_Api=Nothing
End Sub


'设置广告位数据在页面显示的位置
Sub UpdateAdsSeting()
	Dim iSetting,i,Forum_ads
	Dim adsset,adsstr
	Dim Sql
	
	'广告代码字串
	'mm_alimama会员id_网站id_广告位id
	adsset = AdsList.getAttribute("adsset")
	Adsstr = AdsList.getAttribute("zonedesc")

	Adsstr = Replace(Adsstr,"$","") '过滤未完整
	If AdsList.getAttribute("homepage")="1" Then
		For i = 0 To 30
			iSetting = Trim(Dvbbs.Forum_ads(i))
			If (i = 2 or i = 7 or i = 13 or i=12 or i=15 or i = 17) and Dvbbs.Forum_ads(i)="" Then iSetting = 0

			If adsset = "1" and i=0 Then	'顶部
				iSetting = adsstr
			End If
			If adsset = "2" and i=1 Then	'底部
				iSetting = adsstr
			End If
			If adsset = "7" Then			'帖子楼主顶部广告位
				If i = 18 Then
					iSetting = 1			'开启帖子楼主顶部广告位
				End If
				If i = 19 Then
					iSetting = Adsstr
				End If
			End If

			If adsset = "8" Then			'帖子楼主左边广告位
				If i = 22 Then
					iSetting = 1			'开启帖子楼主左边广告位
				End If
				If i = 23 Then
					iSetting = Adsstr
				End If
			End If
			If adsset = "9" Then			'帖子楼主右边广告位
				If i = 22 Then
					iSetting = 2			'开启帖子楼主右边广告位
				End If
				If i = 23 Then
					iSetting = Adsstr
				End If
			End If
			If adsset = "10" Then			'帖子楼主底部广告位
				If i = 20 Then
					iSetting = 1			'开启帖子楼主底部广告位
				End If
				If i = 21 Then
					iSetting = Adsstr
				End If
			End If
			If i = 0 Then
				Forum_ads = iSetting
			Else
				Forum_ads = Forum_ads & "$" & iSetting
			End If
		Next
		Sql = "Update Dv_Setup Set Forum_ads='"&Replace(Forum_ads,"'","''")&"'"
		Dvbbs.Execute(sql)
	End If
	If AdsList.getAttribute("getboard")<>"" Then
		'查获更新版面数据，只更新设置投放广告项，避免清空原广告其他设置
		Dim Rs
		Set Rs = Dvbbs.Execute("select Boardid,Board_Ads from Dv_board where boardid in ("&Dvbbs.Checkstr(AdsList.getAttribute("getboard"))&")")
		do while not rs.eof
			Dvbbs.Forum_ads = Split(Rs(1),"$")
			For i = 0 To 30
				iSetting = Trim(Dvbbs.Forum_ads(i))
				If (i = 2 or i = 7 or i = 13 or i=12 or i=15 or i = 17) and Dvbbs.Forum_ads(i)="" Then iSetting = 0

				If adsset = "1" and i=0 Then	'顶部
					iSetting = adsstr
				End If
				If adsset = "2" and i=1 Then	'底部
					iSetting = adsstr
				End If
				If adsset = "7" Then			'帖子楼主顶部广告位
					If i = 18 Then
						iSetting = 1			'开启帖子楼主顶部广告位
					End If
					If i = 19 Then
						iSetting = Adsstr
					End If
				End If

				If adsset = "8" Then			'帖子楼主左边广告位
					If i = 22 Then
						iSetting = 1			'开启帖子楼主左边广告位
					End If
					If i = 23 Then
						iSetting = Adsstr
					End If
				End If
				If adsset = "9" Then			'帖子楼主右边广告位
					If i = 22 Then
						iSetting = 2			'开启帖子楼主右边广告位
					End If
					If i = 23 Then
						iSetting = Adsstr
					End If
				End If
				If adsset = "10" Then			'帖子楼主底部广告位
					If i = 20 Then
						iSetting = 1			'开启帖子楼主底部广告位
					End If
					If i = 21 Then
						iSetting = Adsstr
					End If
				End If
				If i = 0 Then
					Forum_ads = iSetting
				Else
					Forum_ads = Forum_ads & "$" & iSetting
				End If
			Next
			Sql = "Update Dv_Board Set Board_Ads='"&Replace(Forum_ads,"'","''")&"' Where BoardID ="&Rs(0)
			Dvbbs.Execute(Sql)
		Rs.movenext
		Loop
		Rs.close
		Set Rs = Nothing
	End If
	RestoreBoardCache()
	Dvbbs.loadSetup()
End Sub

'更新版面广告缓存数据
Sub RestoreBoardCache()
	Dim Board,node
	Dvbbs.LoadBoardList()
	For Each node in Application(Dvbbs.CacheName &"_style").documentElement.selectNodes("style/@id")
		Application.Contents.Remove(Dvbbs.CacheName & "_showtextads_"&node.text)
		For Each board in Application(Dvbbs.CacheName&"_boardlist").documentElement.selectNodes("board/@boardid")
			Dvbbs.LoadBoardData board.text
			Application.Contents.Remove(dvbbs.CacheName & "_Text_ad_"& board.text &"_"&node.text)
			Application.Contents.Remove(dvbbs.CacheName & "_Text_ad_"& board.text &"_"&node.text&"_-time")
		Next
		Application.Contents.Remove(dvbbs.CacheName & "_Text_ad_0_"& node.text)
		Application.Contents.Remove(dvbbs.CacheName & "_Text_ad_0_"& node.text&"_-time")
	Next
End Sub
%>