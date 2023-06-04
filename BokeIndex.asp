<!--#include FILE="conn.asp"-->
<!--#include file="inc/const.asp" -->
<!--#include file="boke/config.asp"-->
<!--#include file="boke/Cls_System.asp"-->
<%
Dim DvBoke_Sys,Descriptions
DvBoke.LoadPage("index.xslt")

Set DvBoke_Sys = New Cls_DvBokeIndex
'DvBoke_Sys.MustUpdate =1
DvBoke_Sys.UpTime = 10
Dim iArchiveLink,iPage,iArchiveID,KeyWord,iSelType
Dim MainHtml
If Ubound(DvBoke.ArchiveLink) = 5 Then 
	iArchiveLink = "ShowAll"
Else
	iArchiveLink = Replace(Lcase(DvBoke.ArchiveLink(0)),".html","")
End If

Select Case iArchiveLink
	Case "show_user"
		DvBoke.Stats = "博客用户索引"
		DvBoke.Nav(1)
		Page_SysCatMain()
	Case "show_topic"
		If Ubound(DvBoke.ArchiveLink) < 1 Then 
			iArchiveLink = "ShowAll"
		Else
			If DvBoke.ArchiveLink(1)<>"" Then
				iArchiveID = Split(DvBoke.ArchiveLink(1),"-")
				If Ubound(iArchiveID) = 3 Then
					iSelType = DvBoke.CheckNumeric(iArchiveID(2))
					KeyWord = DvBoke.Checkstr(iArchiveID(1))
					iPage = DvBoke.CheckNumeric(Replace(Lcase(iArchiveID(3)),".html",""))
					iArchiveLink = iArchiveID(0)
				ElseIf Ubound(iArchiveID) = 1 Then
					iPage = DvBoke.CheckNumeric(Replace(Lcase(iArchiveID(1)),".html",""))
					iArchiveLink = iArchiveID(0)
				Else
					iPage = 1
					iArchiveLink = Replace(Lcase(iArchiveID(0)),".html","")
				End If
			Else
				iArchiveLink = -1
			End If
		End If
		Select Case iArchiveLink
		Case "1"
			DvBoke.Stats = "文章"
			Descriptions = DvBoke.Stats
		Case "2"
			DvBoke.Stats = "收藏"
			Descriptions = DvBoke.Stats
		Case "3"
			DvBoke.Stats = "书签"
			Descriptions = DvBoke.Stats
		Case "4"
			DvBoke.Stats = "交易"
			Descriptions = DvBoke.Stats
		Case "5"
			DvBoke.Stats = "相册"
			Descriptions = DvBoke.Stats
		Case Else
			DvBoke.Stats = "博客话题分类"
		End Select
		DvBoke.Nav(1)
		Page_SysTopicMain()
	Case Else
		DvBoke.Stats = "首页"
		DvBoke.Nav(1)
		Page_IndexMain()
End Select

DvBoke_Sys.SaveCache()
Set DvBoke_Sys = Nothing
DvBoke.Footer
Dvbbs.PageEnd()

'-----------------------------------------------------------
'首页主体页面
'-----------------------------------------------------------
Sub Page_IndexMain()
	Dim MainHtml,Node,Tempstr
	MainHtml = DvBoke.Page_Strings(0).text
	MainHtml = Replace(MainHtml,"{$Page_Main}",DvBoke.Page_Strings(1).text)
	MainHtml = Sys_Part(MainHtml)
	MainHtml = Sys_Translate(MainHtml)
	'------------------
	Set Node = DvBoke.SystemDoc.documentElement.selectSingleNode("/bokesystem/topnews")
	If Node Is Nothing Then
		Tempstr = ""
	Else
		Tempstr = Node.text
	End If
	MainHtml = Replace(MainHtml,"{$TopNewsMsg}",Tempstr)
	'------------------
	MainHtml = Replace(MainHtml,"{$skinpath}",DvBoke.Skins_Path)
	MainHtml = Replace(MainHtml,"{$bokename}",DvBoke.BokeName)
	Response.Write MainHtml
End Sub

Sub Page_SysCatMain()
	Dim MainHtml,Cat_ID,iCat_ID
	MainHtml = DvBoke.Page_Strings(0).text
	If Ubound(DvBoke.ArchiveLink) > 0 Then
		iCat_ID = Split(DvBoke.ArchiveLink(1),"-")
		If Ubound(iCat_ID) = 2 Then
			iPage = DvBoke.CheckNumeric(Replace(Lcase(iCat_ID(2)),".html",""))
			Cat_ID = iCat_ID(0)
			KeyWord = DvBoke.CheckStr(iCat_ID(1))
		ElseIf Ubound(iCat_ID) = 1 Then
			iPage = DvBoke.CheckNumeric(Replace(Lcase(iCat_ID(1)),".html",""))
			Cat_ID = iCat_ID(0)
		Else
			iPage = 1
			Cat_ID = DvBoke.CheckNumeric(Replace(Lcase(iCat_ID(0)),".html",""))
		End If
	End If
	MainHtml = Replace(MainHtml,"{$Page_Main}",DvBoke.Page_Strings(2).text)
	MainHtml = Replace(MainHtml,"{$SysCat}",GetSysCat())
	MainHtml = Replace(MainHtml,"{$BokeUserList}",DvBoke.Page_Strings(30).text)
	If Cat_ID = "" Or Cat_ID = "0" Then MainHtml = Replace(MainHtml,"{$Descriptions}",DvBoke.Page_Strings(45).text)
	MainHtml = Sys_BokeUser(MainHtml,Cat_ID)
	MainHtml = Replace(MainHtml,"{$skinpath}",DvBoke.Skins_Path)
	MainHtml = Replace(MainHtml,"{$ibokeurl}",DvBoke.mArchiveLink)
	MainHtml = Replace(MainHtml,"{$bokeurl}",DvBoke.ModHtmlLinked)
	Response.Write MainHtml
