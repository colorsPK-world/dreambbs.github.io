<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="Plus_popwan/cls_setup.asp"-->
<!--#include file="plus_popwan/config.inc"-->
<%
	Dvbbs.LoadTemplates("")
	Dim view
	view = Lcase(Request("view"))
	Select Case view
		Case "config" : ShowConfig()
		Case Else
			PlayGame()
	End Select
	Dvbbs.PageEnd()

'显示站点信息
Sub ShowConfig()
	Dim XmlDom,Node
	Set XmlDom = Server.CreateObject("msxml2.FreeThreadedDOMDocument.3.0")
	XmlDom.loadxml("<webgame_api><popwan/></webgame_api>")
	Set Node = XmlDom.documentElement.selectSingleNode("popwan")
	Node.setAttribute "bbsname",Dvbbs.Forum_info(0)
	Node.setAttribute "siteid",Plus_Popwan.ConfigNode.getAttribute("siteid")
	Node.setAttribute "gamesite",Plus_Popwan.ConfigNode.getAttribute("gamesite")
	Node.setAttribute "recommendid",RecommendID
	Response.Clear
	Response.CharSet="gb2312"  '数据集
	Response.contentType = "application/xml"
	Response.Expires = 0
	Response.Write "<?xml version=""1.0"" encoding=""gb2312""?>"
	Response.Write XmlDom.xml
	Set node = Nothing
	Set XmlDom=Nothing
End Sub

'用户进入游戏跳转
Sub PlayGame()
	Dim GoGame,UniUrl,SiteID,UserKey,Sign,DateTime,UserEmail,Userid
	SiteID = Plus_Popwan.ConfigNode.getAttribute("siteid")
	UserKey = Plus_Popwan.ConfigNode.getAttribute("key")
	UniUrl = Plus_Popwan.ConfigNode.getAttribute("gamesite")
	GoGame = Request.QueryString ("gid")
	DateTime = CstrDateTime(Now()) 'FormatDateTime(Now(),0)
	
	UserEmail = ""
	If Dvbbs.Userid>0 Then
		Sign = MD5("userid="&Dvbbs.Userid&"&username=" & Dvbbs.MemberName & "&siteid=" & siteid & "&time=" & DateTime & "&userkey=" & UserKey,32)
		UserEmail = Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@useremail").text
		Response.Redirect UniUrl & "/webuserreg/?userid="&Dvbbs.Userid&"&username=" & Server.Urlencode(Dvbbs.MemberName) & "&email="&Server.Urlencode(UserEmail)&"&siteid=" & SiteID & "&time=" & Server.Urlencode(DateTime) & "&sign=" & Sign & "&encode=gb2312&go=" & Server.Urlencode(Plus_Popwan.ConfigNode.getAttribute("gamesite")&"/"&GoGame)
	Else
		Response.Redirect "login.asp?f="&Server.UrlEncode("plus_popwan.asp?gid="&GoGame)
	End If
End Sub

Function CstrDateTime(t)
	Dim y,m,d,h,mi,s
	y=CStr(Year(t))
	m=CStr(Month(t))
	d=CStr(Day(t))
	h=CStr(Hour(t))
	mi=CStr(Minute(t))
	s=CStr(Second(t))
	CstrDateTime =  y &"-" & m &"-" &d & " "& h &":"& m &":" &s
End Function
%>