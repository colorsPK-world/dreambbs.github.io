<!--#include FILE="conn.asp"-->
<!--#include file="inc/const.asp" -->
<!--#include file="boke/config.asp"-->
<!--#include file="boke/checkinput.asp"-->
<%
Dim iArchiveLink
Page_Main
DvBoke.Footer
Dvbbs.PageEnd()
Sub Page_Main()
	Dim MainHtml
	If Ubound(DvBoke.ArchiveLink) < 1 Then 
		iArchiveLink = "ShowAll"
	Else
		iArchiveLink = DvBoke.ArchiveLink(1)
	End If
	Select Case iArchiveLink
	Case "showtopic"
		DvBoke.Stats = "频道--文章"
		DvBoke.Nav(0)
		MainHtml = DvBoke.Main_Strings(5).text
		MainHtml = Replace(MainHtml,"{$Main}",ShowTopic())
	Case "showchannel"
		DvBoke.Stats = "频道"
		DvBoke.Nav(0)
		MainHtml = DvBoke.Main_Strings(5).text
		MainHtml = Replace(MainHtml,"{$Main}",ShowChannel())
	Case Else
		DvBoke.Stats = "首页"
		DvBoke.Nav(0)
		MainHtml = DvBoke.Main_Strings(5).text
		MainHtml = Replace(MainHtml,"{$Main}",TopicList)
	End Select
	DvBoke.LeftMenu
	'If DvBoke.BokeUserID=0 Then Exit Sub
	Response.Write MainHtml
End Sub

'TopicID,CatID,sCatID,UserID,UserName,Title,TitleNote,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,LastPoster,LastPostID,IsBest,S_Key,Weather
'首页主题显示
Function TopicList()
	If DvBoke.BokeUserID=0 Then
		DvBoke.ShowCode(46)
		DvBoke.ShowMsg(0)
	End If
	Dim TopicHtml
	Dim Node,ChildNodes

	Set Node = DvBoke.BokeCat.selectNodes("xml/boketopic/rs:data/z:row")
	If (Node Is Nothing) Then Exit Function
	Dim Weather,Weather_A,Weather_B,Weather_C
	Weather_A = Split(DvBoke.System_Setting(13),"|")
	Weather_B = Split(DvBoke.System_Setting(14),"|")
	Weather_C = Ubound(Weather_A)
	Dim PostDate,Title,Content,Channels,ChannelTitle
	For Each ChildNodes in Node
		PostDate = ChildNodes.getAttribute("posttime")
		If Not IsDate(ChildNodes.getAttribute("posttime")) Then
			PostDate = FormatDateTime(Now(),1) & " " & FormatDateTime(Now(),4)
		Else
			PostDate = FormatDateTime(PostDate,1) & " " & FormatDateTime(PostDate,4)
		End If
		Title = ChildNodes.getAttribute("title")
		If Len(Title)>150 Then
			Title = Left(Title,150) &"......"
		End If
		Title = Dv_FilterJS_T(Title)
		Set Channels = DvBoke.BokeCat.selectSingleNode("//rs:data/z:row[@ucatid='"&ChildNodes.getAttribute("catid")&"']")
		If Channels Is Nothing Then
			ChannelTitle = PostDate
		Else
			ChannelTitle = Channels.getAttribute("ucattitle")
		End If
		Content = ChildNodes.getAttribute("titlenote")
		TopicHtml = DvBoke.Main_Strings(6).text
		TopicHtml = Replace(TopicHtml,"{$PostDate}",PostDate)
		If Clng(ChildNodes.getAttribute("weather")) > Weather_C Or Clng(ChildNodes.getAttribute("weather")) < 0 Then
			TopicHtml = Replace(TopicHtml,"{$Weather_A}","晴天")
			TopicHtml = Replace(TopicHtml,"{$Weather_B}","sun.gif")
		Else
			TopicHtml = Replace(TopicHtml,"{$Weather_A}",Weather_A(ChildNodes.getAttribute("weather")))
			TopicHtml = Replace(TopicHtml,"{$Weather_B}",Weather_B(ChildNodes.getAttribute("weather")))
		End If
		TopicHtml = Replace(TopicHtml,"{$topic}",Title)
		TopicHtml = Replace(TopicHtml,"{$Content}",Content)
		TopicHtml = Replace(TopicHtml,"{$PostUserName}",ChildNodes.getAttribute("username"))
		TopicHtml = Replace(TopicHtml,"{$PChannel}",ChannelTitle)
		TopicHtml = Replace(TopicHtml,"{$Childs}",ChildNodes.getAttribute("child"))
		TopicHtml = Replace(TopicHtml,"{$Hits}",ChildNodes.getAttribute("hits"))
		TopicHtml = Replace(TopicHtml,"{$TopicID}",ChildNodes.getAttribute("topicid"))
		TopicHtml = Replace(TopicHtml,"{$CatID}",ChildNodes.getAttribute("catid"))
		TopicHtml = Replace(TopicHtml,"{$sCatID}",ChildNodes.getAttribute("scatid"))
		TopicHtml = Replace(TopicHtml,"{$UserID}",ChildNodes.getAttribute("userid"))
		TopicHtml = Replace(TopicHtml,"{$cat_id}",ChildNodes.getAttribute("catid"))
		TopicHtml = Replace(TopicHtml,"{$cat_tid}",ChildNodes.getAttribute("stype"))
		'TopicHtml = Replace(TopicHtml,"","")
		TopicList = TopicList & TopicHtml
	Next
	TopicList = Replace(TopicList,"{$Skins_Path}",DvBoke.Skins_Path)
	TopicList = Replace(TopicList,"{$bokename}",DvBoke.BokeName)
	TopicList = Replace(TopicList,"{$bokeurl}",DvBoke.ModHtmlLinked)