End Sub

Sub Page_SysTopicMain()
	Dim MainHtml
	Dim Cat_tID,Cat_ID,CatStr,iCat_tID,iCat_ID
	MainHtml = DvBoke.Page_Strings(0).text
	If Ubound(DvBoke.ArchiveLink) > 0 Then
		If DvBoke.ArchiveLink(1) <> "" Then
			iCat_tID = Split(DvBoke.ArchiveLink(1),"-")
			If Ubound(iCat_tID) = 3 Then
				Cat_tID = DvBoke.CheckNumeric(iCat_tID(0))
				iPage = DvBoke.CheckNumeric(Replace(Lcase(iCat_tID(3)),".html",""))
				iSelType = DvBoke.CheckNumeric(iCat_tID(2))
				KeyWord = DvBoke.Checkstr(iCat_tID(1))
			ElseIf Ubound(iCat_tID) = 1 Then
				iPage = DvBoke.CheckNumeric(Replace(Lcase(iCat_tID(1)),".html",""))
				Cat_tID = DvBoke.CheckNumeric(iCat_tID(0))
			Else
				iPage = 1
				Cat_tID = DvBoke.CheckNumeric(Replace(Lcase(iCat_tID(0)),".html",""))
			End If
		End If
	End If
	If Ubound(DvBoke.ArchiveLink) > 1 Then
		iCat_ID = Split(DvBoke.ArchiveLink(2),"-")
		If Ubound(iCat_ID) = 3 Then
			Cat_ID = iCat_ID(0)
			iPage = DvBoke.CheckNumeric(Replace(Lcase(iCat_ID(3)),".html",""))
			KeyWord = DvBoke.Checkstr(iCat_ID(1))
			iSelType = DvBoke.CheckNumeric(iCat_ID(2))
		ElseIf Ubound(iCat_ID) = 1 Then
			iPage = DvBoke.CheckNumeric(Replace(Lcase(iCat_ID(1)),".html",""))
			Cat_ID = iCat_ID(0)
		Else
			iPage = 1
			Cat_ID = DvBoke.CheckNumeric(Replace(Lcase(iCat_ID(0)),".html",""))
		End If
	End If
	If Cat_tID = "" Then Cat_tID = 0
	MainHtml = Replace(MainHtml,"{$Page_Main}",DvBoke.Page_Strings(3).text)
	If Cat_tID = "5" Then
		MainHtml = Replace(MainHtml,"{$BokeChatCat}","")
	Else
		MainHtml = Replace(MainHtml,"{$BokeChatCat}",DvBoke.Page_Strings(34).text)
		MainHtml = Replace(MainHtml,"{$SysCat}",GetChatCat(Cat_tID))
	End If
	If Cat_tID <> "0" Then MainHtml = Replace(MainHtml,"{$Descriptions}",Descriptions)
	If (Cat_tID = "0" And Cat_ID = "") Or Cat_ID = "0" Then
		MainHtml = Replace(MainHtml,"{$Descriptions}",DvBoke.Page_Strings(45).text)
		MainHtml = Replace(MainHtml,"{$Descriptions_a}","")
	End If
	If Cat_tID <> "0" And Cat_ID = "" Then
		MainHtml = Replace(MainHtml,"{$Descriptions_a}",DvBoke.Page_Strings(46).text)
		MainHtml = Replace(MainHtml,"{$showcat}",DvBoke.Page_Strings(45).text)
	End If
	If Cat_tID <> "0" And Cat_ID <> "" Then
		MainHtml = Replace(MainHtml,"{$Descriptions_a}",DvBoke.Page_Strings(46).text)
	End If
	If Cat_tID = "0" And Cat_ID <> "" Then
		MainHtml = Replace(MainHtml,"{$Descriptions}","{$showcat}")
		MainHtml = Replace(MainHtml,"{$Descriptions_a}","")
	End If
	MainHtml = Sys_TopicList(MainHtml,Cat_tID,Cat_ID)
	MainHtml = Replace(MainHtml,"{$skinpath}",DvBoke.Skins_Path)
	MainHtml = Replace(MainHtml,"{$ibokeurl}",DvBoke.mArchiveLink)
	MainHtml = Replace(MainHtml,"{$bokeurl}",DvBoke.ModHtmlLinked)
	Response.Write MainHtml
End Sub

'数据模板加载
Function Sys_Part(PagHtml)
	Dim Str1,i
	For i=5 To 18
		Str1 = "{$"&DvBoke.Page_Strings(i).getAttribute("title")&"}"
		If Instr(PagHtml,Str1) Then
			PagHtml = Replace(PagHtml,Str1,DvBoke.Page_Strings(i).text)
		End If
	Next
	PagHtml = Replace(PagHtml,"{$Page_WeekPostList}",DvBoke.Page_Strings(35).text)
	PagHtml = Replace(PagHtml,"{$Page_NewLinkList}",DvBoke.Page_Strings(36).text)
	Sys_Part = PagHtml
End Function

