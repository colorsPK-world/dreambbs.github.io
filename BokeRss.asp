<!--#include FILE="conn.asp"-->
<!--#include file="inc/const.asp" -->
<!--#include file="boke/config.asp"-->
<%
	If DvBoke.BokeUserID=0 Then
		DvBoke.ShowCode(46)
		DvBoke.ShowMsg(0)
	End If
	Dim TopicLink,TopicList
	If Is_Isapi_Rewrite = 0 Then 
		Dvbbs.ModHtmlLinked = Dvbbs.Get_ScriptNameUrl() & "boke.asp?" & DvBoke.BokeName & ".html"
		TopicLink = Dvbbs.Get_ScriptNameUrl() & "boke.asp?" & DvBoke.BokeName & "/showtopic/"
	Else
		Dvbbs.ModHtmlLinked = Dvbbs.Get_ScriptNameUrl() & DvBoke.BokeName & ".html"
		TopicLink = Dvbbs.Get_ScriptNameUrl() & DvBoke.BokeName & "/showtopic/"
	End If

	Response.Clear
	Response.CharSet="gb2312"  '数据集
	Response.ContentType="text/xml"  '数据流格式定义
	Response.Write "<?xml version=""1.0"" encoding=""gb2312""?>"&vbNewLine
	Response.Write "<rss version=""2.0"">"&vbNewLine
	Response.Write "<channel>"&vbNewLine
	Response.Write "<title><![CDATA["&DvBoke.BokeNode.getAttribute("boketitle")&"]]></title>"&vbNewLine
	Response.Write "<link>"&Dvbbs.ModHtmlLinked&"</link>"&vbNewLine
	Response.Write "<description><![CDATA["&DvBoke.BokeNode.getAttribute("bokechildtitle")&"]]></description>"&vbNewLine

	Dim TopicHtml
	Dim Node,ChildNodes

	Set Node = DvBoke.BokeCat.selectNodes("xml/boketopic/rs:data/z:row")
	If (Node Is Nothing) Then
		DvBoke.ShowCode(46)
		DvBoke.ShowMsg(0)
	End If
	Dim PostDate,Title,Content,Channels,ChannelTitle
	For Each ChildNodes in Node
		PostDate = ChildNodes.getAttribute("posttime")
		If Not IsDate(PostDate) Then PostDate = Now()
		Title = ChildNodes.getAttribute("title")
		If Len(Title)>150 Then Title = Left(Title,150) &"......"
		Content = ChildNodes.getAttribute("titlenote")&""
		Content = Lcase(Content)
		Content = Replace(Content,"<img src=""skins/", "<img src="""&Dvbbs.Get_ScriptNameUrl()&"skins/")
		Content = Replace(Content,"<img src=""images/","<img src="""&Dvbbs.Get_ScriptNameUrl()&"images/")
		Content = Replace(Content,"<img src=""boke/","<img src="""&Dvbbs.Get_ScriptNameUrl()&"boke/")
		Content = Replace(Content,"<a href=""boke/","<a href="""&Dvbbs.Get_ScriptNameUrl()&"boke/")
		Content = Replace(Content,"<a href=""boke.asp","<a href="""&Dvbbs.Get_ScriptNameUrl()&"boke.asp")
		Content = Replace(Content,"<a href="""&DvBoke.BokeName&"","<a href="""&Dvbbs.Get_ScriptNameUrl()&""&DvBoke.BokeName&"")

		TopicHtml = "<item>"

		TopicHtml = TopicHtml & "<title><![CDATA["&DvBoke.HTMLEncode(Title)&"]]></title>"
		TopicHtml = TopicHtml & "<link>"&TopicLink&ChildNodes.getAttribute("topicid")&".html</link>"
		TopicHtml = TopicHtml & "<description><![CDATA["&Content&"]]></description>"
		TopicHtml = TopicHtml & "<author>"&ChildNodes.getAttribute("username")&"</author>"
		TopicHtml = TopicHtml & "<pubDate>"&PostDate&"</pubDate>"

		TopicHtml = TopicHtml & "</item>"

		TopicList = TopicList & TopicHtml
		TopicHtml = ""
	Next
	Response.Write TopicList

	Response.Write "</channel>"&vbNewLine
	Response.Write "</rss>"
%>