End Function

'频道文章显示
Function ShowTopic()
	If DvBoke.BokeUserID=0 Then Exit Function
	Dim ChannelNav,cat_tid,cat_id,PageHtml
	Dim RootID,iRootID,iPage
	Dim ChannelInfo
	Dim Nodes,Node,VisitList,TempStr
	If Ubound(DvBoke.ArchiveLink) < 2 Then
		RootID = 0
	Else
		iRootID = Split(DvBoke.ArchiveLink(2),"-")
		If Ubound(iRootID) = 1 Then
			iPage = DvBoke.CheckNumeric(Replace(Lcase(iRootID(1)),".html",""))
			RootID = iRootID(0)
		Else
			iPage = 1
			RootID = DvBoke.CheckNumeric(Replace(Lcase(iRootID(0)),".html",""))
		End If
	End If
	If RootID = 0 Then
		DvBoke.ShowCode(36)
		DvBoke.ShowMsg(0)
		Exit Function
	End If
	Dim Weather,Weather_A,Weather_B,Weather_C
	Weather_A = Split(DvBoke.System_Setting(13),"|")
	Weather_B = Split(DvBoke.System_Setting(14),"|")
	Weather_C = Ubound(Weather_A)
	
	Dim Rs,Sql
	Dim IsLock,Title,Childs,Hits,PostDate,VisitPic,VisitDoc,VisitXml
	Sql = "Select * From Dv_Boke_Topic Where UserID="&DvBoke.BokeUserID&" and TopicID ="&RootID
	Set Rs = DvBoke.Execute(Sql)
	If Rs.Eof Then
		DvBoke.ShowCode(36)
		DvBoke.ShowMsg(0)
	Else
		IsLock = Rs("IsLock")
		Select Case IsLock
			Case 3	'隐藏
				If Rs("UserID")<>DvBoke.UserID Then
					DvBoke.ShowCode(36)
					DvBoke.ShowMsg(0)
				End If
			Case 2	'关闭
				If Not (Rs("UserID")=DvBoke.UserID or Dvbbs.Master) Then
					DvBoke.ShowCode(36)
					DvBoke.ShowMsg(0)
				End If
			Case 1	'认证

		End Select
		cat_tid = Rs("sType")
		cat_id = Rs("CatID")
		Title = Dv_FilterJS_T(Rs("Title"))
		Childs = Rs("Child")
		Hits = Rs("Hits") + 1
		PostDate = Rs("PostTime")
		VisitDoc = Rs("VisitUser")
		Weather = Rs("Weather")
		DvBoke.Execute("Update Dv_Boke_Topic set hits=hits+1 where TopicID ="&RootID)
	End If
	Rs.Close
	If cat_tid = 2 Then
		Dim GetUrl
		GetUrl = DvBoke.Execute("Select Top 1 Content From [Dv_Boke_Post] where ParentID=0 and Rootid="&Rootid)(0)
		Response.Redirect DvBoke.Furl(GetUrl)
	End If
	DvBoke.LoadPage("topic.xslt")
	Set Node = DvBoke.BokeCat.documentElement.selectSingleNode("rs:data/z:row[@utype='"&cat_id&"']")
	If Not (Node is Nothing) Then
		ChannelInfo = Node.getAttribute("ucatnote")
	Else
		ChannelInfo = ""
	End If
	PageHtml = DvBoke.Page_Strings(0).text
	ChannelNav = DvBoke.Main_Strings(19).text
	ChannelNav = Replace(ChannelNav,"{$bokeuser}",DvBoke.BokeUserName)
	ChannelNav = Replace(ChannelNav,"{$stype}",DvBoke.BokeStype(cat_tid))
	ChannelNav = Replace(ChannelNav,"{$stats}","浏览信息《"&Title&"》")
	ChannelNav = Replace(ChannelNav,"{$Channel_Intro}",ChannelInfo)
	'-----------------------------------------------
	VisitPic = DvBoke.BokeSetting(12)
	
	Set VisitXml=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
	If Not VisitXml.Loadxml(VisitDoc&"") Then
		PageHtml = Replace(PageHtml,"{$VisitList}",DvBoke.Page_Strings(6).text)
		If DvBoke.UserID>0 and not DvBoke.IsBokeOwner Then
			PageHtml = Replace(PageHtml,"{$Vsisitstr}",DvBoke.Page_Strings(7).text)
		Else
			PageHtml = Replace(PageHtml,"{$Vsisitstr}",DvBoke.Page_Strings(8).text)
		End If
	Else
		Set Nodes = VisitXml.documentElement.selectNodes("UserList")
		Set Node = VisitXml.DocumentElement.selectSingleNode("UserList[@uid='"&Dvboke.UserID&"']")
		If Not (Node is nothing) Then
			PageHtml = Replace(PageHtml,"{$Vsisitstr}",DvBoke.Page_Strings(8).text)
		Else
			PageHtml = Replace(PageHtml,"{$Vsisitstr}",DvBoke.Page_Strings(7).text)
		End If
		For Each Node in Nodes
			If Node.getAttribute("usex") = 0 Then
				VisitPic = DvBoke.BokeSetting(13)
			Else
				VisitPic = DvBoke.BokeSetting(12)
			End If
			TempStr = DvBoke.Page_Strings(14).text
			TempStr = Replace(TempStr,"{$VisitName}",Node.getAttribute("uname"))
			TempStr = Replace(TempStr,"{$VisitPic}",VisitPic)
			TempStr = Replace(TempStr,"{$VisitIP}",Node.getAttribute("uip"))
			TempStr = Replace(TempStr,"{$VisitTime}",Node.getAttribute("utime"))
			TempStr = Replace(TempStr,"{$Uid}",Node.getAttribute("uid"))
			VisitList = VisitList & TempStr
		Next
	End If
	If DvBoke.UserID>0 Then
		If DvBoke.UserSex = 0 Then
			VisitPic = DvBoke.BokeSetting(13)
		Else
			VisitPic = DvBoke.BokeSetting(12)
		End If
	End If
	PageHtml = Replace(PageHtml,"{$VisitPic}",VisitPic)
	PageHtml = Replace(PageHtml,"{$VisitList}",VisitList)
	'-----------------------------------------------
	PageHtml = Replace(PageHtml,"{$nav}",ChannelNav)
	PageHtml = Replace(PageHtml,"{$bokeurl}",DvBoke.ModHtmlLinked)
	PageHtml = Replace(PageHtml,"{$catname}",DvBoke.ChannelTitle(cat_id))
	PageHtml = Replace(PageHtml,"{$cat_tid}",cat_tid)
	PageHtml = Replace(PageHtml,"{$cat_id}",cat_id)
	PageHtml = Replace(PageHtml,"{$title}",Title)
	PageHtml = Replace(PageHtml,"{$child}",Childs)
	PageHtml = Replace(PageHtml,"{$hits}",Hits)
	PageHtml = Replace(PageHtml,"{$WeekName}",WeekDayName(WeekDay(PostDate,1)))
	If Clng(Weather) > Weather_C Or Clng(Weather) < 0 Then
		PageHtml = Replace(PageHtml,"{$Weather_A}","晴天")
		PageHtml = Replace(PageHtml,"{$Weather_B}","sun.gif")
	Else
		PageHtml = Replace(PageHtml,"{$Weather_A}",Weather_A(Weather))
		PageHtml = Replace(PageHtml,"{$Weather_B}",Weather_B(Weather))
	End If
	PageHtml = Replace(PageHtml,"{$DispList}",ShowDispList(Rootid,iPage))
	Dim P_PostUserName
	If DvBoke.IsBokeOwner Then
		P_PostUserName = DvBoke.BokeUserName
	Else
		P_PostUserName = DvBoke.UserName
	End If
	If DvBoke.System_Setting(2)<>"1" and DvBoke.UserID=0 Then
		PageHtml = Replace(PageHtml,"{$replyform}","")
	Else
		PageHtml = Replace(PageHtml,"{$replyform}",DvBoke.Page_Strings(9).text)
		If DvBoke.BokeSetting(8) = "0" Then
			PageHtml = Replace(PageHtml,"{$isalipay}","")
		Else
			PageHtml = Replace(PageHtml,"{$isalipay}",DvBoke.Page_Strings(31).text)
		End If
		If DvBoke.System_Setting(5) = "1" Then
			PageHtml = Replace(PageHtml,"{$getcode}",DvBoke.Page_Strings(34).text)
			Dvbbs.LoadTemplates("")
			PageHtml = Replace(PageHtml,"{$Dv_GetCode}",Dvbbs.GetCode)
		Else
			PageHtml = Replace(PageHtml,"{$getcode}","")
		End If
	End If
	PageHtml = Replace(PageHtml,"{$PostUserName}",P_PostUserName)
	PageHtml = Replace(PageHtml,"{$RootID}",Rootid)
	PageHtml = Replace(PageHtml,"{$bokename}",DvBoke.BokeName)
	PageHtml = Replace(PageHtml,"{$Skins_Path}",DvBoke.Skins_Path)
	ShowTopic = PageHtml
