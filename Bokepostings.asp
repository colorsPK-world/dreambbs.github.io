<!--#include FILE="conn.asp"-->
<!--#include file="inc/const.asp" -->
<!--#include file="boke/config.asp"-->
<!--#include file="boke/PostCls.asp"-->
<!--#include file="boke/checkinput.asp"-->
<%
Dim Action,ActMsg
ActMsg = ""
Action = Request.QueryString("Action")

Select Case Lcase(Action)
Case "isbest"
	DvBoke.Stats = "帖子精华管理"
	DvBoke.Nav(0)
	Admin_isbest()
Case "delete"
	DvBoke.Stats = "帖子删除管理"
	DvBoke.Nav(0)
	Admin_delete()
Case "edit"
	DvBoke.Stats = "帖子编辑"
	DvBoke.Nav(0)
	Admin_Edit()
Case "reply"
	DvBoke.Stats = "回复帖子"
	DvBoke.Nav(0)
	Admin_reply()
Case "save_edit"
	DvBoke.Stats = "保存帖子编辑"
	DvBoke.Nav(0)
	Admin_SaveEdit()
Case "save_reply"
	DvBoke.Stats = "保存回复"
	DvBoke.Nav(0)
	Admin_SaveReply()
Case "visit"
	DvBoke.Stats = "添加印记"
	DvBoke.Nav(0)
	VisitMart()
Case "bokestats"
	DvBoke.Stats = "更改博客状态"
	DvBoke.Nav(0)
	BokeStats()
Case Else
	DvBoke.ShowCode(4)
	DvBoke.ShowMsg(0)
End Select
DvBoke.Footer
Dvbbs.PageEnd()
'更改博客状态
Sub BokeStats()
	If Not DvBoke.IsMaster Then
		DvBoke.ShowCode(43)
	End If
	DvBoke.ShowMsg(0)
	Dim Stats
	If DvBoke.BokeNode.getAttribute("stats")="0" Then
		Stats = 2
	Else
		Stats = 0
	End If
	DvBoke.Execute("Update [Dv_Boke_User] Set Stats="&Stats&" where UserID="&DvBoke.BokeUserID)
	DvBoke.ShowCode("博客的状态更改成功！")
	DvBoke.ShowMsg(0)
End Sub

Sub VisitMart()
	If DvBoke.UserID = 0 Then
		DvBoke.ShowCode(14)
	End If
	Dim Rootid
	Rootid = DvBoke.CheckNumeric(Request.QueryString("Rootid"))
	If Rootid = 0 Then
		DvBoke.ShowCode(4)
	End If
	DvBoke.ShowMsg(0)
	Dim Rs,Sql
	Dim VisitXml,VisitDoc,Node,attributes
	Sql = "Select VisitUser From [Dv_Boke_Topic] Where Topicid="&RootID

	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	If Dv_Boke_InDvbbsData = 1 Then
		Rs.Open Sql,Boke_Conn,1,3
	Else
		Rs.Open Sql,Conn,1,3
	End If
	DvBoke.SqlQueryNum = DvBoke.SqlQueryNum + 1
	If Rs.Eof Then
		DvBoke.ShowCode(36)
		DvBoke.ShowMsg(0)
		Exit Sub
	Else
		VisitDoc = Rs(0)
		Set VisitXml=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
		If Not VisitXml.Loadxml(VisitDoc&"") Then
			VisitXml.loadxml "<Visit/>"
		Else
			Set Node = VisitXml.DocumentElement.selectSingleNode("UserList[@uid='"&Dvboke.UserID&"']")
			If Not (Node is nothing) Then
				DvBoke.ShowCode("请不要重复添加印记")
				DvBoke.ShowMsg(0)
				Response.Redirect Request.ServerVariables("HTTP_REFERER")
				Exit Sub
			End If
		End If
		Set Node=VisitXml.createNode(1,"UserList","")
		Set attributes=VisitXml.createAttribute("uid")
		attributes.text = Dvboke.UserID
		node.attributes.setNamedItem(attributes)
		Set attributes=VisitXml.createAttribute("uname")
		attributes.text = Dvboke.UserName
		node.attributes.setNamedItem(attributes)
		Set attributes=VisitXml.createAttribute("uip")
		attributes.text = Dvboke.UserIP
		node.attributes.setNamedItem(attributes)
		Set attributes=VisitXml.createAttribute("usex")
		attributes.text = Dvboke.UserSex
		node.attributes.setNamedItem(attributes)
		Set attributes=VisitXml.createAttribute("utime")
		attributes.text = Now()
		node.attributes.setNamedItem(attributes)
		VisitXml.documentElement.appendChild(node)
		Rs(0) = VisitXml.documentElement.xml
		Rs.Update
		'Response.Write VisitXml.documentElement.xml
	End If
	Rs.Close
	Response.Redirect Request.ServerVariables("HTTP_REFERER")
