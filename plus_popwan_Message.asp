<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="Plus_popwan/cls_setup.asp"-->
<%
	Dim Action

	Dim Errmsg,Numc

	Dvbbs.LoadTemplates("")
	Dvbbs.Stats = "联盟信息管理"
	Dvbbs.Nav()
	Dvbbs.Head_var 0,0,Plus_Popwan.Program,"plus_popwan_Message.asp"
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
		Case "add"
			Call Savemsg()
		Case Else
			sendmsg()
	End Select
End Sub

sub sendmsg()
%>
<style type="text/css">
table {width:100%;}
td {padding-left:5px;}
</style>
<table cellspacing="0" cellpadding="0" class="pw_tb1">
                <tr> 
                  <th colspan="2" style="text-align:center;">论坛短信广播</th>
                </tr>
            <form action="?action=add" method="post">
                <tr> 
                  <td width="22%">消息标题</td>
                  <td width="78%"> 
                    <input type="text" name="title" size="70">
                  </td>
                </tr>
                <tr> 
                  <td width="22%">接收方选择</td>
                  <td width="78%"> 
                    <select name="stype" size="1">
					<option value="1">所有在线用户</option>
					<option value="2">所有贵宾</option>
					<option value="3">所有版主</option>
					<option value="4">所有管理员</option>
					<option value="5">版主/超版/管理员</option>
					<option value="6">所有用户</option>
					<option value="7">所有超版</option>
<%
	Dim Rs,Sql
	Sql = "SELECT UserGroupID, Title From Dv_UserGroups WHERE UserGroupID > 8 AND ParentGID = 0 ORDER BY UserGroupID"
	Set Rs = Dvbbs.Execute(Sql)
	If Not (Rs.Eof And Rs.Bof) Then
		Sql = Rs.GetRows(-1)
		Rs.Close:Set Rs = Nothing
		For i = 0 To Ubound(Sql,2)
%>
					<option value="<%=Cint(Sql(0,i))%>"><%=Dvbbs.HtmlEnCode(Sql(1,i))%></option>
<%
		Next
	End If
%>
					</select>
                  </td>
                </tr>
                <tr> 
                  <td width="22%" height="20" valign="top">
                    <p>消息内容</p>
                    <p>(<font color="red">HTML代码支持</font>)</p>
                  </td>
                  <td width="78%" height="20"> 
                    <textarea name="message" cols="80" rows="10"></textarea>
                    <br><input type="radio" class="radio" name="isshow" value="1" checked>显示发送过程 <input type="radio" class="radio" name="isshow" value="0" > 不显示发送过程（速度较快）
                  </td>
                </tr>
                <tr> 
                  <td width="22%" height="23" valign="top" align="center"> 
                    <div align="left">&nbsp;</div>
                  </td>
                  <td width="78%" height="23"> 
                    <div align="center"> 
                      <input type="submit" class="button" name="Submit" value="发送消息">
                      <input type="reset" class="button" name="Submit2" value="重新填写">
                    </div>
                  </td>
                </tr>
            </form>
              </table>
<%
end sub

Sub Savemsg()
	Dim Sendtime,sender,userlist,Title,message,isshow,Rs,Sql,i
	isshow=Request("isshow")
	Title = TRim(Request("title"))
	message=Replace(Request("message"),Chr(13)&Chr(10),"<br/>")
	message=Dvbbs.checkStr(message)
	If Len(Title)=0 Then 
		Errmsg = Errmsg + "消息标题不能为空"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub			
	End If
	If Len(message)=0 Then
		Errmsg = Errmsg + "消息内容不能为空"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub			
	End If
	If Len(message)>255 Then
		Errmsg = Errmsg + "消息内容不能多于255字节"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& Errmsg &"&action=OtherErr"
		Exit Sub			
	End If 
	sendtime=Now()
	sender=Dvbbs.Forum_info(0)
	Select case request("stype")
	case 1
		Sql = "SELECT Count(*) FROM [dv_online] where userid>0"
		Set Rs = Dvbbs.execute(Sql)
		Numc = Rs(0)
		sql="select username from dv_online where userid>0"
	Case 2
		Sql = "SELECT Count(*) FROM [dv_user] where usergroupid=8"
		Set Rs = Dvbbs.execute(Sql)
		Numc = Rs(0)
		sql = "select username from [dv_user] where usergroupid=8 order by userid desc"
	Case 3
		Sql = "SELECT Count(*) FROM [dv_user] where usergroupid=3"
		Set Rs = Dvbbs.execute(Sql)
		Numc = Rs(0)
		sql = "select username from [dv_user] where usergroupid=3 order by userid desc"
	Case 4
   		Sql = "SELECT Count(*) FROM [dv_user] where usergroupid=1"
		Set Rs = Dvbbs.execute(Sql)
		Numc = Rs(0)
   		sql = "select username from [dv_user] where usergroupid=1 order by userid desc"
	Case 5
   		Sql = "SELECT Count(*) FROM [dv_user] where usergroupid<4"
		Set Rs = Dvbbs.execute(Sql)
		Numc = Rs(0)
   		sql = "select username from [dv_user] where usergroupid<4 order by userid desc"
	Case 6
		Sql = "SELECT Count(*) FROM [Dv_user]"
		Set Rs = Dvbbs.execute(Sql)
		Numc = Rs(0)
		Rs.Close
	    Sql = "SELECT Username FROM [Dv_user] ORDER BY Userid DESC"
	Case 7
		Sql = "SELECT COUNT(*) FROM [Dv_User] WHERE UserGroupID = 2"
		Set Rs = Dvbbs.Execute(Sql)
		Numc = Rs(0)
		sql = "SELECT UserName FROM [Dv_User] WHERE UserGroupID = 2 ORDER BY UserID DESC"
	Case Else
		REM 加入自定义用户组群发短信功能 2004-5-19 Dv.Yz
		Sql = "SELECT COUNT(*) FROM [Dv_User] WHERE Usergroupid = " & Cint(Request("stype"))
		Set Rs = Dvbbs.Execute(Sql)
		Numc = Rs(0)
		Sql = "SELECT Username FROM [Dv_User] WHERE Usergroupid = " & Cint(Request("stype")) & " ORDER BY Userid DESC"
	End Select
