<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/dv_clsother.asp"-->
<!--#include file="inc/dv_Template.inc"-->
<!--#include file="inc/dv_pageclass.asp"-->
<%
Rem ��ҳҳ������
Const CachePage=True		Rem �Ƿ���ҳ�滺��
Const CacheTime=60			Rem ����ʧЧʱ��
Const Link_Br = 8			Rem ��������ÿ�и���	N
Const TopicMode_Br = 10		Rem ����ר��ÿ�и���	N
'Dvbbs.ShowSQL = 1

Dim action
Dim XmlDom,Node,BoardList,Xpath,Count,ChildLen,BWidth
Dim AnnouncementsItem,BBSItem,BoardItem Rem ��ʾ����б��ı���
Dim SmallPaper,TopicModeList,TopicModeListImg
Dim Topic,TopTopic,TopicMode,lastpost,Page,PageCount,Cmd,Rs,SQL,list_type Rem ��ʾ�����б��ı���
Dim LinkDom,LinkNode,UserNode,UserMsg
Dim i,j,n,ii
Dim ShowMod,DispMode

action=Request("action")

Dvbbs.LoadTemplates("index")
'Set XmlDom = Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument"& MsxmlVersion)

If not IsObject(Application(Dvbbs.CacheName&"_boardlist")) Then LoadBoardList()
Set BoardList = Application(Dvbbs.CacheName&"_boardlist")

Select Case action
	Case "frameon" : ShowIsLeft()
	Case Else
		If Dvbbs.CheckStr(Request.Cookies("geturl"))="" And Dvbbs.forum_setting(103)=1 Then
			Response.Cookies("geturl") = "index.asp"
			Response.redirect "index.asp?action=frameon"
		Else
			Main()
		End if
End Select

Sub Main()	
	If Dvbbs.BoardId>0 Then
		Call RequestStr()
		Call Chk_List_Err()
		If Dvbbs.Board_Setting(43)="0" Then
			Dvbbs.Stats=Dvbbs.LanStr(7)
		Else
			Dvbbs.Stats=Dvbbs.LanStr(8)
		End If
		Dvbbs.Nav()
		Dvbbs.ActiveOnline()
		Dvbbs.Head_var 1,BoardList.documentElement.selectSingleNode("board[@boardid='"&Dvbbs.BoardID&"']/@depth").text,"",""
		Call ShowBbsBoard()
		Call DispToolsInfo()
		Call TopicSetting()
		TPL_Scan Template.Html(1)
		Set TopTopic = Nothing
		Set Topic = Nothing
	Else
		Dvbbs.Stats=template.Strings(0)
		Dvbbs.Nav()
		Dvbbs.ActiveOnline()
		Call ShowBbsBoard()
		TPL_Scan Template.Html(0)		
	End If
	Call Ad()
End Sub

Sub ShowIsleft()
Dim RightUrl
RightUrl = Request.QueryString("url")
If RightUrl = "" Then
	RightUrl = Dvbbs.ArchiveHtml("index.asp")
Else
	If Request.Cookies("geturl")<>RightUrl Then
		RightUrl = Dvbbs.ArchiveHtml(Request.Cookies("geturl"))
	End If
End If
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=gb2312" />
<title><%=dvbbs.forum_info(0)%></title>
<style>
.navpoint { cursor: hand;}
body { overflow-x: hidden; overflow: hidden; height:100% }
td { font-size:12px; }
</style>
<script>
var status = 1;
function switchSysBar(){
     if (1 == window.status){
		  window.status = 0;
          document.getElementById("switchPoint").innerHTML = '<img src="images/others/left.gif" alt="չ������" />';
          document.getElementById("frmTitle").style.display="none";
     }
     else{
		  window.status = 1;
          document.getElementById("switchPoint").innerHTML = '<img src="images/others/right.gif" alt="��������" />';
          document.getElementById("frmTitle").style.display="block";
     }
}
</script>
<body style="margin: 0px">
<table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
<tbody>
	<tr>
	<td align="middle" id="frmTitle" style="display:block;" valign="top" name="fmtitle" height="100%">
		<iframe frameborder="0" id="left" name="left" src="frameleft.asp"  style="height: 100%; visibility: inherit;width: 180px;"></iframe>
	<td bgcolor="#337abb" style="width: 10px">
		<table border="0" cellpadding="0" cellspacing="0" height="100%" style="width: 10px">
		<tbody>
			<tr>
				<td onclick="switchSysBar()" style="height: 100%">
					<span class="navpoint" id="switchPoint"><img src="images/others/right.gif"></span>
				</td>
			</tr>
		</tbody>
		</table>
	</td>
	<td style="width: 100%" valign="top">
		<iframe frameborder="0" id="frmright" name="frmright" scrolling="yes" src="<%=righturl%>" style="height:100%; visibility: inherit; width:100%; z-index: 1"></iframe>
	</td>
	</tr>
</tbody>
</table>
</body>
</html>
<%
End Sub

Sub RequestStr() Rem Request ����
	Page=Request("Page")
	If (Not isNumeric(Page))or Page="" Then Page=1
	Page=Clng(Page)
	If Page < 1 Then Page=1
	If Request("topicmode")<>"" and IsNumeric(Request("topicmode")) Then
		TopicMode=Cint(Request("topicmode"))
	Else
		TopicMode=0
	End If
	list_type=Replace(Request("list_type")," ","")
	list_type=Split(list_type,",")
	If UBound(list_type)<2 Then ReDim list_type(3):list_type(0)=0:list_type(1)=0:list_type(2)=0
End Sub
Sub Chk_List_Err()
	If Dvbbs.Board_Setting(1)="1" and Dvbbs.GroupSetting(37)="0" Then
		Dvbbs.AddErrCode(26)
	ElseIf action="batch"  and Dvbbs.GroupSetting(45)<>"1"Then
		Dvbbs.AddErrCode(28)
	End If
	Dvbbs.showerr()
End Sub

Sub Announcements() Rem ������ʾ
	Dvbbs.Name="Dv_news_"&Dvbbs.boardid
	If IsObject(XmlDom) Then Set XmlDom = Nothing 
	If(Dvbbs.ObjIsEmpty()) Then
		Set Rs=Dvbbs.Execute("Select id,boardid,title,addtime,bgs From Dv_bbsnews where Boardid="&Dvbbs.boardid&" order by id desc")
		Set XmlDom = Dvbbs.RecordsetToxml(rs,"announcements","")
		Dvbbs.Name = "Dv_news_"&Dvbbs.boardid
		Dvbbs.Value = XmlDom.xml
		Set Rs=Nothing
	Else
		Set XmlDom = Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
		If Not XmlDom.LoadXml(Dvbbs.Value) Then
			Set Rs=Dvbbs.Execute("Select id,boardid,title,addtime,bgs From Dv_bbsnews where Boardid="&Dvbbs.boardid&" order by id desc")
			Set XmlDom = Dvbbs.RecordsetToxml(rs,"announcements","")
			Set Rs=Nothing
		End If
	End If
	'Response.Write Server.HtmlEncode(XmlDom.xml)
End Sub

Sub ShowBbsBoard()	Rem ��ѯ�����б�����
	If Dvbbs.BoardID=0 Then
		Xpath="board[@parentid=0]"
	Else
		Xpath="board[@boardid="& Dvbbs.Boardid&"]"
	End If
	If Not (BoardList.documentElement.firstchild is nothing) Then
		If Not IsObject(Application(Dvbbs.CacheName &"_information_" & BoardList.documentElement.firstchild.getAttribute("boardid")) ) Then
			Dvbbs.LoadAllBoardinformation()
		End If
	End If