End Sub

Sub Admin_Edit()
	If DvBoke.UserID = 0 Then
		DvBoke.ShowCode(14)
	End If
	Dim Rootid,PostID
	Rootid = DvBoke.CheckNumeric(Request.QueryString("Rootid"))
	PostID = DvBoke.CheckNumeric(Request.QueryString("Postid"))
	If Rootid = 0 or PostID=0 Then
		DvBoke.ShowCode(4)
	End If
	DvBoke.ShowMsg(0)
	Dim Rs,Sql
	Dim CatID,sCatID,PostUserID,Title,Content,JoinTime,sType,ParentID
	Dim PostUserName,TitleNote,IsLock,IsBest,S_Key,Weather
	Sql = "Select PostID,CatID,sCatID,ParentID,RootID,UserID,UserName,Title,Content,JoinTime,IP,sType From [Dv_Boke_Post] Where PostID="&PostID
	Set Rs = DvBoke.Execute(Sql)
	If Rs.Eof Then
		DvBoke.ShowCode(4)
		DvBoke.ShowMsg(0)
		Exit Sub
	End If
	If Rs(5)<>DvBoke.UserID and Not DvBoke.IsMaster Then
		DvBoke.ShowCode(36)
		DvBoke.ShowMsg(0)
	End If
	ParentID = Rs("ParentID")
	PostID = Rs("PostID")
	RootID = Rs("RootID") 
	CatID = Rs("CatID")
	sCatID = Rs("sCatID")
	PostUserID = Rs("UserID")
	Title = Rs("Title")
	Content = Rs("Content")
	JoinTime = Rs("JoinTime")
	sType = Rs("sType")
	PostUserName = Rs("UserName")
	Rs.Close
	If ParentID = 0 Then
		Set Rs =  DvBoke.Execute("Select TitleNote,IsLock,IsBest,S_Key,Weather From Dv_Boke_Topic Where Topicid = "&RootID)
		If Not Rs.Eof Then
			TitleNote = Rs(0)
			IsLock= Rs(1)
			IsBest= Rs(2)
			S_Key= Rs(3)
			Weather= Rs(4)
		End If
		Rs.Close
	End If
	Set Rs = Nothing
	'-------------------------------------
	Dim DvCode
	Set DvCode = New DvBoke_UbbCode
		Content = DvCode.FormatPostCode(Content)
	Set DvCode = Nothing
	'-------------------------------------
	Dim DvBokePost
	Set DvBokePost = New Cls_DvBoke_Post
	DvBokePost.Action = "Bokepostings.asp?user="&DvBoke.BokeName&"&action=save_edit"
	DvBokePost.EditMode = "Default"
	DvBokePost.Show_Upload = 1
	If ParentID = 0 Then
		DvBokePost.IsTopic = 1
		DvBokePost.IsBest = IsBest
		DvBokePost.IsLock = IsLock
		DvBokePost.Weather = Weather
		DvBokePost.SearchKey = S_Key
		DvBokePost.PostTitleNote = TitleNote
	End If
	DvBokePost.PostID = PostID
	DvBokePost.RootID = RootID
	DvBokePost.sType = sType
	DvBokePost.CatID = CatID
	DvBokePost.sCatID = sCatID
	DvBokePost.Title = Title
	DvBokePost.Content = Content
	DvBokePost.PostUserName = PostUserName
	DvBokePost.JoinTime = JoinTime
	DvBokePost.LoadForm()
	DvBokePost.ShowForm
	Set DvBokePost = Nothing
End Sub

Sub Admin_reply()
	If DvBoke.System_Setting(2)<>"1" and DvBoke.UserID=0 Then
		DvBoke.ShowCode(4)
	End If
	If Not DvBoke.IsBokeOwner and Dvboke.BokeSetting(4)="0" Then
		DvBoke.ShowCode(4)
	End If
	DvBoke.ShowMsg(0)
	Dim Rootid,PostID,P_PostUserName
	Rootid = DvBoke.CheckNumeric(Request.QueryString("Rootid"))
	PostID = DvBoke.CheckNumeric(Request.QueryString("Postid"))
	If Rootid = 0 or PostID=0 Then
		DvBoke.ShowCode(4)
	End If
	DvBoke.ShowMsg(0)
	If DvBoke.UserID=DvBoke.BokeUserID and DvBoke.UserID>0 Then
		P_PostUserName = DvBoke.BokeUserName
	Else
		P_PostUserName = DvBoke.UserName
	End If
	
	Dim DvBokePost
	Set DvBokePost = New Cls_DvBoke_Post
	DvBokePost.Action = "Bokepostings.asp?user="&DvBoke.BokeName&"&action=save_reply"
	If DvBoke.IsBokeOwner or DvBoke.IsMaster Then
		DvBokePost.EditMode = "Default"
		DvBokePost.Show_Upload = 1
	Else
		DvBokePost.EditMode = "Basic"
	End If
	DvBokePost.PostID = PostID
	DvBokePost.RootID = RootID
	DvBokePost.PostUserName = P_PostUserName
	DvBokePost.LoadForm()
	DvBokePost.ShowForm
	Set DvBokePost = Nothing
