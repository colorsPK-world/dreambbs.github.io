<!--#include FILE="conn.asp"-->
<!--#include file="inc/const.asp" -->
<!--#include file="inc/md5.asp"-->
<!--#include file="boke/config.asp"-->
<!--#include file="boke/PostCls.asp"-->
<!--#include file="boke/checkinput.asp"-->
<%
If DvBoke.BokeUserID = 0 or Not DvBoke.IsBokeOwner Then
	DvBoke.ShowCode(14)
	DvBoke.ShowMsg(0)
End If
If Is_Isapi_Rewrite = 0 Then DvBoke.ModHtmlLinked = "boke.asp?"
DvBoke.LoadPage("Manage.xslt")
If Session("BokeManage") = "" Then
	If Request("Action")="Login" Then
		DvBoke.Stats = "验证用户信息"
		DvBoke.Top(0)
		Page_ChkLogin()
	Else
		DvBoke.Stats = "博客管理登陆"
		DvBoke.Nav(0)
		Page_Login()
	End If
Else
	Dim s,t,m
	Dim tStr,tStr_1,sTypeID
	s = LCase(Request.QueryString("s"))
	t = LCase(Request.QueryString("t"))
	m = LCase(Request.QueryString("m"))
	Select Case s
	Case "1"
		Select Case t
		Case "1"
			tStr = "文章"
			tStr_1 = "?s=1&t=1"
			sTypeID = 0
		Case "2"
			tStr = "收藏"
			tStr_1 = "?s=1&t=2"
			sTypeID = 1
		Case "3"
			tStr = "链接"
			tStr_1 = "?s=1&t=3"
			sTypeID = 2
		Case "4"
			tStr = "交易"
			tStr_1 = "?s=1&t=4"
			sTypeID = 3
		Case "5"
			tStr = "相册"
			tStr_1 = "?s=1&t=5"
			sTypeID = 4
		Case Else
			tStr = "文章"
			tStr_1 = "?s=1&t=1"
			sTypeID = 0
		End Select
		DvBoke.Stats = "博客管理 - " & tStr
		DvBoke.Top(0)
		Page_Nav_Left()
		Page_UserInput()
	Case "2"
		tStr = "评论管理"
		DvBoke.Stats = "博客管理 - " & tStr
		DvBoke.Top(0)
		Page_Nav_Left()
		Page_UserPost()
	Case "3"
		tStr = "文件管理"
		DvBoke.Stats = "博客管理 - " & tStr
		DvBoke.Top(0)
		Page_Nav_Left()
		Page_UserFile()
	Case "4"
		tStr = "模板管理"
		DvBoke.Stats = "博客管理 - " & tStr
		DvBoke.Top(0)
		Page_Nav_Left()
		If Request.QueryString("action")="Saveskin" Then
			Page_SaveSkins()
		Else
			Page_SkinSetting()
		End If
	Case "5"
		Select Case t
		Case "1"
			tStr = "个人资料"
		Case "2"
			tStr = "博客密码"
		Case "3"
			tStr = "博客设置"
		Case "4"
			tStr = "关键字设置"
		Case Else
			tStr = "个人资料"
		End Select
		DvBoke.Stats = "博客管理 - 个人配置 - " & tStr
		DvBoke.Top(0)
		Page_Nav_Left()
		Page_UserSetting()
	Case "6"	'数据更新
		Select Case t
			Case "1"
			tStr = "频道更新"
		End Select
		DvBoke.Stats = "博客管理 - 数据更新 - " & tStr
		DvBoke.Top(0)
		Page_Nav_Left()
		Page_Upate()
	Case "7"	'数据统计
		DvBoke.Stats = "博客管理 - 数据更新 - " & tStr
		DvBoke.Top(0)
		Page_Nav_Left()
		Page_Count()
	Case Else
		DvBoke.Stats = "博客管理"
		DvBoke.Top(0)
		Page_Nav_Left()
		Page_Manage()
	End Select
End If
DvBoke.Footer
Dvbbs.PageEnd()
Sub Page_Login()
	Dim PageHtml
	Dim Comeurl,tmpstr
	If Request("f")<>"" Then
		Comeurl=Request("f")
	ElseIf Request.ServerVariables("QUERY_STRING")<>"" Then 
		Comeurl = "BokeManage.asp?" & Request.ServerVariables("QUERY_STRING")
	Else
		Comeurl="BokeManage.asp"
	End If
	PageHtml = DvBoke.Page_Strings(0).text
	PageHtml = Replace(PageHtml,"{$UserMsg}",DvBoke.Page_Strings(1).text)
	PageHtml = Replace(PageHtml,"{$UserName}",DvBoke.UserName)
	PageHtml = Replace(PageHtml,"{$ComeUrl}",Comeurl)
	Dvbbs.LoadTemplates("")
	PageHtml = Replace(PageHtml,"{$Dv_GetCode}",Dvbbs.GetCode)
	Response.Write PageHtml
End Sub

Sub Page_ChkLogin()
	Dim PassWord,f
	'数据验证
	If Not DvBoke.ChkPost() Then DvBoke.ShowCode(2):DvBoke.ShowMsg(0)
	If Not Dvbbs.CodeIsTrue() Then
		DvBoke.ShowCode(7)
		DvBoke.ShowMsg(0)
	End If
	PassWord = Request.Form("PassWord")
	If PassWord = "" Or IsNull(PassWord) Then
		DvBoke.ShowCode(11)
	Else
		Password = Md5(Password,16)
	End If 
	DvBoke.ShowMsg(0)
	f = Request("f")
	If f = "" Or IsNull(f) Then f = "BokeManage.asp"
	Dim Rs
	Set Rs = DvBoke.Execute("Select PassWord From Dv_Boke_User Where UserID = " & DvBoke.UserID)
	If Rs.Eof And Rs.Bof Then
		DvBoke.ShowCode(4)
		DvBoke.ShowMsg(0)
	Else
		If Rs(0)=PassWord Then
			Session("BokeManage") = DvBoke.UserID
			Session.Timeout = 40
			Response.Redirect f
		Else
			DvBoke.ShowCode(15)
			DvBoke.ShowMsg(0)
		End If
	End If
	Rs.Close
	Set Rs=Nothing
End Sub

Sub Page_Nav_Left()
	Response.Write Replace(Replace(DvBoke.Page_Strings(2).text,"{$bokeurl}",DvBoke.ModHtmlLinked),"{$bokename}",DvBoke.BokeName)
	Response.Write DvBoke.Page_Strings(3).text
End Sub

Sub Page_Manage()
	Dim Html,Node,Tempstr
	Html = DvBoke.Page_Strings(4).text
	'------------------
	Set Node = DvBoke.SystemDoc.documentElement.selectSingleNode("/bokesystem/managenews")
	If Node Is Nothing Then
		Tempstr = ""
	Else
		Tempstr = Node.text
	End If
	Html = Replace(Html,"{$sysmessage}",Tempstr)
	'------------------
	Response.Write Html
End Sub

Sub Page_UserInput()
	Dim PageHtml,UserPageInput
	PageHtml = DvBoke.Page_Strings(5).text
	Select Case m
	Case "1"	'发表文章
		Select Case LCase(Request("Action"))
			Case "savepost"
				Post_Save(0)
			Case Else
				UserPageInput = Post_News
		End Select
	Case "2"
		If Request.QueryString("Action") = "Save" Then
			Page_UserInput_Cat_Save()
		ElseIf Request.QueryString("Action") = "Del" Then
			Page_UserInput_Cat_Del()
		Else
			UserPageInput = Page_UserInput_Cat()
		End If
	Case "3"
		If Request.QueryString("Action") = "Del" Then
			UserPageInput = Page_UserInput_mTopic_Del()
		Else
			UserPageInput = Page_UserInput_mTopic()
		End If
	Case Else
		UserPageInput = Page_UserInput_mTopic()
	End Select
	PageHtml = Replace(PageHtml,"{$UserInputInfo}",UserPageInput)
	PageHtml = Replace(PageHtml,"{$UserAction}",tStr)
	PageHtml = Replace(PageHtml,"{$UserAction_1}",tStr_1)
	Response.Write PageHtml
End Sub

Sub Page_UserPost()
	Dim UserPageInput
	If Request.QueryString("Action") = "Del" Then
		UserPageInput = Page_UserInput_mPost_Del()
	Else
		UserPageInput = Page_UserInput_mPost()
	End If
	Response.Write UserPageInput
End Sub

Sub Page_Upate()
	Update_UserCatToXml()
	DvBoke.ShowMsg(0)
End Sub


'添加文章
Function Post_News()
	Dim PageHtml
	Dim Stype
	Dim Cat_Val
	Dim DvBokePost
	Dim Rs
	Stype = t-1
	Set Rs=DvBoke.Execute("Select uCatID From Dv_Boke_UserCat Where UserID = "&DvBoke.BokeUserID&" And uType = " & sType)
	If Rs.Eof And Rs.Bof Then
		Rs.Close:Set Rs=Nothing
		DvBoke.ShowCode(54)
		DvBoke.ShowMsg(2)
		Post_News = Replace(DvBoke.InputShowMsg,"{$t}",sType + 1)
		Exit Function
	End If
	Set DvBokePost = New Cls_DvBoke_Post
	DvBokePost.Action = "?s="&s&"&t="&t&"&m="&m&"&action=savepost"
	DvBokePost.EditMode = "Default"
	DvBokePost.Show_Upload = 1	'允许上传
	DvBokePost.IsTopic = 1
	DvBokePost.sType = Stype
	DvBokePost.PostUserName = DvBoke.BokeUserName
	DvBokePost.JoinTime = FormatDateTime(Now(),1)
	DvBokePost.LoadForm()
	PageHtml = DvBokePost.FormHtml
	Set DvBokePost = Nothing
	Post_News = PageHtml
End Function