'调用数据转换
Function Sys_Translate(PagHtml)
	'新加入排行
	If Instr(PagHtml,"{$Page_NewJoinBoker}") Then
		PagHtml = Replace(PagHtml,"{$Page_NewJoinBoker}",Page_NewJoinBoker())
	End If
	'热门排行
	If Instr(PagHtml,"{$Page_HotBoker}") Then
		PagHtml = Replace(PagHtml,"{$Page_HotBoker}",Page_HotBoker())
	End If

	'最新文章
	If Instr(PagHtml,"{$Page_NewTopicList}") Then
		PagHtml = Replace(PagHtml,"{$Page_NewTopicList}",Page_NewTopicList())
	End If
	'最新评论
	If Instr(PagHtml,"{$Page_NewPostList}") Then
		PagHtml = Replace(PagHtml,"{$Page_NewPostList}",Page_NewPostList())
	End If
	'SysCatList
	If Instr(PagHtml,"{$SysCat}") Then
		PagHtml = Replace(PagHtml,"{$SysCat}",GetSysCat())
	End If 
	'SysCatList
	If Instr(PagHtml,"{$SysChatCat}") Then
		PagHtml = Replace(PagHtml,"{$SysChatCat}",GetChatCat(""))
	End If 
	If Instr(PagHtml,"{$Page_Photos}") Then
		PagHtml = Replace(PagHtml,"{$Page_Photos}",Page_Photos())
	End If 
	If Instr(PagHtml,"{$Page_WeekPostList}") Then
		PagHtml = Replace(PagHtml,"{$Page_WeekPostList}",Page_WeekPostList())
	End If 
	If Instr(PagHtml,"{$Page_NewLinkList}") Then
		PagHtml = Replace(PagHtml,"{$Page_NewLinkList}",Page_NewLinkList())
	End If 
	If Instr(PagHtml,"{$Page_UpBoker}") Then
		PagHtml = Replace(PagHtml,"{$Page_UpBoker}",Page_UpBoker())
	End If 
	If Instr(PagHtml,"{$SystemInfo}") Then
		PagHtml = Replace(PagHtml,"{$SystemInfo}",Page_SystemInfo())
	End If 
	If Instr(PagHtml,"{$UserInfo}") Then
		PagHtml = Replace(PagHtml,"{$UserInfo}",Page_UserInfo())
	End If 
	PagHtml = Replace(PagHtml,"{$ibokeurl}",DvBoke.mArchiveLink)
	PagHtml = Replace(PagHtml,"{$bokeurl}",DvBoke.ModHtmlLinked)
	Sys_Translate = PagHtml
End Function