End Sub

Sub Admin_SaveEdit()
	If DvBoke.UserID = 0 Then
		DvBoke.ShowCode(14)
	End If
	Dim P_Title,P_SearchKey,P_DDateTime,P_sType,P_sCatID,P_Catid,P_Lock,P_Best,P_PostContent,P_PostTitleNote,P_Weather
	Dim PostID,RootID
	Dim P_UpFileID,HaveUpFile,IsTopic
	'-----------------------------------------------------------------------------
	'获取表单数据 ----------------------------------------------------------------
	'-----------------------------------------------------------------------------
	P_Title = DvBoke.Checkstr(Trim(Request.Form("Title")))
	P_SearchKey = DvBoke.Checkstr(Trim(Request.Form("SearchKey")))
	P_DDateTime = Trim(Request.Form("DDateTime"))
	P_sType = DvBoke.CheckNumeric(Request.Form("sType"))
	P_sCatID =  DvBoke.CheckNumeric(Request.Form("sCatID"))
	P_Catid =  Request.Form("Catid")
	P_Lock =  DvBoke.CheckNumeric(Request.Form("Lock"))
	P_Best =  DvBoke.CheckNumeric(Request.Form("Best"))
	P_PostContent = CheckAlipay()
	If P_PostContent = "" Then P_PostContent = DvBoke.Checkstr(Request.Form("PostContent"))
	P_PostTitleNote = DvBoke.Checkstr(Request.Form("PostTitleNote"))
	PostID =  DvBoke.CheckNumeric(Request.Form("PostID"))
	RootID =  DvBoke.CheckNumeric(Request.Form("RootID"))
	P_Weather = DvBoke.CheckNumeric(Request.Form("Weather"))
	P_UpFileID = Request.Form("upfilerename")

	If P_UpFileID <>"" Then
		HaveUpFile = 1
		P_UpFileID = Replace(P_UpFileID,"'","")
		P_UpFileID=Replace(P_UpFileID,";","")
		P_UpFileID=Replace(P_UpFileID,"--","")
		P_UpFileID=Replace(P_UpFileID,")","")
		Dim fixid
		fixid=Replace(P_UpFileID," ","")
		fixid=Replace(fixid,",","")
		If Not IsNumeric(fixid) or fixid="" Then HaveUpFile=0
		P_UpFileID=left(P_UpFileID,Len(P_UpFileID)-1)
	Else
		HaveUpFile=0
	End If
	'-----------------------------------------------------------------------------
	'数据验证 --------------------------------------------------------------------
	'-----------------------------------------------------------------------------
	If Not DvBoke.ChkPost() Then DvBoke.ShowCode(2):DvBoke.ShowMsg(0)
	If StrLength(P_Title)>250 or StrLength(P_Title)="" Then
		DvBoke.ShowCode(30)
	End If
	If StrLength(P_PostTitleNote)>250 Then
		DvBoke.ShowCode(30)
	End If
	If StrLength(P_SearchKey)>250 Then
		DvBoke.ShowCode(31)
	End If

	If P_DDateTime<>"" and IsDate(P_DDateTime) Then
		P_DDateTime = Cdate(FormatDateTime(P_DDateTime,1)&FormatDateTime(Now(),3))
	Else
		P_DDateTime = Cdate(FormatDateTime(Now(),1)&FormatDateTime(Now(),3))
	End If

	If StrLength(P_PostContent)="" Then
		DvBoke.ShowCode(35)
	Else
		P_PostContent = Replace(P_PostContent,vbNewLine,"")
	End If

	'-------------------------------------
	Dim DvCode,FoundCode
	FoundCode = Dvbbs.CodeIsTrue()
	Set DvCode = New DvBoke_UbbCode
		P_PostContent = DvCode.FormatCode(P_PostContent)
	'-------------------------------------

	' PostID,CatID,sCatID,ParentID,RootID,UserID,UserName,Title,Content,JoinTime,IP,sType
	Dim Sql,Rs,ParentID
	Sql = "Select * From [Dv_Boke_Post] Where PostID="&PostID
	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	If Dv_Boke_InDvbbsData = 1 Then
		Rs.Open Sql,Boke_Conn,1,3
	Else
		Rs.Open Sql,Conn,1,3
	End If
	DvBoke.SqlQueryNum = DvBoke.SqlQueryNum + 1
	If Rs.Eof Then
		DvBoke.ShowCode(36)
		DvBoke.ShowMsg(0)
		Exit Sub
	Else
		If Rs("UserID")<>DvBoke.UserID and Not DvBoke.IsMaster Then
			DvBoke.ShowCode(36)
			DvBoke.ShowMsg(0)
		End If
		ParentID = Rs("ParentID")
		If (Not FoundCode) And ParentID = 0 And DvBoke.System_Setting(4) = "1" Then
			DvBoke.ShowCode(7)
		End If
		If (Not FoundCode) And ParentID <> 0 And DvBoke.System_Setting(5) = "1" Then
			DvBoke.ShowCode(7)
		End If
		DvBoke.ShowMsg(0)
		Rs("Title") = P_Title
		Rs("Content") = P_PostContent
		If ParentID = 0 Then
			If P_sType < 0 or P_sType > 4 Then
				DvBoke.ShowCode(32)
			End If
			If P_sCatID = -1 Then
				DvBoke.ShowCode(33)
			End If
			If P_Catid = "-1" or P_Catid ="" or not Isnumeric(P_Catid) Then
				DvBoke.ShowCode(34)
			Else
				P_Catid = DvBoke.CheckNumeric(P_Catid)
			End If
			DvBoke.ShowMsg(0)
			Rs("CatID") = P_Catid
			Rs("sCatID") = P_sCatID
			Rs("sType") = P_sType
			Rs("JoinTime") = P_DDateTime
			Rs("IsUpfile") = HaveUpFile
		End If
		Rs.Update
	End If
	Rs.Close

	If ParentID = 0 Then
		IsTopic = 0
		Sql = "Select * From [Dv_Boke_Topic] Where Topicid="&Rootid
		Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
		If Dv_Boke_InDvbbsData = 1 Then
			Rs.Open Sql,Boke_Conn,1,3
		Else
			Rs.Open Sql,Conn,1,3
		End If
		DvBoke.SqlQueryNum = DvBoke.SqlQueryNum + 1
		If Rs.Eof Then
			DvBoke.ShowCode(36)
			DvBoke.ShowMsg(0)
			Exit Sub
		Else
			Rs("CatID") = P_Catid
			Rs("sCatID") = P_sCatID
			Rs("Title") = P_Title
			Rs("TitleNote") = P_PostTitleNote
			Rs("IsLock") = P_Lock
			Rs("sType") = P_sType
			Rs("IsBest") = P_Best
			Rs("S_Key") = P_SearchKey
			Rs("Weather") = P_Weather
			Rs("PostTime") = P_DDateTime	'
			Rs.Update
		End If
		Rs.Close
		Sql = "Update [Dv_Boke_Post] Set CatID = "&P_Catid&",sCatID = "&P_sCatID&",sType = "&P_sType&",IsLock="&P_Lock&" Where RootID="&Rootid
		DvBoke.Execute Sql
		ActMsg = "主题《"&P_Title&"》编辑成功！"
	Else
		IsTopic = 1
		ActMsg = "回复帖子编辑成功！"
	End If

	''CatID,sType,TopicID,PostID,IsTopic,Title,FileNote,IsLock
	If HaveUpFile = 1 THen
		Sql = "Update Dv_Boke_Upfile Set CatID="&P_Catid&",sType="&P_sType&",TopicID="&RootID&",PostID="&PostID&",IsTopic="&IsTopic&",Title='"&P_Title&"',FileNote='"&P_PostTitleNote&"',IsLock="&P_Lock&" where id in ("&P_UpFileID&")"
		DvBoke.Execute Sql
	End If

	'----------------------------------------------------------------
	Dim Node
	Set Node = DvBoke.BokeCat.selectSingleNode("xml/boketopic/rs:data/z:row[@topicid='"&RootID&"']")
	If Not (Node Is Nothing) Then
		If ParentID = 0 Then
			If P_PostTitleNote="" or IsNull(P_PostTitleNote) Then
				If Len(P_PostContent) > 250 Then
					P_PostTitleNote = SplitLines(P_PostContent,DvBoke.BokeSetting(2))
				Else
					P_PostTitleNote = P_PostContent
				End If
			End If
			P_PostTitleNote = DvCode.UbbCode(P_PostTitleNote) & "...<br/>[<a href="""&DvBoke.ModHtmlLinked&DvBoke.BokeName&".showtopic."&Rootid&".html"">阅读全文</a>]"
			Node.attributes.getNamedItem("titlenote").text = P_PostTitleNote
			Node.attributes.getNamedItem("title").text = P_Title
		End If
		Node.attributes.getNamedItem("lastposttime").text = Now()
		DvBoke.Execute("Update Dv_Boke_User set XmlData = '"&Replace(DvBoke.BokeCat.documentElement.xml,"'","''")&"' where UserID="&DvBoke.BokeUserID)
	End If
	'----------------------------------------------------------------
	Set DvCode = Nothing
	Select Case DvBoke.BokeSetting(5)
	Case "0"
		DvBoke.RefreshID = 0
	Case "1"
		DvBoke.RefreshID = -1
	Case Else
		DvBoke.RefreshID = RootID
	End Select
	DvBoke.ShowCode(ActMsg)
	DvBoke.ShowMsg(0)