End Function

Function ShowDispList(TopicID,Page)
	Dim PageHtml,TempHtml,Temp
	Dim Rs,Sql,SqlStr
	Dim MaxRows,Endpage,CountNum,PageSearch
	Endpage = 0
	MaxRows = DvBoke.BokeSetting(8)
	'Page = Request("Page")
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)
	'If Ubound(DvBoke.ArchiveLink) = 4 Then
	'	SqlStr = DvBoke.CheckNumeric(Replace(Lcase(DvBoke.ArchiveLink(3)),".html",""))
	'	SqlStr = " And (ParentID = 0 Or PostID = " & SqlStr & ")"
	'End If
	'PostID=0 ,CatID=1 ,sCatID=2 ,ParentID=3 ,RootID=4 ,UserID=5 ,UserName=6 ,Title=7 ,Content=8 ,JoinTime=9 ,IP=10 ,sType=11
	Sql = "Select PostID,CatID,sCatID,ParentID,RootID,UserID,UserName,Title,Content,JoinTime,IP,sType From [Dv_Boke_Post] Where RootID="&TopicID&" "&SqlStr&" order by PostID "
	'Response.Write Ubound(DvBoke.ArchiveLink)
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
		DvBoke.ShowCode(36)
		DvBoke.ShowMsg(0)
	End If
	Rs.close:Set Rs = Nothing
	Dim i,Content
	'-------------------------------------
	Dim DvCode
	Set DvCode = New DvBoke_UbbCode
	For i=0 To Ubound(SQL,2)

		Content = DvCode.UbbCode(Sql(8,i))

		Temp = DvBoke.Page_Strings(2).text
		If DvBoke.UserID>0 and (DvBoke.UserID = Sql(5,i) or DvBoke.IsMaster) Then
			Temp = Replace(Temp,"{$Edit}",DvBoke.Page_Strings(3).text)
		Else
			Temp = Replace(Temp,"{$Edit}","")
		End If
		If (DvBoke.IsBokeOwner or DvBoke.IsMaster) and Sql(3,i) = 0 Then
			Temp = Replace(Temp,"{$Manage}",DvBoke.Page_Strings(4).text)
		Else
			Temp = Replace(Temp,"{$Manage}","")
		End If
		If DvBoke.IsBokeOwner or DvBoke.IsMaster Then
			Temp = Replace(Temp,"{$Delete}",DvBoke.Page_Strings(5).text)
		Else
			Temp = Replace(Temp,"{$Delete}","")
		End If
		If Sql(3,i)=0 Then
			Temp =  Replace(Temp,"{$ReTitle}","")
		Else
			Temp =  Replace(Temp,"{$ReTitle}",DvBoke.Page_Strings(19).text)
			Temp =  Replace(Temp,"{$RTitle}",Dv_FilterJS_T(Sql(7,i)))
		End If
		If Sql(5,i)=0 Then
			Temp =  Replace(Temp,"{$PostUserName}","访客："&replace(Sql(6,i),"<","&lt;"))
		Else
			Temp =  Replace(Temp,"{$PostUserName}",replace(Sql(6,i),"<","&lt;"))
		End If
		Temp =  Replace(Temp,"{$PostID}",Sql(0,i))
		Temp =  Replace(Temp,"{$UserID}",Sql(5,i))
		Temp =  Replace(Temp,"{$Content}",Content)
		Temp =  Replace(Temp,"{$PostDate}",Sql(9,i))
		TempHtml = TempHtml & Temp
	Next
	Set DvCode = Nothing
	'-------------------------------------
	'boke.asp?sw/showtopic/10.html
	PageSearch = DvBoke.Furl(DvBoke.ModHtmlLinked & DvBoke.BokeName&".showtopic."&Topicid&"")
	'PageSearch = DvBoke.Furl("act=showtopic&user="&DvBoke.BokeName&"&rootid="&Topicid)
	TempHtml = TempHtml & DvBoke.Page_Strings(1).text
	PageHtml = Replace(TempHtml,"{$fontsize}",DvBoke.BokeSetting(9))
	PageHtml = Replace(PageHtml,"{$lineheight}",DvBoke.BokeSetting(10))
	PageHtml =  Replace(PageHtml,"{$RootID}",TopicID)
	PageHtml = Replace(PageHtml,"{$Page}",Page)
	PageHtml = Replace(PageHtml,"{$MaxRows}",MaxRows)
	PageHtml = Replace(PageHtml,"{$CountNum}",CountNum)
	PageHtml = Replace(PageHtml,"{$PageSearch}",PageSearch)
	PageHtml = Replace(PageHtml,"{$bokename}",DvBoke.BokeName)
	PageHtml = Replace(PageHtml,"{$Skins_Path}",DvBoke.Skins_Path)
	ShowDispList = PageHtml