'Act 0=保存新帖
Sub Post_Save(Act)
	Dim P_Title,P_SearchKey,P_DDateTime,P_sType,P_sCatID,P_Catid,P_Lock,P_Best,P_PostContent,P_PostTitleNote,P_Weather,P_iWeather
	Dim P_UpFileID,HaveUpFile
	Dim PostID,RootID

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
	P_Weather = Request.Form("Weather")

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
	If StrLength(P_SearchKey)>250 Then
		DvBoke.ShowCode(31)
	End If

	If P_DDateTime<>"" and IsDate(P_DDateTime) Then
		P_DDateTime = Cdate(FormatDateTime(P_DDateTime,1)&FormatDateTime(Now(),3))
	Else
		P_DDateTime = Cdate(FormatDateTime(Now(),1)&FormatDateTime(Now(),3))
	End If
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
	If StrLength(P_PostContent)="" Then
		DvBoke.ShowCode(35)
	Else
		P_PostContent = Replace(P_PostContent,vbNewLine,"")
	End If
	If P_Weather <> "" Then
		P_iWeather = Split(P_Weather,"|")
		If Ubound(P_iWeather) = 1 Then
			P_Weather = DvBoke.CheckNumeric(P_iWeather(1))
		Else
			P_Weather = 0
		End If
	Else
		P_Weather = 0
	End If

	DvBoke.ShowMsg(0)
	If (Not Dvbbs.CodeIsTrue()) And DvBoke.System_Setting(4) = "1" Then
		DvBoke.ShowCode(7)
		DvBoke.ShowMsg(0)
	End If
	'-------------------------------------
	Dim DvCode
	Set DvCode = New DvBoke_UbbCode
		P_PostContent = DvCode.FormatCode(P_PostContent)
	Set DvCode = Nothing
	'-------------------------------------
	Dim Num_T,Num_F,Num_L,Num_P
	Num_T=0
	Num_F=0
	Num_L=0
	Num_P=0
	Select Case P_sType
	Case 0
		Num_T = 1
	Case 1
		Num_F=1
	Case 2
		Num_L=1
	Case 4
		Num_P=1
	End Select
	'-----------------------------------------------------------------------------
	'数据处理 --------------------------------------------------------------------
	'-----------------------------------------------------------------------------
	'TopicID,CatID,sCatID,UserID,UserName,Title,TitleNote,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,LastPoster,LastPostID,IsBest,S_Key,Weather

	'数据表[Dv_Boke_Topic]：TopicID=0 ,CatID=1 ,sCatID=2 ,UserID=3 ,UserName=4 ,Title=5 ,TitleNote=6 ,PostTime=7 ,Child=8 ,Hits=9 ,IsView=10 ,IsLock=11 ,sType=12 ,LastPostTime=13 ,LastPoster=14 ,LastPostID=15 ,IsBest=16 ,S_Key=17

	'PostID,CatID,sCatID,ParentID,RootID,UserID,UserName,Title,Content,JoinTime,IP,sType,Weather

	'数据表[Dv_Boke_Post]：PostID=0 ,CatID=1 ,sCatID=2 ,ParentID=3 ,RootID=4 ,UserID=5 ,UserName=6 ,Title=7 ,Content=8 ,JoinTime=9 ,IP=10 ,sType=11
	Dim Rs,Sql
	If Act = 0 Then
		SQL = "INSERT INTO [Dv_Boke_Topic] (CatID,sCatID,UserID,UserName,Title,TitleNote,PostTime,IsLock,sType,LastPostTime,IsBest,S_Key,Weather) Values (" & P_Catid & "," & P_sCatID & "," & DvBoke.BokeUserID & ",'" & DvBoke.BokeUserName & "','" & P_Title & "','" & P_PostTitleNote & "','"  & P_DDateTime & "',"& P_Lock &"," & P_sType & ",'"& P_DDateTime &"',"& P_Best &",'"& P_SearchKey &"',"& P_Weather &")"
		DvBoke.Execute Sql
		RootID = DvBoke.Execute("Select Top 1 TopicID From [Dv_Boke_Topic] order by TopicID desc")(0)
		

		SQL = "INSERT INTO [Dv_Boke_Post] (CatID,sCatID,RootID,UserID,UserName,Title,Content,JoinTime,[IP],sType,IsUpfile,BokeUserID,IsLock) Values (" & P_Catid & "," & P_sCatID & ","& RootID &"," & DvBoke.BokeUserID & ",'" & DvBoke.BokeUserName & "','" & P_Title & "','" & P_PostContent & "','"  & P_DDateTime & "','"& DvBoke.UserIP &"'," & P_sType & "," & HaveUpFile & ","&DvBoke.BokeUserID&","&P_Lock&")"
		DvBoke.Execute Sql
		PostID = DvBoke.Execute("Select Top 1 PostID From [Dv_Boke_Post] order by PostID desc")(0)

		Sql = "Update [Dv_Boke_User] Set TopicNum = TopicNum + "&Num_T&",FavNum=FavNum + "&Num_F&",PhotoNum=PhotoNum+"&Num_P&",TodayNum=TodayNum+1,LastUpTime="&bSqlNowString&" Where UserID="&DvBoke.BokeUserID
		DvBoke.Execute Sql

		Sql = "Update [Dv_Boke_SysCat] Set TopicNum = TopicNum + "&Num_T&",TodayNum=TodayNum+1,LastUpTime="&bSqlNowString&" Where sCatID in ("&P_sCatID&","&DvBoke.BokeNode.getAttribute("syscatid")&")"
		DvBoke.Execute Sql

		Sql = "Update [Dv_Boke_UserCat] Set TopicNum = TopicNum + 1,TodayNum=TodayNum+1,LastUpTime="&bSqlNowString&" Where uCatID="&P_Catid
		DvBoke.Execute Sql

		Sql = "Update [Dv_Boke_System] Set S_TopicNum=S_TopicNum+ "&Num_T&",S_PhotoNum=S_PhotoNum+"&Num_P&",S_FavNum=S_FavNum+ "&Num_F&",S_TodayNum=S_TodayNum+1,S_LastPostTime="&bSqlNowString
		DvBoke.Execute Sql
		''CatID,sType,TopicID,PostID,IsTopic,Title,FileNote,IsLock
		If HaveUpFile = 1 THen
			Sql = "Update Dv_Boke_Upfile Set CatID="&P_Catid&",sType="&P_sType&",TopicID="&RootID&",PostID="&PostID&",IsTopic=0,Title='"&P_Title&"',FileNote='"&P_PostTitleNote&"',IsLock="&P_Lock&" where id in ("&P_UpFileID&")"
			DvBoke.Execute Sql
		End If
		Update_TopicToXml()
		'更新系统XML数据------------
		DvBoke.Update_SysCat P_Catid&","&DvBoke.BokeNode.getAttribute("syscatid"),0,1,Num_T,0,Now()
		DvBoke.Update_System 0,1,Num_F,Num_P,Num_T,0,Now()
		DvBoke.SaveSystemCache()
		'更新系统XML数据------------

		DvBoke.ShowCode(37)
		DvBoke.ShowMsg(0)
	End If

	If Not (Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@cachebokebody") Is Nothing) Then
		Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@cachebokebody").text = ""
	End If
	If Not (Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@cacheboketopic") Is Nothing) Then
		Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@cacheboketopic").text = ""
	End If

End Sub

'用户栏目设置
Function Page_UserInput_Cat()
	Dim PageHtml,PageHtml_Str,Rs
	PageHtml = DvBoke.Page_Strings(12).text
	If Request("uCatID")<>"" And IsNumeric(Request("uCatID")) Then
		Set Rs = DvBoke.Execute("Select * From Dv_Boke_UserCat Where uCatID = " & Request("uCatID") & " And uType = " & sTypeID & " And UserID = " & DvBoke.UserID)
		If Not (Rs.Eof And Rs.Bof) Then
			PageHtml = Replace(PageHtml,"{$uCatID}",Rs("uCatID"))
			PageHtml = Replace(PageHtml,"{$uCatTitle}",Rs("uCatTitle"))
			PageHtml = Replace(PageHtml,"{$uCatNote}",Rs("uCatNote"))
			If Rs("IsView")=1 Then
				PageHtml = Replace(PageHtml,"{$IsView}","checked")
			Else
				PageHtml = Replace(PageHtml,"{$IsView}","")
			End If
			PageHtml = Replace(PageHtml,"{$uType}",Rs("uType"))
		End If
		Rs.Close
		Set Rs = Nothing
	End If
	PageHtml = Replace(PageHtml,"{$uCatID}","0")
	PageHtml = Replace(PageHtml,"{$uCatTitle}","")
	PageHtml = Replace(PageHtml,"{$uCatNote}","")
	PageHtml = Replace(PageHtml,"{$IsView}","checked")
	PageHtml = Replace(PageHtml,"{$uType}",sTypeID)
	Set Rs = DvBoke.Execute("Select * From Dv_Boke_UserCat Where UserID = " & DvBoke.UserID & " And uType = " & sTypeID & " Order By uCatID")
	If Not (Rs.Eof And Rs.Bof) Then
		Do While Not Rs.Eof
			PageHtml_Str = PageHtml_Str & "<ul>"
			PageHtml_Str = PageHtml_Str & "<li class=""Set3"">"&Rs("uCatTitle")&"</li>"
			'PageHtml_Str = PageHtml_Str & "<li class=""Set3"">"&DvBoke.Cat_Type(Rs("utype"))&"</li>"
			PageHtml_Str = PageHtml_Str & "<li class=""Set5"">"&Left(Rs("uCatNote"),35)&"</li>"
			PageHtml_Str = PageHtml_Str & "<li class=""Set3""><a href="""&tStr_1&"&m=2&uCatID="&Rs("uCatID")&""">编辑</a>&nbsp;&nbsp;<a href=""#"" onclick=""alertreadme('您确定删除栏目 "&Rs("uCatTitle")&" 吗?','"&tStr_1&"&m=2&Action=Del&uCatID="&Rs("uCatID")&"')"">删除</a></li>"
			PageHtml_Str = PageHtml_Str & "</ul>"
		Rs.MoveNext
		Loop
	End If
	Rs.Close
	Set Rs=Nothing
	PageHtml = Replace(PageHtml,"{$InfoList}",PageHtml_Str)
	Page_UserInput_Cat = PageHtml
End Function

'保存用户栏目设置
Sub Page_UserInput_Cat_Save()
	Dim uCatID,uCatTitle,uCatNote,IsView,sType
	uCatID = Request.Form("uCatID")
	uCatTitle = DvBoke.CheckStr(Request.Form("uCatTitle"))
	uCatNote = DvBoke.CheckStr(Request.Form("uCatNote"))
	IsView = Request.Form("IsView")
	sType = Request.Form("sType")

	If uCatID = "" Or Not IsNumeric(uCatID) Then uCatID = 0
	uCatID = cCur(uCatID)
	If IsView = "" Or Not IsNumeric(IsView) Then IsView = 0
	IsView = Cint(IsView)
	If sType = "" Or Not IsNumeric(sType) Then sType = 0
	sType = Cint(sType)
	If uCatTitle = "" Then
		DvBoke.ShowCode(25)
	Else
		uCatTitle = Server.HtmlEncode(uCatTitle)
	End If
	If uCatNote <> "" Then uCatNote = Server.HtmlEncode(uCatNote)
	DvBoke.ShowMsg(0)
	If uCatID > 0 Then
		DvBoke.Execute("Update Dv_Boke_UserCat Set uCatTitle = '"&uCatTitle&"',uCatNote = '"&uCatNote&"',IsView = "&IsView&",uType = "&sType&" Where uCatID = " & uCatID & " And UserID = " & DvBoke.UserID)
	Else
		DvBoke.Execute("Insert Into Dv_Boke_UserCat (uCatTitle,uCatNote,IsView,UserID,uType) Values ('"&uCatTitle&"','"&uCatNote&"',"&IsView&","&DvBoke.UserID&","&sType&")")
	End If
	Update_UserCatToXml()
	DvBoke.ShowCode(24)
	DvBoke.ShowMsg(0)
End Sub

'更新用户栏目数据
Sub Update_UserCatToXml()
	'uCatID=0 ,UserID=1 ,uCatTitle=2 ,uCatNote=3 ,OpenTime=4 ,uType=5 ,TopicNum=6 ,PostNum=7 ,TodayNum=8 ,IsView=9,LastUpTime=10
	Dim Rs,Sql
	Dim XmlDoc,NodeList,Node
	Sql = "Select ucatid,userid,ucattitle,ucatnote,opentime,utype,topicnum,postnum,todaynum,isview,lastuptime From Dv_Boke_UserCat where UserID = " & DvBoke.UserID &" order by utype,uCatID"
	Set Rs = DvBoke.Execute(LCase(Sql))
	If Not (Rs.Eof And Rs.Bof) Then
		Set XmlDoc=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
		Rs.Save XmlDoc,1
		XmlDoc.documentElement.RemoveChild(XmlDoc.documentElement.selectSingleNode("s:Schema"))
		Set NodeList=XmlDoc.documentElement.selectNodes("rs:data/z:row")
		For Each Node in NodeList
			Node.attributes.getNamedItem("opentime").text = Rs("opentime")
			Node.attributes.getNamedItem("lastuptime").text = Rs("lastuptime")
			Rs.MoveNext
		Next
		DvBoke.Execute("Update Dv_Boke_User set XmlData = '"&Replace(XmlDoc.documentElement.xml,"'","''")&"' where UserID="&DvBoke.UserID)
		Set DvBoke.BokeCat = XmlDoc
		Set XmlDoc = Nothing
	End If
	Rs.Close
	Set Rs=Nothing
	
	Update_TopicToXml()
	Update_LinkToXml()
	Update_PhotoToXml()
	Update_PostToXml()
	Update_KeyWordToXml()
	DvBoke.ShowCode(27)
End Sub
'更新首页主题数据
Sub Update_TopicToXml()
	Dim Node,XmlDoc,NodeList,ChildNode,BokeBody
	Dim DvCode
	Set DvCode = New DvBoke_UbbCode
	Set Node = DvBoke.BokeCat.selectNodes("xml/boketopic")
	If Not (Node Is Nothing) Then
		For Each NodeList in Node
			DvBoke.BokeCat.DocumentElement.RemoveChild(NodeList)
		Next
	End If
	Set Node=DvBoke.BokeCat.createNode(1,"boketopic","")
	Set XmlDoc=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
	If Not IsNumeric(DvBoke.BokeSetting(6)) Then DvBoke.BokeSetting(6) = "10"
	Dim Rs,Sql
	Sql = "Select Top "&DvBoke.BokeSetting(6)&" TopicID,CatID,sCatID,UserID,UserName,Title,TitleNote,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,IsBest,S_Key,Weather From [Dv_Boke_Topic] Where UserID="&DvBoke.BokeUserID&" and sType <>2 order by PostTime desc"
	Set Rs = DvBoke.Execute(LCase(Sql))
	If Not Rs.Eof Then
		Rs.Save XmlDoc,1
		XmlDoc.documentElement.RemoveChild(XmlDoc.documentElement.selectSingleNode("s:Schema"))
		Set ChildNode = XmlDoc.documentElement.selectNodes("rs:data/z:row")
		For Each NodeList in ChildNode
			If Rs("TitleNote")="" Or IsNull(Rs("TitleNote")) Then
				BokeBody = DvBoke.Execute("Select Content From Dv_Boke_Post Where ParentID=0 and Rootid="&Rs(0))(0)
				If Len(BokeBody) > 250 Then
					BokeBody = SplitLines(BokeBody,DvBoke.BokeSetting(2))
				End If
			Else
				BokeBody = Rs("TitleNote")
			End If
			BokeBody = DvCode.UbbCode(BokeBody) & "...<br/>[<a href=""boke.asp?"&DvBoke.BokeName&".showtopic."&Rs("TopicID")&".html"">阅读全文</a>]"
			NodeList.attributes.getNamedItem("titlenote").text = BokeBody
			NodeList.attributes.getNamedItem("posttime").text = Rs("PostTime")
			NodeList.attributes.getNamedItem("lastposttime").text = Rs("LastPostTime")
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


'更新首页评论数据
Sub Update_PostToXml()
	Dim Node,XmlDoc,NodeList,ChildNode
	Set Node = DvBoke.BokeCat.selectNodes("xml/bokepost")
	If Not (Node Is Nothing) Then
		For Each NodeList in Node
			DvBoke.BokeCat.DocumentElement.RemoveChild(NodeList)
		Next
	End If
	Set Node=DvBoke.BokeCat.createNode(1,"bokepost","")
	Set XmlDoc=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
	If Not IsNumeric(DvBoke.BokeSetting(3)) Then DvBoke.BokeSetting(3) = "10"
	Dim Rs,Sql
	Sql = "Select Top "&DvBoke.BokeSetting(3)&" PostID,CatID,sCatID,ParentID,RootID,UserID,UserName,Title,Content,JoinTime,IP,sType From [Dv_Boke_Post] Where  BokeUserID="&DvBoke.BokeUserID&" and ParentID>0 and sType in (0,3,4) order by JoinTime desc"
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

'更新首页链接数据
Sub Update_LinkToXml()
	Dim Nums
	Dim Node,XmlDoc,NodeList,ChildNode
	Set Node = DvBoke.BokeCat.selectNodes("xml/bokelink")
	If Not (Node Is Nothing) Then
		For Each NodeList in Node
			DvBoke.BokeCat.DocumentElement.RemoveChild(NodeList)
		Next
	End If
	Set Node=DvBoke.BokeCat.createNode(1,"bokelink","")
	Set XmlDoc=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
	'If Not IsNumeric(DvBoke.BokeSetting(6)) Then DvBoke.BokeSetting(6) = "10"
	Nums = 5
	Dim Rs,Sql
	Sql = "Select Top "&Nums&" TopicID,CatID,sCatID,UserID,UserName,Title,TitleNote,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,IsBest,S_Key,Weather,Title as Content From [Dv_Boke_Topic] Where UserID="&DvBoke.BokeUserID&" and sType = 2 and IsLock<3 order by LastPostTime desc"
	Set Rs = DvBoke.Execute(LCase(Sql))
	If Not Rs.Eof Then
		Rs.Save XmlDoc,1
		XmlDoc.documentElement.RemoveChild(XmlDoc.documentElement.selectSingleNode("s:Schema"))
		Set ChildNode = XmlDoc.documentElement.selectNodes("rs:data/z:row")
		For Each NodeList in ChildNode
			NodeList.attributes.getNamedItem("content").text = DvBoke.Execute("Select Content From Dv_Boke_Post Where ParentID=0 and Rootid="&Rs(0))(0)
			NodeList.attributes.getNamedItem("posttime").text = Rs("PostTime")
			NodeList.attributes.getNamedItem("lastposttime").text = Rs("LastPostTime")
			Rs.MoveNext
		Next
		Set ChildNode=XmlDoc.documentElement.selectSingleNode("rs:data")
		Node.appendChild(ChildNode)
	End If
	Rs.Close
	Set Rs = Nothing
	DvBoke.BokeCat.documentElement.appendChild(Node)
	DvBoke.Execute("Update Dv_Boke_User set XmlData = '"&Replace(DvBoke.BokeCat.documentElement.xml,"'","''")&"' where UserID="&DvBoke.UserID)
End Sub

'更新首页图片数据
Sub Update_PhotoToXml()
	Dim Nums
	Dim Node,XmlDoc,NodeList,ChildNode
	Set Node = DvBoke.BokeCat.selectNodes("xml/bokephoto")
	If Not (Node Is Nothing) Then
		For Each NodeList in Node
			DvBoke.BokeCat.DocumentElement.RemoveChild(NodeList)
		Next
	End If
	Set Node=DvBoke.BokeCat.createNode(1,"bokephoto","")
	Set XmlDoc=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
	'If Not IsNumeric(DvBoke.BokeSetting(6)) Then DvBoke.BokeSetting(6) = "10"
	Nums = 5
	Dim Rs,Sql
	Sql = "Select Top "&Nums&" ID,BokeUserID,UserName,CatID,sType,TopicID,PostID,IsTopic,Title,FileName,FileType,FileSize,FileNote,DownNum,ViewNum,DateAndTime,PreviewImage,IsLock From Dv_Boke_Upfile where sType=4 and IsTopic=0 and IsLock<3 and BokeUserID="&DvBoke.BokeUserID&" order by DateAndTime Desc "
	Set Rs = DvBoke.Execute(LCase(Sql))
	If Not Rs.Eof Then
		Rs.Save XmlDoc,1
		XmlDoc.documentElement.RemoveChild(XmlDoc.documentElement.selectSingleNode("s:Schema"))
		Set ChildNode = XmlDoc.documentElement.selectNodes("rs:data/z:row")
		For Each NodeList in ChildNode
			NodeList.attributes.getNamedItem("dateandtime").text = Rs("DateAndTime")
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

'更新关键字转换数据
Sub Update_KeyWordToXml()
	Dim Node,XmlDoc,NodeList,ChildNode
	Set Node = DvBoke.BokeCat.selectNodes("xml/bokekeyword")
	If Not (Node Is Nothing) Then
		For Each NodeList in Node
			DvBoke.BokeCat.DocumentElement.RemoveChild(NodeList)
		Next
	End If
	Set Node=DvBoke.BokeCat.createNode(1,"bokekeyword","")
	Set XmlDoc=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
	Dim Rs,Sql
	Sql = "Select KeyID,KeyWord,nKeyWord,LinkUrl,LinkTitle,NewWindows From Dv_Boke_KeyWord where  UserID="&DvBoke.UserID
	Set Rs = DvBoke.Execute(LCase(Sql))
	If Not Rs.Eof Then
		Rs.Save XmlDoc,1
		XmlDoc.documentElement.RemoveChild(XmlDoc.documentElement.selectSingleNode("s:Schema"))
		Set ChildNode=XmlDoc.documentElement.selectSingleNode("rs:data")
		Node.appendChild(ChildNode)
	End If
	Rs.Close
	Set Rs = Nothing
	DvBoke.BokeCat.documentElement.appendChild(Node)
	DvBoke.Execute("Update Dv_Boke_User set XmlData = '"&Replace(DvBoke.BokeCat.documentElement.xml,"'","''")&"' where UserID="&DvBoke.UserID)
End Sub

Sub Page_UserInput_Cat_Del()
	Dim uCatID
	uCatID = Request("uCatID")
	If uCatID = "" Or Not IsNumeric(uCatID) Then uCatID = 0
	uCatID = cCur(uCatID)
	DvBoke.Execute("Delete From Dv_Boke_UserCat Where uCatID = "&uCatID&" And UserID = " & DvBoke.BokeUserID)
	DvBoke.ShowCode(26)
	DvBoke.ShowMsg(0)
End Sub

Function Page_UserInput_mTopic()
	Dim PageHtml,KeyWord,iKeyWord
	PageHtml = DvBoke.Page_Strings(13).text
	Dim Rs,Sql
	Dim Page,MaxRows,Endpage,CountNum,PageSearch
	CountNum = 0
	Endpage = 0
	MaxRows = DvBoke.System_Setting(7)
	Page = Request("Page")
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)
	KeyWord = Request("KeyWord")
	If KeyWord <> "" Then
		KeyWord = DvBoke.CheckStr(KeyWord)
		iKeyWord = " And (Title Like '%"&KeyWord&"%' Or Content Like '%"&KeyWord&"%')"
	End If

	'字段排序 TopicID=0 ,CatID=1 ,sCatID=2 ,UserID=3 ,UserName=4 ,Title=5 ,Content=6 ,JoinTime=7 ,sType=8

	Sql = "Select RootID,CatID,sCatID,UserID,UserName,Title,Content,JoinTime,sType,PostID From Dv_Boke_Post Where UserID = "&DvBoke.UserID&" And sType = "&sTypeID&" And ParentID = 0 "&iKeyWord&" order by PostID Desc"
	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	If Dv_Boke_InDvbbsData = 1 Then
		Rs.Open Sql,Boke_Conn,1,1
	Else
		Rs.Open Sql,Conn,1,1
	End If
	DvBoke.SqlQueryNum = DvBoke.SqlQueryNum + 1
	If Not Rs.eof Then
		CountNum = Rs.RecordCount
		If CountNum Mod MaxRows=0 Then
			Endpage = CountNum \ MaxRows
		Else
			Endpage = CountNum \ MaxRows+1
		End If
		Rs.MoveFirst
		If Page > Endpage Then Page = Endpage
		If Page < 1 Then Page = 1
		If Page >1 Then 				
			Rs.Move (Page-1) * MaxRows
		End if
		SQL=Rs.GetRows(MaxRows)
	Else
		DvBoke.ShowCode(48)
		DvBoke.ShowMsg(2)
	End If
	Rs.close:Set Rs = Nothing
	Dim i,Temp,Temp1
	If DvBoke.InputShowMsg = "" Then
		For i=0 To Ubound(SQL,2)
		Temp1 = DvBoke.Page_Strings(21).text
		Temp1 = Replace(Temp1,"{$EditID}",Sql(0,i))
		Temp1 = Replace(Temp1,"{$topicid}",Sql(0,i))
		Temp1 = Replace(Temp1,"{$postid}",Sql(9,i))
		If strLength(Sql(5,i)) > 24 Then Sql(5,i) = CutStr(Sql(5,i),24) & "..."
		Temp1 = Replace(Temp1,"{$Topic}",Sql(5,i))
		Temp1 = Replace(Temp1,"{$DateTime}",FormatDateTime(Sql(7,i),2) & " " & FormatDateTime(Sql(7,i),4))
		If Sql(1,i)=0 Then
			Temp1 = Replace(Temp1,"{$cat}","未归类")
		Else
			Temp1 = Replace(Temp1,"{$cat}",DvBoke.ChannelTitle(Sql(1,i)))
		End If
		Temp = Temp & Temp1
		Next
	Else
		Temp = DvBoke.InputShowMsg
	End If

	PageHtml = Replace(PageHtml,"{$InfoList}",Temp)
	PageHtml = Replace(PageHtml,"{$Page}",Page)
	PageHtml = Replace(PageHtml,"{$MaxRows}",MaxRows)
	PageHtml = Replace(PageHtml,"{$CountNum}",CountNum)
	PageSearch = "KeyWord="&KeyWord&"&s=1&t="&sTypeID&"&m=3"
	PageHtml = Replace(PageHtml,"{$PageSearch}",PageSearch)
	If Is_Isapi_Rewrite = 0 Then DvBoke.ModHtmlLinked = "boke.asp?"
	PageHtml = Replace(PageHtml,"{$bokeurl}",DvBoke.ModHtmlLinked)
	PageHtml = Replace(PageHtml,"{$bokename}",DvBoke.BokeName)
	PageHtml = Replace(PageHtml,"{$KeyWord}",KeyWord)
	PageHtml = Replace(PageHtml,"{$t}",sTypeID)
	
	Temp = ""
	Set Rs=DvBoke.Execute("Select * From Dv_Boke_UserCat Where UserID = " & DvBoke.UserID)
	If Not (Rs.Eof And Rs.Bof) Then
		Do While Not Rs.Eof
			Temp = Temp & "<Option value="""&Rs("uCatID")&""">"&Server.HtmlEncode(Rs("uCatTitle")&"")&"</Option>"
		Rs.MoveNext
		Loop
		PageHtml = Replace(PageHtml,"{$uCatList}",Temp)
	Else
		PageHtml = Replace(PageHtml,"{$uCatList}","")
	End If
	Rs.Close:Set Rs=Nothing
	Page_UserInput_mTopic = PageHtml

End Function

Function Page_UserInput_mTopic_Del()
	Dim TopicID,iTopic,i,Rs,Sql,tRs,PostNum,tPostNum,TopicNum,uCatID,sTypeID_a
	Dim Num_T,Num_F,Num_L,Num_P
	Num_T=0
	Num_F=0
	Num_L=0
	Num_P=0
	TopicID = Request("TopicID")
	iTopic = Request("iTopic")
	uCatID = Request("uCatID")
	If TopicID = "" Or iTopic = "" Then
		DvBoke.ShowCode(9)
		DvBoke.ShowMsg(2)
		Page_UserInput_mTopic_Del = DvBoke.InputShowMsg
		Exit Function
	End If
	If Not IsNumeric(iTopic) Then
		DvBoke.ShowCode(9)
		DvBoke.ShowMsg(2)
		Page_UserInput_mTopic_Del = DvBoke.InputShowMsg
		Exit Function
	End If
	iTopic = Cint(iTopic)
	If iTopic <> 0 And iTopic <> 1 Then
		DvBoke.ShowCode(9)
		DvBoke.ShowMsg(2)
		Page_UserInput_mTopic_Del = DvBoke.InputShowMsg
		Exit Function
	End If
	If uCatID = "" Or Not IsNumeric(uCatID) Then uCatID = 0
	uCatID = cCur(uCatID)
	TopicID = Replace(TopicID," ","")
	TopicID = Split(TopicID,",")
	'检测目标栏目是否合法
	If uCatID = -1 And iTopic = 1 Then
		DvBoke.ShowCode(49)
		DvBoke.ShowMsg(2)
		Page_UserInput_mTopic_Del = DvBoke.InputShowMsg
		Exit Function
	End If
	If uCatID > 0 Then
		Set Rs=DvBoke.Execute("Select * From Dv_Boke_UserCat Where UserID = "&DvBoke.UserID&" And uCatID = " & uCatID)
		If Rs.Eof And Rs.Bof Then
			Rs.Close:Set Rs=Nothing
			DvBoke.ShowCode(49)
			DvBoke.ShowMsg(2)
			Page_UserInput_mTopic_Del = DvBoke.InputShowMsg
			Exit Function
		Else
			sTypeID_a = Rs("uType")
		End If
		Rs.Close:Set Rs=Nothing
	End If
	
	For i = 0 To Ubound(TopicID)
		If IsNumeric(TopicID(i)) Then
			Select Case iTopic
			Case 0
				Set Rs=DvBoke.Execute("Select * From Dv_Boke_Topic Where UserID = "&DvBoke.UserID&" And TopicID = " & TopicID(i))
				If Not (Rs.Eof And Rs.Bof) Then
					TopicNum = 0
					If DateDiff("d",Rs("PostTime"),Now()) = 0 Then TopicNum = 1
					Select Case Rs("sType")
					Case 0
						Num_T = 1
					Case 1
						Num_F = 1
					Case 2
						Num_L = 1
					Case 4
						Num_P = 1
					End Select
					'删除包括其评论
					Set tRs=DvBoke.Execute("Select * From Dv_Boke_Post Where RootID = " & TopicID(i))
					PostNum = 0
					tPostNum = 0
					Do While Not tRs.Eof
						PostNum = PostNum + 1
						If DateDiff("d",tRs("JoinTime"),Now()) = 0 Then tPostNum = tPostNum + 1
						'上传文件清理
						If tRs("IsUpfile")=1 Then DvBoke.SysDeleteFile(tRs("PostID"))
					tRs.MoveNext
					Loop
					PostNum = PostNum - 1
					tRs.Close:Set tRs=Nothing
					TopicNum = TopicNum + tPostNum
					DvBoke.Execute("Delete From Dv_Boke_Post Where RootID = " & TopicID(i))
					'更新系统数据
					DvBoke.Execute("Update [Dv_Boke_SysCat] Set TopicNum = TopicNum - 1,PostNum = PostNum - "&PostNum&",TodayNum = TodayNum - "&TopicNum&" Where sCatID in ("&Rs("sCatID")&","&DvBoke.BokeNode.getAttribute("syscatid")&")")
					
					DvBoke.Execute("Update [Dv_Boke_System] Set S_TopicNum=S_TopicNum - "&Num_T&",S_PostNum=S_PostNum - "&PostNum&",S_PhotoNum=S_PhotoNum - "&Num_P&",S_FavNum=S_FavNum - "&Num_F&",S_TodayNum=S_TodayNum - "&TopicNum)
					'更新用户总数据
					DvBoke.Execute("Update [Dv_Boke_User] Set TopicNum = TopicNum - "&Num_T&",PostNum = PostNum - "&PostNum&",FavNum=FavNum - "&Num_F&",PhotoNum=PhotoNum - "&Num_P&",TodayNum=TodayNum - "&TopicNum&" Where UserID="&DvBoke.BokeUserID)
					'更新用户栏目数据
					DvBoke.Execute("Update [Dv_Boke_UserCat] Set TopicNum = TopicNum - 1,PostNum = PostNum - "&PostNum&",TodayNum=TodayNum - "&TopicNum&" Where uCatID="&Rs("CatID"))
					'删除主题
					DvBoke.Execute("Delete From Dv_Boke_Topic Where TopicID = " & TopicID(i))
					Num_T=0:Num_F=0:Num_L=0:Num_P=0
				End If
				Rs.Close:Set Rs=Nothing
			Case 1
				Set Rs=DvBoke.Execute("Select * From Dv_Boke_Topic Where UserID = "&DvBoke.UserID&" And TopicID = " & TopicID(i))
				If Not (Rs.Eof And Rs.Bof) Then
					TopicNum = 0
					If DateDiff("d",Rs("PostTime"),Now()) = 0 Then TopicNum = 1
					Select Case Rs("sType")
					Case 0
						Num_T = 1
					Case 1
						Num_F = 1
					Case 2
						Num_L = 1
					Case 4
						Num_P = 1
					End Select
					'移动包括其评论
					Set tRs=DvBoke.Execute("Select * From Dv_Boke_Post Where RootID = " & TopicID(i))
					PostNum = 0
					tPostNum = 0
					Do While Not tRs.Eof
						PostNum = PostNum + 1
						If DateDiff("d",tRs("JoinTime"),Now()) = 0 Then tPostNum = tPostNum + 1
						'上传文件移动
						If tRs("IsUpfile")=1 Then DvBoke.Execute("Update Dv_Boke_Upfile Set CatID = "&uCatID&",sType = "&sTypeID_a&" Where PostID = " & tRs("PostID"))
					tRs.MoveNext
					Loop
					PostNum = PostNum - 1
					tRs.Close:Set tRs=Nothing
					TopicNum = TopicNum + tPostNum
					DvBoke.Execute("UpDate Dv_Boke_Post Set CatID = "&uCatID&",sType = "&sTypeID_a&" Where RootID = " & TopicID(i))
					'更新用户栏目数据
					DvBoke.Execute("Update [Dv_Boke_UserCat] Set TopicNum = TopicNum - 1,PostNum = PostNum - "&PostNum&",TodayNum=TodayNum - "&TopicNum&" Where uCatID="&Rs("CatID"))
					DvBoke.Execute("Update [Dv_Boke_UserCat] Set TopicNum = TopicNum + 1,PostNum = PostNum + "&PostNum&",TodayNum=TodayNum + "&TopicNum&" Where uCatID="&uCatID)
					'移动主题
					DvBoke.Execute("Update Dv_Boke_Topic Set CatID = "&uCatID&",sType = "&sTypeID_a&" Where TopicID = " & TopicID(i))
					Num_T=0:Num_F=0:Num_L=0:Num_P=0
				End If
				Rs.Close:Set Rs=Nothing
			End Select
		End If
	Next
	'更新用户首页数据
	Update_TopicToXml()
	DvBoke.LoadSetup(1)
	'更新系统缓存数据
	DvBoke.ShowCode(50)
	DvBoke.ShowMsg(2)
	Page_UserInput_mTopic_Del = DvBoke.InputShowMsg
End Function

Function Page_UserInput_mPost()
	Dim PageHtml,KeyWord,iKeyWord,iTopic
	PageHtml = DvBoke.Page_Strings(22).text
	Dim Rs,Sql
	Dim Page,MaxRows,Endpage,CountNum,PageSearch
	Endpage = 0
	MaxRows = DvBoke.System_Setting(7)
	Page = Request("Page")
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)
	KeyWord = Request("KeyWord")
	If KeyWord <> "" Then
		KeyWord = DvBoke.CheckStr(KeyWord)
		iKeyWord = " And (Title Like '%"&KeyWord&"%' Or Content Like '%"&KeyWord&"%')"
	End If

	'字段排序 TopicID=0 ,CatID=1 ,sCatID=2 ,UserID=3 ,UserName=4 ,Title=5 ,Content=6 ,JoinTime=7 ,sType=8

	Sql = "Select RootID,CatID,sCatID,UserID,UserName,Title,Content,JoinTime,sType,PostID,Content From Dv_Boke_Post Where UserID = "&DvBoke.UserID&" And (Not ParentID = 0) "&iKeyWord&" order by PostID Desc"
	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	If Dv_Boke_InDvbbsData = 1 Then
		Rs.Open Sql,Boke_Conn,1,1
	Else
		Rs.Open Sql,Conn,1,1
	End If
	DvBoke.SqlQueryNum = DvBoke.SqlQueryNum + 1
	If Not Rs.eof Then
		CountNum = Rs.RecordCount
		If CountNum Mod MaxRows=0 Then
			Endpage = CountNum \ MaxRows
		Else
			Endpage = CountNum \ MaxRows+1
		End If
		Rs.MoveFirst
		If Page > Endpage Then Page = Endpage
		If Page < 1 Then Page = 1
		If Page >1 Then 				
			Rs.Move (Page-1) * MaxRows
		End if
		SQL=Rs.GetRows(MaxRows)
	Else
		DvBoke.ShowCode(48)
		DvBoke.ShowMsg(2)
		'Page_UserInput_mTopic = DvBoke.InputShowMsg
		'Exit Function
	End If
	Rs.close:Set Rs = Nothing
	Dim i,Temp,Temp1
	If DvBoke.InputShowMsg = "" Then
		For i=0 To Ubound(SQL,2)
		Temp1 = DvBoke.Page_Strings(23).text
		Temp1 = Replace(Temp1,"{$EditID}",Sql(9,i))
		Temp1 = Replace(Temp1,"{$topicid}",Sql(0,i))
		Temp1 = Replace(Temp1,"{$postid}",Sql(9,i))
		If Sql(5,i) = "" Or IsNull(Sql(5,i)) Then
			If strLength(Sql(10,i)) > 24 Then Sql(10,i) = CutStr(Sql(10,i),24) & "..."
			iTopic = Server.HtmlEncode(Sql(10,i))
		Else
			If strLength(Sql(5,i)) > 24 Then Sql(5,i) = CutStr(Sql(5,i),24) & "..."
			iTopic = Server.HtmlEncode(Sql(5,i))
		End If
		Temp1 = Replace(Temp1,"{$Topic}",iTopic)
		Temp1 = Replace(Temp1,"{$DateTime}",FormatDateTime(Sql(7,i),2) & " " & FormatDateTime(Sql(7,i),4))
		Temp1 = Replace(Temp1,"{$cat}",Sql(4,i))
		Temp = Temp & Temp1
		Next
	Else
		Temp = DvBoke.InputShowMsg
	End If

	PageHtml = Replace(PageHtml,"{$InfoList}",Temp)
	PageHtml = Replace(PageHtml,"{$Page}",Page)
	PageHtml = Replace(PageHtml,"{$MaxRows}",MaxRows)
	PageHtml = Replace(PageHtml,"{$CountNum}",CountNum)
	PageSearch = "KeyWord="&KeyWord&"&s=2"
	PageHtml = Replace(PageHtml,"{$PageSearch}",PageSearch)
	If Is_Isapi_Rewrite = 0 Then DvBoke.ModHtmlLinked = "boke.asp?"
	PageHtml = Replace(PageHtml,"{$bokeurl}",DvBoke.ModHtmlLinked)
	PageHtml = Replace(PageHtml,"{$bokename}",DvBoke.BokeName)
	PageHtml = Replace(PageHtml,"{$KeyWord}",KeyWord)
	PageHtml = Replace(PageHtml,"{$t}",sTypeID)
	
	Temp = ""
	Set Rs=DvBoke.Execute("Select * From Dv_Boke_UserCat Where UserID = " & DvBoke.UserID)
	If Not (Rs.Eof And Rs.Bof) Then
		Do While Not Rs.Eof
			Temp = Temp & "<Option value="""&Rs("uCatID")&""">"&Server.HtmlEncode(Rs("uCatTitle")&"")&"</Option>"
		Rs.MoveNext
		Loop
		PageHtml = Replace(PageHtml,"{$uCatList}",Temp)
	Else
		PageHtml = Replace(PageHtml,"{$uCatList}","")
	End If
	Rs.Close:Set Rs=Nothing
	Page_UserInput_mPost = PageHtml
End Function

Function Page_UserInput_mPost_Del()
	Dim TopicID,iTopic,i,Rs,Sql,tRs,PostNum,tPostNum,TopicNum
	TopicID = Request("TopicID")
	iTopic = Request("iTopic")
	If TopicID = "" Or iTopic = "" Then
		DvBoke.ShowCode(9)
		DvBoke.ShowMsg(2)
		Page_UserInput_mPost_Del = DvBoke.InputShowMsg
		Exit Function
	End If
	If Not IsNumeric(iTopic) Then
		DvBoke.ShowCode(9)
		DvBoke.ShowMsg(2)
		Page_UserInput_mPost_Del = DvBoke.InputShowMsg
		Exit Function
	End If
	iTopic = Cint(iTopic)
	If iTopic <> 0 Then
		DvBoke.ShowCode(9)
		DvBoke.ShowMsg(2)
		Page_UserInput_mPost_Del = DvBoke.InputShowMsg
		Exit Function
	End If
	TopicID = Replace(TopicID," ","")
	TopicID = Split(TopicID,",")
	
	For i = 0 To Ubound(TopicID)
		If IsNumeric(TopicID(i)) Then
			'删除评论
			Set Rs=DvBoke.Execute("Select * From Dv_Boke_Post Where PostID = " & TopicID(i))
			tPostNum = 0
			If Not (Rs.Eof And Rs.Bof) Then
				If DateDiff("d",Rs("JoinTime"),Now()) = 0 Then tPostNum = 1
				'更新系统数据
				DvBoke.Execute("Update [Dv_Boke_SysCat] Set PostNum = PostNum - 1,TodayNum = TodayNum - "&tPostNum&" Where sCatID in ("&Rs("sCatID")&","&DvBoke.BokeNode.getAttribute("syscatid")&")")


				DvBoke.Execute("Update [Dv_Boke_System] Set S_PostNum = S_PostNum - 1,S_TodayNum = S_TodayNum - "&tPostNum)
				'更新用户总数据
				DvBoke.Execute("Update [Dv_Boke_User] Set PostNum = PostNum - 1,TodayNum=TodayNum - "&tPostNum&" Where UserID="&DvBoke.BokeUserID)
				'更新用户栏目数据
				DvBoke.Execute("Update [Dv_Boke_UserCat] Set PostNum = PostNum - 1,TodayNum=TodayNum - "&tPostNum&" Where uCatID="&Rs("CatID"))
				'上传文件清理
				If Rs("IsUpfile")=1 Then DvBoke.SysDeleteFile(Rs("PostID"))
				'更新主题数据
				DvBoke.Execute("UpDate [Dv_Boke_Topic] Set Child=Child-1 Where TopicID = " & Rs("RootID"))
				DvBoke.Execute("Delete From Dv_Boke_Post Where PostID = " & TopicID(i))
			End If
			Rs.Close:Set Rs=Nothing
		End If
	Next
	'更新用户首页数据
	Update_TopicToXml()
	DvBoke.LoadSetup(1)
	'更新系统缓存数据
	DvBoke.ShowCode(50)
	DvBoke.ShowMsg(0)
	'Page_UserInput_mPost_Del = DvBoke.InputShowMsg
End Function

Sub Page_UserSetting()
	Dim PageHtml,UserPageHtml
	PageHtml = DvBoke.Page_Strings(6).text
	Select Case t
	Case "1"
		If Request.QueryString("Action") = "Save" Then
			Page_UserSetting_Info_Save()
		Else
			UserPageHtml = Page_UserSetting_Info()
		End If
	Case "2"
		If Request.QueryString("Action") = "Save" Then
			Page_UserSetting_Pass_Save()
		Else
			UserPageHtml = Page_UserSetting_Pass()
		End If
	Case "3"
		If Request.QueryString("Action") = "Save" Then
			Page_UserSetting_Set_Save()
		Else
			UserPageHtml = Page_UserSetting_Set()
		End If
	Case "4"
		If Request.QueryString("Action") = "Save" Then
			Page_UserSetting_Key_Save()
		ElseIf Request.QueryString("Action") = "Del" Then
			Page_UserSetting_Key_Del()
		Else
			UserPageHtml = Page_UserSetting_Key()
		End If
	Case Else
		If Request.QueryString("Action") = "Save" Then
			Page_UserSetting_Info_Save()
		Else
			UserPageHtml = Page_UserSetting_Info()
		End If
	End Select
	PageHtml = Replace(PageHtml,"{$UserSettingInfo}",UserPageHtml)
	Response.Write PageHtml
End Sub

Function Page_UserSetting_Info()
	Dim PageHtml
	PageHtml = DvBoke.Page_Strings(7).text
	PageHtml = Replace(PageHtml,"{$BokeName}",Server.HtmlEncode(DvBoke.BokeNode.getAttribute("bokename")&""))
	PageHtml = Replace(PageHtml,"{$NickName}",Server.HtmlEncode(DvBoke.BokeNode.getAttribute("nickname")&""))
	PageHtml = Replace(PageHtml,"{$BokeTitle}",Server.HtmlEncode(DvBoke.BokeNode.getAttribute("boketitle")&""))
	PageHtml = Replace(PageHtml,"{$BokeCTitle}",Server.HtmlEncode(DvBoke.BokeNode.getAttribute("bokechildtitle")&""))
	PageHtml = Replace(PageHtml,"{$BokeNote}",Server.HtmlEncode(DvBoke.BokeNode.getAttribute("bokenote")&""))
	Page_UserSetting_Info = PageHtml
End Function

Sub Page_UserSetting_Info_Save()
	Dim NickName,BokeTitle,BokeCTitle,BokeNote
	If Not DvBoke.ChkPost() Then DvBoke.ShowCode(2):DvBoke.ShowMsg(0)
	NickName = Request.Form("NickName")
	BokeTitle = Request.Form("BokeTitle")
	BokeCTitle = Request.Form("BokeCTitle")
	BokeNote = Request.Form("BokeNote")

	If NickName = "" or strLength(NickName)>50 or strLength(NickName)<1 Then
		DvBoke.ShowCode(8)
	Else
		NickName = Server.Htmlencode(NickName)
	End If
	If BokeTitle = "" or strLength(BokeTitle)>150 or strLength(BokeTitle)<1 Then
		DvBoke.ShowCode(12)
	Else
		BokeTitle = Server.Htmlencode(BokeTitle)
	End If
	If BokeCTitle = "" or strLength(BokeCTitle)>250 or strLength(BokeCTitle)<1 Then
		DvBoke.ShowCode(12)
	Else
		BokeCTitle = Server.Htmlencode(BokeCTitle)
	End If
	If BokeNote <> "" Then
		If CheckText(BokeNote) = False Then
			DvBoke.ShowCode(9)
		Else
			BokeNote = Server.Htmlencode(BokeNote)
		End If
	End If
	If CheckText(NickName) = False Then DvBoke.ShowCode(9)
	DvBoke.ShowMsg(0)

	Dim Rs,SQL
	Sql  = "Select * From [Dv_Boke_User] Where UserID = " & DvBoke.BokeUserID
	If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase
	Set Rs=Dvbbs.iCreateObject("Adodb.RecordSet")
	Rs.Open Sql,Boke_Conn,1,3
	If Lcase(Rs("NickName")) <> Lcase(NickName) Then
		'更新主题表
		DvBoke.Execute("Update Dv_Boke_Topic Set UserName = '"&DvBoke.CheckStr(NickName)&"' Where UserID = " & DvBoke.BokeUserID)
		'更新帖子表
		DvBoke.Execute("Update Dv_Boke_Post Set UserName = '"&DvBoke.CheckStr(NickName)&"' Where UserID = " & DvBoke.BokeUserID)
		'更新上传表
		DvBoke.Execute("Update Dv_Boke_Upfile Set UserName = '"&DvBoke.CheckStr(NickName)&"' Where UserID = " & DvBoke.BokeUserID)
	End If
	Rs("NickName") = NickName
	Rs("BokeTitle") = BokeTitle
	Rs("BokeChildTitle") = BokeCTitle
	Rs("BokeNote") = BokeNote
	Rs.Update
	Rs.Close
	Set Rs=Nothing
	'更新用户首页数据
	Update_TopicToXml()
	DvBoke.LoadSetup(1)
	DvBoke.ShowCode(16)
	DvBoke.ShowMsg(0)
End Sub

Function Page_UserSetting_Pass()
	Page_UserSetting_Pass = DvBoke.Page_Strings(8).text
End Function

Sub Page_UserSetting_Pass_Save()
	Dim PassWord,nPassWord,rnPassWord
	If Not DvBoke.ChkPost() Then DvBoke.ShowCode(2):DvBoke.ShowMsg(0)
	PassWord = Request.Form("PassWord")
	nPassWord = Request.Form("nPass")
	rnPassWord = Request.Form("rnPass")

	If PassWord = "" Or nPassWord = "" Or rnPassWord = "" Then
		DvBoke.ShowCode(11)
	End If
	If nPassWord <> rnPassWord Then
		DvBoke.ShowCode(17)
	End If
	nPassWord = MD5(nPassWord,16)
	PassWord = MD5(PassWord,16)
	DvBoke.ShowMsg(0)

	Dim Rs
	Set Rs = DvBoke.Execute("Select PassWord From Dv_Boke_User Where UserID = " & DvBoke.UserID)
	If PassWord <> Rs(0) Then
		DvBoke.ShowCode(15)
		DvBoke.ShowMsg(0)
	End If
	Rs.Close : Set Rs = Nothing
	DvBoke.Execute("Update Dv_Boke_User Set [PassWord]='"&nPassWord&"' Where UserID = " & DvBoke.UserID)
	DvBoke.ShowCode(18)
	DvBoke.ShowMsg(0)
End Sub

Function Page_UserSetting_Set()
	Dim PageHtml,i,Rs,PageHtml_Str
	PageHtml = DvBoke.Page_Strings(9).text
	For i = 0 To 50
		PageHtml = Replace(PageHtml,"{$Setting"&i&"}",DvBoke.BokeSetting(i))
	Next
	Set Rs = DvBoke.Execute("Select * From Dv_Boke_SysCat Where sType = 0 Order By sCatID")
	Do While Not Rs.Eof
		PageHtml_Str = PageHtml_Str & "<Option value="""&Rs("sCatID")&""" "
		If Cint(DvBoke.BokeNode.getAttribute("syscatid")) = Rs("sCatID") Then PageHtml_Str = PageHtml_Str & "selected"
		PageHtml_Str = PageHtml_Str & ">"&Rs("sCatTitle")&"</Option>"
	Rs.MoveNext
	Loop
	Rs.Close
	Set Rs=Nothing
	PageHtml = Replace(PageHtml,"{$CatList}",PageHtml_Str)
	Page_UserSetting_Set = PageHtml
End Function

Sub Page_UserSetting_Set_Save()
	Dim iSetting,BokeSetting,i
	Dim SysCatID
	SysCatID = Request.Form("SysCatID")
	If SysCatID = "" Or Not IsNumeric(SysCatID) Then SysCatID = 1
	SysCatID = Clng(SysCatID)
	For i = 0 To 50
		If Trim(Request.Form("Setting"&i)) = "" Then
			iSetting= 1
		Else
			iSetting = Replace(Trim(Request.Form("Setting"&i)),",","")
		End If
		If i < 12 Then
			If Not IsNumeric(iSetting) Then
				DvBoke.ShowCode(9)
				Exit For
			End If
		End If
		If i = 0 Then
			BokeSetting = iSetting
		Else
			BokeSetting = BokeSetting & "," & iSetting
		End If
	Next
	DvBoke.ShowMsg(0)
	BokeSetting = DvBoke.CheckStr(BokeSetting)
	BokeSetting = Server.HtmlEncode(BokeSetting)
	BokeSetting = Dv_FilterJS(BokeSetting)
	
	'当用户所选系统分类改变时相应更新分类用户数
	If DvBoke.BokeNode.getAttribute("syscatid")<>SysCatID Then
		DvBoke.Execute("Update Dv_Boke_SysCat Set ucatnum = ucatnum - 1 Where scatid = " & DvBoke.BokeNode.getAttribute("syscatid"))
		DvBoke.Execute("Update Dv_Boke_SysCat Set ucatnum = ucatnum + 1 Where scatid = " & SysCatID)

		DvBoke.Update_SysCat DvBoke.BokeNode.getAttribute("syscatid"),-1,0,0,0,Null
		DvBoke.Update_SysCat SysCatID,1,0,0,0,Null
		DvBoke.SaveSystemCache()
	End If

	DvBoke.Execute("Update Dv_Boke_User Set BokeSetting = '"&BokeSetting&"',SysCatID = "&SysCatID&" Where UserID = " & DvBoke.BokeUserID)

	DvBoke.ShowCode(19)
	DvBoke.ShowMsg(0)
End Sub

Function Page_UserSetting_Key()
	Dim PageHtml,PageHtml_Str,Rs
	PageHtml = DvBoke.Page_Strings(10).text
	If Request("KeyID")<>"" And IsNumeric(Request("KeyID")) Then
		Set Rs = DvBoke.Execute("Select * From Dv_Boke_KeyWord Where KeyID = " & Request("KeyID") & " And UserID = " & DvBoke.UserID)
		If Not (Rs.Eof And Rs.Bof) Then
			PageHtml = Replace(PageHtml,"{$KeyID}",Rs("KeyID"))
			PageHtml = Replace(PageHtml,"{$KeyWord}",Rs("KeyWord"))
			PageHtml = Replace(PageHtml,"{$nKeyWord}",Rs("nKeyWord"))
			PageHtml = Replace(PageHtml,"{$LinkUrl}",Rs("LinkUrl") & "")
			If Rs("NewWindows")=1 Then
				PageHtml = Replace(PageHtml,"{$NewWindows}","checked")
			Else
				PageHtml = Replace(PageHtml,"{$NewWindows}","")
			End If
			PageHtml = Replace(PageHtml,"{$LinkTitle}",Rs("LinkTitle") & "")
		End If
		Rs.Close
		Set Rs = Nothing
	End If
	PageHtml = Replace(PageHtml,"{$KeyID}","0")
	PageHtml = Replace(PageHtml,"{$KeyWord}","")
	PageHtml = Replace(PageHtml,"{$nKeyWord}","")
	PageHtml = Replace(PageHtml,"{$LinkUrl}","")
	PageHtml = Replace(PageHtml,"{$NewWindows}","checked")
	PageHtml = Replace(PageHtml,"{$LinkTitle}","")
	Set Rs = DvBoke.Execute("Select * From Dv_Boke_KeyWord Where UserID = " & DvBoke.UserID & " Order By KeyID")
	If Not (Rs.Eof And Rs.Bof) Then
		Do While Not Rs.Eof
			PageHtml_Str = PageHtml_Str & "<ul>"
			PageHtml_Str = PageHtml_Str & "<li class=""Set33"">"&Rs("KeyWord")&"</li>"
			PageHtml_Str = PageHtml_Str & "<li class=""Set33"">"&Rs("nKeyWord")&"</li>"
			PageHtml_Str = PageHtml_Str & "<li class=""Set44""><a href="""&Rs("LinkUrl")&""" target=""_blank"" title="""&Server.HtmlEncode(Rs("LinkTitle")&"")&""">"&Left(Rs("LinkUrl"),25)&"</a></li>"
			PageHtml_Str = PageHtml_Str & "<li class=""Set55""><a href=""?s=5&t=4&KeyID="&Rs("KeyID")&""">编辑</a>&nbsp;&nbsp;<a href=""#"" onclick=""alertreadme('您确定删除关键字 "&Rs("KeyWord")&" 吗?','?s=5&t=4&Action=Del&KeyID="&Rs("KeyID")&"')"">删除</a></li>"
			PageHtml_Str = PageHtml_Str & "</ul>"
		Rs.MoveNext
		Loop
	End If
	Rs.Close
	Set Rs=Nothing
	PageHtml = Replace(PageHtml,"{$KeyWordList}",PageHtml_Str)
	Page_UserSetting_Key = PageHtml
End Function

Sub Page_UserSetting_Key_Save()
	Dim KeyID,KeyWord,nKeyWord,LinkUrl,LinkTitle,NewWindows
	Dim Rs
	KeyID = Request.Form("KeyID")
	KeyWord = Replace(DvBoke.CheckStr(Request.Form("KeyWord")),"|","")
	nKeyWord = Replace(DvBoke.CheckStr(Request.Form("nKeyWord")),"|","")
	LinkUrl = Request.Form("LinkUrl")
	LinkTitle = Request.Form("LinkTitle")
	NewWindows = Request.Form("NewWindows")

	If KeyID = "" Or Not IsNumeric(KeyID) Then KeyID = 0
	KeyID = cCur(KeyID)
	If NewWindows = "" Or Not IsNumeric(NewWindows) Then NewWindows = 0
	NewWindows = Cint(NewWindows)
	If KeyWord = "" Or nKeyWord = "" Then
		DvBoke.ShowCode(20)
	Else
		KeyWord = Server.HtmlEncode(KeyWord)
		nKeyWord = Server.HtmlEncode(nKeyWord)
	End If
	If LinkUrl <> "" Then LinkUrl = DvBoke.CheckStr(Server.HtmlEncode(Dv_FilterJS(LinkUrl)))
	If LinkTitle <> "" Then LinkTitle = DvBoke.CheckStr(Server.HtmlEncode(Dv_FilterJS(LinkTitle)))
	DvBoke.ShowMsg(0)
	If KeyID > 0 Then
		Set Rs = DvBoke.Execute("Select KeyID From Dv_Boke_KeyWord Where (Not KeyID = "&KeyID&") And UserID = "&DvBoke.UserID&" And KeyWord = '"&KeyWord&"'")
		If Not (Rs.Eof And Rs.Bof) Then
			DvBoke.ShowCode(22)
			DvBoke.ShowMsg(0)
		End If
		Rs.Close
		Set Rs = Nothing
		DvBoke.Execute("Update Dv_Boke_KeyWord Set KeyWord = '"&KeyWord&"',nKeyWord = '"&nKeyWord&"',LinkUrl = '"&LinkUrl&"',LinkTitle = '"&LinkTitle&"',NewWindows = "&NewWindows&" Where KeyID = " & KeyID & " And UserID = " & DvBoke.UserID)
	Else
		Set Rs = DvBoke.Execute("Select KeyID From Dv_Boke_KeyWord Where UserID = "&DvBoke.UserID&" And KeyWord = '"&KeyWord&"'")
		If Not (Rs.Eof And Rs.Bof) Then
			DvBoke.ShowCode(22)
			DvBoke.ShowMsg(0)
		End If
		Rs.Close
		Set Rs = Nothing
		DvBoke.Execute("Insert Into Dv_Boke_KeyWord (KeyWord,nKeyWord,LinkUrl,LinkTitle,NewWindows,UserID) Values ('"&KeyWord&"','"&nKeyWord&"','"&LinkUrl&"','"&LinkTitle&"',"&NewWindows&","&DvBoke.UserID&")")
	End If
	DvBoke.ShowCode(21)
	DvBoke.ShowMsg(0)
End Sub

Sub Page_UserSetting_Key_Del()
	Dim KeyID
	KeyID = Request("KeyID")
	If KeyID = "" Or Not IsNumeric(KeyID) Then KeyID = 0
	KeyID = cCur(KeyID)
	DvBoke.Execute("Delete From Dv_Boke_KeyWord Where KeyID = "&KeyID&" And UserID = " & DvBoke.UserID)
	DvBoke.ShowCode(23)
	DvBoke.ShowMsg(0)
End Sub

'风格模板列表
Sub Page_SkinSetting()
	Dim Rs,Sql
	Dim Page,MaxRows,Endpage,CountNum,PageSearch
	Dim PageHtml
		
	PageHtml = DvBoke.Page_Strings(18).text
	Endpage = 0
	MaxRows = 9
	Page = Request("Page")
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)

	'S_ID=0 ,S_SkinName=1 ,S_Path=2 ,S_ViewPic=3 ,S_Info=4 ,S_Builder=5
	Sql = "Select S_ID,S_SkinName,S_Path,S_ViewPic,S_Info,S_Builder From [Dv_Boke_Skins] "
	'Set Rs = DvBoke.Execute(Sql)
	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	If Dv_Boke_InDvbbsData = 1 Then
		Rs.Open Sql,Boke_Conn,1,1
	Else
		Rs.Open Sql,Conn,1,1
	End If
	DvBoke.SqlQueryNum = DvBoke.SqlQueryNum + 1
	If Not Rs.eof Then
		CountNum = Rs.RecordCount
		If CountNum Mod MaxRows=0 Then
			Endpage = CountNum \ MaxRows
		Else
			Endpage = CountNum \ MaxRows+1
		End If
		Rs.MoveFirst
		If Page > Endpage Then Page = Endpage
		If Page < 1 Then Page = 1
		If Page >1 Then 				
			Rs.Move (Page-1) * MaxRows
		End if
		SQL=Rs.GetRows(MaxRows)
	Else
		DvBoke.ShowCode(28)
		DvBoke.ShowMsg(0)
		Exit Sub
	End If
	Rs.close:Set Rs = Nothing
	Dim i,ii,Temp1,Temp2,TempHtml,ViewLogo
	PageSearch = "s=4"

	Temp2 = DvBoke.Page_Strings(20).text

	For i=0 To Ubound(SQL,2)
		Temp1 = DvBoke.Page_Strings(19).text
		If SQL(3,i)<>"" or not IsNull(SQL(3,i)) Then
			ViewLogo = SQL(3,i)
		Else
			ViewLogo = "boke/images/viewskins.png"
		End If
		Temp1 = Replace(Temp1,"{$ViewLogo}",ViewLogo)
		Temp1 = Replace(Temp1,"{$S_Name}",SQL(1,i))
		Temp1 = Replace(Temp1,"{$S_id}",SQL(0,i))

		TempHtml = TempHtml & Temp1

		If ii=3 Then
			TempHtml = TempHtml & Temp2
			ii=0
		Else
			ii=ii+1
		End If
	Next

	PageHtml = Replace(PageHtml,"{$skin_list}",TempHtml)
	PageHtml = Replace(PageHtml,"{$S_id}",DvBoke.BokeNode.getAttribute("skinid"))
	PageHtml = Replace(PageHtml,"{$Page}",Page)
	PageHtml = Replace(PageHtml,"{$MaxRows}",MaxRows)
	PageHtml = Replace(PageHtml,"{$CountNum}",CountNum)
	PageHtml = Replace(PageHtml,"{$PageSearch}",PageSearch)
	Response.Write PageHtml
End Sub

'保存模板风格设置
Sub Page_SaveSkins()
	Dim Skinid
	Skinid = Request.Form("Skinid")
	If Not DvBoke.ChkPost() Then DvBoke.ShowCode(2)
	If DvBoke.CheckNumeric(Skinid) = 0 Then
		DvBoke.ShowCode(4)
	End If
	DvBoke.ShowMsg(0)
	Dim Rs,Sql
	Set Rs = DvBoke.Execute("Select S_ID From Dv_Boke_Skins Where S_ID="&Skinid)
	If Not Rs.Eof Then
		DvBoke.Execute("Update Dv_Boke_User Set Skinid="&Skinid&" where UserID="&DvBoke.UserID)
		DvBoke.ShowCode(29)
	Else
		DvBoke.ShowCode(4)
	End If
	DvBoke.ShowMsg(0)
End Sub

Sub Page_UserFile()
	Dim PageHtml,mStr,KeyWord,iKeyWord,iFileType
	Dim Sql,Rs,TopicHtml,i,Title,ii
	Dim Page,MaxRows,Endpage,CountNum,PageSearch
	Endpage = 0
	MaxRows = Cint(DvBoke.BokeSetting(7))
	'MaxRows = 2
	Page = Request("Page")
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)
	PageHtml = DvBoke.Page_Strings(24).text
	KeyWord = DvBoke.CheckStr(Request("keyword"))
	If KeyWord <> "" Then iKeyWord = " And (Title Like '%"&KeyWord&"%' Or sFileName Like '%"&KeyWord&"%')"
	Select Case m
	Case "1"
		mStr = "所有"
	Case "2"
		mStr = "图片"
		iFileType = " And FileType = 1"
	Case "3"
		mStr = "压缩"
		iFileType = " And FileType = 5"
	Case "4"
		mStr = "文档"
		iFileType = " And FileType = 6"
	Case "5"
		mStr = "媒体"
		iFileType = " And FileType In (2,3,4)"
	Case Else
		mStr = "所有"
	End Select
	Sql = "Select ID,BokeUserID,UserName,CatID,sType,TopicID,PostID,IsTopic,Title,FileName,FileType,FileSize,FileNote,DownNum,ViewNum,DateAndTime,PreviewImage,IsLock,sFileName From Dv_Boke_Upfile where Userid="&DvBoke.BokeUserID&" "&iFileType&" "&iKeyWord&" order by DateAndTime Desc"
	'Response.Write sql
	PageHtml = Replace(PageHtml,"{$ActionInfo}",mStr)
	PageHtml = Replace(PageHtml,"{$KeyWord}",KeyWord)
	If Request("Action")="Del" Then
		PageHtml = Replace(PageHtml,"{$topiclist}",Page_UserFile_Del())
		Response.Write PageHtml
		Exit Sub
	End If

	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	If Dv_Boke_InDvbbsData = 1 Then
		Rs.Open Sql,Boke_Conn,1,1
	Else
		Rs.Open Sql,Conn,1,1
	End If
	DvBoke.SqlQueryNum = DvBoke.SqlQueryNum + 1
	If Not Rs.eof Then
		CountNum = Rs.RecordCount
		If CountNum Mod MaxRows=0 Then
			Endpage = CountNum \ MaxRows
		Else
			Endpage = CountNum \ MaxRows+1
		End If
		Rs.MoveFirst
		If Page > Endpage Then Page = Endpage
		If Page < 1 Then Page = 1
		If Page >1 Then 				
			Rs.Move (Page-1) * MaxRows
		End if
		SQL=Rs.GetRows(MaxRows)
	Else
		DvBoke.ShowCode(48)
		DvBoke.ShowMsg(2)
		TopicHtml = DvBoke.InputShowMsg
	End If
	Rs.close:Set Rs = Nothing

	If TopicHtml = "" Then
		Dim Temp,Temp2
		Temp2 = DvBoke.Page_Strings(27).text
		Dim ViewFile
		If Not IsNumeric(DvBoke.System_Setting(9)) Then
			DvBoke.System_Setting(9) = 3
		Else
			DvBoke.System_Setting(9) = Cint(DvBoke.System_Setting(9))
		End If
		For i=0 To Ubound(SQL,2)
			TopicHtml = DvBoke.Page_Strings(26).text
			Title = Sql(8,i)
			If Len(Title)>150 Then
				Title = Left(Title,150) &"......"
			End If
			If Title = "" Or IsNull(Title) Then
				If Sql(18,i)<>"" Then
					Title = Sql(18,i)
				Else
					Title = Split(Sql(9,i),"/")(2)
				End If
			End If

			ViewFile = Sql(16,i)
			If ViewFile="" or IsNull(ViewFile) Then
				ViewFile = Sql(9,i)
			End If
			ViewFile = DvBoke.System_UpSetting(19) & ViewFile
			If Sql(10,i) <> 1 Then
				ViewFile = "boke/images/info.gif"
			End If
			TopicHtml = Replace(TopicHtml,"{$ViewPhoto}",ViewFile)
			If Sql(17,i) = 4 Then
				Title = "未曾使用"
				TopicHtml = Replace(TopicHtml,"{$topic}",DvBoke.HTMLEncode(Title))
			Else
				If Sql(7,i)=0 Then
					TopicHtml = Replace(TopicHtml,"{$topic}","<a href="""&DvBoke.ModHtmlLinked&DvBoke.BokeName&".showtopic."&Sql(5,i)&".html"" target=""_blank"">" & DvBoke.HTMLEncode(Title) & "</a>")
				ElseIf Sql(7,i)=1 Then
					TopicHtml = Replace(TopicHtml,"{$topic}","<a href="""&DvBoke.ModHtmlLinked&DvBoke.BokeName&".showtopic."&Sql(5,i)&"."&Sql(6,i)&".html"" target=""_blank"">" & DvBoke.HTMLEncode(Title) & "</a>")
				Else
					TopicHtml = Replace(TopicHtml,"{$topic}",DvBoke.HTMLEncode(Title))
				End If
			End If
			TopicHtml = Replace(TopicHtml,"{$PostDate}",FormatDateTime(Sql(15,i),1))
			TopicHtml = Replace(TopicHtml,"{$PostUserName}",Sql(2,i))
			TopicHtml = Replace(TopicHtml,"{$TopicID}",Sql(5,i))
			TopicHtml = Replace(TopicHtml,"{$fileid}",Sql(0,i))
			Temp = Temp & TopicHtml
			If ii >= Cint(DvBoke.System_Setting(9))-1 Then
				Temp = Temp & Temp2
				ii = 0
			Else
				ii = ii+1
			End If
		Next
		Temp = Replace(Temp,"{$width}",Dvboke.System_UpSetting(14))
		Temp = Replace(Temp,"{$height}",Dvboke.System_UpSetting(15))
		PageHtml = Replace(PageHtml,"{$topiclist}",DvBoke.Page_Strings(25).text)
		PageHtml = Replace(PageHtml,"{$photo_list}",Temp)
	Else
		PageHtml = Replace(PageHtml,"{$topiclist}",TopicHtml)
	End If
	PageSearch = "s=3&m="&m&"&keyword="&keyword
	PageHtml = Replace(PageHtml,"{$Page}",Page)
	PageHtml = Replace(PageHtml,"{$MaxRows}",MaxRows)
	PageHtml = Replace(PageHtml,"{$CountNum}",CountNum)
	PageHtml = Replace(PageHtml,"{$PageSearch}",PageSearch)
	PageHtml = Replace(PageHtml,"{$bokename}",DvBoke.BokeName)
	PageHtml = Replace(PageHtml,"{$bokeurl}",DvBoke.ModHtmlLinked)

	Response.Write PageHtml