End Sub

Sub GetBBSLink() Rem ������������
	Dvbbs.name="ForumLink"
	If Dvbbs.ObjIsEmpty() Then LoadlinkList()
	Set LinkDom=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
	If Not (LinkDom.loadxml(Dvbbs.Value)) Then Set LinkDom=getlink()	
End Sub
Function getlink()
	Set Rs=Dvbbs.Execute("select * From Dv_bbslink Order by islogo desc,id ")
	Set getlink=Dvbbs.RecordsetToxml(rs,"link","bbslink")
	Set Rs=Nothing
End Function
Sub LoadlinkList()
	Dim XmlDomTemp
	Set Rs=Dvbbs.Execute("select * From Dv_bbslink Order by islogo desc,id ")
	Set XmlDomTemp=Dvbbs.RecordsetToxml(rs,"link","bbslink")
	Dvbbs.name="ForumLink"
	Dvbbs.Value=XmlDomTemp.xml
	Set XmlDomTemp=Nothing
	Set Rs=Nothing
End Sub

Sub Ad()	Rem �������
	If Dvbbs.Forum_ads(2)="1" or Dvbbs.Forum_ads(13)="1" Then
		TPL_Echo "<script language=""javascript"" src=""inc/Dv_Adv.js"" type=""text/javascript""></script>"
		TPL_Echo "<script language=""javascript"" type=""text/javascript"">" & vbNewLine
		If Dvbbs.Forum_ads(2)="1" Then TPL_Echo Chr(9) & "move_ad('"&Dvbbs.Forum_ads(3)&"','"&Dvbbs.Forum_ads(4)&"','"&Dvbbs.Forum_ads(5)&"','"&Dvbbs.Forum_ads(6)&"');" & vbNewLine
		If Dvbbs.Forum_ads(13)="1" Then TPL_Echo Chr(9) & "fix_up_ad('"& Dvbbs.Forum_ads(8) & "','" & Dvbbs.Forum_ads(10) & "','" & Dvbbs.Forum_ads(11) & "','" & Dvbbs.Forum_ads(9) & "');"& vbNewLine
		TPL_Echo vbNewLine&"</script>"
	End If
End Sub

Sub Forum_BirUser() Rem ��ѯ��������յ��û�
	Dim Rs,SQL,NowMonth,NowDate,todaystr0,todaystr1,node
	NowMonth=Month(Date())
	NowDate=Day(Date())
	If NowMonth< 10 Then
		todaystr0="0"&NowMonth
	Else
		todaystr0=CStr(NowMonth)
	End If
	If NowDate < 10 Then
		todaystr0=todaystr0&"-"&"0"&NowDate
	Else
		todaystr0=todaystr0&"-"&NowDate
	End If
	todaystr1=NowMonth&"-"&NowDate
	If todaystr0=todaystr1 Then
		SQL="select username,Userbirthday from [Dv_user] where Userbirthday like '%-"&todaystr1&"' Order by UserID"
	Else
		SQL="select username,Userbirthday from [Dv_user] where Userbirthday like '%-"&todaystr1&"' Or Userbirthday like '%-"&todaystr0&"' Order by UserID"
	End If
	Set Rs=Dvbbs.Execute(SQL)
	Set Application(Dvbbs.CacheName & "_biruser")=Dvbbs.RecordsetToxml(rs,"user","biruser")
	Set Rs=Nothing
	For Each node In Application(Dvbbs.CacheName & "_biruser").documentElement.selectNodes("user")
		todaystr0=Node.selectSingleNode("@userbirthday").text
		If IsDate(todaystr0) Then
			Node.setAttribute "age",datediff("yyyy",todaystr0,Now())
		Else
			Application(Dvbbs.CacheName & "_biruser").documentElement.removeChild(node)
		End If
	Next
	Application(Dvbbs.CacheName & "_biruser").documentElement.setAttribute "date",CStr(Date())
End Sub

Sub TopicSetting()
	TopicModeList = Split("$$"& Dvbbs.Board_Setting(48),"$$")
	TopicModeListImg = Split("$$"& Dvbbs.Board_Setting(49),"$$")
End Sub

Sub ShowTopic_1() Rem ��ѯ�̶������б�	
	Dim topiclist,topidlist
	If Page=1 Then ' //�̶�����
		topidlist=Dvbbs.CacheData(28,0)
		If topidlist="" Then
			topidlist=Application(Dvbbs.CacheName &"_information_" & Dvbbs.boardid).documentElement.selectSingleNode("information/@boardtopstr").text
		ElseIf Trim(Application(Dvbbs.CacheName &"_information_" & Dvbbs.boardid).documentElement.selectSingleNode("information/@boardtopstr").text)<>"" Then
			topidlist=topidlist &","& Application(Dvbbs.CacheName &"_information_" & Dvbbs.boardid).documentElement.selectSingleNode("information/@boardtopstr").text
		End If

		If Trim(topidlist) <>"" Then
			If Not IsObject(Conn) Then ConnectionDatabase
			If IsSqlDataBase=1 And IsBuss=1 Then
				Set Cmd = Dvbbs.iCreateObject("ADODB.Command")
				Set Cmd.ActiveConnection=conn
				Cmd.CommandText="Dv_TSQL"
				Cmd.CommandType=4
				Cmd.Parameters.Append cmd.CreateParameter("@tsql",200,1,2000)
				Cmd("@tsql")="Select topicid,boardid,title,postusername,postuserid,dateandtime,child,hits,votetotal,lastpost,lastposttime,istop,isvote,isbest,locktopic,expression,topicmode,mode,getmoney,getmoneytype,usetools,issmstopic,hidename from dv_topic Where istop > 0 and topicid in ("& Dvbbs.Checkstr(topidlist) &") Order By istop desc, Lastposttime Desc"
				Set Rs=Cmd.Execute				
				Set Cmd = Nothing
			Else
				Set Rs=Dvbbs.Execute("Select topicid,boardid,title,postusername,postuserid,dateandtime,child,hits,votetotal,lastpost,lastposttime,istop,isvote,isbest,locktopic,expression,topicmode,mode,getmoney,getmoneytype,usetools,issmstopic,hidename from dv_topic Where istop > 0 and topicid in ("& Dvbbs.Checkstr(topidlist) &") Order By istop desc, Lastposttime Desc")
			End If
			If Not Rs.EOF Then
				TopTopic=Rs.GetRows(-1)
			Else
				TopTopic=Null				
			End If			
			Set Rs=Nothing
		End If
	End If