%>
<br><table cellspacing="0" cellpadding="0" class="pw_tb1">
<tr><td colspan=2>
下面开始发送短消息，预计本次发送<%=Numc%>个用户。
<table style="width:400px;" cellspacing="1" cellpadding="1" class="pw_tb1">
<tr> 
<td bgcolor="#000000">
<table style="width:400px;" cellspacing="0" cellpadding="1" class="pw_tb1">
<tr> 
<td bgcolor="#ffffff" height="9"><img src="skins/default/bar/bar3.gif" width="0" height="16" id="img2" name="img2" align="absmiddle"></td></tr></table>
</td></tr></table> <span id="txt2" name="txt2" style="font-size:9pt">0</span></td></tr>
</table>
<%
Response.Flush
	Set Rs = Dvbbs.Execute(Sql)
	'修正所属用户组用户数为0时的错误 Dv.Yz 2005-1-27
	If Not (Rs.Eof And Rs.Bof) Then
		userlist=Rs.GetRows(-1)
		Set Rs = Nothing
		Response.Write "<script>document.getElementById('img2').width=" & Fix((i/Numc) * 400) & ";" & VbCrLf
		Response.Write "document.getElementById('txt2').innerHTML=""正在发送，..."";" & VbCrLf
		Response.Write "document.getElementById('img2').title=""发送短信给...."";</script>" & VbCrLf
		Response.Flush
		For i=0 to UBound(userlist,2)
			userlist(0,i)=Dvbbs.checkStr(userlist(0,i))
			If Response.IsClientConnected Then
				If isshow="1" Then
					Response.Write "<script>document.getElementById('img2').width=" & Fix((i/Numc) * 400) & ";" & VbCrLf
					Response.Write "document.getElementById('txt2').innerHTML=""" & FormatNumber(i/Numc*100,4,-1) & "%，发送短信给" & userlist(0,i) & "成功！"";" & VbCrLf
					Response.Write "document.getElementById('img2').title=""发送短信给" & userlist(0,i)  & "成功！"";</script>" & VbCrLf
					Response.Flush
				End If
				Sql = "INSERT into dv_message(incept, sender, title, content, sendtime, flag, issend) values('"&userlist(0,i) &"', '"&sender&"', '"&Title&"', '"&Trim(message)&"', "&SqlNowString&",0,1)"
				Dvbbs.Execute(Sql)
				Update_user_msg(userlist(0,i))
				userlist(0,i)=""
			End If 
		Next 
		Response.Write "<script>document.getElementById('img2').width=400;" & VbCrLf
		Response.Write "document.getElementById('txt2').innerHTML=""100%，发送完成"";" & VbCrLf
		Response.Write "document.getElementById('img2').title=""发送短信给...."";</script>" & VbCrLf
		Response.Flush
	End If
	Dvbbs.Dvbbs_Suc("操作成功！请继续别的操作。")
End Sub

Function inceptid(stype,iusername)
	Dim ars
	set ars=Dvbbs.Execute("Select top 1 id,sender from dv_Message Where flag=0 and issend=1 and delR=0 And incept ='"& iusername &"'")
	If stype=1 Then
		inceptid=ars(0)
	Else
		inceptid=ars(1)
	End If
	set ars=nothing
End Function
Function update_user_msg(username)
	Dim msginfo
	If newincept(username)>0 Then
		msginfo=newincept(username) & "||" & inceptid(1,username) & "||" & inceptid(2,username)
	Else
		msginfo="0||0||null"
	End If
	Dvbbs.Execute("update [dv_user] set UserMsg='"&dvbbs.CheckStr(msginfo)&"' where username='"&dvbbs.CheckStr(username)&"'")
End Function
'统计留言
Function newincept(iusername)
	Dim rs
	Rs=Dvbbs.Execute("Select Count(id) from dv_Message Where flag=0 and issend=1 and delR=0 And incept='"& iusername &"'")
	newincept=Rs(0)
	Set Rs=Nothing
	If IsNull(newincept) Then newincept=0
End Function
%>