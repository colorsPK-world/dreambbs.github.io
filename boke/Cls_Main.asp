<%
'Product DvBoke version 1.00
'Copyright (C) 2004,2005 AspSky.Net. All rights reserved.
'Written By Dvbbs.net Fssunwin
'Web: http://www.aspsky.net/ , http://www.dvbbs.net/
'Email: eway@aspsky.net Sunwin@artbbs.net

Class Cls_DvBoke
	Public UserID,UserName,UserIP,UserSex
	Public BokeUserID,BokeUserName,BokeName,BokeDOM,BokeNode,BokeSetting,BokeCat,BokeCatNode,BokeStype
	Public SystemDoc,System_Node,System_Setting,System_UpSetting,SysCat,SysChatCat
	Public SqlQueryNum,ArchiveLink,ModHtmlLinked,mArchiveLink
	Public Page_File,Skins_Path,Cache_Path,Page_Strings,Main_Strings
	Public Stats,ScriptName,RefreshID
	Public IsBokeOwner,IsMaster,InputShowMsg
	Private SystemPath,ErrCode,bokeurl_r
	Private Sub Class_Initialize()
		BokeStype = "文章,收藏,链接,交易,相册"
		BokeStype = Split(BokeStype,",")
		SqlQueryNum = 0
		IsBokeOwner = False
		IsMaster = False
		If Dvbbs.Master Then
			IsMaster = True
		End If
		'Skins_Path = "Boke/Skins/default/"
		Cache_Path = "Boke/CacheFile/"
		Dim Tmpstr
		Tmpstr = Request.ServerVariables("PATH_INFO")
		Tmpstr = Split(Tmpstr,"/")
		ScriptName = Lcase(Tmpstr(UBound(Tmpstr)))
		UserSex = 1
		If Is_Isapi_Rewrite = 0 Then ModHtmlLinked = "?"
		ArchiveLink = Lcase(Request.ServerVariables("QUERY_STRING"))
		If ArchiveLink <> "" Then
			ArchiveLink = Split(ArchiveLink,".")
			If Instr(Lcase(ArchiveLink(0)),"show_")=0 Then BokeName = Replace(ArchiveLink(0),".html","")
		Else
			ReDim ArchiveLink(5)
		End If
		If Lcase(InStr(Request.ServerVariables("QUERY_STRING"),".html")) = 0 And Lcase(InStr(Request.ServerVariables("QUERY_STRING"),".xml")) = 0 Then BokeName = Request("User")
		Set MyBoardOnline=new Cls_UserOnlne 
		Dvbbs.GetForum_Setting
		Dvbbs.CheckUserLogin
		If Request.QueryString("UserID")<>"" And IsNumeric(Request.QueryString("UserID")) Then
			BokeUserID = cCur(Request.QueryString("UserID"))
			UserID = Dvbbs.UserID
			UserName = ""
		ElseIf Dvbbs.UserID>0 Then
			UserID = Dvbbs.UserID
			BokeUserID = Dvbbs.UserID
			UserName = Dvbbs.MemberName
			UserSex = Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@usersex").text
		Else
			BokeUserID = 0
			UserID = 0
			UserName = ""
		End If
		If Instr(Lcase(ArchiveLink(0)),"userid_") and IsNumeric(Replace(Lcase(ArchiveLink(0)),"userid_","")) Then
			BokeUserID = cCur(Replace(Lcase(ArchiveLink(0)),"userid_",""))
			BokeName = ""
		End If
		UserIP = Dvbbs.UserTrueIP
		LoadSetup(0)
		Skins_Path = System_Node.getAttribute("s_path")
		GetUBokeInfo()
		If Not IsObject(BokeNode) Then
			Setup_SysBokeNode
		End If
	End Sub

	Private Sub class_terminate()
		Set SystemDoc = Nothing
		If IsObject(BokeDOM) Then Set BokeDOM = Nothing
		If IsObject(Boke_Conn) Then Boke_Conn.Close : Set Boke_Conn = Nothing
	End Sub

	Public Property Get Version()
		Version = "<a href=""http://www.cndw.com"" target=""_blank""><u>iBoker V1.0.0</u></a>"
	End Property

	Public Function Execute(Command)
		'Response.Write Command
		'Response.Write "<br/>"
		If Dv_Boke_InDvbbsData = 1 Then
			If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase()
			Set Execute = Boke_Conn.Execute(Command)
		Else
		
			If Not IsObject(Conn) Then ConnectionDatabase()
			Set Execute = Conn.Execute(Command)
		End If
		SqlQueryNum = SqlQueryNum + 1
	End Function

	Rem 判断发言是否来自外部
	Public Function ChkPost()
		Dim server_v1,server_v2
		Chkpost=False 
		server_v1=Cstr(Request.ServerVariables("HTTP_REFERER"))
		server_v2=Cstr(Request.ServerVariables("SERVER_NAME"))
		If Mid(server_v1,8,len(server_v2))=server_v2 Then Chkpost=True 
	End Function

	Public Function CheckNumeric(Byval CHECK_ID)
		If CHECK_ID<>"" and IsNumeric(CHECK_ID) Then _
			CHECK_ID = cCur(CHECK_ID) _
		Else _
			CHECK_ID = 0
		CheckNumeric = CHECK_ID
	End Function

	Public Function Checkstr(Str)
		If Isnull(Str) Then
			CheckStr = ""
			Exit Function 
		End If
		Str = Replace(Str,Chr(0),"")
		CheckStr = Replace(Str,"'","''")
	End Function

	Public Function getUrlEncodel(byVal  Url)  
		Dim  i,code  
		getUrlEncodel=""  
		If Trim(Url)="" Then Exit Function  
		For  i=1  To  Len(Url)  
			code=Asc(Mid(Url,i,1))  
			If code<0  Then code = code + 65536  
			If code>255  Then  
				getUrlEncodel=getUrlEncodel&"%"&Left(Hex(Code),2)&"%"&Right(Hex(Code),2)  
			Else  
				getUrlEncodel=getUrlEncodel&Mid(Url,i,1)  
			End If 
		Next  
	End Function

	Public Function Furl(url)
		Furl=Replace(url," ","%20",1,-1,1)
		Furl=getUrlEncodel(Furl)
	End Function
	
	Function HTMLEncode(reString) '转换HTML代码
		Dim Str:Str=reString
		IF Not isnull(Str) Then
			Str = replace(Str, ">", "&gt;")
			Str = replace(Str, "<", "&lt;")
			Str = Replace(Str, CHR(32), "&nbsp;")
			Str = Replace(Str, CHR(9), "&nbsp;")
			Str = Replace(Str, CHR(9), "&#160;&#160;&#160;&#160;")
			Str = Replace(Str, CHR(34), "&quot;")
			Str = Replace(Str, CHR(39), "&#39;")
			Str = Replace(Str, CHR(13), "")
			Str = Replace(Str, CHR(10), "<br>")
			HTMLEncode = Str
		End IF
	End Function

	Function ClearHtmlTages(reString)
		Dim Re
		Dim Str:Str=reString
		IF Not isnull(Str) Then
			Set Re=New RegExp
			Re.IgnoreCase =True
			Re.Global=True
			Re.Pattern="<(.[^>]*)>"
			Str=Re.Replace(Str, "")
			Set Re=Nothing
			Str = replace(Str, ">", "&gt;")
			Str = replace(Str, "<", "&lt;")
			Str = Replace(Str, CHR(32), "&nbsp;")
			Str = Replace(Str, CHR(9), "&nbsp;")
			Str = Replace(Str, CHR(9), "&#160;&#160;&#160;&#160;")
			Str = Replace(Str, CHR(34), "&quot;")
			Str = Replace(Str, CHR(39), "&#39;")
			Str = Replace(Str, CHR(13), "")
			'Str = Server.Htmlencode(Str)
		End IF
		ClearHtmlTages = Str
	End Function

	'初始化默认数据
	Private Sub Setup_SysBokeNode()
		Dim XslDoc
		Page_File = Server.MapPath(Cache_Path &"default.config")
		Set XslDoc=Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
		If Not XslDoc.Load(Page_File) Then
			Response.Write "初始数据不存在！"
			Response.End
		Else
			Set BokeNode=XslDoc.documentElement.selectSingleNode("rs:data/z:row")
			BokeNode.attributes.getNamedItem("joinboketime").text = Now()
			BokeNode.attributes.getNamedItem("lastuptime").text = Now()
			BokeSetting = Split(BokeNode.getAttribute("bokesetting"),",")
			Set BokeCat=Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
			BokeCat.Load(Server.MapPath(Cache_Path &"usercat.config"))
		End If
		Set XslDoc = Nothing
	End Sub

	'UserID=0 ,UserName=1 ,NickName=2 ,BokeName=3 ,PassWord=4 ,BokeTitle=5 ,BokeChildTitle=6 ,BokeNote=7 ,JoinBokeTime=8 ,PageView=9 ,TopicNum=10 ,FavNum=11 ,PhotoNum=12 ,PostNum=13 ,TodayNum=14 ,Trackbacks=15 ,SpaceSize=16 ,XmlData=17 ,SysCatID=18 ,BokeSetting=19 ,LastUpTime=20 ,SkinID=21,Stats=22
	Public Sub GetUBokeInfo()
		Dim Sql,Rs
		Sql = "Select UserID,UserName,NickName,BokeName,PassWord,BokeTitle,BokeChildTitle,BokeNote,JoinBokeTime,PageView,TopicNum,FavNum,PhotoNum,PostNum,TodayNum,Trackbacks,SpaceSize,XmlData,SysCatID,BokeSetting,LastUpTime,SkinID,Stats,S.S_SkinName,S.S_Path,S.S_ViewPic,S.S_Info,S.S_Builder From [Dv_Boke_User] U Inner Join [Dv_Boke_Skins] S On U.SkinID = S.S_ID"
		Sql = Lcase(Sql)
		If BokeName<>"" Then
			Sql = Sql & " where BokeName = '"&Dvbbs.Checkstr(BokeName)&"'"
		ElseIf BokeUserID>0 Then
			Sql = Sql & " where UserID = "&BokeUserID
		Else
			'请选取相关的DVBOKE，返回综合列表
			Exit Sub
		End If
		Set Rs = Execute(SQL)
		If Rs.EOF And Rs.BOF Then
			'申请页面
			BokeUserID = 0
			If Dvbbs.UserID = 0 Then
				'Response.Write "<script>alert(""您访问的博客用户不存在，系统将会自动转向到系统博客首页面！"");</script>"
				'Response.Redirect "BokeIndex.asp"
			Else
				'Response.Write "<script>alert(""您访问的博客用户不存在，系统将会自动转向到个人博客申请页面！"");</script>"
				'Response.Redirect "BokeApply.asp"
			End If
			Exit Sub
		End If
		BokeUserID = Rs(0)
		BokeUserName = Rs(2)
		BokeName = Rs(3)
		BokeSetting = Split(Rs(19)&"",",")
		
		If BokeUserID = UserID and UserID>0 Then
			IsBokeOwner = True
		End If
		If Not IsMaster Then
			If Rs(22)=2 Then
				ShowCode(52)
				ShowMsg(0)
			ElseIf Rs(22)=1 and Not IsBokeOwner Then
				ShowCode(53)
				ShowMsg(0)
			End If
			If BokeSetting(0) <> "1" And Not IsBokeOwner Then
				ShowCode(41)
				ShowMsg(0)
			End If
		End If
		Set BokeDOM=Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
		Rs.Save BokeDOM,1
		BokeDOM.documentElement.RemoveChild(BokeDOM.documentElement.selectSingleNode("s:Schema"))
		Set BokeNode=BokeDOM.documentElement.selectSingleNode("rs:data/z:row")
		If DateDiff("d",Rs(20),now())<>0 and BokeNode.getAttribute("todaynum")>0 Then
			BokeNode.attributes.getNamedItem("todaynum").text = 0
			Execute("Update [Dv_Boke_User] set TodayNum=0 where UserID="&BokeUserID)
		End If
		BokeNode.attributes.getNamedItem("lastuptime").text = Rs(20)
		BokeNode.attributes.getNamedItem("joinboketime").text = Rs(8)
		'If ScriptName<>"bokeindex.asp" Then
		Skins_Path = BokeNode.getAttribute("s_path")
		'End If
		Set BokeCat=Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
		If Rs(16)="" Or IsNull(Rs(17)) Then
			BokeCat.Load(Server.MapPath(Cache_Path &"usercat.config"))
		Else
			If Not BokeCat.LoadXml(Rs(17)) Then
				'Response.Write "用户栏目数据出错！"
				BokeCat.Load(Server.MapPath(Cache_Path &"usercat.config"))
			End If
		End If
		'Response.Write BokeCat.documentElement.xml
		Set BokeCatNode = BokeCat.documentElement.selectNodes("rs:data/z:row")
		Rs.Close : Set Rs = Nothing

	End Sub

	'重置系统表数据 ACT=1强制更新
	Public Sub LoadSetup(Act)
		Page_File = Server.MapPath(Cache_Path &"System.config")
		Set SystemDoc = Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
		If Not SystemDoc.Load(Page_File) Then
			SystemDoc.LoadXml("<?xml version=""1.0"" encoding=""Gb2312""?><bokesystem/>")
			ReLoadBoke_System()
			ReLoadBoke_SysCat()
			SaveSystemCache()
		ElseIf Act=1 Then
			ReLoadBoke_System()
			ReLoadBoke_SysCat()
			SaveSystemCache()
		End If
		Set System_Node = SystemDoc.documentElement.selectSingleNode("/bokesystem/system/rs:data/z:row")
		Set SysCat = SystemDoc.documentElement.selectSingleNode("/bokesystem/syscat")
		Set SysChatCat = SystemDoc.documentElement.selectSingleNode("/bokesystem/syschatcat")
		System_Setting = Split(System_Node.getAttribute("s_setting"),",")
		System_UpSetting = Split(System_Setting(12),"|")
		
		'Response.Write SystemDoc.documentElement.xml
	End Sub

	Public Sub SaveSystemCache()
		Page_File = Server.MapPath(Cache_Path &"System.config")
		SystemDoc.save Page_File
	End Sub

	'系统
	'S_LastPostTime,S_TopicNum,S_PhotoNum,S_FavNum,S_UserNum,S_TodayNum,S_PostNum
	Public Sub Update_System(UserNum,TodayNum,FavNum,PhotoNum,TopicNum,PostNum,LastTime)
		If Not IsNull(LastTime) and IsDate(LastTime) Then
			System_Node.attributes.getNamedItem("s_lastposttime").text = LastTime
		End If
		System_Node.attributes.getNamedItem("s_topicnum").text = System_Node.attributes.getNamedItem("s_topicnum").text + TopicNum
		System_Node.attributes.getNamedItem("s_photonum").text = System_Node.attributes.getNamedItem("s_photonum").text + PhotoNum
		System_Node.attributes.getNamedItem("s_favnum").text = System_Node.attributes.getNamedItem("s_favnum").text + FavNum
		System_Node.attributes.getNamedItem("s_usernum").text = System_Node.attributes.getNamedItem("s_usernum").text + UserNum
		System_Node.attributes.getNamedItem("s_todaynum").text = System_Node.attributes.getNamedItem("s_todaynum").text + TodayNum
		System_Node.attributes.getNamedItem("s_postnum").text = System_Node.attributes.getNamedItem("s_postnum").text + PostNum
		'SaveSystemCache()
	End Sub

	'系统分类
	'sCatID,uCatNum,TopicNum,PostNum,TodayNum,LastUpTime
	Public Sub Update_SysCat(sCatID,UserNum,TodayNum,TopicNum,PostNum,LastTime)
		Dim UpCatID,i,Nodes
		UpCatID = Split(sCatID,",")
		For i = 0  To Ubound(UpCatID)
			Set Nodes = SystemDoc.documentElement.selectSingleNode("//rs:data/z:row[@scatid = '"&UpCatID(i)&"']")
			If Not (Nodes is nothing) Then
				If Not IsNull(LastTime) and IsDate(LastTime) Then
					Nodes.attributes.getNamedItem("lastuptime").text = LastTime
				End If
				Nodes.attributes.getNamedItem("ucatnum").text = Nodes.attributes.getNamedItem("ucatnum").text + UserNum
				Nodes.attributes.getNamedItem("topicnum").text = Nodes.attributes.getNamedItem("topicnum").text + TopicNum
				Nodes.attributes.getNamedItem("postnum").text = Nodes.attributes.getNamedItem("postnum").text + PostNum
				Nodes.attributes.getNamedItem("todaynum").text = Nodes.attributes.getNamedItem("todaynum").text + TodayNum
			End If
		Next
		'SaveSystemCache()
	End Sub

	Private Sub ReLoadBoke_System()
		Dim Nodes,NodeList
		Set Nodes = SystemDoc.documentElement.selectSingleNode("/bokesystem/system")
		If Nodes is Nothing Then
			Set Nodes = SystemDoc.createNode(1,"system","")
			SystemDoc.documentElement.appendChild(Nodes)
		Else
			If Nodes.hasChildNodes Then
				Nodes.removeChild Nodes.selectSingleNode("rs:data")
			End If
		End If
		Dim Rs,TempXmlDoc,TempNodes
		Set TempXmlDoc = Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
		Set Rs = Execute(Lcase("Select Top 1  B.S_Name,S_Note,S_LastPostTime,S_TopicNum,S_PhotoNum,S_FavNum,S_UserNum,S_TodayNum,S_PostNum,S_Setting,S_Url,S_sDomain,SkinID,S.S_SkinName,S.S_Path,S.S_ViewPic,S.S_Info,S.S_Builder From Dv_Boke_System B Inner Join [Dv_Boke_Skins] S On S.S_ID = B.SkinID"))
		Rs.Save TempXmlDoc,1
		TempXmlDoc.documentElement.RemoveChild(TempXmlDoc.documentElement.selectSingleNode("s:Schema"))

		Set TempNodes = TempXmlDoc.documentElement.selectSingleNode("rs:data/z:row")

		TempNodes.attributes.getNamedItem("s_lastposttime").text = Rs("S_LastPostTime")
		If (DateDiff("d",Rs("S_LastPostTime"),now())<>0 and TempNodes.getAttribute("s_todaynum")>0) or TempNodes.getAttribute("s_todaynum")<0 Then
			TempNodes.attributes.getNamedItem("s_todaynum").text = 0
			Execute("Update [Dv_Boke_System] set S_TodayNum=0")
		End If
		Set TempNodes=TempXmlDoc.documentElement.selectSingleNode("rs:data")
		Nodes.appendChild(TempNodes)
		Rs.Close
		Set Rs = Nothing
	End Sub


	'SysCat,SysChatCat
	Private Sub ReLoadBoke_SysCat()
		Dim Nodes,TempNodes,NodeList,TempXmlDoc
		Dim Rs
		Set TempXmlDoc = Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
		'SysCat
		Set Nodes = SystemDoc.documentElement.selectSingleNode("/bokesystem/syscat")
		If Nodes is Nothing Then
			Set Nodes = SystemDoc.createNode(1,"syscat","")
			SystemDoc.documentElement.appendChild(Nodes)
		Else
			If Nodes.hasChildNodes Then
				Nodes.removeChild Nodes.selectSingleNode("rs:data")
			End If
		End If
		Set Rs = Execute(Lcase("Select sCatID,sCatTitle,sCatNote,uCatNum,TopicNum,PostNum,TodayNum,sType,LastUpTime From Dv_Boke_SysCat where sType = 0"))
		If Not Rs.Eof Then
			Rs.Save TempXmlDoc,1
			TempXmlDoc.documentElement.RemoveChild(TempXmlDoc.documentElement.selectSingleNode("s:Schema"))
			Set TempNodes = TempXmlDoc.documentElement.selectNodes("rs:data/z:row")
			For Each NodeList in TempNodes
				NodeList.attributes.getNamedItem("lastuptime").text = Rs("LastUpTime")
				If (DateDiff("d",Rs("LastUpTime"),now())<>0 and NodeList.getAttribute("TodayNum")>0) or NodeList.getAttribute("TodayNum")<0 Then
					NodeList.attributes.getNamedItem("todaynum").text = 0
					Execute("Update [Dv_Boke_SysCat] set todaynum=0 where sCatID="&Rs(0))
				End If
				Rs.MoveNext
			Next
			Set TempNodes=TempXmlDoc.documentElement.selectSingleNode("rs:data")
			Nodes.appendChild(TempNodes)
		End If
		
		'SysChatCat
		Set Nodes = SystemDoc.documentElement.selectSingleNode("/bokesystem/syschatcat")
		If Nodes is Nothing Then
			Set Nodes = SystemDoc.createNode(1,"syschatcat","")
			SystemDoc.documentElement.appendChild(Nodes)
		Else
			If Nodes.hasChildNodes Then
				Nodes.removeChild Nodes.selectSingleNode("rs:data")
			End If
		End If
		Set Rs = Execute(Lcase("Select sCatID,sCatTitle,sCatNote,uCatNum,TopicNum,PostNum,TodayNum,sType,LastUpTime From Dv_Boke_SysCat where sType = 1"))
		If Not Rs.Eof Then
			Rs.Save TempXmlDoc,1
			TempXmlDoc.documentElement.RemoveChild(TempXmlDoc.documentElement.selectSingleNode("s:Schema"))
			Set TempNodes =TempXmlDoc.documentElement.selectNodes("rs:data/z:row")
			For Each NodeList in TempNodes
				NodeList.attributes.getNamedItem("lastuptime").text = Rs("LastUpTime")
				If (DateDiff("d",Rs("LastUpTime"),now())<>0 and NodeList.getAttribute("TodayNum"))>0 or NodeList.getAttribute("TodayNum")<0 Then
					NodeList.attributes.getNamedItem("todaynum").text = 0
					Execute("Update [Dv_Boke_SysCat] set todaynum=0 where sCatID="&Rs(0))
				End If
				Rs.MoveNext
			Next
			Set TempNodes=TempXmlDoc.documentElement.selectSingleNode("rs:data")
			Nodes.appendChild(TempNodes)
		End If
		Rs.Close
		Set Rs = Nothing
		Set TempXmlDoc = Nothing
	End Sub

	'应用过程
	'页面加载
	Public Sub LoadPage(ByVal StyleFile)
		Dim XslDoc
		Page_File = Server.MapPath(Skins_Path & "xml/" & StyleFile)
		Set XslDoc=Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
		If Not XslDoc.Load(Page_File) Then
			Response.Write "模板不存在"
			Response.End
			Exit Sub
		Else
			Set Page_Strings = XslDoc.DocumentElement.selectNodes("xsl:variable")
		End If
		Set XslDoc = Nothing
	End Sub
	
	Public Sub Head(isSystem)
		Page_File = Server.MapPath(Skins_Path & "xml/main.xslt")
		If Is_Isapi_Rewrite = 0 Then
			ModHtmlLinked = "boke.asp?"
			mArchiveLink = "bokeindex.asp?"
			bokeurl_r = "bokerss.asp?"
		End If
		Dim XslDoc
		Set XslDoc=Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
		If Not XslDoc.Load(Page_File) Then
			Response.Write "主模板不存在!"
			Exit Sub
		Else
			Set Main_Strings = XslDoc.DocumentElement.selectNodes("xsl:variable")
		End If
		Set XslDoc = Nothing
		Dim Html
		Html = Main_Strings(0).text
		If isSystem = 1 Then
			Html = Replace(Html,"{$boketitle}",System_Node.getAttribute("s_name"))
			Html = Replace(Html,"{$bokechildtitle}",System_Setting(17))
			Html = Replace(Html,"{$bokename}","")
			Html = Replace(Html,"{$BokeUrl}",System_Node.getAttribute("s_url"))
		Else
			Html = Replace(Html,"{$boketitle}",BokeNode.getAttribute("boketitle")&"")
			Html = Replace(Html,"{$bokechildtitle}",BokeNode.getAttribute("bokechildtitle")&"")
			Html = Replace(Html,"{$bokename}",BokeNode.getAttribute("bokename")&"--")
			Html = Replace(Html,"{$BokeUrl}",System_Node.getAttribute("s_url")&ModHtmlLinked&BokeNode.getAttribute("bokename")&".html")
		End If
		Html = Replace(Html,"{$stats}",Stats)
		Html = Replace(Html,"{$copyright}","")
		Html = Replace(Html,"{$skinpath}",Skins_Path)
		If BokeUserID > 0 Then
			Html = Replace(Html,"{$rssurl}",Dvbbs.Get_ScriptNameUrl & bokeurl_r & BokeName & ".rss.xml")
		Else
			Html = Replace(Html,"{$rssurl}","")
		End If
		
		Response.Write Html
	End Sub
	
	Public Sub Nav(isSystem)
		Top(isSystem)
		Dim Html
		If isSystem = 1 Then
			Html = Main_Strings(33).text
		Else
			Html = Main_Strings(3).text
			Html = Replace(Html,"{$TopicNum}",BokeNode.getAttribute("topicnum")&"")
			Html = Replace(Html,"{$FavNum}",BokeNode.getAttribute("favnum")&"")
			Html = Replace(Html,"{$TodayNum}",BokeNode.getAttribute("todaynum")&"")
			Html = Replace(Html,"{$LastUpTime}",FormatDateTime(CDate(BokeNode.getAttribute("lastuptime")),1))
			If BokeSetting(14)="1" Then
				If BokeSetting(15)<>"1" And BokeSetting(15)<>"" Then
					Main_Strings(30).text = Replace(Main_Strings(30).text,"{$PaytoStr}",BokeSetting(15))
					Html = Replace(Html,"{$BokePayto}",Main_Strings(30).text)
				Else
					Main_Strings(30).text = Replace(Main_Strings(30).text,"{$PaytoStr}",Main_Strings(31).text)
					Html = Replace(Html,"{$BokePayto}",Main_Strings(30).text)
				End If
			Else
				Html = Replace(Html,"{$BokePayto}","")
			End If
			If IsMaster Then
				If BokeNode.getAttribute("stats")="0" Then
					Html = Replace(Html,"{$Open}",Main_Strings(36).text)
				Else
					Html = Replace(Html,"{$Open}",Main_Strings(37).text)
				End If
			Else
				Html = Replace(Html,"{$Open}","")
			End If
		End If
		If IsBokeOwner Then
			If isSystem = 1 Then
				Html = Replace(Html,"{$BokeOwnerNav}",Main_Strings(34).text)
			Else
				Html = Replace(Html,"{$BokeOwnerNav}",Main_Strings(27).text)
			End If
		Else
			Html = Replace(Html,"{$BokeOwnerNav}",Main_Strings(28).text)
		End If
		Html = Replace(Html,"{$bokeurl}",ModHtmlLinked)
		Html = Replace(Html,"{$ibokeurl}",mArchiveLink)
		Html = Replace(Html,"{$bokename}",BokeName)
		Html = Replace(Html,"{$skinpath}",Skins_Path)
		Response.Write Html
		If isSystem = 0 Then BokeChannel()
	End Sub

	Public Sub Top(isSystem)
		Head(isSystem)
		Dim Html
		Html = Main_Strings(2).text
		If isSystem = 1 Then
			Html = Replace(Html,"{$boketitle}",System_Node.getAttribute("s_name"))
			Html = Replace(Html,"{$bokechildtitle}",System_Setting(17))
			Html = Replace(Html,"{$SiteUrl}","")
		Else
			If System_Node.getAttribute("s_sdomain") = "" Then
				Html = Replace(Html,"{$SiteUrl}","")
			Else
				Dim sDomain,i,sDomainList
				sDomain = Split(System_Node.getAttribute("s_sdomain")&"","|")
				For i = 0 To Ubound(sDomain)
					If sDomainList = "" Then
						sDomainList = "<a href=""http://"&BokeName&"."&sDomain(i)&"/"">"&BokeName&"."&sDomain(i)&"</a>"
					Else
						sDomainList = sDomainList & "&nbsp;,&nbsp;<a href=""http://"&BokeName&"."&sDomain(i)&"/"">"&BokeName&"."&sDomain(i)&"</a>"
					End if
				Next
				Html = Replace(Html,"{$SiteUrl}",Replace(Main_Strings(35).text,"{$SiteUrl}",sDomainList))
			End If
			Html = Replace(Html,"{$boketitle}",BokeNode.getAttribute("boketitle")&"")
			Html = Replace(Html,"{$bokechildtitle}",BokeNode.getAttribute("bokechildtitle")&"")
		End If
		Response.Write Html
	End Sub

	Public Sub BokeChannel()
		Dim TempList,Temp
		Dim Html,Node,i,NodeList
		If Is_Isapi_Rewrite = 0 Then ModHtmlLinked = "boke.asp?"
		For i = 0 To 4
			Set NodeList = BokeCat.documentElement.selectNodes("rs:data/z:row[@utype='"&i&"']")
			If NodeList.length>0 Then
				Temp = ""
				Html = Main_Strings(16).text
				For Each Node in NodeList
					TempList = Main_Strings(17).text
					TempList = Replace(TempList,"{$channelname}",Node.getAttribute("ucattitle"))
					TempList = Replace(TempList,"{$cat_id}",Node.getAttribute("ucatid"))
					Temp = Temp & TempList
				Next
				Html = Replace(Html,"{$channellist}",Temp)
				Html = Replace(Html,"{$bokename}",BokeName)
				Html = Replace(Html,"{$cat_tid}",i)
				Html = Replace(Html,"{$bokeurl}",ModHtmlLinked)
				Response.Write Html
			End If
		Next
	End Sub
	Public Sub BokeChannelToJS()
		Dim Temp,Temp1,Temp2
		Dim Html,Node,i,ii,NodeList
		Response.Write "<script language=""JavaScript"">var BokeCat_ID = new Array();var BokeCat_Title = new Array();"
		For i = 0 To 4
			Response.Write ""
			Temp1 = "["
			Temp2 = "["
			ii=0
			Set NodeList = BokeCat.documentElement.selectNodes("rs:data/z:row[@utype='"&i&"']")
			If NodeList.length>0 Then
				For Each Node in NodeList
					ii = ii + 1
					Temp1 = Temp1 & "'" & Node.getAttribute("ucatid")&"'"
					Temp2 = Temp2 & "'" &Node.getAttribute("ucattitle") &"'"
					If ii<NodeList.length Then
						Temp1 = Temp1 & ","
						Temp2 = Temp2 & ","
					End If
				Next
			End If
			Temp1 = Temp1 & "]"
			Temp2 = Temp2 & "]"
			Response.Write "BokeCat_ID["&i&"]="&Temp1&";"&vBnewline
			Response.Write "BokeCat_Title["&i&"]="&Temp2&";"&vBnewline
		Next
		Response.Write "</script>"
	End Sub
	'------------------------------------- Left Function ------------------------------------------------------------
	Public Sub LeftMenu()
		Dim Html,i,Str1
		Html = Main_Strings(4).text
		For i=7 To 15
			Str1 = "{$"&Main_Strings(i).getAttribute("title")&"}"
			If Instr(Html,Str1) Then
				Select Case Str1
					Case "{$show_bokenote}"
						Html = Replace(Html,"{$show_bokenote}",SBokeNote)
					Case "{$show_channel}"
						Html = Replace(Html,Str1,SChannel)
					Case Else
					Html = Replace(Html,Str1,Main_Strings(i).text)
				End Select
			End If
		Next
		If Instr(Html,"{$bokelinks}") Then
			Html = Replace(Html,"{$bokelinks}",LinkStr)
		End If
		If Instr(Html,"{$bokephotos}") Then
			Html = Replace(Html,"{$bokephotos}",BokePhotos)
		End If
		If Instr(Html,"{$boketopicnews}") Then
			Html = Replace(Html,"{$boketopicnews}",BokePost)
		End If
		If Instr(Html,"{$bokecounts}") Then
			Html = Replace(Html,"{$bokecounts}",BokeCounts)
		End If
		If BokeSetting(15)<>"1" And BokeSetting(15)<>"" Then
			Html = Replace(Html,"{$ChannelPay}",BokeSetting(15))
		Else
			Html = Replace(Html,"{$ChannelPay}","")
		End If
		Html = Replace(Html,"{$bokename}",BokeName)
		Html = Replace(Html,"{$bokeurl_r}",Dvbbs.Get_ScriptNameUrl & bokeurl_r)
		Html = Replace(Html,"{$bokeurl}",ModHtmlLinked)
		Response.Write Html
	End Sub
	Public Function BokeCounts()
		Dim ShowTemp
		ShowTemp = Main_Strings(26).text
		ShowTemp = Replace(ShowTemp,"{$TodayNum}",BokeNode.getAttribute("todaynum"))
		ShowTemp = Replace(ShowTemp,"{$TopicNum}",BokeNode.getAttribute("topicnum"))
		ShowTemp = Replace(ShowTemp,"{$FavNum}",BokeNode.getAttribute("favnum"))
		ShowTemp = Replace(ShowTemp,"{$PhotoNum}",BokeNode.getAttribute("photonum"))
		ShowTemp = Replace(ShowTemp,"{$PostNum}",BokeNode.getAttribute("postnum"))
		ShowTemp = Replace(ShowTemp,"{$Trackbacks}",BokeNode.getAttribute("trackbacks"))
		ShowTemp = Replace(ShowTemp,"{$JoinBokeTime}",Formatdatetime(BokeNode.getAttribute("joinboketime"),2))
		ShowTemp = Replace(ShowTemp,"{$LastUpTime}",Formatdatetime(BokeNode.getAttribute("lastuptime"),2))
		BokeCounts = ShowTemp
	End Function
	Public Function SBokeNote()
		Dim ShowTemp
		ShowTemp = ""
		If BokeNode.getAttribute("bokenote")<>"" Then
			ShowTemp = Main_Strings(7).text
			ShowTemp = Replace(ShowTemp,"{$bokenote}",HtmlEncode(BokeNode.getAttribute("bokenote")))
		End If
		SBokeNote = ShowTemp
	End Function
	Public Function SChannel()
		Dim ShowTemp
		If BokeNode.getAttribute("xmldata")<>"" Then
			ShowTemp = Main_Strings(8).text
			ShowTemp = Replace(ShowTemp,"{$bokechannel}","")
		End If
		SChannel = ShowTemp
	End Function
	Public Function ChannelTitle(Ucatid)
		Dim Channels
		Set Channels = BokeCat.selectSingleNode("//rs:data/z:row[@ucatid='"&Ucatid&"']")
		If Channels Is Nothing Then
			ChannelTitle = ""
		Else
			ChannelTitle = Channels.getAttribute("ucattitle")
		End If
	End Function
	Public Function LinkStr()
		Dim Node,ChildNodes,LinkTemp,Temp
		Set Node = DvBoke.BokeCat.selectNodes("xml/bokelink/rs:data/z:row")
		If Node.Length=0 Then
			LinkStr = "暂未添加该信息。"
			Exit Function
		End If
		For Each ChildNodes in Node
			Temp = Main_Strings(23).text
			Temp = Replace(Temp,"{$linkurl}",ClearHtmlTages(ChildNodes.getAttribute("content")))
			Temp = Replace(Temp,"{$linkname}",ClearHtmlTages(ChildNodes.getAttribute("title")))
			LinkTemp = LinkTemp & Temp
		Next
		LinkStr = LinkTemp
	End Function

	Public Function BokePost()
		Dim Node,ChildNodes,BokePostTemp,Temp
		Set Node = DvBoke.BokeCat.selectNodes("xml/bokepost/rs:data/z:row")
		If Node.Length=0 Then
			BokePost = "暂未添加该信息。"
			Exit Function
		End If
		Dim Title
		For Each ChildNodes in Node
			Temp = Main_Strings(25).text
			Title = ChildNodes.getAttribute("title")
			If Title = "" Then
				Title = ChildNodes.getAttribute("content")
			End If
			Title = ClearHtmlTages(Title)
			If Len(Title)>16 Then
				Title = Left(Title,16)&"..."
			End If
			Temp = Replace(Temp,"{$title}",	Title)
			Temp= Replace(Temp,"{$TopicID}",ChildNodes.getAttribute("rootid"))
			Temp= Replace(Temp,"{$PostID}",ChildNodes.getAttribute("postid"))
			Temp= Replace(Temp,"{$postusername}",ChildNodes.getAttribute("username"))
			BokePostTemp = BokePostTemp & Temp
		Next
		BokePostTemp = Replace(BokePostTemp,"{$bokename}",BokeName)
		BokePost = BokePostTemp
	End Function

	Public Function BokePhotos()
		Dim Node,ChildNodes,PhotosTemp,Temp
		Set Node = DvBoke.BokeCat.selectNodes("xml/bokephoto/rs:data/z:row")
		If Node.Length=0 Then
			BokePhotos = "暂未添加该信息。"
			Exit Function
		End If
		Dim ViewFile
		For Each ChildNodes in Node
			Temp = Main_Strings(24).text
			ViewFile = ChildNodes.getAttribute("previewimage")
			If ViewFile="" or IsNull(ViewFile) Then
				ViewFile = DvBoke.System_UpSetting(19) & ChildNodes.getAttribute("filename")
			End If
			Temp = Replace(Temp,"{$ViewPhoto}",ViewFile)
			Temp = Replace(Temp,"{$topic}",HTMLEncode(ChildNodes.getAttribute("title")))
			Temp= Replace(Temp,"{$TopicID}",ChildNodes.getAttribute("topicid"))
			PhotosTemp = PhotosTemp & Temp
			Exit For
		Next
		PhotosTemp = Replace(PhotosTemp,"{$width}",Dvboke.System_UpSetting(14))
		PhotosTemp = Replace(PhotosTemp,"{$height}",Dvboke.System_UpSetting(15))
		PhotosTemp = Replace(PhotosTemp,"{$bokename}",BokeName)
		
		BokePhotos = PhotosTemp
	End Function

	'------------------------------------- Left Function ------------------------------------------------------------
	Public Function SysInfo
		Dim TempStr
		Dim Endtime
		Endtime = Timer()
		TempStr = "查询次数：("& SqlQueryNum + Dvbbs.SqlQueryNum &")"
		TempStr = TempStr & ",页面执行时间 0"&FormatNumber((Endtime-Startime),5)&" 秒"
		SysInfo = TempStr
	End Function

	Public Sub Footer()
		Dim Html
		Html = Main_Strings(1).text
		If BokeUserName = "" or ScriptName="bokeindex.asp" Then
			BokeUserName = "<a href="""&System_Node.getAttribute("s_url")&""">"&System_Node.getAttribute("s_name")&"</a>"
		End If
		Html = Replace(Html,"{$bokeuser}",BokeUserName)
		Html = Replace(Html,"{$version}",Version)
		Html = Replace(Html,"{$sysinfo}",SysInfo)
		Response.Write Html
	End Sub

	Public Sub ShowCode(Byval Code)
		If ErrCode<>"" Then  ErrCode = ErrCode & ","
		ErrCode = ErrCode & Code
	End Sub
	
	'Stype 0=显示底部及顶部信息,1=不显示顶部及底部,2=在相关页面内显示
	Public Sub ShowMsg(Stype)
		If sType = 2 Then
			If ErrCode = "" Then Exit Sub
			LoadPage("SysDescription.xslt")
			Dim Codes,ShowCodes,i,Description,Count
			Dim ShowSkins,TempStr
			ShowSkins = Page_Strings(0).text
			Count = Page_Strings.length
			Description = ""
			TempStr = Page_Strings(1).text
			Codes = ErrCode
			ShowCodes = Split(Codes,",")
			For i=0 to UBound(ShowCodes)
				If IsNumeric(ShowCodes(i)) Then
					If Clng(ShowCodes(i)) <= Count and Clng(ShowCodes(i))>1 Then
						Description = Description & Replace(TempStr,"{$msg}",Page_Strings(ShowCodes(i)).text)
					End If
				Else
					Description = Description & Replace(TempStr,"{$msg}",Server.Htmlencode(ShowCodes(i)))
				End If
			Next
			ShowSkins = Replace(ShowSkins,"{$refresh}","")
			ShowSkins = Replace(ShowSkins,"{$refreshinfro}","")
			ShowSkins = Replace(ShowSkins,"{$description}",Description)
			InputShowMsg = ShowSkins
		Else
			If ErrCode<>"" and ScriptName<>"bokedescription.asp" Then Response.Redirect Furl("BokeDescription.asp?user="&BokeName&"&ShowHead="& Stype &"&RefreshID="&RefreshID&"&Codes=" & ErrCode)
		End If
	End Sub
	'是否支持FSO
	Public Function SysObjFso()
		Dim xTestObj
		SysObjFso = False
		On Error Resume Next
		Set xTestObj = Dvbbs.iCreateObject("Scripting.FileSystemObject")
		If Err = 0 Then SysObjFso = True
		Set xTestObj = Nothing
		Err = 0
	End Function
	Public Sub SysDeleteFile(PostID)
		If PostID = "" Or Not IsNumeric(PostID) Then Exit Sub
		Dim Rs
		Dim objFSO,FilePath,ViewFilepath,FileSize
		FileSize = 0
		'On Error Resume Next
		Set objFSO = Dvbbs.iCreateObject("Scripting.FileSystemObject")
		FilePath = DvBoke.System_UpSetting(19)
		Set Rs=Execute("Select ID,FileName,PreviewImage,FileSize,BokeUserID From Dv_Boke_Upfile Where PostID = " & PostID)
		Do While Not Rs.Eof
			'删除附件
			FileSize = Rs("FileSize")
			If SysObjFso=True Then
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
			'返还文件空间
			If FileSize>0 Then
				FileSize = Formatnumber((FileSize/1024)/1024,2)
				Response.Write "Update Dv_Boke_User Set SpaceSize = SpaceSize + "&FileSize&" where SpaceSize<>-1 and UserID="&Rs("BokeUserID")
				Execute("Update Dv_Boke_User Set SpaceSize = SpaceSize + "&FileSize&" where SpaceSize<>-1 and UserID="&Rs("BokeUserID"))
			End If
			'删除附件表记录
			Execute("Delete From Dv_Boke_Upfile Where ID = " & Rs("ID"))
		Rs.MoveNext
		Loop
		Rs.Close:Set Rs=Nothing
	End Sub
End Class

%>