<!--#include FILE="conn.asp"-->
<!--#include file="inc/const.asp" -->
<!--#include file="boke/config.asp"-->
<!--#include file="boke/checkinput.asp"-->
<%
DvBoke.Stats = "查询"
DvBoke.Nav(0)
DvBoke.LeftMenu
Page_Main()
DvBoke.Footer
Dvbbs.PageEnd()
Sub Page_Main()
	Dim MainHtml
	DvBoke.LoadPage("Search.xslt")
	MainHtml = DvBoke.Main_Strings(5).text
	MainHtml = Replace(MainHtml,"{$Main}",DvBoke.Page_Strings(1).text)
	MainHtml = SearchOut(MainHtml)
	Response.Write MainHtml
End Sub

Function SearchOut(PageHtml)
	PageHtml = Search(PageHtml)
	PageHtml = Replace(PageHtml,"{$BokeUser}",DvBoke.BokeUserName)
	PageHtml = Replace(PageHtml,"{$BokeName}",DvBoke.BokeName)
	PageHtml = Replace(PageHtml,"{$Skins_Path}",DvBoke.Skins_Path)
	PageHtml = Replace(PageHtml,"{$BokeUrl}",DvBoke.ModHtmlLinked)
	SearchOut = PageHtml
End Function

Function Search(PageHtml)
	'------> 获取查询条件
	Dim SqlStr
	Dim Stype,SelType,CatID,KeyWord,DYear,DMonth,DDay
	Stype = Request("Stype")
	SelType = DvBoke.CheckNumeric(Request("Sel"))
	KeyWord = DvBoke.Checkstr(Request("KeyWord"))
	DYear = DvBoke.CheckNumeric(Request("DY"))
	DMonth = DvBoke.CheckNumeric(Request("DM"))
	DDay = DvBoke.CheckNumeric(Request("DD"))
	'分类
	If Stype>=0 THen
		Stype = DvBoke.CheckNumeric(Stype)
		SqlStr = SqlStr &" and sType ="&Stype
	Else
		Stype = -1
	End If
	'年
	If DYear>0 Then
		SqlStr = SqlStr &" and Year(JoinTime) ="&DYear
	End If
	'月
	If DMonth>0 Then
		SqlStr = SqlStr &" and Month(JoinTime) ="&DMonth
	End If
	'日
	If DDay>0 Then
		SqlStr = SqlStr &" and Day(JoinTime) ="&DDay
	End If
	If KeyWord<>"" Then
		Select Case SelType
			Case 2	'内容
				SqlStr = SqlStr &" and Content like '%"&KeyWord&"%'"
			Case 1	'作者
				SqlStr = SqlStr &" and UserName like '%"&KeyWord&"%'"
			Case Else	'标题
				SqlStr = SqlStr &" and Title like '%"&KeyWord&"%'"
		End Select
	End If
	PageSearch = "User="&DvBoke.BokeName&"&Stype="&Stype&"&Sel="&SelType&"&KeyWord="&KeyWord&"&DY="&DYear&"&DM="&DMonth&"&DD="&DDay
	PageSearch=Replace(Replace(PageSearch,"\","\\"),"""","\""")
	Dim Rs,Sql
	Set Rs = Dvbbs.iCreateObject("ADODB.Recordset")
	Dim Page,MaxRows,Endpage,CountNum,PageSearch
	CountNum = 0
	Endpage = 0
	MaxRows = Cint(DvBoke.BokeSetting(7))
	'MaxRows = 2
	Page = Request("page")
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)
	'TopicID,CatID,sCatID,UserID,UserName,Title,TitleNote,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,IsBest,S_Key,Weather,VisitUser,PayMoney,PayNumber,PayTime,TrackBacks
	'字段排序 TopicID=0 ,CatID=1 ,sCatID=2 ,UserID=3 ,UserName=4 ,Title=5 ,TitleNote=6 ,PostTime=7 ,Child=8 ,Hits=9 ,IsView=10 ,IsLock=11 ,sType=12 ,LastPostTime=13 ,IsBest=14 ,S_Key=15 ,Weather=16 ,VisitUser=17 ,PayMoney=18 ,PayNumber=19 ,PayTime=20 ,TrackBacks=21 

	'PostID,BokeUserID,CatID,sCatID,ParentID,RootID,UserID,UserName,Title,Content,JoinTime,IP,sType,IsUpfile
	'字段排序 PostID=0 ,BokeUserID=1 ,CatID=2 ,sCatID=3 ,ParentID=4 ,RootID=5 ,UserID=6 ,UserName=7 ,Title=8 ,Content=9 ,JoinTime=10 ,IP=11 ,sType=12 ,IsUpfile=13

	Sql = "Select PostID,BokeUserID,CatID,sCatID,ParentID,RootID,UserID,UserName,Title,Content,JoinTime,IP,sType,IsUpfile From [Dv_Boke_Post] Where BokeUserID = "&DvBoke.BokeUserID
	If DvBoke.IsBokeOwner Then
		Sql = Sql & SqlStr
	Else
		Sql = Sql & " and IsLock<3 " & SqlStr
	End If
	Sql = Sql & " order by JoinTime desc"
	'Response.Write sql
	'------> 数据库查询

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
	'------> 数据库查询
	'------> 模板转换
	If DvBoke.InputShowMsg <> "" Then
		PageHtml = Replace(PageHtml,"{$searchlist}",DvBoke.InputShowMsg)
	Else
		Dim i,TempHtml,Temp1
		Dim Title,TopicNums
		For i=0 To Ubound(SQL,2)
			TopicNums = (i + 1) + ((page - 1)*MaxRows)
			Title = Sql(8,i)
			If Title ="" Then
				Title = Left(Sql(9,i),150)&"..."
			End If
			Title = Dvbbs.HTMLEncode(DvBoke.ClearHtmlTages(Title))
			Temp1 = DvBoke.Page_Strings(2).text
			Temp1 = Replace(Temp1,"{$Title}",Title)
			Temp1 = Replace(Temp1,"{$TopicID}",Sql(5,i))
			Temp1 = Replace(Temp1,"{$Num}",TopicNums)
			Temp1 = Replace(Temp1,"{$StypeName}",DvBoke.BokeStype(Sql(12,i)))
			Temp1 = Replace(Temp1,"{$CatName}",DvBoke.ChannelTitle(Sql(2,i)))
			Temp1 = Replace(Temp1,"{$UserName}",Sql(7,i))
			Temp1 = Replace(Temp1,"{$PostTime}",Sql(10,i))
			Temp1 = Replace(Temp1,"{$UserID}",Sql(6,i))
			Temp1 = Replace(Temp1,"{$SID}",Sql(12,i))
			Temp1 = Replace(Temp1,"{$CID}",Sql(2,i))
			TempHtml = TempHtml & Temp1
		Next
		PageHtml = Replace(PageHtml,"{$searchlist}",TempHtml)
	End If
	PageSearch = DvBoke.Furl(PageSearch)
	PageHtml = Replace(PageHtml,"{$DYear}",DYear)
	PageHtml = Replace(PageHtml,"{$DMonth}",DMonth)
	PageHtml = Replace(PageHtml,"{$DDay}",DDay)
	PageHtml = Replace(PageHtml,"{$Stype}",Stype)
	PageHtml = Replace(PageHtml,"{$SelType}",SelType)
	PageHtml = Replace(PageHtml,"{$KeyWord}",KeyWord)
	PageHtml = Replace(PageHtml,"{$Page}",Page)
	PageHtml = Replace(PageHtml,"{$MaxRows}",MaxRows)
	PageHtml = Replace(PageHtml,"{$CountNum}",CountNum)
	PageHtml = Replace(PageHtml,"{$PageSearch}",PageSearch)
	Search = PageHtml
End Function
%>