End Sub

Function Page_UserFile_Del()
	Dim FileID,iTopic,i,Rs,tRs
	Dim PostContent,objFSO,FilePath,ViewFilepath,IsUpfile
	'On Error Resume Next
	Set objFSO = Dvbbs.iCreateObject("Scripting.FileSystemObject")
	FilePath = DvBoke.System_UpSetting(19)
	FileID = Request("fileid")
	iTopic = Request("iTopic")
	If FileID = "" Or iTopic = "" Then
		DvBoke.ShowCode(9)
		DvBoke.ShowMsg(2)
		Page_UserFile_Del = DvBoke.InputShowMsg
		Exit Function
	End If
	If Not IsNumeric(iTopic) Then
		DvBoke.ShowCode(9)
		DvBoke.ShowMsg(2)
		Page_UserFile_Del = DvBoke.InputShowMsg
		Exit Function
	End If
	iTopic = Cint(iTopic)
	If iTopic <> 0 Then
		DvBoke.ShowCode(9)
		DvBoke.ShowMsg(2)
		Page_UserFile_Del = DvBoke.InputShowMsg
		Exit Function
	End If
	FileID = Replace(FileID," ","")
	FileID = Split(FileID,",")
	
	For i = 0 To Ubound(FileID)
		If IsNumeric(FileID(i)) Then
			Set Rs=DvBoke.Execute("Select * From Dv_Boke_Upfile Where BokeUserID = " & DvBoke.BokeUserID & " And ID = " & FileID(i))
			If Not (Rs.Eof And Rs.Bof) Then
				'如关联帖子,则更新相应数据
				If (Rs("IsTopic")=0 Or Rs("IsTopic")=1) And Rs("PostID")>0 Then
					Set tRs=DvBoke.Execute("Select * From Dv_Boke_Post Where PostID=" & Rs("PostID"))
					If Not (tRs.Eof And tRs.Bof) Then
						IsUpfile = 0
						PostContent = tRs("Content")
						PostContent = Replace(PostContent,"[upload="&Split(Rs("FileName"),".")(1)&"]"&Rs("FileName")&"[/upload]","")
						PostContent = DvBoke.CheckStr(PostContent)
						If InStr(PostContent,"[/upload]") > 0 Then IsUpfile = 1
						DvBoke.Execute("Update Dv_Boke_Post Set Content = '" & PostContent & "',IsUpfile="&IsUpfile&" Where PostID = " & Rs("PostID"))
					End If
					tRs.Close:Set tRs=Nothing
				End If
				'删除附件
				If DvBoke.SysObjFso=True Then
					If objFSO.FileExists(Server.MapPath(FilePath & Rs("FileName"))) Then
						objFSO.DeleteFile(Server.MapPath(FilePath & Rs("FileName")))
					End If
					ViewFilepath = Rs("PreviewImage")
					IF Not IsNull(ViewFilepath) And ViewFilepath<>"" Then
						ViewFilepath=Replace(ViewFilepath,"..","")
						If objFSO.FileExists(Server.MapPath(ViewFilepath)) Then
							objFSO.DeleteFile(Server.MapPath(ViewFilepath))
						End If
					End IF
				End If
				'删除附件表记录
				DvBoke.Execute("Delete From Dv_Boke_Upfile Where ID = " & Rs("ID"))
			End If
			Rs.Close:Set Rs=Nothing
		End If
	Next
	DvBoke.ShowCode(51)
	DvBoke.ShowMsg(2)
	Page_UserFile_Del = DvBoke.InputShowMsg