End Sub

Sub Admin_SaveReply()
	If Not DvBoke.ChkPost() Then DvBoke.ShowCode(2):DvBoke.ShowMsg(0)
	Dim P_Title,P_PostContent,P_PostUserName
	Dim RootID,Topic,CatID,sCatID,Stype,TopicUserID,ParentID,TopicChild
	Dim Sql,Rs
	Dim P_UpFileID,HaveUpFile,IsTopic,IsLock

	If DvBoke.System_Setting(2)<>"1" and DvBoke.UserID=0 Then
		DvBoke.ShowCode(4)
	End If
	If Not DvBoke.IsBokeOwner and Dvboke.BokeSetting(4)="0" Then
		DvBoke.ShowCode(4)
	End If
	DvBoke.ShowMsg(0)
	'-----------------------------------------------------------------------------
	'获取表单数据 ----------------------------------------------------------------
	'-----------------------------------------------------------------------------
	P_PostUserName = DvBoke.Checkstr(Trim(Request.Form("PostUserName")))
	P_Title = DvBoke.Checkstr(Trim(Request.Form("Title")))
	P_PostContent = CheckAlipay()
	If P_PostContent = "" Then P_PostContent = DvBoke.Checkstr(Request.Form("PostContent"))
	RootID =  DvBoke.CheckNumeric(Request.Form("RootID"))
	P_UpFileID = Request.Form("upfilerename")
	IsTopic = 1
	If P_UpFileID <>"" Then
		HaveUpFile = 1
		P_UpFileID = Replace(P_UpFileID,"'","")
		P_UpFileID=Replace(P_UpFileID,";","")
		P_UpFileID=Replace(P_UpFileID,"--","")
		P_UpFileID=Replace(P_UpFileID,")","")
		Dim fixid
		fixid=Replace(P_UpFileID," ","")
		fixid=Replace(fixid,",","")
		If Not IsNumeric(fixid) or fixid="" Then HaveUpFile=0
		P_UpFileID=left(P_UpFileID,Len(P_UpFileID)-1)
	Else
		HaveUpFile=0
	End If
	If DvBoke.UserID=0 Then
		If P_PostUserName="" or CheckText(P_PostUserName)=false Then
			DvBoke.ShowCode(39)
		Else
			Dim FoundUser
			FoundUser = False
			Set Rs = DvBoke.Execute("Select * From [Dv_Boke_User] Where UserName ='"&P_PostUserName&"' or NickName='"&P_PostUserName&"'")
			If Not Rs.Eof Then
				FoundUser = True
			End If
			Set Rs = Dvbbs.Execute("Select * From [Dv_User] Where UserName ='"&P_PostUserName&"'")
			If Not Rs.Eof Then
				FoundUser = True
			End If
			Rs.CLose
			If FoundUser = True Then
				DvBoke.ShowCode(40)
			End If
		End If
	Else
		If DvBoke.UserID=DvBoke.BokeUserID Then
			P_PostUserName = DvBoke.BokeUserName
		Else
			P_PostUserName = DvBoke.UserName
		End If
	End If

	If Rootid = 0 Then
		DvBoke.ShowCode(4)
	End If
	If StrLength(P_PostContent)="" Then
		DvBoke.ShowCode(35)
	Else
		P_PostContent = Replace(P_PostContent,vbNewLine,"")
	End If
	If (Not Dvbbs.CodeIsTrue()) And DvBoke.System_Setting(5) = "1" Then
		DvBoke.ShowCode(7)
	End If
	DvBoke.ShowMsg(0)
	'-------------------------------------
	Dim DvCode
	Set DvCode = New DvBoke_UbbCode
		P_PostContent = DvCode.FormatCode(P_PostContent)
	Set DvCode = Nothing
	'-------------------------------------
	Sql = "Select Title,Userid,CatID,sCatID,Stype,IsLock,Child,LastPostTime From [Dv_Boke_Topic] Where Topicid="&Rootid
	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	If Dv_Boke_InDvbbsData = 1 Then
		Rs.Open Sql,Boke_Conn,1,3
	Else
		Rs.Open Sql,Conn,1,3
	End If
	DvBoke.SqlQueryNum = DvBoke.SqlQueryNum + 1
	If Rs.Eof Then
		DvBoke.ShowCode(4)
		DvBoke.ShowMsg(0)
		Exit Sub
	Else
		Select Case Rs(5)
			Case 3 '只有作者可以回复
				If Not DvBoke.IsBokeOwner Then
					DvBoke.ShowCode(38)
				End If
			Case 2	'只有管理员和作者可以回复
				If Not (DvBoke.IsMaster or DvBoke.IsBokeOwner) Then
					DvBoke.ShowCode(38)
				End If
			Case 1	'认证
				
			Case Else
		End Select
		DvBoke.ShowMsg(0)
		TopicUserID = Rs("UserID")
		Topic = Rs("Title")
		CatID = Rs("CatID")
		sCatID = Rs("sCatID")
		Stype = Rs("Stype")
		IsLock = Rs("IsLock")
		TopicChild = Rs("Child") + 1
		Rs("Child") = TopicChild
		Rs("LastPostTime") = Now()
		Rs.Update
	End If
	Rs.Close
	Set Rs = Nothing

	Dim PostID
	ParentID = DvBoke.Execute("Select PostID From [Dv_Boke_Post] Where Rootid="&Rootid&" and ParentID=0")(0)
	SQL = "INSERT INTO [Dv_Boke_Post] (ParentID,BokeUserID,CatID,sCatID,RootID,UserID,UserName,Title,Content,JoinTime,[IP],sType,IsUpfile,IsLock) Values ("&ParentID&","&TopicUserID&"," & CatID & "," & sCatID & ","& RootID &"," & DvBoke.UserID & ",'" & P_PostUserName & "','" & P_Title & "','" & P_PostContent & "',"  & bSqlNowString & ",'"& DvBoke.UserIP &"'," & Stype & "," & HaveUpFile & ","&IsLock&")"
	DvBoke.Execute Sql
	
	PostID = DvBoke.Execute("Select Top 1 PostID From [Dv_Boke_Post] order by PostID desc")(0)
	'-----------------------------------------------------------------------------------
	'用户博客 
	Sql = "Update [Dv_Boke_User] Set PostNum=PostNum+1,TodayNum=TodayNum+1,LastUpTime="&bSqlNowString&" Where UserID="&TopicUserID
	DvBoke.Execute Sql
	'博客话题
	Sql = "Update [Dv_Boke_SysCat] Set PostNum=PostNum+1,TodayNum=TodayNum+1,LastUpTime="&bSqlNowString&" Where sCatID="&sCatID
	DvBoke.Execute Sql
	'SysCatID 更新博客所属的分类
	Sql = "Update [Dv_Boke_SysCat] Set PostNum=PostNum+1,TodayNum=TodayNum+1,LastUpTime="&bSqlNowString&" Where sCatID="&DvBoke.BokeNode.getAttribute("syscatid")
	DvBoke.Execute Sql
	'用户栏目更新
	Sql = "Update [Dv_Boke_UserCat] Set PostNum=PostNum+1,TodayNum=TodayNum+1,LastUpTime="&bSqlNowString&" Where uCatID="&Catid
	DvBoke.Execute Sql
	'博客系统
	Sql = "Update [Dv_Boke_System] Set S_TodayNum=S_TodayNum+1,S_PostNum=S_PostNum+1,S_LastPostTime="&bSqlNowString
	DvBoke.Execute Sql
	'-----------------------------------------------------------------------------------

	''CatID,sType,TopicID,PostID,IsTopic,Title,FileNote,IsLock
	If HaveUpFile = 1 THen
		Sql = "Update Dv_Boke_Upfile Set CatID="&CatID&",sType="&Stype&",TopicID="&RootID&",PostID="&PostID&",IsTopic="&IsTopic&",Title='"&P_Title&"',IsLock="&IsLock&" where id in ("&P_UpFileID&")"
		DvBoke.Execute Sql
	End If
	'----------------------------------------------------------------
	Dim Node,NodeName,Nodes
	Set Node = DvBoke.BokeCat.selectSingleNode("xml/boketopic/rs:data/z:row[@topicid='"&RootID&"']")
	If Not (Node Is Nothing) Then
		Node.attributes.getNamedItem("child").text = Node.attributes.getNamedItem("child").text + 1
		Node.attributes.getNamedItem("lastposttime").text = Now()
	End If
	Set Node = DvBoke.BokeCat.selectSingleNode("xml/rs:data/z:row[@ucatid='"&Catid&"']")
	If Not (Node Is Nothing) Then
		Node.attributes.getNamedItem("postnum").text = Node.attributes.getNamedItem("postnum").text + 1
		Node.attributes.getNamedItem("lastuptime").text = Now()
	End If
	Update_PostToXml()
	'----------------------------------------------------------------
	
	'更新系统XML数据------------
	DvBoke.Update_SysCat sCatID&","&DvBoke.BokeNode.getAttribute("syscatid"),0,1,0,1,Now()
	DvBoke.Update_System 0,1,0,0,0,1,Now()
	DvBoke.SaveSystemCache()
	'更新系统XML数据------------

	ActMsg = "回复主题《"&Topic&"》成功！"
	Select Case DvBoke.BokeSetting(5)
	Case "0"
		DvBoke.RefreshID = 0
	Case "1"
		DvBoke.RefreshID = -1
	Case Else
		DvBoke.RefreshID = RootID
	End Select
	'Update_BokeTopic TopicChild,RootID,TopicUserID
	DvBoke.ShowCode(ActMsg)
	DvBoke.ShowMsg(0)