End Sub
Sub ShowTopic_2() Rem ��ѯ��ͨ�����б�
	Dim SQLQuery,d
	If IsSqlDataBase=1 Then
		d=""
	Else
		d="'"
	End If
	Select Case CInt(list_type(0)) Rem ������ѯ
		Case 0	:	SQLQuery = " "
		Case 1	:	SQLQuery = " And datediff("&(d&"d"&d)&",DateAndTime,"&SqlNowString&")=0"
		Case 2	:	SQLQuery = " And datediff("&(d&"ww"&d)&",DateAndTime,"&SqlNowString&")=0"
		Case 3	:	SQLQuery = " And datediff("&(d&"m"&d)&",DateAndTime,"&SqlNowString&")=0"
		Case 4	:	SQLQuery = " And datediff("&(d&"d"&d)&",DateAndTime,"&SqlNowString&")=180"
		Case 5	:	SQLQuery = " And datediff("&(d&"yyyy"&d)&",DateAndTime,"&SqlNowString&")=0"
		Case 6	:	SQLQuery = " And isbest=1"
		Case 7	:	SQLQuery = " And isvote=1"
		Case 8
			If Dvbbs.UserID>0 Then SQLQuery = " And postuserid="&Dvbbs.UserID
		Case Else	:	SQLQuery = " "
	End Select
	Dim OrderId,SortId,sqlfields,sqlfieldswhere
	sqlfields="TopicID,boardid,title,postusername,postuserid,dateandtime,child,hits,votetotal,lastpost,lastposttime,istop,isvote,isbest,locktopic,Expression,TopicMode,Mode,GetMoney,GetMoneyType,UseTools,IsSmsTopic,HideName"
	sqlfieldswhere=" boardid not in (444,777) and IsTop=0 and Mode="&TopicMode&" and boardid="&dvbbs.boardid
	sqlfieldswhere=sqlfieldswhere&SQLQuery
	OrderId=CInt(list_type(1))
	SortId=CInt(list_type(2))
    Dim OrderField,OrderStr,OrderType
	If OrderId=0 Then
	    OrderField="LastPostTime"
	ElseIf OrderId=1 Then
	    OrderField="TopicId"
	ElseIf OrderId=2 Then
	    OrderField="hits"
	ElseIf OrderId=3 Then
	    OrderField="child"
	Else
		OrderField="LastPostTime"
	End If

	If SortId=0 Then
			OrderStr="DESC":OrderType=1
	Else
			OrderStr="ASC":OrderType=0
	End If
	If Not IsObject(Conn) Then ConnectionDatabase 
	If IsSqlDataBase=1 And IsBuss=1 Then
		
		Dim mypage
		Set mypage=new Pager
		mypage.getconn=conn '�õ����ݿ�����
		mypage.pagesize=Cint(Dvbbs.Board_Setting(26)) '�����ҳÿһҳ�ļ�¼��
		mypage.TableName="Dv_Topic" 'Ҫ��ѯ�ı���
		mypage.Tablezd=sqlfields
		mypage.KeyName=OrderField
		mypage.OrderType=OrderType
		mypage.PageWhere=sqlfieldswhere
		mypage.GetStyle =1
		Set Rs=mypage.getrs()
		If Not (Rs.EoF And Rs.Bof) Then
			Topic=Rs.GetRows(-1)
		Else
			Topic=Null
		End If
		Count = mypage.int_totalRecord
		Rs.close()
		Set Rs=Nothing
	Else		
		Set Rs = Dvbbs.iCreateObject("adodb.recordset")
		If Cint(TopicMode)=0 Then
			Sql="Select  TopicID,boardid,title,postusername,postuserid,dateandtime,child,hits,votetotal,lastpost,lastposttime,istop,isvote,isbest,locktopic,Expression,TopicMode,Mode,GetMoney,GetMoneyType,UseTools,IsSmsTopic,hidename From Dv_Topic Where BoardID="&Dvbbs.BoardID&" And IsTop=0 "&SQLQuery&" Order By "&OrderField&" "& OrderStr
		Else
			Sql="Select  TopicID,boardid,title,postusername,postuserid,dateandtime,child,hits,votetotal,lastpost,lastposttime,istop,isvote,isbest,locktopic,Expression,TopicMode,Mode,GetMoney,GetMoneyType,UseTools,IsSmsTopic,hidename From Dv_Topic Where Mode="&TopicMode&" and BoardID="&Dvbbs.BoardID&" And IsTop=0 "&SQLQuery&" Order By "&OrderField &" "& OrderStr
		End If
		Rs.Open Sql,Conn,1,1
		If Page >1 Then
			Rs.Move (page-1) * Clng(Dvbbs.Board_Setting(26))
		End If
		If Not Rs.EoF Then			
			Topic=Rs.GetRows(Dvbbs.Board_Setting(26))
		Else
			Topic=Null
		End If

		Count = Rs.RecordCount

		Rs.close()
		Set Rs=Nothing
	End If

	Rem "0-TopicID,1-boardid,2-title,3-postusername,4-postuserid,5-dateandtime,6-child,7-hits,8-votetotal,9-lastpost,10-lastposttime,11-istop,12-isvote,13-isbest,14-locktopic,15-Expression,16-TopicMode,17-Mode,15-GetMoney,19-GetMoneyType,20-UseTools,21-IsSmsTopic,22-hidename"
	If Count Mod Clng(Dvbbs.Board_Setting(26))=0 Then
		PageCount = Count / Clng(Dvbbs.Board_Setting(26))
	Else
		PageCount = Count / Clng(Dvbbs.Board_Setting(26))+1
	End If
	If Page>PageCount Then Page=1	
End Sub

Sub ParseBbsBoardNode(sToken,BoardData,ParentNode) Rem ת�������б�����	
	On Error Resume Next

	If Not IsObject(BoardData) Then
		If Not IsObject(Application(Dvbbs.CacheName&"_boardlist")) Then Dvbbs.LoadBoardList
		Set BoardData = BoardList.documentElement.selectSingleNode("board[@boardid="& Dvbbs.Boardid&"]")
	End If

	If ParentNode="information/" Then
		If Not IsObject(Application(Dvbbs.CacheName &"_information_" & BoardData.selectSingleNode("@boardid").text)) Then
			Dvbbs.LoadBoardinformation(BoardData.selectSingleNode("@boardid").text)
		End If
		Set Node = Application(Dvbbs.CacheName &"_information_" & BoardData.selectSingleNode("@boardid").text).documentElement.selectSingleNode("information/@"&sToken)
	Else
		Set Node = BoardData.selectSingleNode("@"&sToken&"")
	End If

	Select Case sToken
		Case "width"
			TPL_Echo BWidth
		Case "today"
			If Application(Dvbbs.CacheName &"_information_" & BoardData.selectSingleNode("@boardid").text).documentElement.selectSingleNode("information/@todaynum").text="0" Then
				TPL_Echo "today"
			Else
				TPL_Echo "todaynew"
			End If
		Case "br"
			If j Mod n =0 And j<ChildLen Then TPL_Echo "</tr><tr class=""underline"">"
		Case "disp"		TPL_Echo DispMode
		Case "mode"		TPL_Echo ShowMod
		Case "dispimg"
			If DispMode="none" Then
				TPL_Echo "plus"
			Else
				TPL_Echo "nofollow"
			End If
		Case Else			
			If Not (Node Is Nothing) Then
				If sToken="boardmaster" Then
					If Node.text="" Then
						TPL_Echo "���ް���"
					Else
						Dim boardmaster
						boardmaster = Split(Node.text,"|")
						For i=0 To UBound(boardmaster)
							TPL_Echo "<a href=""dispuser.asp?name="&boardmaster(i)&""" title=""�鿴����"&boardmaster(i)&"������"" target=""_blank"">"&boardmaster(i)&"</a>&nbsp;&nbsp;"
						Next
					End If
				ElseIf sToken="indeximg" And Len(Node.text)>4 Then
					TPL_Echo "<img src="""&Node.text&""" alt=""����������"" border=""0"" />"
				ElseIf ParentNode="information/" Then
					If BoardData.selectSingleNode("@checkout").text="1" And sToken="lastpost_3" Then
						TPL_Echo "����֤�û�����鿴."
					Else
						TPL_Echo Server.HtmlEnCode(Dvbbs.Replacehtml(Node.text))
					End If
				Else
					TPL_Echo Node.text
				End If
			End If
	End Select
	Set Node = Nothing
	If Err Then Err.Clear
End Sub

Sub BirUser()
	If Dvbbs.Forum_setting(29)="1" Then
		If Not IsObject(Application(Dvbbs.CacheName & "_biruser")) Then
			Forum_BirUser()
		ElseIf Application(Dvbbs.CacheName & "_biruser").documentElement.selectSingleNode("@date").text <> CStr(Date()) Then
			Forum_BirUser()
		End If
	End If
End Sub

Sub ParseBirUserNode(sToken,UserNode)	Rem ת�����������û�����
	On Error Resume Next
	If sToken="sum" Then
		TPL_Echo Application(Dvbbs.CacheName & "_biruser").documentElement.selectNodes("user").Length
	End If
	If Not IsObject(UserNode) Then Exit Sub
	Set Node = UserNode.selectSingleNode("@"&sToken&"")
	If Not (Node Is Nothing) Then
		TPL_Echo Node.text
	End If
	Set Node = Nothing
	If Err Then Err.Clear
End Sub

Sub ParseLinkNode(sToken,LinkNode)	Rem ת��������������
	On Error Resume Next
	If Not IsObject(LinkNode) Then Exit Sub
	Set Node = LinkNode.selectSingleNode("@"&sToken&"")
	If Not (Node Is Nothing) Then
		TPL_Echo Node.text
	End If
	If sToken="width" Then	TPL_Echo Int(100/Link_Br)&"%"
	If sToken="br" And (i Mod Link_Br)=0 Then
		TPL_Echo "<br style=""clear:both"" />"
	End If
	Set Node = Nothing
	If Err Then Err.Clear
End Sub

Sub ParseRuleNode(sToken) Rem ת���������
	On Error Resume Next
	If IsObject(XmlDom) Then Set XmlDom = Nothing
	Set XMLDom = Application(Dvbbs.CacheName &"_boarddata_" & Dvbbs.boardid).cloneNode(True)
	Set Node = XMLDom.documentElement.selectSingleNode("boarddata/@"&sToken&"")
	If Not (Node Is Nothing) Then
		TPL_Echo Node.text
	End If
	Set Node = Nothing
	If Err Then Err.Clear
End Sub

Sub ParseAnnouncements(sToken) Rem ת����������
	On Error Resume Next
	Select Case sToken
		Case "i"	:	TPL_Echo i
		Case Else
			If Not IsObject(AnnouncementsItem) Then Exit Sub
			Set Node = AnnouncementsItem.selectSingleNode("@"&sToken&"")
			If Not (Node Is Nothing) Then
				TPL_Echo Replace(Replace(Node.text,"""",""),"'","")
			End If
	End Select
	Set Node = Nothing
	If Err Then Err.Clear