End Function

'个人博客数据更新或统计
Sub Page_Count()
	Dim PageHtml
	PageHtml = DvBoke.Page_Strings(28).text
	Select Case t
		Case "1"
			Update_UserNickName()
		Case "2"
			Update_UserCatData()
		Case "3"
			Update_UserBokeData()
	Case Else
	End Select
	Response.Write PageHtml
End Sub

'更新用户笔名
Sub Update_UserNickName()
	Dim Sql
	'[Dv_Boke_Topic]
	Sql = "Update [Dv_Boke_Topic] Set UserName = '"&DvBoke.CheckStr(DvBoke.BokeUserName)&"' Where UserID="&DvBoke.BokeUserID
	DvBoke.Execute Sql
	DvBoke.ShowCode("主题信息更新完成！")
	'[Dv_Boke_Upfile]
	Sql = "Update [Dv_Boke_Upfile] Set UserName = '"&DvBoke.CheckStr(DvBoke.BokeUserName)&"' Where UserID="&DvBoke.BokeUserID
	DvBoke.Execute Sql
	DvBoke.ShowCode("上传文件信息更新完成！")
	'[Dv_Boke_Post]
	Sql = "Update [Dv_Boke_Post] Set UserName = '"&DvBoke.CheckStr(DvBoke.BokeUserName)&"' Where UserID="&DvBoke.BokeUserID
	DvBoke.Execute Sql
	DvBoke.ShowCode("回复信息更新完成！")
	DvBoke.ShowMsg(0)