End Sub

'更新首页评论数据
Sub Update_PostToXml()
	Dim Node,XmlDoc,NodeList,ChildNode
	Set Node = DvBoke.BokeCat.selectNodes("xml/bokepost")
	If Node.Length>0 Then
		For Each NodeList in Node
			DvBoke.BokeCat.DocumentElement.RemoveChild(NodeList)
		Next
	End If
	Set Node=DvBoke.BokeCat.createNode(1,"bokepost","")
	Set XmlDoc=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
	If Not IsNumeric(DvBoke.BokeSetting(3)) Then DvBoke.BokeSetting(3) = "10"
	Dim Rs,Sql
	Sql = "Select Top "&DvBoke.BokeSetting(3)&" PostID,CatID,sCatID,ParentID,RootID,UserID,UserName,Title,Content,JoinTime,IP,sType From [Dv_Boke_Post] Where  BokeUserID="&DvBoke.BokeUserID&" and ParentID>0 and sType <>2 order by JoinTime desc"
	Set Rs = DvBoke.Execute(LCase(Sql))
	If Not Rs.Eof Then
		Rs.Save XmlDoc,1
		XmlDoc.documentElement.RemoveChild(XmlDoc.documentElement.selectSingleNode("s:Schema"))
		Set ChildNode = XmlDoc.documentElement.selectNodes("rs:data/z:row")
		For Each NodeList in ChildNode
			NodeList.attributes.getNamedItem("jointime").text = Rs("JoinTime")
			NodeList.attributes.getNamedItem("content").text = Left(Rs("content")&"",50)
			Rs.MoveNext
		Next
		Set ChildNode=XmlDoc.documentElement.selectSingleNode("rs:data")
		Node.appendChild(ChildNode)
	End If
	Rs.Close
	Set Rs = Nothing
	DvBoke.BokeCat.documentElement.appendChild(Node)
	DvBoke.Execute("Update Dv_Boke_User set XmlData = '"&Replace(DvBoke.BokeCat.documentElement.xml,"'","''")&"' where UserID="&DvBoke.BokeUserID)