End Sub

Sub ParseSmallpaper(sToken) Rem ת��С�ֱ�����
	On Error Resume Next
	Select Case sToken
		Case "i"	:	TPL_Echo i
		Case Else
			If Not IsObject(SmallPaper) Then Exit Sub
			Set Node = SmallPaper.selectSingleNode("@"&sToken&"")
			If Not (Node Is Nothing) Then
				If IsDate(Node.text) Then
					TPL_Echo DateValue(Node.text)
				Else
					TPL_Echo Dvbbs.HtmlEnCode(Node.text)
				End If
			End If
	End Select
	Set Node = Nothing
	If Err Then Err.Clear
End Sub

Sub ParseTopicMode(sToken) Rem ת������ר������
	Select Case sToken
		Case "boardid"	: TPL_Echo Dvbbs.Boardid
		Case "i"	:	TPL_Echo i
		Case "title"
			If i=TopicMode Then
				TPL_Echo "<b><font color=""#FF0000"">"&TopicModeList(i)&"</font></b>"
			Else
				TPL_Echo TopicModeList(i)
			End If
		Case "img"
			If TopicModeListImg(i)<>"" Then
				TPL_Echo "<img src="""&TopicModeListImg(i)&""" alt="""" />&nbsp;"
			End If
		Case "br"
			If (i Mod TopicMode_Br)=0 And UBound(TopicModeList)<>i Then TPL_Echo "<br />"
	End Select
End Sub

