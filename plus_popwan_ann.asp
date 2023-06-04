<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/Dv_ClsOther.asp"-->
<!--#include file="Plus_popwan/cls_setup.asp"-->
<%
	Dim Action
	Dvbbs.LoadTemplates("")
	Dvbbs.Stats = "发表论坛公告"
	Dvbbs.Nav()
	Dvbbs.Head_var 0,0,Plus_Popwan.Program,"plus_popwan_ann.asp"
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
	Select Case action
		Case "addann"
			AddAnn()
		Case "SaveAnn"
			SaveAnn()
		Case Else
			AddAnn()
	End Select
End Sub

Sub SaveAnn()
	Dim rs,sql
	If Request.form("submit")="" Then Exit Sub
	If Not Dvbbs.ChkPost() Then Dvbbs.AddErrCode(16):Exit sub
	Dim username,title,content,bgs
	If request("username")="" then
		Response.redirect "showerr.asp?ErrCodes=<li>请输入您的用户名，请确认您输入的用户名长度是否符合论坛标准。&action=OtherErr"
	Else
		username=Dvbbs.MemberName
	End if
	'防止标题被插入脚本和出现不规范代码。
	Dim checkinfo
	checkinfo=checkXHTML(request("title"))
	If checkinfo<>"" Then
		Response.redirect "showerr.asp?ErrCodes=<li>"&checkinfo&"&action=OtherErr"
	End If
	If request("title")="" then
		Response.redirect "showerr.asp?ErrCodes=<li>数据中含有非法字符。&action=OtherErr"
	Else
		title=request("title")
	End If
	If Dvbbs.strLength(title)>250 Then Response.redirect "showerr.asp?ErrCodes=<li>标题不能多于250个字符&action=OtherErr"
	If request("content")="" Then 
		Response.redirect "showerr.asp?ErrCodes=<li>您输入的用户名包含系统禁止注册字符。&action=OtherErr"
	Else
		content=Dvbbs.CheckStr(request("content"))
	End If
	bgs=Dv_FilterJS(request("bgs"))
	
	'Dvbbs.Execute("Alter Table Dv_bbsnews Alter Column title varchar(250) null")
	Set Rs=Dvbbs.iCreateObject("adodb.recordset")
	Sql="select * from Dv_bbsnews"
	If Not IsObject(Conn) Then ConnectionDatabase
	Rs.open sql,conn,1,3
	Rs.addnew
		Rs("username")=username
		Rs("title")=title
		Rs("content")=content
		Rs("addtime")=Now()
		Rs("boardid")=Dvbbs.BoardID
		If bgs<>"" Then
			Rs("bgs")=bgs
		End If
	Rs.update
	rs.close:Set rs=Nothing
	Dvbbs.Name = "Dv_news_"&Dvbbs.boardid
	Dvbbs.RemoveCache
	Dvbbs.Dvbbs_suc("<li>您已经成功的发布了公告。")
	If Dvbbs.BoardID=0 Then
		Dvbbs.Execute("Insert Into Dv_Log (l_AnnounceID,l_BoardID,l_touser,l_username,l_content,l_ip,l_type) values (0,"&Dvbbs.BoardID&",'论坛公告','" & Dvbbs.MemberName & "','发布新公告','" & Dvbbs.userTrueIP & "',3)")
	Else
		Dvbbs.Execute("Insert Into Dv_Log (l_AnnounceID,l_BoardID,l_touser,l_username,l_content,l_ip,l_type) values (0,"&Dvbbs.BoardID&",'论坛公告','" & Dvbbs.MemberName & "','在 "&Dvbbs.boardtype&"发布新公告','" & Dvbbs.userTrueIP & "',3)")
	End If
	
End Sub

Sub AddAnn()
%>
<style type="text/css">
table {width:100%;}
td {padding-left:5px;}
</style>
<!--announcements.asp##发布或编辑公告页面-->
<form action="?action=SaveAnn" method="post">
  <table class="tableborder1" cellspacing="1" cellpadding="6" align="center">
      <tr>
        <th align="center" colspan="2">发布论坛公告</th>
      </tr>
	  <script language = "javaScript" src = "inc/toxhtml.js" type="text/javascript"></script><div style="display : none;" id="hiddenhtml"></div>
      <tr valign="middle">
        <td class="tablebody1" align="left"><b>用户名</b></td>
        <td class="tablebody1" align="left"><input name="username" type="text" disabled value="<%=Dvbbs.MemberName%>" size="20" /> 
          <input name="username" type="hidden" value="<%=Dvbbs.MemberName%>" /></td>
      </tr>
       <tr valign="middle">
        <td class="tablebody1" align="left"><b>版　面</b></td>
        <td class="tablebody1" align="left"><select id="boardid" name="boardid"></select>
</td>
      </tr>
       <tr valign="middle">
        <td class="tablebody1" align="left"><b>背景乐</b></td>
        <td class="tablebody1" align="left"><input name="bgs" type="text" value="" size="60" />&nbsp;支持MID或WAV文件，此项非必填。</td>
      </tr>
        <tr valign="middle">
        <td class="tablebody1" align="left"><b>标　题</b></td>
        <td class="tablebody1" align="left"><input name="title" type="text" value=""  onblur="fixtoxhtml(this)" size="60" /></td>
      </tr>
      <tr>
        <td class="tablebody1" valign="top" width="30%" align="left"><b>内　容</b></td>
        <td class="tablebody1" valign="middle" align="left"><textarea class="smallarea" name="Content" rows="8" wrap="virtual" cols="60"></textarea></td>
      </tr>
      <tr>
        <td class="tablebody2" align="center" valign="middle" colspan="2"><input name="submit" type="submit" value="发 布" /></td>
      </tr>
  </table>
</form>
<script language="JavaScript" type="text/javascript">
<!--
BoardJumpListSelect('<%=Dvbbs.Boardid%>',"boardid","论坛首页","0",0);
//-->
</script>

<%
End Sub


%>