End Sub
'更新栏目数据
Sub Update_UserCatData()
	Dim Rs,Sql,DayStr
	Dim ChildNode,uCatID
	Dim TopicNum,PostNum,TodayNum,LastUpTime
	If Dv_Boke_DataBase = 1 Then
		DayStr = "d"
	Else
		DayStr = "'d'"
	End If
	If DvBoke.BokeCatNode.length>0 Then
		For Each ChildNode In DvBoke.BokeCatNode
			uCatID = DvBoke.CheckNumeric(ChildNode.getAttribute("ucatid"))
			If uCatID>0 Then
				TopicNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Topic] Where CatID = "&uCatID)(0)
				PostNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Post] Where ParentID>0 and CatID = "&uCatID)(0)
				TodayNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Post] Where CatID = "&uCatID&" and DateDiff("&DayStr&",JoinTime,"&bSqlNowString&") = 0")(0)
				
				'Response.Write "Select Top 1 JoinTime From [Dv_Boke_Post] Where CatID = "&uCatID&" order by JoinTime,postid desc"

				Set Rs = DvBoke.Execute("Select Top 1 JoinTime From [Dv_Boke_Post] Where CatID = "&uCatID&" order by JoinTime desc")
				If Rs.Eof Then
					LastUpTime = Now()
				Else
					LastUpTime = Rs(0)
				End If
				Rs.Close
				ChildNode.attributes.getNamedItem("topicnum").text = TopicNum
				ChildNode.attributes.getNamedItem("postnum").text = PostNum
				ChildNode.attributes.getNamedItem("todaynum").text = TodayNum
				ChildNode.attributes.getNamedItem("lastuptime").text = LastUpTime
				DvBoke.Execute("Update Dv_Boke_UserCat Set TopicNum="&TopicNum&",PostNum="&PostNum&",TodayNum="&TodayNum&",LastUpTime = '"&LastUpTime&"' where  uCatID = "&uCatID)
				DvBoke.ShowCode("["&ChildNode.getAttribute("ucattitle")&"] 更新完成：主题共 "&TopicNum&" 篇，评论共 "&PostNum&" 篇，今日帖共 "&TodayNum&" 篇； ")
			End If
		Next
		DvBoke.Execute("Update Dv_Boke_User set XmlData = '"&Replace(DvBoke.BokeCat.documentElement.xml,"'","''")&"' where UserID="&DvBoke.BokeUserID)
	End If
	DvBoke.ShowCode(DvBoke.BokeCatNode.length&" 个分栏更新完成！")
	DvBoke.ShowMsg(0)