Sub ParseTopTopicNode(sToken) Rem ת���̶���������
	Dim title
	Select Case sToken
		Case "checkbox"
			lastpost = Split(TopTopic(9,i),"$")
			If UBound(lastpost)<7 Then
				Redim Preserve lastpost(6)
			End If
			If action="batch" Then
				TPL_Echo"<input type=""checkbox"" name=""Announceid"" value="""&TopTopic(0,i)&""" class=""checkbox"" />&nbsp;"
			End If			
			If CInt(TopTopic(17,i))>0 And CInt(TopTopic(1,i))=Dvbbs.BoardId Then
				TPL_Echo "["& TopicModeList(TopTopic(17,i)) &"]&nbsp;"
			End If
		Case "id"			:	TPL_Echo TopTopic(0,i)
		Case "listimg"
			If CInt(TopTopic(6,i))>0 Then
				TPL_Echo	"<a href=""loadtree1.asp?boardid="&TopTopic(1,i)&"&amp;rootid="&TopTopic(0,i)&"&amp;action=1"" target=""hiddenframe""  title=""չ�������б�""><img src="""&Dvbbs.mainpic(11)&""" alt=""չ�������б�"" /></a>&nbsp;"
			Else
				TPL_Echo	"<img src="""&Dvbbs.mainpic(10)&""" alt=""�޻ظ�����"" />"
			End If
		Case "boardid"		:	TPL_Echo TopTopic(1,i)
		Case "title","title2"
			title = Dvbbs.ChkBadWords(TopTopic(2,i))
			If "title2"=sToken Then
				TPL_Echo Server.HtmlEnCode(Dvbbs.Replacehtml(title))
			Else
				title = Left(title,CInt(Dvbbs.Board_Setting(25)))
				Select Case CInt(TopTopic(16,i))
					Case 1	:	TPL_Echo title
					Case 2	:	TPL_Echo "<font color=""red"">" & Server.HtmlEnCode(title) &"</font>"
					Case 3	:	TPL_Echo "<font color=""blue"">" & Server.HtmlEnCode(title) &"</font>"
					Case 4	:	TPL_Echo "<font color=""green"">" & Server.HtmlEnCode(title) &"</font>"
					Case Else	:	TPL_Echo Server.HtmlEnCode(title)
				End Select
			End If
		Case "titleimg"			
			If Dvbbs.Board_Setting(60)<>"" And Dvbbs.Board_Setting(60)<>"0" Then
				Dim PostTime
				If Dvbbs.Board_Setting(38) = "0" Then
						PostTime = lastpost(2)
				Else
						PostTime = TopTopic(5,i)
				End If
				If DateDiff("n",Posttime,Now)+Cint(Dvbbs.Forum_Setting(0)) < CLng(Dvbbs.Board_Setting(61)) Then
					TPL_Echo "&nbsp;<img src="""&Dvbbs.Board_Setting(60)&""" border=""0"" alt="""&DateDiff("n",Posttime,Now)+Cint(Dvbbs.Forum_Setting(0))&"����ǰ����!""/>"
				End If
			End If
		Case "pagelist"
			If lastpost(4)<>"" Then	TPL_Echo "&nbsp;<img src="""&Dvbbs.Forum_PicUrl&"filetype/"&lastpost(4)&".gif"" width=""16"" height=""16"" class=""filetype"" />&nbsp;"
			
			Rem ����̶�����Ҫ���ò�ͬ���ķ�ҳ���ã���ȡ������һ������
			'Dim tempBoardId:tempBoardId=Dvbbs.BoardId
			'If CInt(tempBoardId)<>CInt(TopTopic(1,i)) Then
			'	Dvbbs.BoardId = CInt(TopTopic(1,i))				
			'Else
			'	Dvbbs.BoardId = tempBoardId
			'End If
			'Dvbbs.GetForum_Setting()

			If TopTopic(6,i)+1 > Dvbbs.CheckNumeric(Dvbbs.Board_Setting(27)) Then
				Call TopicPageList(TopTopic(0,i),TopTopic(1,i),TopTopic(6,i)+1)				
			End If
		Case "star"			:	TPL_Echo Int(TopTopic(6,i)/Dvbbs.CheckNumeric(Dvbbs.Board_Setting(27)))+1
		Case "postusername"			
			If TopTopic(22,i)="0" Then
				TPL_Echo "<a href=""dispuser.asp?Name="&TopTopic(3,i)&""">"&TopTopic(3,i)&"</a>"				
			ElseIf TopTopic(22,i)="1" And TopTopic(4,i)<>"0"  Then
				TPL_Echo "<font color=""gray"">�����û�</font>"
			Else
				TPL_Echo "<font color=""gray"">����</font>"
			End If
		Case "postusername_2"
			If TopTopic(22,i)="0" And TopTopic(4,i)<>"0" Then
				TPL_Echo TopTopic(3,i)
			ElseIf TopTopic(22,i)="1" Then
				TPL_Echo "�����û�"
			Else
				TPL_Echo "����"
			End If
		Case "dateandtime"	:	TPL_Echo TopTopic(5,i)
		Case "dateandtime2"	:	TPL_Echo DateValue(TopTopic(5,i))
		Case "child"		:	TPL_Echo TopTopic(6,i)
		Case "hit"
			If CInt(TopTopic(12,i))=1 Then
				TPL_Echo "<font color=""red""><b>" & TopTopic(8,i) &"</b></font>"
			Else
				TPL_Echo TopTopic(7,i)
			End if
		Case "lastpostuser" :	TPL_Echo lastpost(0)
		Case "lastpostid"	:	TPL_Echo lastpost(1)
		Case "lastpostcontent" :	TPL_Echo Server.HtmlEnCode(Dvbbs.Replacehtml(lastpost(3)))
		Case "lastposttime" :	TPL_Echo lastpost(2)
		Case "top" :	TPL_Echo TopTopic(11,i)
		Case "tool"
			If CInt(TopTopic(19,i))>0											Then	Call TopicTool(CInt(TopTopic(19,i)),TopTopic(18,i),TopTopic(0,i),1) ' �������
			If TopTopic(20,i)>"0" And TopTopic(20,i)<"28"						Then	Call TopicTool(TopTopic(20,i),0,TopTopic(0,i),2) ' ��������
			If TopTopic(21,i)="1"												Then	Call TopicTool(0,0,TopTopic(0,i),3)	' �ֻ�����������
			If TopTopic(21,i)="2"												Then	Call TopicTool(0,0,TopTopic(0,i),4)	' ��������
			If InStr(TopTopic(15,i),"|")>0 And InStr(TopTopic(15,i),"0|")<>1	Then	Call TopicTool(0,0,TopTopic(0,i),5)	' ħ����������
	End Select
End Sub

Sub ParseTopicNode(sToken) Rem ת����ͨ��������
	Dim title
	Select Case sToken
		Case "folder"
			If CInt(Topic(14,i))>0 Then
				TPL_Echo Dvbbs.mainpic(4)
			ElseIf CInt(Topic(13,i))>0 Then
				TPL_Echo Dvbbs.mainpic(5)
			ElseIf CInt(Topic(12,i))>0 Then
				TPL_Echo Dvbbs.mainpic(6)
			ElseIf CInt(Topic(6,i))>CInt(Dvbbs.Forum_Setting(44)) Then
				TPL_Echo Dvbbs.mainpic(3)
			Else
				TPL_Echo Dvbbs.mainpic(2)
			End If
		Case "id"			:	TPL_Echo Topic(0,i)
		Case "listimg"
			If CInt(Topic(6,i))>0 Then
				TPL_Echo	"<a href=""loadtree1.asp?boardid="&Topic(1,i)&"&amp;rootid="&Topic(0,i)&"&amp;action=1"" target=""hiddenframe""  title=""չ�������б�""><img src="""&Dvbbs.mainpic(11)&""" alt=""չ�������б�"" /></a>"
			Else
				TPL_Echo	"<img src="""&Dvbbs.mainpic(10)&""" alt=""�޻ظ�����"" />"
			End If
		Case "checkbox"
			lastpost = Split(Topic(9,i),"$")
			If UBound(lastpost)<7 Then
				Redim Preserve lastpost(6)
			End If
			If action="batch" Then
				TPL_Echo"<input type=""checkbox"" name=""Announceid"" value="""&Topic(0,i)&""" class=""checkbox"" />&nbsp;"
			End If			
			If CInt(Topic(17,i))>0 Then
				TPL_Echo "["& TopicModeList(Topic(17,i)) &"]&nbsp;"
			End If
		Case "boardid"		:	TPL_Echo Topic(1,i)
		Case "title","title2"
			title = Dvbbs.ChkBadWords(Topic(2,i))			
			If "title2"=sToken Then
				TPL_Echo Server.HtmlEnCode(Dvbbs.Replacehtml(title))
			Else
				title = Left(title,CInt(Dvbbs.Board_Setting(25)))
				Select Case CInt(Topic(16,i))
					Case 1	:	TPL_Echo title
					Case 2	:	TPL_Echo "<font color=""red"">" & Server.HtmlEnCode(title) &"</font>"
					Case 3	:	TPL_Echo "<font color=""blue"">" & Server.HtmlEnCode(title) &"</font>"
					Case 4	:	TPL_Echo "<font color=""green"">" & Server.HtmlEnCode(title) &"</font>"
					Case Else	:	TPL_Echo Server.HtmlEnCode(title)
				End Select
			End If
		Case "titleimg"			
			If Dvbbs.Board_Setting(60)<>"" And Dvbbs.Board_Setting(60)<>"0" Then
				Dim PostTime
				If Dvbbs.Board_Setting(38) = "0" Then
						PostTime = lastpost(2)
				Else
						PostTime = Topic(5,i)
				End If
				If DateDiff("n",Posttime,Now)+Cint(Dvbbs.Forum_Setting(0)) < CLng(Dvbbs.Board_Setting(61)) Then
					TPL_Echo "&nbsp;<img src="""&Dvbbs.Board_Setting(60)&""" border=""0"" alt="""&DateDiff("n",Posttime,Now)+Cint(Dvbbs.Forum_Setting(0))&"����ǰ����!""/>"
				End If
			End If
		Case "pagelist"
			If lastpost(4)<>"" Then	TPL_Echo "&nbsp;<img src="""&Dvbbs.Forum_PicUrl&"filetype/"&lastpost(4)&".gif"" width=""16"" height=""16"" class=""filetype"" />&nbsp;"
			If Topic(6,i)+1 > Dvbbs.CheckNumeric(Dvbbs.Board_Setting(27)) Then
				Call TopicPageList(Topic(0,i),Topic(1,i),Topic(6,i)+1)				
			End If
		Case "star"			:	TPL_Echo Int(Topic(6,i)/Dvbbs.CheckNumeric(Dvbbs.Board_Setting(27)))+1
		Case "page"			:	If page>1 Then TPL_Echo "&amp;page="&page
		Case "postusername"			
			If Topic(22,i)="0" And Topic(4,i)<>"0" Then
				TPL_Echo "<a href=""dispuser.asp?Name="&Topic(3,i)&""">"&Topic(3,i)&"</a>"				
			ElseIf Topic(22,i)="1" Then
				TPL_Echo "<font color=""gray"">�����û�</font>"
			Else
				TPL_Echo "<font color=""gray"">����</font>"
			End If
		Case "postusername_2"
			If Topic(22,i)="0" And Topic(4,i)<>"0" Then
				TPL_Echo Topic(3,i)
			ElseIf Topic(22,i)="1" Then
				TPL_Echo "�����û�"
			Else
				TPL_Echo "����"
			End If
		Case "dateandtime"	:	TPL_Echo Topic(5,i)
		Case "dateandtime2"	:	TPL_Echo DateValue(Topic(5,i))
		Case "child"		:	TPL_Echo Topic(6,i)
		Case "hit"
			If CInt(Topic(12,i))=1 Then
				TPL_Echo "<font color=""red""><b>" & Topic(8,i) &"</b></font>"
			Else
				TPL_Echo Topic(7,i)
			End if
		Case "lastpostuser" :	TPL_Echo lastpost(0)
		Case "lastpostid"	:	TPL_Echo lastpost(1)
		Case "lastpostcontent" :	TPL_Echo Server.HtmlEnCode(Dvbbs.Replacehtml(lastpost(3)))
		Case "lastposttime" :	TPL_Echo lastpost(2)
		Case "showpage"
			Dim gaction
			If action<>"" Then gaction= "&amp;action="&action
			TPL_ShowPage	Page,Count, Dvbbs.CheckNumeric(Dvbbs.Board_Setting(26)),10, "index.asp?boardid="&Dvbbs.BoardID & gaction &"&amp;TopicMode="&TopicMode&"&amp;List_Type="&Replace(Request("list_type")," ","")&"&amp;Page="
		Case "tool"
			If CInt(Topic(19,i))>0										Then	Call TopicTool(CInt(Topic(19,i)),Topic(18,i),Topic(0,i),1) ' �������
			If Topic(20,i)>"0" And Topic(20,i)<"28"						Then	Call TopicTool(Topic(20,i),0,Topic(0,i),2) ' ��������
			If Topic(21,i)="1"											Then	Call TopicTool(0,0,Topic(0,i),3)	' �ֻ�����������
			If Topic(21,i)="2"											Then	Call TopicTool(0,0,Topic(0,i),4)	' ��������
			If InStr(Topic(15,i),"|")>0 And InStr(Topic(15,i),"0|")<>1	Then	Call TopicTool(0,0,Topic(0,i),5)	' ħ����������
	End Select
End Sub

Function TopicPageList(id,boardid,pn)
	TPL_Echo	"&nbsp;[<img src="""&Dvbbs.Forum_PicUrl&"pagelist.gif"" />"
	Dim p
	If pn Mod Dvbbs.CheckNumeric(Dvbbs.Board_Setting(27)) = 0 Then
		p = pn/Dvbbs.CheckNumeric(Dvbbs.Board_Setting(27))
	Else
		p = Int(pn/Dvbbs.CheckNumeric(Dvbbs.Board_Setting(27)))+1
	End If
	If p<=10 Then
		For ii=2 To p
			TPL_Echo "&nbsp;<a href=""dispbbs.asp?boardid="&boardid&"&amp;Id="&id&"&amp;page="&page&"&amp;star="&ii&""">"&ii&"</a>"
		Next
	Else
		For ii=2 To 9
			TPL_Echo "&nbsp;<a href=""dispbbs.asp?boardid="&boardid&"&amp;Id="&id&"&amp;page="&page&"&amp;star="&ii&""">"&ii&"</a>"
		Next
		TPL_Echo "..." & "<a href=""dispbbs.asp?boardid="&boardid&"&amp;Id="&id&"&amp;page="&page&"&amp;star="&p&""">"&p&"</a>"
	End If
	TPL_Echo "]"
End Function

Sub TopicTool(t,n,id,s) Rem ��ʾ����ʹ�õĵ�����Ϣ
	Select Case s
	Case 1
		Select Case t
			Case 1
				TPL_Echo "<span style=""float:right"">[����"&n&"�����]<img src=""images/mini_query.gif"" border=""0"" alt=""���ͽ������������"&n&"����ң��鿴��ϸ��Ϣ"" onclick=""openScript('ViewInfo.asp?t=2&amp;action=View&amp;BoardId="&Dvbbs.BoardId&"&amp;ID="&id&"',600,450);"" style=""cursor : pointer;"" /></span> "
			Case 2
				TPL_Echo "<span style=""float:right""><img src=""images/mini_query.gif"" border=""0"" alt=""�����������Ŀǰ�����"&n&"����ң��鿴��ϸ��Ϣ"" onclick=""openScript('ViewInfo.asp?t=2&amp;action=View&amp;BoardId="&Dvbbs.BoardId&"&amp;ID="&id&"',600,450);"" style=""cursor : pointer;"" /></span> "
			Case 3
				TPL_Echo "<span style=""float:right""><img src=""images/mini_query.gif"" border=""0"" alt=""��ҹ���������Ҫ֧��"&n&"����Ҳ���������鿴��ϸ��Ϣ"" onclick=""openScript('ViewInfo.asp?t=2&amp;action=View&amp;BoardId="&Dvbbs.BoardId&"&amp;ID="&id&"',600,450);"" style=""cursor : pointer;"" /></span> "
			Case 5
				TPL_Echo "<span style=""float:right""><img src=""images/mini_query.gif"" border=""0"" alt=""���ͽ����[�ѽ���]��������"&n&"����ң��鿴��ϸ��Ϣ"" onclick=""openScript('ViewInfo.asp?t=2&amp;action=View&amp;BoardId="&Dvbbs.BoardId&"&amp;ID="&id&"',600,450);"" style=""cursor : pointer;"" /></span> "
		End Select
	Case 2
		TPL_Echo "<span style=""float:right""><font class=""showtools"" onmousemove=""this.title='������ʹ���˵��ߣ�'+ShowTools["&t&"]+'';"">[<script type=""text/javascript"" language=""javascript"">document.write (ShowTools["&t&"]);</script>]</font></span> "
	Case 3
		TPL_Echo "<span style=""float:right""><a href=""wap.asp?Action=readme"" target=""_blank"" title=""Wap-�ֻ�����"" ><img src=""images/wap.gif"" border=""0"" /></a></span> "
	Case 4
		TPL_Echo "<span style=""float:right""><img src=""images/alipay/tenpay_icon.gif"" border=""0""  alt=""���Ӱ����Ƹ�ͨ������Ϣ���Ƹ�ͨ�����������б��ϣ��������ѡ���ȫ����ݣ�"" /></span> "
	Case 5
		TPL_Echo "<span style=""float:right""><img src=""dv_plus/tools/magicface/magicemot.gif"" border=""0""  alt=""ħ������"" /></span> "
	End Select
End Sub


Sub	DispToolsInfo() Rem ��ʾ����js
	TPL_Echo vbNewLine & "<script language=""javascript"" type=""text/javascript"">" & vbNewLine
	TPL_Echo LoadToolsInfo & vbNewLine
	TPL_Echo "</script>" & vbNewLine
End Sub
Function LoadToolsInfo() Rem ���ص�����Ϣ
	Dim Tools_Info,i,ShowTools,TempStr
	Dvbbs.Name="Plus_ToolsInfo"
	If Dvbbs.ObjIsEmpty() Then
		Dim Rs,Sql
		Sql = "Select ID,ToolsName From Dv_Plus_Tools_Info order by ID"
		Set Rs = Dvbbs.Plus_Execute(Sql)
		If Not Rs.Eof Then
			Sql = Rs.GetString(,, "����", "@#@", "")
		End If
		Rs.Close : Set Rs = Nothing
		Tools_Info = Split(Sql,"@#@")
		TempStr =  "var ShowTools = new Array();" & vbNewLine
		For i=0 To Ubound(Tools_Info)-1
			ShowTools = Split(Tools_Info(i),"����")
			TempStr = TempStr & "ShowTools["&ShowTools(0)&"]='"&Replace(Replace(Replace(ShowTools(1),"\","\\"),"'","\'"),chr(13),"")&"';"
		Next
		Dvbbs.value = TempStr & vbNewLine
	End If
	LoadToolsInfo = Dvbbs.value
End Function

Sub ParsePageNode(sToken) Rem ת��ҳ�濪�ص�����
	Select Case sToken
		Case "online_asp"
			If Dvbbs.Forum_Setting(14)="1" Or Dvbbs.Forum_Setting(15)="1" Then
				TPL_Echo "Online.asp?action=1&amp;boardid="&Dvbbs.boardid
			End If
		Case "listtype" :	TPL_Echo Join(list_type,",")
		Case "TopicMode"	:	TPL_Echo TopicMode
		Case "page"		:	TPL_Echo page
		Case "codestr"	:   TPL_Echo Dvbbs.MainHtml(15)
		Case "left"
			If Dvbbs.Forum_Setting(114)="0" Then
				TPL_Echo "page_left"
			End If
	End Select

	If InStr(sToken,"mainpic_")>0 Then
		Dim pic_i
		pic_i = Int(Replace(sToken,"mainpic_",""))
		TPL_Echo Dvbbs.mainpic(pic_i)
	End If
End Sub

Sub ParseInfoNode(sToken) Rem ת����̳���ú���̳��Ϣ������
	Select Case sToken
		Case "logincheckcode"		: TPL_Echo Dvbbs.forum_setting(79)'��¼��֤������
		Case "rss"					: TPL_Echo Dvbbs.Forum_ChanSetting(2)'rss����
		Case "wap"					: TPL_Echo Dvbbs.Forum_ChanSetting(1)'wap����
		Case "pic_0"				: TPL_Echo template.pic(0)
		Case "pic_1"				: TPL_Echo template.pic(1)
		Case "pic_2"				: TPL_Echo template.pic(2)
		Case "pic_3"				: TPL_Echo template.pic(3)
		Case "issearch_a"			: TPL_Echo 0
		Case "ForumUrl"				: TPL_Echo Dvbbs.Get_ScriptNameUrl()
		Case "dvgetcode"			: TPL_Echo Dvbbs.GetCode()
	End Select
End Sub

Sub ParseUserInfoNode(sToken) Rem ת���û���Ϣ������
	Select Case sToken
		Case "userid"			: TPL_Echo Dvbbs.UserId
		Case "username"			: TPL_Echo Dvbbs.MemberName
		Case Else
			Set Node = Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@"&sToken&"")
			If Not (Node Is Nothing) Then
				TPL_Echo Node.text
			End If
			Set Node = Nothing
	End Select
End Sub

Sub ParseUserMsgNode(sTokenName,UserMsg) Rem ת���û�����Ϣ������
	If IsArray(UserMsg) And IsNumeric(sTokenName) Then
		If CInt(sTokenName)<=UBound(UserMsg) Then	TPL_Echo UserMsg(sTokenName)
	End If
End Sub

'---------------------------------------
'����	����ǩ����
'����	sTokenType	- ��ǩ����
'		sTokenName	- ģ������
'---------------------------------------
Sub TPL_ParseNode(sTokenType, sTokenName)
	Select Case sTokenType
		Case "user"
			ParseUserInfoNode		sTokenName
		Case "bbsitem"
			ParseBbsBoardNode		sTokenName,BBSItem,""
		Case "boarditem"
			ParseBbsBoardNode		sTokenName,BoardItem,""
		Case "information"
			ParseBbsBoardNode		sTokenName,BoardItem,"information/"
		Case "usermsg"
			ParseUserMsgNode		sTokenName,UserMsg
		Case "biruser_list"
			ParseBirUserNode		sTokenName,UserNode
		Case "announcementsitem"
			ParseAnnouncements		sTokenName
		Case "smallpaper"
			ParseSmallPaper		sTokenName
		Case "toptopic"
			ParseTopTopicNode		sTokenName
		Case "topic"
			ParseTopicNode		sTokenName
		Case "rule"
			ParseRuleNode		sTokenName
		Case "topicmode_li"
			ParseTopicMode	sTokenName
		Case "page"
			ParsePageNode	sTokenName
		Case "forum_info"
			ParseInfoNode	sTokenName
		Case "text_link","logo_link"
			ParseLinkNode	sTokenName,LinkNode
		Case "ad"
			If sTokenName="forumtextad" Then
				If Dvbbs.Boardid=0 Then
					TPL_Echo	GetForumTextAd(0)
				Else
					TPL_Echo	GetForumTextAd(1)
				End If
			End If
		Case "usergrouppic"			
			On Error Resume Next
			If Not (Node.selectSingleNode("@"&sTokenName&"") Is Nothing) Then
				TPL_Echo Node.selectSingleNode("@"&sTokenName&"").text
			End If
			If Err Then	Err.Clear
		Case Else
	End Select 
End Sub

Sub TPL_ParseArea(sTokenName, sTemplate) Rem ģ�������ǩ����
	If Dvbbs.BoardId=0 Then
		Call DispIndex(sTokenName, sTemplate)
	Else
		Call DispIndex(sTokenName, sTemplate)
		Call DispTopic(sTokenName, sTemplate)
	End If
	Select Case sTokenName
		Case "userid=0"	:	If Dvbbs.UserId=0 Then	TPL_Scan sTemplate
		Case "userid>0"	:	If Dvbbs.UserId>0 Then	TPL_Scan sTemplate	
		Case "homecall=0"	:	If Dvbbs.forum_setting(113)=0 Then	TPL_Scan sTemplate
		Case "homecall>0"	:	If Dvbbs.forum_setting(113)>0 Then	TPL_Scan sTemplate	
		Case "riInform=0"	:	If Dvbbs.forum_setting(114)=0 Then	TPL_Scan sTemplate
		Case "riInform>0"	:	If Dvbbs.forum_setting(114)>0 Then	TPL_Scan sTemplate
	End Select
End Sub 

Sub DispIndex(sTokenName, sTemplate)	Rem ������ҳ�Ͱ���ģ��
	Select Case sTokenName
		Case "bbsitem"					Rem һ������			
			For Each BBSItem In BoardList.documentElement.selectNodes(Xpath)				
				ShowMod=Trim(Request.Cookies("List")("list"&BBSItem.selectSingleNode("@boardid").text))
				DispMode=Trim(Request.Cookies("Disp")("list"&BBSItem.selectSingleNode("@boardid").text))

				If ShowMod="" Or Not IsNumeric(ShowMod) Then
					ShowMod = BBSItem.selectSingleNode("@mode").text
				End If

				ChildLen = BoardList.documentElement.selectNodes("board[@parentid="&(BBSItem.selectSingleNode("@boardid").text)&"]").Length
				n = CInt(BBSItem.selectSingleNode("@simplenesscount").text)
				If n<=0 Then n=3
				If ChildLen>n Or ChildLen=0 Then
					BWidth = Int(100/n)&"%"
				Else
					BWidth = Int(100/ChildLen)&"%"
				End If
				If (ChildLen>0 Or Dvbbs.BoardId=0) And (BBSItem.selectSingleNode("@hidden").text="0" Or Dvbbs.GroupSetting(37)="1") Then				
					 TPL_Scan	sTemplate
				End If				
			Next		
		Case "bbsitem_1"				Rem �Ӱ��� �б�ģʽ
			If ShowMod="0" And (DispMode="" Or Dvbbs.BoardId>0) Then TPL_Scan	sTemplate
		Case "bbsitem_2"				Rem �Ӱ��� ���ģʽ
			If ShowMod="1" And (DispMode="" Or Dvbbs.BoardId>0) Then TPL_Scan	sTemplate
		Case "boarditem"
			j=0
			For Each BoardItem In BoardList.documentElement.selectNodes("board[@parentid="&(BBSItem.selectSingleNode("@boardid").text)&"]")
				If BoardItem.selectSingleNode("@hidden").text="0" Or Dvbbs.GroupSetting(37)="1" Then ' ������̳��Ȩ��
					j=j+1:TPL_Scan	sTemplate
				End If
			Next
			Set BoardItem = Nothing			
		Case "announcementsitem"		Rem ����
			Call Announcements():i=0
			For Each AnnouncementsItem In XMLDom.documentElement.selectNodes("announcements[@boardid="& Dvbbs.Boardid&"]")
				i=i+1	:	TPL_Scan	sTemplate
			Next
			Set AnnouncementsItem = Nothing
	End Select

	If Dvbbs.BoardId=0 Then
		Select Case sTokenName
			Case "smsnew=0","smsnew>0"
				Set Node = Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@usermsg")			
				If Not (Node Is Nothing) Then
					UserMsg = Split(Node.text,"||")
					If UBound(UserMsg)<2 Then UserMsg = Split("0||0||null","||")
					If sTokenName="smsnew=0" And CInt(UserMsg(0))=0 Then
						TPL_Scan	sTemplate
					ElseIf sTokenName="smsnew>0" And CInt(UserMsg(0))>0 Then
						TPL_Scan	sTemplate
					End if
				End If
				Set Node = Nothing
			Case "logincode"				Rem ������½��֤��
				If Dvbbs.forum_setting(79)<>"0" Then
					Session("xcount")=4
					TPL_Scan	sTemplate
				End If
			Case "logo_link"				Rem Logo��������
				If Dvbbs.BoardId=0 Then
					Call GetBBSLink:i=0
					For Each LinkNode In LinkDom.documentElement.selectNodes("link[@islogo=1]")
						i=i+1	:	TPL_Scan	sTemplate
					Next
				End If
			Case "text_link"				Rem ������������
				If Dvbbs.BoardId=0 Then				
					i=0
					For Each LinkNode In LinkDom.documentElement.selectNodes("link[@islogo=0]")
						i=i+1	:	TPL_Scan	sTemplate
					Next
				End If
				Set LinkNode = Nothing
			Case "biruser"					Rem �����û��жϿ���
				If Dvbbs.Forum_setting(29)="1" Then
					Call BirUser()
					TPL_Scan sTemplate
				End If
			Case "biruser_list"				Rem ��ʾ���������û�
				For Each UserNode In Application(Dvbbs.CacheName & "_biruser").documentElement.selectNodes("user")
					TPL_Scan sTemplate
				Next
				Set UserNode = Nothing
			Case "usergrouppic"				
				For Each Node In Application(Dvbbs.CacheName &"_grouppic").documentElement.selectNodes("usergroup[@orders!=0]")
					TPL_Scan sTemplate
				Next
				Set Node = Nothing
		End Select
	End If
End Sub

Sub DispTopic(sTokenName, sTemplate)	Rem ���������б�ģ��
	Select Case sTokenName
		Case "showtopic"				Rem ��������
			If Dvbbs.Board_Setting(43)="0" Then TPL_Scan sTemplate
		Case "boardtab"					Rem �ж��Ƿ������ʾ �Ӱ��桢��桢ר����Ŀ������
			Dim term_1,term_2,term_3			
			term_1 = UBound(TopicModeList)>1
			term_2 = Not (Application(Dvbbs.CacheName &"_boarddata_" & Dvbbs.boardid).cloneNode(True).documentElement.selectSingleNode("boarddata/@rules") Is Nothing) And Application(Dvbbs.CacheName &"_boarddata_" & Dvbbs.boardid).cloneNode(True).documentElement.selectSingleNode("boarddata/@rules").text<>""
			term_3 = BoardList.documentElement.selectNodes("board[@parentid="&(Dvbbs.BoardId)&"]").Length>0 And (BoardList.documentElement.selectNodes("board[@hidden=0 and @parentid="&(Dvbbs.BoardId)&"]").Length>0 Or Dvbbs.GroupSetting(37)="1")

			If term_1 Or term_2 Or term_3 Then
				TPL_Scan sTemplate
			End If
		Case "rule"								Rem ���
			If Not (Application(Dvbbs.CacheName &"_boarddata_" & Dvbbs.boardid).cloneNode(True).documentElement.selectSingleNode("boarddata/@rules") Is Nothing) Then
				If Application(Dvbbs.CacheName &"_boarddata_" & Dvbbs.boardid).cloneNode(True).documentElement.selectSingleNode("boarddata/@rules").text<>"" Then
					TPL_Scan sTemplate
				End If
			End If
		Case "smallpaper"				Rem С�ֱ�
			If Not IsObject(Application(Dvbbs.CacheName & "_smallpaper")) Then LoadBoardNews_Paper()
			For Each SmallPaper in Application(Dvbbs.CacheName & "_smallpaper").documentElement.SelectNodes("smallpaper[@s_boardid='"&Dvbbs.Boardid&"']")
				i=i+1	:	TPL_Scan	sTemplate
			Next
			Set SmallPaper = Nothing
		Case "topicmode"				Rem ר��
			If UBound(TopicModeList)>1 Then
				TPL_Scan sTemplate
			End If
		Case "topicmode_li"				Rem ר���б�
			For i=1 To UBound(TopicModeList)
				TPL_Scan sTemplate
			Next
		Case "tenpay"
			If Dvbbs.Board_Setting(67)=1 Then	TPL_Scan sTemplate
		Case "page=1"
			If Page=1 Then TPL_Scan sTemplate
		Case "toptopic"					Rem �̶�����
			If Page=1 Then
				Call ShowTopic_1()
				If IsArray(TopTopic) Then
					For i=0 To UBound(TopTopic,2)
						TPL_Scan sTemplate
					Next
				End If
			End If
		Case "topic"					Rem ��ͨ����
			Call ShowTopic_2()
			If IsArray(Topic) Then
				For i=0 To UBound(Topic,2)
					TPL_Scan sTemplate
				Next
			End If
		Case "action=batch"
			If action="batch" Then TPL_Scan sTemplate
		Case Else 
	End Select
End Sub

TPL_Flush()

If IsObject(XmlDom) Then Set XmlDom = Nothing
If IsObject(LinkDom) Then Set LinkDom = Nothing 
Set BBSItem = Nothing
Set BoardList = Nothing
Set Node = Nothing

Set TopTopic=Nothing
Set Topic=Nothing
If action<>"frameon" Then
	Dvbbs.Footer
End If
Dvbbs.PageEnd()
%>