End Sub

'删除操作
Sub Admin_delete()
	If DvBoke.UserID = 0 Then
		DvBoke.ShowCode(14)
	End If
	Dim Rootid,PostID,IsUpfile
	Rootid = DvBoke.CheckNumeric(Request.QueryString("Rootid"))
	PostID = DvBoke.CheckNumeric(Request.QueryString("Postid"))
	If Rootid = 0 or PostID=0 Then
		DvBoke.ShowCode(4)
	End If
	DvBoke.ShowMsg(0)
	Dim Rs,Sql
	Dim ParentID,CatID,sCatID,Title,CountNum,TopicNum,sType
	Sql = "Select PostID,CatID,sCatID,ParentID,RootID,UserID,Title,sType,IsUpfile From [Dv_Boke_Post] Where PostID="&PostID
	Set Rs = DvBoke.Execute(Sql)
	If Rs.Eof Then
		DvBoke.ShowCode(4)
		DvBoke.ShowMsg(0)
		Exit Sub
	End If
	If Not (DvBoke.IsBokeOwner or DvBoke.IsMaster) Then
		If Rs(5)<>DvBoke.UserID or Rs(5)=0 Then
			DvBoke.ShowCode(36)
			DvBoke.ShowMsg(0)
		End If
	End If

	Rootid = Rs("Rootid")
	ParentID = Rs("ParentID")
	CatID = Rs("CatID")
	sCatID = Rs("sCatID")
	sType = Rs("sType")
	IsUpfile = Rs("IsUpfile")
	Rs.Close
	Set Rs=Nothing
	Dim DTodayNum,DayStr
	DTodayNum = 0
	If Dv_Boke_DataBase = 1 Then
		DayStr = "d"
	Else
		DayStr = "'d'"
	End If
	Dim Num_T,Num_F,Num_L,Num_P
	Num_T=0
	Num_F=0
	Num_L=0
	Num_P=0
	Title = DvBoke.Execute("Select title From [Dv_Boke_Topic] Where TopicID="&Rootid)(0)
	If ParentID = 0 Then
		TopicNum = 1
		CountNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Post] Where ParentID>0 and RootID="&Rootid)(0)
		DTodayNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Post] Where RootID="&Rootid&" and datediff("&DayStr&",JoinTime,"&bSqlNowString&")=0 ")(0)
		Set Rs=DvBoke.Execute("Select * From Dv_Boke_Post Where RootID="&RootID)
		Do While Not Rs.Eof
			If Rs("IsUpfile")=1 Then DvBoke.SysDeleteFile(Rs("PostID"))
		Rs.MoveNext
		Loop
		Rs.Close:Set Rs=Nothing
		Sql = "Delete From Dv_Boke_Topic Where TopicID="&Rootid
		DvBoke.Execute(Sql)
		Sql = "Delete From [Dv_Boke_Post] Where RootID="&Rootid
		DvBoke.Execute(Sql)
		ActMsg = "主题《"& Title &"》删除成功！"
	Else
		TopicNum = 0
		CountNum = 1
		DTodayNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Post] Where PostID="&PostID&" and datediff("&DayStr&",JoinTime,"&bSqlNowString&")=0 ")(0)
		If IsUpfile=1 Then DvBoke.SysDeleteFile(PostID)
		Sql = "Delete From [Dv_Boke_Post] Where PostID="&PostID
		DvBoke.Execute(Sql)
		Sql = "Update [Dv_Boke_Topic] Set Child = Child - 1 Where TopicID="&Rootid
		DvBoke.Execute Sql
		ActMsg = "主题《"& Title &"》回复评论删除成功！"
	End If
	Select Case sType
		Case 0
			Num_T = TopicNum
		Case 1
			Num_F = TopicNum
		Case 2
			Num_L = TopicNum
		Case 4
			Num_P = TopicNum
	End Select
	Sql = "Update [Dv_Boke_User] Set TopicNum = TopicNum - "&Num_T&",FavNum=FavNum - "&Num_F&",PhotoNum=PhotoNum - "&Num_P&",PostNum= PostNum -"&CountNum&",TodayNum=TodayNum - "&DTodayNum&" Where UserID="&DvBoke.BokeUserID
	DvBoke.Execute Sql
	Sql = "Update [Dv_Boke_SysCat] Set TopicNum = TopicNum - "&TopicNum&" ,PostNum=PostNum-"&CountNum&",TodayNum=TodayNum-"&DTodayNum&" Where sCatID in ("&sCatID&","&DvBoke.BokeNode.getAttribute("syscatid")&")"
	DvBoke.Execute Sql

	Sql = "Update [Dv_Boke_UserCat] Set TopicNum = TopicNum - "&TopicNum&" ,PostNum=PostNum-"&CountNum&",TodayNum=TodayNum-"&DTodayNum&" Where uCatID="&Catid
	DvBoke.Execute Sql
	Sql = "Update [Dv_Boke_System] Set S_PostNum = S_PostNum-"&CountNum&",S_TopicNum=S_TopicNum- "&Num_T&",S_PhotoNum=S_PhotoNum-"&Num_P&",S_FavNum=S_FavNum- "&Num_F&",S_TodayNum=S_TodayNum-"&DTodayNum
	DvBoke.Execute Sql
	Update_PostToXml()
	DvBoke.LoadSetup(1)
	DvBoke.ShowCode(ActMsg)
	DvBoke.ShowMsg(0)