End Function


'频道主题列表显示
Function ShowChannel()
	If DvBoke.BokeUserID=0 Then Exit Function
	Dim cat_tid,cat_id,CatStr,iCat_tID,iCat_ID,iPage
	If Ubound(DvBoke.ArchiveLink) > 1 Then
		iCat_tID = Split(DvBoke.ArchiveLink(2),"-")
		If Ubound(iCat_tID) = 1 Then
			iPage = DvBoke.CheckNumeric(Replace(Lcase(iCat_tID(1)),".html",""))
			cat_tid = iCat_tID(0)
		Else
			iPage = 1
			cat_tid = DvBoke.CheckNumeric(Replace(Lcase(iCat_tID(0)),".html",""))
		End If
	End If
	If Ubound(DvBoke.ArchiveLink) > 2 Then
		iCat_ID = Split(DvBoke.ArchiveLink(3),"-")
		If Ubound(iCat_ID) = 1 Then
			iPage = DvBoke.CheckNumeric(Replace(Lcase(iCat_ID(1)),".html",""))
			cat_id = iCat_ID(0)
		Else
			iPage = 1
			cat_id = DvBoke.CheckNumeric(Replace(Lcase(iCat_ID(0)),".html",""))
		End If
	End If
	If cat_tid="" or Not IsNumeric(cat_tid) Then
		Exit Function
	Else
		cat_tid = Clng(cat_tid)
	End If

	Dim ChannelNav,ChannelInfo,Node
	Set Node = DvBoke.BokeCat.documentElement.selectSingleNode("rs:data/z:row[@utype='"&cat_id&"']")
	If Not (Node is Nothing) Then
		ChannelInfo = Node.getAttribute("ucatnote")
	Else
		ChannelInfo = ""
	End If
	ChannelNav = DvBoke.Main_Strings(19).text
	ChannelNav = Replace(ChannelNav,"{$bokeuser}",DvBoke.BokeUserName)
	ChannelNav = Replace(ChannelNav,"{$stype}",DvBoke.BokeStype(cat_tid))
	ChannelNav = Replace(ChannelNav,"{$catname}",DvBoke.ChannelTitle(cat_id))
	ChannelNav = Replace(ChannelNav,"{$stats}","信息列表")
	ChannelNav = Replace(ChannelNav,"{$cat_tid}",cat_tid)
	ChannelNav = Replace(ChannelNav,"{$cat_id}",cat_id)
	ChannelNav = Replace(ChannelNav,"{$Channel_Intro}",ChannelInfo)
	Dim Weather,Weather_A,Weather_B,Weather_C
	Weather_A = Split(DvBoke.System_Setting(13),"|")
	Weather_B = Split(DvBoke.System_Setting(14),"|")
	Weather_C = Ubound(Weather_A)
	Dim Rs,Sql
	Dim Page,MaxRows,Endpage,CountNum,PageSearch
	Endpage = 0
	MaxRows = Cint(DvBoke.BokeSetting(7))
	'MaxRows = 2
	Page = iPage
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)
	If Cat_ID > 0 Then
		CatStr = " and CatID="&cat_id
	End If
	IF cat_tid = 4 Then
		'相册
		'字段排序 ID=0 ,BokeUserID=1 ,UserName=2 ,CatID=3 ,sType=4 ,TopicID=5 ,PostID=6 ,IsTopic=7 ,Title=8 ,FileName=9 ,FileType=10 ,FileSize=11 ,FileNote=12 ,DownNum=13 ,ViewNum=14 ,DateAndTime=15 ,PreviewImage=16 ,IsLock=17
		Sql = "Select ID,BokeUserID,UserName,CatID,sType,TopicID,PostID,IsTopic,Title,FileName,FileType,FileSize,FileNote,DownNum,ViewNum,DateAndTime,PreviewImage,IsLock From Dv_Boke_Upfile where sType="&cat_tid&" "&CatStr&" and BokeUserID="&DvBoke.BokeUserID&" and IsTopic=0"
		If DvBoke.IsBokeOwner Then
			Sql = Sql & " order by DateAndTime Desc"
		Else
			Sql = Sql & " and IsLock<3 order by DateAndTime Desc"
		End If
	ElseIf cat_tid = 2 Then	'链接模式
		If Cat_ID > 0 Then
		CatStr = " and T.CatID="&cat_id
		End If
		''字段排序 TopicID=0 ,CatID=1 ,sCatID=2 ,UserID=3 ,UserName=4 ,Title=5 ,TitleNote=6 ,PostTime=7 ,Child=8 ,Hits=9 ,IsView=10 ,IsLock=11 ,sType=12 ,LastPostTime=13 ,IsBest=14 ,S_Key=15 ,Weather=16 
		Sql = "Select T.TopicID,T.CatID,T.sCatID,T.UserID,T.UserName,T.Title,T.TitleNote,T.PostTime,T.Child,T.Hits,T.IsView,T.IsLock,T.sType,T.LastPostTime,T.IsBest,T.S_Key,T.Weather,P.PostID From Dv_Boke_Topic T Inner Join [Dv_Boke_Post] P on P.Rootid=T.Topicid where P.ParentID=0 and T.sType="&cat_tid&" "&CatStr&" and T.UserID="&DvBoke.BokeUserID
		If DvBoke.IsBokeOwner Then
			Sql = Sql & " order by T.LastPostTime Desc"
		Else
			Sql = Sql & " and T.IsLock<3 order by T.LastPostTime Desc"
		End If

	Else
		''字段排序 TopicID=0 ,CatID=1 ,sCatID=2 ,UserID=3 ,UserName=4 ,Title=5 ,TitleNote=6 ,PostTime=7 ,Child=8 ,Hits=9 ,IsView=10 ,IsLock=11 ,sType=12 ,LastPostTime=13 ,IsBest=14 ,S_Key=15 ,Weather=16 
		Sql = "Select TopicID,CatID,sCatID,UserID,UserName,Title,TitleNote,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,IsBest,S_Key,Weather From Dv_Boke_Topic where sType="&cat_tid&" "&CatStr&" and Userid="&DvBoke.BokeUserID
		If DvBoke.IsBokeOwner Then
			Sql = Sql & " order by LastPostTime Desc"
		Else
			Sql = Sql & " and IsLock<3 order by LastPostTime Desc"
		End If
	End If
	'Response.Write sql
	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	If Dv_Boke_InDvbbsData = 1 Then
		If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase
		Rs.Open Sql,Boke_Conn,1,1
	Else
		If Not IsObject(Conn) Then ConnectionDatabase
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
		DvBoke.ShowCode(36)
		DvBoke.ShowMsg(0)
	End If
	Rs.close:Set Rs = Nothing

	'--------------------------------------------------------------------------
	Dim i,ii,Temp,Temp2,TopicHtml
	Dim Title,Content,Channels,ChannelTitle
	Dim PageHtml
	PageHtml = DvBoke.Main_Strings(18).text

	If cat_tid = 4 Then	'相册模式
		Temp2 = DvBoke.Main_Strings(22).text
		Dim ViewFile
		If Not IsNumeric(DvBoke.System_Setting(9)) Then
			DvBoke.System_Setting(9) = 3
		Else
			DvBoke.System_Setting(9) = Cint(DvBoke.System_Setting(9))
		End If
		For i=0 To Ubound(SQL,2)
			TopicHtml = DvBoke.Main_Strings(21).text
			Title = Sql(8,i)
			If Len(Title)>20 Then
				Title = Left(Title,20) &"......"
			End If
			ViewFile = Sql(16,i)
			If ViewFile="" or IsNull(ViewFile) Then
				ViewFile = DvBoke.System_UpSetting(19) & Sql(9,i)
			End If
			ViewFile = ViewFile
			If Sql(10,i) <> 1 Then
				ViewFile = "boke/images/info.gif"
			End If
			TopicHtml = Replace(TopicHtml,"{$ViewPhoto}",ViewFile)
			TopicHtml = Replace(TopicHtml,"{$topic}",Dv_FilterJS_T(Title))
			TopicHtml = Replace(TopicHtml,"{$PostDate}",FormatDateTime(Sql(15,i),1))
			TopicHtml = Replace(TopicHtml,"{$PostUserName}",Sql(2,i))
			TopicHtml = Replace(TopicHtml,"{$TopicID}",Sql(5,i))
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
		PageHtml = Replace(PageHtml,"{$topiclist}",DvBoke.Main_Strings(20).text)
		PageHtml = Replace(PageHtml,"{$photo_list}",Temp)

	ElseIf cat_tid = 2 Then	'链接模式
		Dim LinkLogo,PostID
		DvBoke.LoadPage("topic.xslt")
		For i=0 To Ubound(SQL,2)
			LinkLogo = Sql(6,i)
			TopicHtml = DvBoke.Page_Strings(28).text
			
			PostID = Sql(17,i)
			If LinkLogo<>"" Then
				TopicHtml = Replace(TopicHtml,"{$LinkeLogo}",DvBoke.Page_Strings(29).text)
				TopicHtml = Replace(TopicHtml,"{$LinkImg}",LinkLogo)
			Else
				TopicHtml = Replace(TopicHtml,"{$LinkeLogo}","")
			End If

			If DvBoke.UserID>0 and (DvBoke.UserID = Sql(3,i) or DvBoke.IsMaster) Then
				TopicHtml = Replace(TopicHtml,"{$Edit}",DvBoke.Page_Strings(3).text)
			Else
				TopicHtml = Replace(TopicHtml,"{$Edit}","")
			End If

			If DvBoke.IsBokeOwner or DvBoke.IsMaster Then
				TopicHtml= Replace(TopicHtml,"{$Manage}",DvBoke.Page_Strings(4).text)
				TopicHtml = Replace(TopicHtml,"{$Delete}",DvBoke.Page_Strings(30).text)
			Else
				TopicHtml = Replace(TopicHtml,"{$Manage}","")
				TopicHtml = Replace(TopicHtml,"{$Delete}","")
			End If
			TopicHtml = Replace(TopicHtml,"{$RootID}",Sql(0,i))
			TopicHtml = Replace(TopicHtml,"{$PostID}",PostID)
			TopicHtml = Replace(TopicHtml,"{$TopicID}",Sql(0,i))
			TopicHtml = Replace(TopicHtml,"{$topic}",Dv_FilterJS_T(Sql(5,i)))
			TopicHtml = Replace(TopicHtml,"{$hits}",Sql(9,i))
			TopicHtml = Replace(TopicHtml,"{$UserID}",Sql(3,i))
			TopicHtml = Replace(TopicHtml,"{$PostUserName}",Sql(4,i))
			TopicHtml = Replace(TopicHtml,"{$PostDate}",FormatDateTime(Sql(7,i),1) & " " & FormatDateTime(Sql(7,i),4))
			Temp = Temp & TopicHtml
		Next
	Else
		'-------------------------------------
		Dim DvCode
		Set DvCode = New DvBoke_UbbCode
		For i=0 To Ubound(SQL,2)
			TopicHtml = DvBoke.Main_Strings(6).text
			Title = Sql(5,i)
			If Len(Title)>150 Then
				Title = Left(Title,150) &"......"
			End If
			Content = Sql(6,i)
			ChannelTitle = DvBoke.ChannelTitle(Sql(1,i))
			If ChannelTitle = "" Then ChannelTitle = FormatDateTime(Sql(7,i),1) & " " & FormatDateTime(Sql(7,i),4)
			TopicHtml = Replace(TopicHtml,"{$PostDate}",FormatDateTime(Sql(7,i),1) & " " & FormatDateTime(Sql(7,i),4))
			If Clng(Sql(16,i)) > Weather_C Or Clng(Sql(16,i)) < 0 Then
				TopicHtml = Replace(TopicHtml,"{$Weather_A}","晴天")
				TopicHtml = Replace(TopicHtml,"{$Weather_B}","sun.gif")
			Else
				TopicHtml = Replace(TopicHtml,"{$Weather_A}",Weather_A(Sql(16,i)))
				TopicHtml = Replace(TopicHtml,"{$Weather_B}",Weather_B(Sql(16,i)))
			End If
			TopicHtml = Replace(TopicHtml,"{$topic}",Dv_FilterJS_T(Title))
			TopicHtml = Replace(TopicHtml,"{$Content}",DvCode.UbbCode(Content))
			TopicHtml = Replace(TopicHtml,"{$PostUserName}",Sql(4,i))
			TopicHtml = Replace(TopicHtml,"{$PChannel}",ChannelTitle)
			TopicHtml = Replace(TopicHtml,"{$Childs}",Sql(8,i))
			TopicHtml = Replace(TopicHtml,"{$Hits}",Sql(9,i))
			TopicHtml = Replace(TopicHtml,"{$TopicID}",Sql(0,i))
			TopicHtml = Replace(TopicHtml,"{$CatID}",Sql(1,i))
			TopicHtml = Replace(TopicHtml,"{$sCatID}",Sql(2,i))
			TopicHtml = Replace(TopicHtml,"{$UserID}",Sql(3,i))
			TopicHtml = Replace(TopicHtml,"{$cat_tid}",Sql(12,i))
			TopicHtml = Replace(TopicHtml,"{$cat_id}",Sql(1,i))
			Temp = Temp & TopicHtml
		Next
		Set DvCode = Nothing
		'-------------------------------------
	End If

	If Cat_ID > 0 Then
		PageSearch = DvBoke.Furl(DvBoke.ModHtmlLinked & DvBoke.BokeName & ".showchannel."&cat_tid&"."&Cat_ID&"")
	Else
		PageSearch = DvBoke.Furl(DvBoke.ModHtmlLinked & DvBoke.BokeName & ".showchannel."&cat_tid&"")
	End If
	PageHtml = Replace(PageHtml,"{$nav}",ChannelNav)
	PageHtml = Replace(PageHtml,"{$topiclist}",Temp)
	PageHtml = Replace(PageHtml,"{$Page}",Page)
	PageHtml = Replace(PageHtml,"{$MaxRows}",MaxRows)
	PageHtml = Replace(PageHtml,"{$CountNum}",CountNum)
	PageHtml = Replace(PageHtml,"{$PageSearch}",PageSearch)
	PageHtml = Replace(PageHtml,"{$bokename}",DvBoke.BokeName)
	PageHtml = Replace(PageHtml,"{$bokeurl}",DvBoke.ModHtmlLinked)
	PageHtml = Replace(PageHtml,"{$Skins_Path}",DvBoke.Skins_Path)
	ShowChannel = PageHtml
End Function
%>