'-----------------------------------------------------------
'调用数据转换
'-----------------------------------------------------------
'新加入用户
Function Page_NewJoinBoker()
	Dim Nodes,ChildNode
	Dim TempHtml,TempStr,i
	DvBoke_Sys.GetNode = "newjoinboker"
	DvBoke_Sys.SqlStr = "Select Top 6 UserID,UserName,NickName,BokeName,BokeTitle From [Dv_Boke_User] Order By JoinBokeTime desc "

	DvBoke_Sys.GetData()
	i=0
	For Each ChildNode In DvBoke_Sys.Nodes.selectNodes("rs:data/z:row")
		i = i+1
		TempHtml = DvBoke.Page_Strings(19).text
		TempHtml = Replace(TempHtml,"{$num}",i)
		TempHtml = Replace(TempHtml,"{$Boke_Name}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("bokename"))&"")
		TempHtml = Replace(TempHtml,"{$Boke_User}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("nickname"))&"")
		TempHtml = Replace(TempHtml,"{$Boke_Title}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("boketitle"))&"")
		TempStr = TempStr & TempHtml
	Next
	Page_NewJoinBoker = TempStr
End Function

'热门用户，以评论排序
Function Page_HotBoker()
	Dim Nodes,ChildNode
	Dim TempHtml,TempStr,i
	DvBoke_Sys.GetNode = "hotboker"
	DvBoke_Sys.SqlStr = "Select Top 6 UserID,UserName,NickName,BokeName,BokeTitle,JoinBokeTime From [Dv_Boke_User] Order By PostNum desc"

	DvBoke_Sys.GetData()
	For Each ChildNode In DvBoke_Sys.Nodes.selectNodes("rs:data/z:row")
		TempHtml = DvBoke.Page_Strings(20).text
		TempHtml = Replace(TempHtml,"{$Boke_Name}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("bokename"))&"")
		TempHtml = Replace(TempHtml,"{$Boke_User}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("nickname"))&"")
		TempHtml = Replace(TempHtml,"{$Boke_Title}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("boketitle"))&"")
		TempStr = TempStr & TempHtml
		i = i + 1
		If i > 5 Then Exit For
	Next
	Page_HotBoker = TempStr
End Function

'更新用户，以更新时间排序
Function Page_UpBoker()
	Dim Nodes,ChildNode
	Dim TempHtml,TempStr
	DvBoke_Sys.GetNode = "upboker"
	DvBoke_Sys.SqlStr = "Select Top 6 UserID,UserName,NickName,BokeName,BokeTitle,BokeChildTitle,JoinBokeTime,PageView,TopicNum,FavNum,PhotoNum,PostNum,TodayNum,Trackbacks,SysCatID,LastUpTime,SkinID From [Dv_Boke_User] Order By LastUpTime desc"

	DvBoke_Sys.GetData()
	For Each ChildNode In DvBoke_Sys.Nodes.selectNodes("rs:data/z:row")
		TempHtml = DvBoke.Page_Strings(20).text
		TempHtml = Replace(TempHtml,"{$Boke_Name}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("bokename"))&"")
		TempHtml = Replace(TempHtml,"{$Boke_User}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("nickname"))&"")
		TempHtml = Replace(TempHtml,"{$Boke_Title}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("boketitle"))&"")
		TempStr = TempStr & TempHtml
	Next
	Page_UpBoker = TempStr
End Function

'最新主题
Function Page_NewTopicList()
	Dim Nodes,ChildNode
	Dim TempHtml,TempStr
	DvBoke_Sys.GetNode = "topiclist"
	DvBoke_Sys.SqlStr = "Select Top 8 TopicID,CatID,sCatID,UserID,UserName,Title,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,IsBest From [Dv_Boke_Topic] where sType<>2 and IsLock<3 Order By TopicID desc "
	DvBoke_Sys.GetData()
	Dim Title,LastPostTime,iLastPostTime
	For Each ChildNode In DvBoke_Sys.Nodes.selectNodes("rs:data/z:row")
		TempHtml = DvBoke.Page_Strings(22).text
		Title = ChildNode.getAttribute("title")
		If Len(Title)>16 Then
			Title = Left(Title,16) &"..."
		ElseIf Title="" Then
			Title = "..."
		End If
		Title = Dvbbs.HTMLEncode(Title)
		LastPostTime = ChildNode.getAttribute("lastposttime")
		iLastPostTime = "20" & Right(Year(LastPostTime),2) & "-"
		If Len(Month(LastPostTime))=1 Then
			iLastPostTime = iLastPostTime & "0" & Month(LastPostTime) & "-"
		Else
			iLastPostTime = iLastPostTime & Month(LastPostTime) & "-"
		End If
		If Len(Day(LastPostTime))=1 Then
			iLastPostTime = iLastPostTime & "0" & Day(LastPostTime)
		Else
			iLastPostTime = iLastPostTime & Day(LastPostTime)
		End If
		
		TempHtml = Replace(TempHtml,"{$CatName}",DvBoke.SysChatCat.selectSingleNode("rs:data/z:row[@scatid = '"&ChildNode.getAttribute("scatid")&"']").getAttribute("scattitle"))
		TempHtml = Replace(TempHtml,"{$TopicID}",ChildNode.getAttribute("topicid"))
		TempHtml = Replace(TempHtml,"{$UserID}",ChildNode.getAttribute("userid"))
		TempHtml = Replace(TempHtml,"{$Title}",Title)
		TempHtml = Replace(TempHtml,"{$PostUser}",Dvbbs.HtmlEncode(ChildNode.getAttribute("username")))
		TempHtml = Replace(TempHtml,"{$LastPostTime}",iLastPostTime)
		TempStr = TempStr & TempHtml
	Next
	Page_NewTopicList = TempStr
End Function

'最新评论
Function Page_NewPostList()
	Dim Nodes,ChildNode
	Dim TempHtml,TempStr
	DvBoke_Sys.GetNode = "postlist"
	DvBoke_Sys.SqlStr = "Select Top 8 PostID,BokeUserID,CatID,sCatID,ParentID,RootID,UserID,UserName,Title, Content,JoinTime From [Dv_Boke_Post] where ParentID>0 Order By PostID desc "

	DvBoke_Sys.GetData()
	Dim Title,LastPostTime,iLastPostTime
	For Each ChildNode In DvBoke_Sys.Nodes.selectNodes("rs:data/z:row")
		TempHtml = DvBoke.Page_Strings(23).text
		Title = ChildNode.getAttribute("title")
		If Title="" Then
			Title = ChildNode.getAttribute("content")
		End If
		If Len(Title)>16 Then
			Title = Left(Title,16) &"..."
		ElseIf Title="" Then
			Title = "..."
		End If
		'Title = Dvbbs.HTMLEncode(Title)
		Title = DvBoke.ClearHtmlTages(Title)
		
		LastPostTime = ChildNode.getAttribute("jointime")
		iLastPostTime = "20" & Right(Year(LastPostTime),2) & "-"
		If Len(Month(LastPostTime))=1 Then
			iLastPostTime = iLastPostTime & "0" & Month(LastPostTime) & "-"
		Else
			iLastPostTime = iLastPostTime & Month(LastPostTime) & "-"
		End If
		If Len(Day(LastPostTime))=1 Then
			iLastPostTime = iLastPostTime & "0" & Day(LastPostTime)
		Else
			iLastPostTime = iLastPostTime & Day(LastPostTime)
		End If

		LastPostTime = Right(Year(LastPostTime),2) &"-"& Month(LastPostTime) &"-"&Day(LastPostTime)
		TempHtml = Replace(TempHtml,"{$CatName}",DvBoke.SysChatCat.selectSingleNode("rs:data/z:row[@scatid = '"&ChildNode.getAttribute("scatid")&"']").getAttribute("scattitle"))
		TempHtml = Replace(TempHtml,"{$TopicID}",ChildNode.getAttribute("rootid"))
		TempHtml = Replace(TempHtml,"{$UserID}",ChildNode.getAttribute("bokeuserid"))
		TempHtml = Replace(TempHtml,"{$Title}",Title)
		TempHtml = Replace(TempHtml,"{$PostUser}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("username")))
		TempHtml = Replace(TempHtml,"{$LastPostTime}",iLastPostTime)
		TempStr = TempStr & TempHtml
	Next
	Page_NewPostList = TempStr
End Function

'本周热评
Function Page_WeekPostList()
	Dim Nodes,ChildNode
	Dim TempHtml,TempStr,DayStr,i
	DvBoke_Sys.GetNode = "weektopiclist"
	If Dv_Boke_DataBase = 1 Then
		DayStr = "d"
	Else
		DayStr = "'d'"
	End If
	DvBoke_Sys.SqlStr = "Select Top 8 TopicID,CatID,sCatID,UserID,UserName,Title,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,IsBest From [Dv_Boke_Topic] where DateDiff("&DayStr&",PostTime,"&bSqlNowString&")<7 Order By Child desc"
	DvBoke_Sys.GetData()
	Dim Title,LastPostTime,iLastPostTime
	For Each ChildNode In DvBoke_Sys.Nodes.selectNodes("rs:data/z:row")
		TempHtml = DvBoke.Page_Strings(37).text
		i = i + 1
		Title = ChildNode.getAttribute("title")
		If Len(Title)>18 Then
			Title = Left(Title,18) &"..."
		ElseIf Title="" Then
			Title = "..."
		End If
		Title = DvBoke.ClearHtmlTages(Title)
		LastPostTime = ChildNode.getAttribute("posttime")
		
		TempHtml = Replace(TempHtml,"{$TopicID}",ChildNode.getAttribute("topicid"))
		TempHtml = Replace(TempHtml,"{$Title}",Title)
		TempHtml = Replace(TempHtml,"{$PostUser}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("username")))
		TempHtml = Replace(TempHtml,"{$LastPostTime}",LastPostTime)
		TempHtml = Replace(TempHtml,"{$Child}",ChildNode.getAttribute("child"))
		TempHtml = Replace(TempHtml,"{$UserID}",ChildNode.getAttribute("userid"))
		TempHtml = Replace(TempHtml,"{$num}",i)
		TempStr = TempStr & TempHtml
		If i > 7 Then Exit For
	Next
	Page_WeekPostList = TempStr
End Function

'最新书签
Function Page_NewLinkList()
	Dim Nodes,ChildNode
	Dim TempHtml,TempStr,DayStr,i
	DvBoke_Sys.GetNode = "linklist"
	DvBoke_Sys.SqlStr = "Select Top 8 TopicID,CatID,sCatID,UserID,UserName,Title,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,IsBest From [Dv_Boke_Topic] where sType = 2 Order By Child desc"
	DvBoke_Sys.GetData()
	Dim Title,LastPostTime,iLastPostTime
	For Each ChildNode In DvBoke_Sys.Nodes.selectNodes("rs:data/z:row")
		TempHtml = DvBoke.Page_Strings(38).text
		i = i + 1
		Title = ChildNode.getAttribute("title")
		If Len(Title)>18 Then
			Title = Left(Title,18) &"..."
		ElseIf Title="" Then
			Title = "..."
		End If
		Title = DvBoke.ClearHtmlTages(Title)
		LastPostTime = ChildNode.getAttribute("posttime")
		
		TempHtml = Replace(TempHtml,"{$TopicID}",ChildNode.getAttribute("topicid"))
		TempHtml = Replace(TempHtml,"{$Title}",Title)
		TempHtml = Replace(TempHtml,"{$PostUser}",DvBoke.ClearHtmlTages(ChildNode.getAttribute("username")))
		TempHtml = Replace(TempHtml,"{$LastPostTime}",LastPostTime)
		TempHtml = Replace(TempHtml,"{$UserID}",ChildNode.getAttribute("userid"))
		TempHtml = Replace(TempHtml,"{$num}",i)
		TempStr = TempStr & TempHtml
		If i > 7 Then Exit For
	Next
	Page_NewLinkList = TempStr
End Function

'最新图片
Function Page_Photos()
	Dim Rows
	Rows = 6	'每行的个数
	Dim Nodes,ChildNode,i
	Dim TempHtml,TempStr,Temp,CountNum
	DvBoke_Sys.GetNode = "newphotos"
	DvBoke_Sys.SqlStr = "Select Top 6 ID,BokeUserID,UserID,UserName,CatID,sType,TopicID,PostID,IsTopic,Title,FileName,sFileName,FileType,FileSize,FileNote,DownNum,ViewNum,DateAndTime,PreviewImage,IsLock From [Dv_Boke_Upfile] where IsLock<3 and FileType=1 and Stype=4 Order By DateAndTime desc "
	DvBoke_Sys.GetData()
	Set Nodes = DvBoke_Sys.Nodes.selectNodes("rs:data/z:row")
	i = 0
	CountNum = Nodes.Length
	Dim ViewFile
	For Each ChildNode In Nodes
		i = i+1
		ViewFile = ChildNode.getAttribute("previewimage")
		If ViewFile="" or IsNull(ViewFile) Then
			ViewFile = DvBoke.System_UpSetting(19) & ChildNode.getAttribute("filename")
		End If
		ViewFile = ViewFile
		TempHtml = DvBoke.Page_Strings(26).text
		TempHtml = Replace(TempHtml,"{$ViewPhoto}",ViewFile)
		TempHtml = Replace(TempHtml,"{$UserID}",ChildNode.getAttribute("bokeuserid"))
		TempHtml = Replace(TempHtml,"{$TopicID}",ChildNode.getAttribute("topicid"))
		'TempHtml = Replace(TempHtml,"{$Boke_User}",Dvbbs.HtmlEncode(ChildNode.getAttribute("nickname"))&"")
		'TempHtml = Replace(TempHtml,"{$Boke_Title}",Dvbbs.HtmlEncode(ChildNode.getAttribute("boketitle"))&"")

		TempStr = TempStr & TempHtml
		If i>Rows-1 or (CountNum<Rows and i = Nodes.Length mod Rows) Then
			CountNum = CountNum - i
			Temp = Temp & Replace(DvBoke.Page_Strings(4).text,"{$PhotoLine}",TempStr)
			TempStr = ""
			i = 0
		End If
	Next
	Page_Photos = Temp
End Function

Function GetSysCat()
	Dim Nodes,ChildNode,TempHtml,TempStr,i
	Set Nodes = DvBoke.SysCat.selectNodes("rs:data/z:row")
	If Nodes is Nothing Then
		Exit Function
	End If
	i = 0
	For Each ChildNode In Nodes
		i = i+1
		TempHtml = DvBoke.Page_Strings(24).text
		TempHtml = Replace(TempHtml,"{$CatName}",ChildNode.getAttribute("scattitle"))
		TempHtml = Replace(TempHtml,"{$catid}",ChildNode.getAttribute("scatid"))
		TempStr = TempStr & TempHtml
		If i>7 Then
			TempStr = TempStr & "<br/>"
			i = 0
		End If
	Next
	GetSysCat = TempStr
End Function

Function GetChatCat(sType)
	Dim Nodes,ChildNode,TempHtml,TempStr,i
	Set Nodes = DvBoke.SysChatCat.selectNodes("rs:data/z:row")
	If Nodes is Nothing Then
		Exit Function
	End If
	i = 0
	For Each ChildNode In Nodes
		i = i+1
		TempHtml = DvBoke.Page_Strings(25).text
		TempHtml = Replace(TempHtml,"{$CatName}",ChildNode.getAttribute("scattitle"))
		TempHtml = Replace(TempHtml,"{$catid}",ChildNode.getAttribute("scatid"))
		TempHtml = Replace(TempHtml,"{$t}",sType)
		TempStr = TempStr & TempHtml
		If i>7 Then
			TempStr = TempStr & "<br/>"
			i = 0
		End If
	Next
	GetChatCat = TempStr
End Function

'-----------------------------------------------------------
':博客索引
'-----------------------------------------------------------
Function Sys_BokeUser(PageHtml,CatID)
	Dim Rs,Sql
	Dim Page,MaxRows,Endpage,CountNum,PageSearch,CatName
	Endpage = 0
	CountNum = 0
	'MaxRows = 1
	MaxRows = DvBoke.System_Setting(7)
	Page = iPage
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)
	
	Dim SqlStr,Str
	If CatID>0 Then
		If Str <> "" Then
			Str = Str &" and "
		End If
		Str = Str &"SysCatID = "&CatID
	End If
	If Str<>"" Then
		SqlStr = "Where "& Str
	End If
	PageSearch = "s=1&catid="&CatID
	Sql = "Select UserID,UserName,NickName,BokeName,BokeTitle,BokeChildTitle,JoinBokeTime,TopicNum,FavNum,PhotoNum,PostNum,TodayNum,Trackbacks,SpaceSize,SysCatID,LastUpTime,SkinID From [Dv_Boke_User] "
	Sql = Sql & SqlStr &" order by LastUpTime Desc"
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
		DvBoke.ShowCode(4)
		DvBoke.ShowMsg(2)
	End If
	Rs.close:Set Rs = Nothing
	Dim i,Temp,Temp1
	Dim SysCat
	If DvBoke.InputShowMsg <> "" Then
		PageHtml = Replace(PageHtml,"{$Page_BokeUserList}","<tr><td></td><td colspan=""8"">"&DvBoke.InputShowMsg&"</td><td></td></tr>")
	Else
		For i=0 To Ubound(SQL,2)
			Temp1 = DvBoke.Page_Strings(31).text

			Set SysCat = DvBoke.SysCat.selectSingleNode("rs:data/z:row[@scatid = '"&Sql(14,i)&"']")
			If SysCat Is Nothing Then
				Temp1 = Replace(Temp1,"{$CatName}","未分类")
				If i = 0 Then CatName = "未分类"
			Else
				Temp1 = Replace(Temp1,"{$CatName}",SysCat.getAttribute("scattitle"))
				If i = 0 Then CatName = SysCat.getAttribute("scattitle")
			End If
			Temp1 = Replace(Temp1,"{$BokeTitle}",Dvbbs.HtmlEncode(Sql(4,i)))
			Temp1 = Replace(Temp1,"{$BokeSn}",Dvbbs.HtmlEncode(Sql(3,i)))
			Temp1 = Replace(Temp1,"{$UserID}",Sql(0,i))
			Temp1 = Replace(Temp1,"{$BokeUser}",Dvbbs.HtmlEncode(Sql(2,i)))
			Temp1 = Replace(Temp1,"{$TopicNum}",Sql(7,i))
			Temp1 = Replace(Temp1,"{$FavNum}",Sql(8,i))
			Temp1 = Replace(Temp1,"{$PhotoNum}",Sql(9,i))
			Temp1 = Replace(Temp1,"{$PostNum}",Sql(10,i))
			Temp1 = Replace(Temp1,"{$JoinTime}",FormatDateTime(Sql(6,i),1))
			Temp = Temp & Temp1
		Next
		PageHtml = Replace(PageHtml,"{$Page_BokeUserList}",Temp)
	End If

	If CatID = "" Then CatID = 0
	PageSearch=Replace(Replace(PageSearch,"\","\\"),"""","\""")
	PageSearch = DvBoke.Furl(DvBoke.mArchiveLink & "show_user."&CatID&"")
	PageHtml = Replace(PageHtml,"{$Page}",Page)
	PageHtml = Replace(PageHtml,"{$MaxRows}",MaxRows)
	PageHtml = Replace(PageHtml,"{$CountNum}",CountNum)
	PageHtml = Replace(PageHtml,"{$PageSearch}",PageSearch)
	PageHtml = Replace(PageHtml,"{$Descriptions}",CatName)
	Sys_BokeUser = PageHtml

End Function

'-----------------------------------------------------------
':话题，文章，收藏,链接页面
'-----------------------------------------------------------
Function Sys_TopicList(PageHtml,sType,CatID)
	Dim Rs,Sql,TopicNums
	Dim Page,MaxRows,Endpage,CountNum,PageSearch,CatName
	Endpage = 0
	CountNum = 0
	'MaxRows = 2
	MaxRows = DvBoke.System_Setting(7)
	Page = iPage
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)
	
	Dim SqlStr,Str
	If CatID>0 and Stype <> 5 Then
		Str = Str &" and sCatID = "&CatID
	End If
	If Stype <> 5 Then
		If Stype>0 and Stype<=4 Then
			Str = Str &" and sType="&Stype-1
		Else
			Str = Str &" and sType<4"
		End If
	End If
	'-------------------------------------------------------
	'Search Form
	If Request.Form("sel")<>"" Then
		iSelType = DvBoke.CheckNumeric(Request.Form("sel"))
	End If

	If Request.Form("searchword") <> "" Then
		KeyWord = DvBoke.Checkstr(Request.Form("searchword"))
	End If
	If KeyWord<>"" Then
		Select Case iSelType
			Case 1
				Str = Str &" and UserName like '%"&KeyWord&"%'"
			Case Else
				Str = Str &" and Title like '%"&KeyWord&"%'"
		End Select
	End If

	'-------------------------------------------------------
	SqlStr = Str
	TopicNums = 0
	'TopicID=0 ,CatID=1 ,sCatID=2 ,UserID=3 ,UserName=4 ,Title=5 ,TitleNote=6 ,PostTime=7 ,Child=8 ,Hits=9 ,IsView=10 ,IsLock=11 ,sType=12 ,LastPostTime=13 ,IsBest=14 ,S_Key=15 ,Weather=16 ,VisitUser=17 ,PayMoney=18 ,PayNumber=19 ,PayTime=20 ,TrackBacks=21
	If Stype = 5 Then
		Sql = "Select ID,BokeUserID,UserID,UserName,CatID,sType,TopicID,PostID,IsTopic,Title,FileName,sFileName,FileType,FileSize,FileNote,DownNum,ViewNum,DateAndTime,PreviewImage,IsLock From [Dv_Boke_Upfile] where IsLock<3 and FileType=1 and sType=4 and IsTopic = 0 "
		Sql = Sql & SqlStr &" Order By DateAndTime desc"
	Else
		Sql = "Select TopicID,CatID,sCatID,UserID,UserName,Title,TitleNote,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,IsBest,S_Key,Weather,VisitUser,PayMoney,PayNumber,PayTime,TrackBacks From [Dv_Boke_Topic] Where IsLock<1 "
		Sql = Sql & SqlStr &" order by LastPostTime Desc"
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
		DvBoke.ShowCode(4)
		DvBoke.ShowMsg(2)
	End If
	Rs.close:Set Rs = Nothing
	Dim i,Temp,Temp1
	Dim SysCat
	Dim Title
	If DvBoke.InputShowMsg <> "" Then
		PageHtml = Replace(PageHtml,"{$BokeTopicList}",DvBoke.InputShowMsg)
	Else
		If Stype = 5 Then	'相册
			Dim ViewFile,ii,Rows
			Rows = Cint(DvBoke.System_Setting(9))
			For i=0 To Ubound(SQL,2)
				ViewFile = Sql(18,i)
				Title = Sql(9,i)
				If Len(Title)>20 Then
					Title = Left(Title,20) &"......"
				End If
				Title = Dvbbs.HTMLEncode(Title)
				If ViewFile="" or IsNull(ViewFile) Then
					ViewFile = DvBoke.System_UpSetting(19) & Sql(10,i)
				End If
				ViewFile = ViewFile

				Temp1 = DvBoke.Page_Strings(28).text
				Temp1 = Replace(Temp1,"{$ViewPhoto}",ViewFile)
				Temp1 = Replace(Temp1,"{$UserID}",Sql(2,i))
				Temp1 = Replace(Temp1,"{$TopicID}",Sql(6,i))
				Temp1 = Replace(Temp1,"{$Title}",Title)
				Temp1 = Replace(Temp1,"{$UserName}",Dvbbs.HtmlEncode(Sql(3,i)))
				Temp1 = Replace(Temp1,"{$FileSize}",FormatNumber(Sql(13,i)/1024,2))
				Temp1 = Replace(Temp1,"{$DateTime}",FormatDateTime(Sql(17,i),2))
				Temp = Temp & Temp1
				If ii >= Rows-1 Then
					Temp = Temp & DvBoke.Main_Strings(22).text
					ii = 0
				Else
					ii = ii+1
				End If
			Next
			PageHtml = Replace(PageHtml,"{$BokeTopicList}",DvBoke.Page_Strings(27).text)
			PageHtml = Replace(PageHtml,"{$photo_list}",Temp)
		'ElseIf Stype = 4 Then	'交易

		Else
			For i=0 To Ubound(SQL,2)
				TopicNums = (i + 1) + ((page - 1)*MaxRows)
				Title = Sql(5,i)
				Title = Dvbbs.HTMLEncode(Title)
				If Stype-1 = 2 Then
					Temp1 = DvBoke.Page_Strings(33).text
					If Sql(6,i)<>"" Then
						Temp1 = Replace(Temp1,"{$Logo}","<img src="""&Sql(6,i)&""" border=""0""/>")
					Else
						Temp1 = Replace(Temp1,"{$Logo}","")
					End If
				Else
					Temp1 = DvBoke.Page_Strings(32).text
				End If
				Set SysCat = DvBoke.SysChatCat.selectSingleNode("rs:data/z:row[@scatid = '"&Sql(2,i)&"']")
				If SysCat Is Nothing Then
					Temp1 = Replace(Temp1,"{$CatName}","未分类")
					If i = 0 Then CatName = "未分类"
				Else
					Temp1 = Replace(Temp1,"{$CatName}",SysCat.getAttribute("scattitle"))
					If i = 0 Then CatName = SysCat.getAttribute("scattitle")
				End If
				Temp1 = Replace(Temp1,"{$Title}",Title)
				Temp1 = Replace(Temp1,"{$UserName}",Dvbbs.HtmlEncode(Sql(4,i)))
				Temp1 = Replace(Temp1,"{$PostTime}",Sql(7,i))
				Temp1 = Replace(Temp1,"{$UserID}",Sql(3,i))
				Temp1 = Replace(Temp1,"{$TopicID}",Sql(0,i))
				Temp1 = Replace(Temp1,"{$Num}",TopicNums)
				Temp1 = Replace(Temp1,"{$Child}",Sql(8,i))
				Temp1 = Replace(Temp1,"{$Hits}",Sql(9,i))
				Temp = Temp & Temp1	
			Next
			PageHtml = Replace(PageHtml,"{$BokeTopicList}",Temp)
		End If
	End If
	If sType <> "0" And CatID = "" Then
		PageSearch = DvBoke.mArchiveLink & "show_topic."&sType
	Else
		If CatID = "" Then CatID = 0
		PageSearch = DvBoke.mArchiveLink & "show_topic."&sType&"."&CatID
	End If
	If KeyWord<>"" Then
		PageSearch = PageSearch & "-" & KeyWord & "-" & iSelType
	End If
	PageSearch=Replace(Replace(PageSearch,"\","\\"),"""","\""")
	PageSearch = DvBoke.Furl(PageSearch)
	PageHtml = Replace(PageHtml,"{$Page}",Page)
	PageHtml = Replace(PageHtml,"{$MaxRows}",MaxRows)
	PageHtml = Replace(PageHtml,"{$CountNum}",CountNum)
	PageHtml = Replace(PageHtml,"{$PageSearch}",PageSearch)
	PageHtml = Replace(PageHtml,"{$showcat}",CatName)
	Sys_TopicList = PageHtml
End Function

'系统信息
Function Page_SystemInfo()
	Dim PageHtml
	PageHtml = DvBoke.Page_Strings(39).text
	PageHtml = Replace(PageHtml,"{$UserNum}",DvBoke.System_Node.getAttribute("s_usernum"))
	PageHtml = Replace(PageHtml,"{$TopicNum}",DvBoke.System_Node.getAttribute("s_topicnum"))
	PageHtml = Replace(PageHtml,"{$FavNum}",DvBoke.System_Node.getAttribute("s_favnum"))
	PageHtml = Replace(PageHtml,"{$PhotoNum}",DvBoke.System_Node.getAttribute("s_photonum"))
	PageHtml = Replace(PageHtml,"{$PostNum}",DvBoke.System_Node.getAttribute("s_postnum"))
	PageHtml = Replace(PageHtml,"{$TodayNum}",DvBoke.System_Node.getAttribute("s_todaynum"))
	Page_SystemInfo = PageHtml
End Function
'用户信息
Function Page_UserInfo()
	Dim PageHtml
	If Dvbbs.UserID = 0 Then
		PageHtml = DvBoke.Page_Strings(40).text
		If Dvbbs.Forum_Setting(79)="0" Then
			PageHtml = Replace(PageHtml,"{$GetCode}","")
		Else
			PageHtml = Replace(PageHtml,"{$GetCode}",DvBoke.Page_Strings(42).text)
			Dvbbs.LoadTemplates("")
			PageHtml = Replace(PageHtml,"{$Dv_GetCode}",Dvbbs.GetCode)
		End If
	Else
		PageHtml = DvBoke.Page_Strings(41).text
		If DvBoke.BokeUserID = 0 Then
			PageHtml = Replace(PageHtml,"{$UserMsg}",DvBoke.Page_Strings(44).text)
			PageHtml = Replace(PageHtml,"{$UserName}",Dvbbs.MemberName)
		Else
			PageHtml = Replace(PageHtml,"{$UserMsg}",DvBoke.Page_Strings(43).text)
			PageHtml = Replace(PageHtml,"{$UserName}",DvBoke.BokeNode.getAttribute("nickname"))
		End If
		PageHtml = Replace(PageHtml,"{$TopicNum}",DvBoke.BokeNode.getAttribute("topicnum"))
		PageHtml = Replace(PageHtml,"{$PhotoNum}",DvBoke.BokeNode.getAttribute("photonum"))
		PageHtml = Replace(PageHtml,"{$PostNum}",DvBoke.BokeNode.getAttribute("postnum"))
		PageHtml = Replace(PageHtml,"{$TodayNum}",DvBoke.BokeNode.getAttribute("todaynum"))
	End If
	Page_UserInfo = PageHtml
End Function
%>