End Sub
'更新个人博客总数据
Sub Update_UserBokeData()
	'[Dv_Boke_User]
	Dim DayStr,Rs
	Dim TopicNum,FavNum,PhotoNum,PostNum,TodayNum,LastUpTime,SpaceSize
	TopicNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Topic] Where sType=0 and UserID = "&DvBoke.BokeUserID)(0)
	FavNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Topic] Where sType=1 and UserID = "&DvBoke.BokeUserID)(0)
	PhotoNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Topic] Where sType=4 and UserID = "&DvBoke.BokeUserID)(0)
	PostNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Post] Where ParentID>0 and BokeUserID = "&DvBoke.BokeUserID)(0)
	If Dv_Boke_DataBase = 1 Then
		DayStr = "d"
	Else
		DayStr = "'d'"
	End If
	TodayNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Post] Where BokeUserID = "&DvBoke.BokeUserID&" and DateDiff("&DayStr&",JoinTime,"&bSqlNowString&") = 0")(0)
	Set Rs = DvBoke.Execute("Select Top 1 JoinTime From [Dv_Boke_Post] Where BokeUserID = "&DvBoke.BokeUserID&" order by JoinTime desc")
	If Rs.Eof Then
		LastUpTime = Now()
	Else
		LastUpTime = Rs(0)
	End If
	DvBoke.ShowCode("博客总数据更新完成：主题共 "&TopicNum&" 篇，收藏共 "&FavNum&" 篇，相册共 "&PhotoNum&" 张，评论共 "&PostNum&" 篇，今日帖共 "&TodayNum&" 篇。 ")
	Dvboke.BokeNode.attributes.getNamedItem("spacesize").text = cCur(Dvboke.BokeNode.getAttribute("spacesize"))
	If Dvboke.BokeNode.getAttribute("spacesize")>0 Then
		SpaceSize = DvBoke.Execute("Select Sum(FileSize) From [Dv_Boke_Upfile] Where BokeUserID = "&DvBoke.BokeUserID)(0)
		If SpaceSize>0 Then
			SpaceSize = Formatnumber((SpaceSize/1024)/1024,2)
			Dvboke.BokeNode.attributes.getNamedItem("spacesize").Text = cCur(DvBoke.System_Setting(15)) - SpaceSize
			If Dvboke.BokeNode.getAttribute("spacesize")<0 Then Dvboke.BokeNode.attributes.getNamedItem("spacesize").text = 0
		End If
		If Dvboke.BokeNode.getAttribute("spacesize") = 0 Then
			DvBoke.ShowCode("您的博客已超出"&DvBoke.System_Setting(15)&"MB，需要更多的空间请与管理员联系！")
		Else
			DvBoke.ShowCode("您的上传空间还有"&Dvboke.BokeNode.getAttribute("spacesize")&"MB。")
		End If
	End If
	DvBoke.Execute("Update Dv_Boke_User set TopicNum="&TopicNum&",FavNum="&FavNum&",PhotoNum="&PhotoNum&",PostNum="&PostNum&",TodayNum="&TodayNum&",LastUpTime='"&LastUpTime&"',spacesize = "&Dvboke.BokeNode.getAttribute("spacesize")&" where UserID="&DvBoke.BokeUserID)
	DvBoke.ShowMsg(0)
End Sub

%>