End Sub

'精华管理
Sub Admin_isbest()
	If DvBoke.UserID = 0 Then
		DvBoke.ShowCode(14)
	End If
	Dim Rootid
	Rootid = DvBoke.CheckNumeric(Request.QueryString("Rootid"))
	If Rootid = 0 Then
		DvBoke.ShowCode(4)
	End If
	DvBoke.ShowMsg(0)
	Dim Rs,Sql
	Sql = "Select UserID,IsBest,Title From Dv_Boke_Topic Where Topicid="&Rootid
	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	If Dv_Boke_InDvbbsData = 1 Then
		Rs.Open Sql,Boke_Conn,1,3
	Else
		Rs.Open Sql,Conn,1,3
	End If
	DvBoke.SqlQueryNum = DvBoke.SqlQueryNum + 1
	If Rs.Eof Then
		DvBoke.ShowCode(4)
		DvBoke.ShowMsg(0)
		Exit Sub
	Else
		If Rs(0)<>DvBoke.UserID and Not DvBoke.IsMaster Then
			DvBoke.ShowCode(36)
			DvBoke.ShowMsg(0)
		End If
		If Rs("IsBest")=0 Then
			Rs("IsBest")=1
			ActMsg = "主题《"&Rs(2)&"》添加为精华成功！"
		Else
			Rs("IsBest")=0
			ActMsg = "精华主题《"&Rs(2)&"》解除成功！"
		End If
		Rs.Update
	End If
	Rs.Close
	Set Rs = Nothing
	DvBoke.ShowCode(ActMsg)
	DvBoke.ShowMsg(0)
End Sub
%>