<!--#include FILE="conn.asp"-->
<!--#include file="inc/const.asp" -->
<!--#include file="boke/config.asp"-->
<!--#include file="inc/md5.asp"-->
<!--#include file="boke/checkinput.asp"-->
<%
Dim Action
Action = LCase(Request.QueryString("action"))
DvBoke.LoadPage("reg.xslt")
If DvBoke.System_Setting(0)<>"1" Then
	DvBoke.ShowCode(41)
	DvBoke.ShowMsg(0)
Else
	Select Case Action
	Case "savereg"
		If Dvbbs.UserID = 0 Then
			DvBoke.ShowCode(45)
			DvBoke.ShowMsg(0)
		End If
		If DvBoke.BokeUserID > 0 Then
			DvBoke.ShowCode(44)
			DvBoke.ShowMsg(0)
		Else
			DvBoke.Stats = "申请博客"
			DvBoke.Nav(1)
			Page_Savereg()
		End If
	Case "logout"
		Page_Logout()
	Case Else
		If Dvbbs.UserID = 0 Then
			DvBoke.ShowCode(45)
			DvBoke.ShowMsg(0)
		End If
		If DvBoke.BokeUserID > 0 Then
			DvBoke.ShowCode(44)
			DvBoke.ShowMsg(0)
		Else
			DvBoke.Stats = "申请博客"
			DvBoke.Nav(1)
			Page_Reg()
		End If
	End Select
End If
DvBoke.Footer
Dvbbs.PageEnd()
Sub Page_Logout()
	Session("BokeManage") = Empty
	Response.Redirect "boke.asp"
End Sub

Sub Page_Reg()
	Dim PageHtml
	PageHtml = DvBoke.Page_Strings(0).text
	PageHtml = Replace(PageHtml,"{$RegMsg}",DvBoke.Page_Strings(6).text)
	PageHtml = Replace(PageHtml,"{$UserName}",DvBoke.UserName)
'	If DvBoke.System_Setting(3) = "0" Then
'		PageHtml = Replace(PageHtml,"{$getcode}","")
'	Else
'		PageHtml = Replace(PageHtml,"{$getcode}",DvBoke.Page_Strings(1).text)
'		Dvbbs.LoadTemplates("")
'		PageHtml = Replace(PageHtml,"{$Dv_GetCode}",Dvbbs.GetCode)
'	End If
	Response.Write PageHtml
End Sub

Sub Page_Savereg()
	Dim NickName,BokeName,Password,BokeTitle,BokeCTitle,CodeStr,tRs
	'数据验证
	If Dvbbs.UserID = 0 Then Dvbbs.AddErrCode(42):Dvbbs.Showerr()
	If Not DvBoke.ChkPost() Then DvBoke.ShowCode(2):DvBoke.ShowMsg(0)

	NickName = Request.Form("NickName")
	BokeName = DvBoke.Checkstr(Lcase(Request.Form("BokeName")))	'唯一
	Password = Request.Form("BokePassWord")
	BokeTitle = Request.Form("BokeTitle")
	BokeCTitle = Request.Form("BokeCTitle")

	If NickName <> "" Then
		If strLength(NickName)>50 or strLength(NickName)<1 Then
			DvBoke.ShowCode(8)
		Else
			NickName = Server.Htmlencode(NickName)
		End If
	Else
		NickName = Dvbbs.MemberName
	End If
	If CheckNotIsEn(BokeName) = True or CheckText(BokeName) = False Then
		DvBoke.ShowCode(10)
	End If
	If PassWord <> "" Then
		Password = Md5(Password,16)
	Else
		PassWord = Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userpassword").text
	End If
	If BokeTitle <> "" Then
		If strLength(BokeTitle)>150 or strLength(BokeTitle)<1 Then
			DvBoke.ShowCode(12)
		Else
			BokeTitle = Server.Htmlencode(BokeTitle)
		End If
	Else
		BokeTitle = Dvbbs.MemberName & DvBoke.Page_Strings(5).text
	End If
	If BokeCTitle <> "" Then
		If strLength(BokeCTitle)>250 or strLength(BokeCTitle)<1 Then
			DvBoke.ShowCode(12)
		Else
			BokeCTitle = Server.Htmlencode(BokeCTitle)
		End If
	Else
		BokeCTitle = DvBoke.Page_Strings(7).text
	End If
	If CheckText(NickName) = False Then DvBoke.ShowCode(9)
	DvBoke.ShowMsg(0)
	Dim Sql,Rs
	'UserID=0 ,UserName=1 ,NickName=2 ,BokeName=3 ,PassWord=4 ,BokeTitle=5 ,BokeChildTitle=6 ,BokeNote=7 ,JoinBokeTime=8 ,PageView=9 ,TopicNum=10 ,FavNum=11 ,PostNum=12 ,TodayNum=13 ,Trackbacks=14 ,SpaceSize=15 ,XmlData=16 ,SysCatID=17
	Sql  = "Select * From [Dv_Boke_User] Where UserID = "& DvBoke.UserID &" or BokeName = '"&BokeName&"'"
	If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase
	Set Rs=Dvbbs.iCreateObject("Adodb.RecordSet")
	Rs.Open Sql,Boke_Conn,1,3
	If Not Rs.Eof And Not Rs.Bof Then
		DvBoke.ShowCode(13)
		DvBoke.ShowMsg(0)
	Else
		'提取默认个人分类
		Set tRs=DvBoke.Execute("Select Top 1 * From Dv_Boke_Syscat Order By sCatID")
		'更新该分类用户数
		DvBoke.Execute("Update Dv_Boke_Syscat Set uCatNum = uCatNum + 1 Where sCatID = " & tRs("sCatID"))
		Rs.AddNew
		Rs("UserID") = DvBoke.UserID
		Rs("UserName") = DvBoke.UserName
		Rs("NickName") = NickName
		Rs("BokeName") = BokeName
		Rs("PassWord") = Password
		Rs("BokeTitle") = BokeTitle
		Rs("BokeChildTitle") = BokeCTitle
		If IsNumeric(DvBoke.System_Setting(15)) Then
			Rs("SpaceSize") = DvBoke.System_Setting(15)
		Else
			Rs("SpaceSize") = 0
		End If	
		Rs("BokeSetting")="1,0,4,15,1,2,15,15,20,12,15,10,boke/images/sex/footmark1.gif,boke/images/sex/footmark2.gif,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
		Rs("SysCatID") = tRs("sCatID")
		Rs("SkinID") = DvBoke.System_Node.getAttribute("skinid")
		Rs.Update
		tRs.Close:Set tRs=Nothing
	End If
	Rs.Close
	Set Rs=Nothing

	DvBoke.Execute("Update Dv_Boke_System Set S_UserNum = S_UserNum + 1")
	DvBoke.Update_System 1,0,0,0,0,0,Null
	DvBoke.SaveSystemCache()
	DvBoke.ShowCode(47)
	DvBoke.ShowMsg(0)
End Sub

%>