<%
'//=============================================
' 动网论坛模板解释通用函数
' 作者	HxyMan
' 更新	2008-1-14
' 标签   {$token.value} - 单标签 / {$token.begin} ... {$token.end} - 区域标签
' 解释	TPL_Scan 扫描模板，遇到标签即交给 TPL_Parse 处理
' 使用	1、页面头部包含此头文件。
'	2、页面中需要定义两个处理过程：TPL_ParseArea(sToken, sAreaContent) / TPL_ParseNode(sToken, sValue)
'//=============================================

Dim TPL_Memo, TPL_Immediate
TPL_Immediate	= True	'是否立即输出内容

Sub TPL_Echo(sStr)
	If TPL_Immediate Then
		Response.Write	sStr
	Else
		TPL_Memo	= TPL_Memo&sStr
	End If 
End Sub 

Sub TPL_Flush
	TPL_UrlReWrite
	Response.Write	TPL_Memo
	TPL_Memo	= ""
End Sub

Sub TPL_UrlReWrite
	TPL_Memo = Dvbbs.ArchiveHtml(TPL_Memo)
End Sub 

Sub TPL_Scan(sTemplate)
	Dim iPosLast, iPosCur
	iPosLast	= 1
	While True 
		iPosCur	= InStr(iPosLast, sTemplate, "{$")
		If iPosCur>0 Then
			TPL_Echo	Mid(sTemplate, iPosLast, iPosCur-iPosLast)
			iPosLast	= TPL_Parse(sTemplate, iPosCur+2)
		Else
			TPL_Echo	Mid(sTemplate, iPosLast)
			Exit Sub  
		End If 
	 Wend 
End Sub 

Function TPL_Parse(sTemplate, iPosBegin)
	Dim iPosCur, sToken, sValue, sTemp
	iPosCur		= InStr(iPosBegin, sTemplate, "}") 
	sTemp		= Mid(sTemplate,iPosBegin,iPosCur-iPosBegin)
	iPosBegin	= iPosCur+1
	iPosCur		= InStr(sTemp, ".")
	sToken		= Left(sTemp, iPosCur-1)
	sValue		= Mid(sTemp, iPosCur+1)
	Select Case sValue
		Case "begin"
			sTemp			= "{$" & ( sToken & ".end}" )
			iPosCur			= InStr(iPosBegin, sTemplate, sTemp)
			TPL_ParseArea	  sToken, Mid(sTemplate, iPosBegin, iPosCur-iPosBegin)
			iPosBegin		= iPosCur+Len(sTemp)
		Case Else
			Select Case sToken
				Case "pub"	 TPL_ParsePub sValue
				Case "label" TPL_ParseLabel sValue
				Case "urlrewrite" TPL_ParseRewrite sValue
				Case Else	 TPL_ParseNode sToken, sValue
			End Select 
	End Select 
	TPL_Parse	= iPosBegin
End Function 

'iCur-当前页 iRecords-总记录数 iPerPages-每页显示数 iLists-列出可点击的数目 sParam-传递参数，格式 xxx.asp?a=xxx&b=xxx&page= 
Sub TPL_ShowPage(iCur, iRecords, iPerPage, iLists, sParam)
	Dim iBegin, iEnd, iPages, i
	iPages	= (iRecords\iPerPage)
	If (iRecords Mod iPerPage)>0 Then iPages = iPages+1
	If 1>=iPages Then Exit Sub 
	iBegin	= iCur
	iEnd	= iCur
	i	= iLists
	Do While True 
		If iBegin>1 Then 
			iBegin	= iBegin-1
			i		= i-1  
		End If 
		If i>1 And iEnd<iPages Then
			iEnd	= iEnd+1
			i		= i-1
		End If 
		If (iBegin<=1 And iEnd>=iPages) Or i<=1 Then Exit Do     
	Loop  
	TPL_Echo "<b class=""page"">总数 "
	TPL_Echo iRecords & "</b>"
	If iBegin<>1 Then	TPL_Echo " <a class=""page"" href=""" & sParam & "1"">1.. </a>"
	If iCur<>1 Then		TPL_Echo " <a class=""page"" href=""" & sParam & (iCur-1) & """>上一页</a> "
	For i=iBegin To iEnd
		If i=iCur Then 
			TPL_Echo " <a class=""page"" href=""javascript:;"" id=""on"">" & i & "</a> "
		Else
			TPL_Echo " <a class=""page"" href=""" & sParam & i & """>" & i & "</a> "
		End If 
	Next 
	If iCur<>iPages Then	TPL_Echo " <a class=""page"" href=""" & sParam & (iCur+1) & """>下一页</a> "
	If iEnd<>iPages Then	TPL_Echo " <a class=""page"" href=""" & sParam & iPages & """>.." & iPages & "</a> "
	If iPages>1 Then	TPL_Echo " <b class=""page""><input type=""text"" title=""输入数字，回车跳转"" size=""3"" onkeydown=""if (13==event.keyCode) document.location.href='"&sParam&"'+this.value"" value="""&iCur&""" /></b> "
	
End Sub

Sub TPL_ParseRewrite(sToken)
	If 0=IsUrlreWrite Then Exit Sub 
	Select Case sToken
		Case "open"		
			TPL_Immediate=False
		Case "close"
			TPL_Flush
			TPL_Immediate=True 
	End Select 
End Sub 

Sub TPL_ParsePub(sToken)
	Select Case sToken
		Case "boardid"	    TPL_Echo Dvbbs.boardid
		Case "boardtype"	TPL_Echo Server.HtmlEnCode(Dvbbs.Replacehtml(Dvbbs.BoardType))
		Case "username"		TPL_Echo Dvbbs.MemberName
		Case "forum_picurl" TPL_Echo Dvbbs.Forum_PicUrl
		Case "querytimes"   TPL_Echo Dvbbs.SqlQueryNum
		Case "checkcode"	
			If CInt(Dvbbs.Board_Setting(4))>0 Then TPL_Echo "<b>验证码：</b><input type=""text"" name=""codestr"" style=""margin-top:6px;"" size=""4"" /> <img id=""pgetcode"" src="""&DvCodeFile&""" alt= ""验证码,看不清楚?请点击刷新验证码"" style=""margin-top:10px;cursor : pointer;"" onClick=""this.src='"&DvCodeFile&"?t='+Math.random()""/>"
		Case "editmode"
			If "0"=Dvbbs.Board_Setting(5) Then
				TPL_Echo "2"
			Else
				TPL_Echo Dvbbs.GroupSetting(67)
			End If
		Case "forum_type":response.Write Dvbbs.forum_info(0)
		Case "forum_maxonline"		: TPL_Echo Dvbbs.CacheData(5,0)
		Case "forum_maxonlinedate"	: TPL_Echo Dvbbs.CacheData(6,0)
		Case "forum_topicnum"		: TPL_Echo Dvbbs.CacheData(7,0)
		Case "forum_postnum"		: TPL_Echo Dvbbs.CacheData(8,0)
		Case "forum_todaynum"		: TPL_Echo Dvbbs.CacheData(9,0)
		Case "forum_usernum"		: TPL_Echo Dvbbs.CacheData(10,0)
		Case "forum_yesterdaynum"	: TPL_Echo Dvbbs.CacheData(11,0)
		Case "forum_maxpostnum"		: TPL_Echo Dvbbs.CacheData(12,0)
		Case "forum_maxpostdate"	: TPL_Echo Dvbbs.CacheData(13,0)
		Case "forum_lastuser"		: TPL_Echo Dvbbs.CacheData(14,0)
		Case "forum_homecall"
		    Dvbbs.CacheData(37,0)="<script type=""text/javascript"">var swf_width=300;var swf_height=250;var files='';var texts='';var links='';files+='|http://www.cndw.com/templets/images/03.jpg'; texts+='|动网论坛'; links+='|http://www.dvbbs.net/';files+='|http://www.cndw.com/templets/images/01.jpg'; texts+='|动网9年';links+='|http://www.cndw.com/';files+='|http://www.cndw.com/templets/images/02.jpg'; texts+='|商业大亨Online'; links+='|http://bto.uwan.com/';files=files.substr(1,files.length-1); texts=texts.substr(1,texts.length-1);links=links.substr(1,links.length-1);document.write('<object classid=""clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"" codebase=""http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"" width=""'+ swf_width +'"" height=""'+ swf_height +'"">');document.write('<param name=""movie"" value=""dv_plus/bcastr3/bcastr31.swf""><param name=""quality"" value=""high"">');document.write('<param name=""menu"" value=""false""><param name=wmode value=""opaque"">');document.write('<param name=""FlashVars"" value=""bcastr_file='+files+'&bcastr_link='+links+'&bcastr_title='+texts+'&TitleBgColor=6699FF"">');document.write('<embed src=""dv_plus/bcastr3/bcastr31.swf"" wmode=""opaque"" FlashVars=""bcastr_file='+files+'&bcastr_link='+links+'&bcastr_title='+texts+'&TitleBgColor=6699FF& menu=""false"" quality=""high"" width=""'+ swf_width +'"" height=""'+ swf_height +'"" type=""application/x-shockwave-flash"" pluginspage=""http://www.macromedia.com/go/getflashplayer"" />'); document.write('</object>'); </script>"
		    TPL_Echo Dvbbs.CacheData(37,0)
		Case "forum_online"			: TPL_Echo MyBoardOnline.Forum_Online
		Case "forum_useronline"		: TPL_Echo MyBoardOnline.Forum_UserOnline
		Case "forum_guestonline"	: TPL_Echo MyBoardOnline.Forum_GuestOnline
		Case "forum_createtime"		: TPL_Echo FormatDateTime(Dvbbs.Forum_Setting(74),1)		
	End Select 
End Sub 

Sub TPL_ParseLabel(sToken)
	Dim sAppID, sTemp, bReLoad, dLasttime, iIntv
	sAppID		= Dvbbs.CacheName&"_label_"&LCase(sToken)
	dLasttime	= Application(sAppID&"_last")
	iIntv		= Application(sAppID&"_intv")
	If ""<>iIntv And ""<>dLasttime And _
			DateDiff("s", CDate(dLasttime), Now()) <= CLng(iIntv) Then 
		bReLoad	= False 
	Else
		bReLoad	= True
	End If 
	If ""=Application(sAppID&"_buffer") Then bReLoad=True 
	If bReLoad Then
		On Error Resume Next 
		sTemp	= Dvbbs.ReadTextFile("Resource/Label/"&sToken&".tpl")
		If Err Then
			Err.Clear
			Response.Write "读取"&"Resource/Label/"&sToken&".tpl失败！"
			Response.End 
		End If 
		TPL_Label sAppID, sTemp
	End If 
	TPL_Scan Application(sAppID&"_buffer")
End Sub 

Sub TPL_UpdateCache(sAppID,iIntv,sBuff)
	Application.Lock
	Application(sAppID&"_last")=Now()
	Application(sAppID&"_intv")=iIntv
	Application(sAppID&"_buffer")=sBuff
	Application.UnLock
End Sub

Function TPL_TagTransf(s)
	TPL_TagTransf=Dvbbs.ChkBadWords(Replace(s,"{$", "{ $"))
End Function 

Sub TPL_Label(sAppID, sConfig)
	Dim aConfig, sTemp
	aConfig	=	Split(sConfig, "|||")
	sTemp	=	aConfig(0)
	Select Case sTemp
		Case "static"
			TPL_UpdateCache sAppID,aConfig(1),aConfig(2)
		Case "query"
			Select Case aConfig(2)
				Case "bbs"
					TPL_UpdateCache sAppID,aConfig(1),aConfig(4)&TPL_BBS(aConfig(3),aConfig(5),aConfig(8),aConfig(9))&aConfig(6)
				Case "file"
					TPL_UpdateCache sAppID,aConfig(1),aConfig(4)&TPL_File(aConfig(3),aConfig(5),aConfig(8),aConfig(9))&aConfig(6)
				Case "user"
					TPL_UpdateCache sAppID,aConfig(1),aConfig(4)&TPL_User(aConfig(3),aConfig(5),aConfig(9))&aConfig(6)
				Case "news"
					TPL_UpdateCache sAppID,aConfig(1),aConfig(4)&TPL_News(aConfig(3),aConfig(5),aConfig(9))&aConfig(6)
				Case "group"
					TPL_UpdateCache sAppID,aConfig(1),aConfig(4)&TPL_Group(aConfig(3),aConfig(5),aConfig(9))&aConfig(6)
			End Select 
		Case "rss"
			TPL_Rss sAppID, aConfig(1), aConfig(2), aConfig(3)
		Case Else 
	End Select 
End Sub 

Function TPL_BBS(sQuery, sTplLoop, iTopiclen, sTimeFmt)
	Dim Rs,SQL,i,Topic,Topiclen,sLoop,sResult,iTopicType
	Dim Expression,LastInfo,LastPostName,LastPostTime
	Set Rs=Dvbbs.Execute(sQuery)
	If Not Rs.eof Then
		SQL=Rs.GetRows(-1)
	Else
		TPL_BBS="<li>暂未有贴子信息</li>"
		Exit Function 
	End If 
	Rs.close:Set Rs=Nothing 
	Topiclen=iTopiclen
	If Not Isnumeric(Topiclen) Or Topiclen = "" Then
		Topiclen = 20
	Else
		Topiclen = Cint(Topiclen)
	End If
	If InStr(LCase(sQuery),"dv_bbs")>0 Then
		iTopicType=3
	ElseIf InStr(LCase(sQuery),"dv_best") Then 
		iTopicType=2 
	Else
		iTopicType=1
	End If 
	Dim BoardNode,Nodes,TempObj
	Set TempObj = Application(Dvbbs.CacheName&"_boardlist").cloneNode(True)
	Set BoardNode = TempObj.documentElement.getElementsByTagName("board") 
	For i=0 To Ubound(SQL,2)
		sLoop=sTplLoop
		Expression = ""
		LastPostName = ""
		LastPostTime = ""
		Topic = SQL(1,i)
		If Topic = "" And 2=iTopicType then
			Topic = SQL(6,i)
		End If
		Topic=TPL_FormatTopic(Topic)
		If Dvbbs.strLength(Topic)>Topiclen then
			Topic = Dvbbs.strCut(TPL_FormatTopic(Topic),Topiclen)
		End If
		Expression = SQL(7,i)
		If Instr(SQL(7,i)&"","|") Then
			Expression = Split(SQL(7,i),"|")(1)
		End If
		If 1=iTopicType Then
			If SQL(8,i)<>"" then
				LastInfo=split(SQL(8,i),"$")
				LastPostName = LastInfo(0)
				LastPostTime = LastInfo(2)
			End If
		End If
		If Instr(sLoop,"{$BoardName}") Then
			For Each Nodes in BoardNode
				If Nodes.getAttribute("boardid") = CStr(SQL(3,i)) Then
						sLoop = Replace(sLoop,"{$BoardName}",Nodes.getAttribute("boardtype"))
						sLoop = Replace(sLoop,"{$BoardInfo}",Nodes.getAttribute("readme")&"")
					Exit For
				End If
			Next
		End If
		sLoop = Replace(sLoop,"{$ID}",SQL(2,i))
		sLoop = Replace(sLoop,"{$ReplyID}",SQL(5,i))
		sLoop = Replace(sLoop,"{$Boardid}",SQL(3,i))
		sLoop = Replace(sLoop,"{$ID}",SQL(2,i))
		sLoop = Replace(sLoop,"{$Topic}",TPL_TagTransf(Topic))
		sLoop = Replace(sLoop,"{$Face}",TPL_TagTransf(Expression))
		sLoop = Replace(sLoop,"{$ReplyName}",TPL_TagTransf(LastPostName))
		sLoop = Replace(sLoop,"{$ReplyTime}",TPL_FormatTime(LastPostTime,sTimeFmt))
		sLoop = Replace(sLoop,"{$UserName}",TPL_TagTransf(SQL(0,i)))
		sLoop = Replace(sLoop,"{$PostTime}",TPL_FormatTime(SQL(4,i),sTimeFmt))
		sResult = sResult & sLoop
	Next
	Set BoardNode = Nothing 
	Set TempObj = Nothing 
	TPL_BBS=sResult
End Function  

Function TPL_Group(sQuery, sTplLoop, sTimeFmt)
	Dim SQL,Rs,i,sLoop,sResult
	If Not IsObject(Dv_IndivGroup_Conn) Then Dv_IndivGroup_ConnectionDatabase
	SET Rs = Dv_IndivGroup_Conn.Execute(sQuery)
	If Not Rs.eof Then
		SQL=Rs.GetRows(-1)
	Else
		TPL_Group="<li>暂未有圈子数据！</li>"
		Exit Function
	End If
	Rs.close:Set Rs = Nothing
	For i=0 To Ubound(SQL,2)
		sLoop = sTplLoop
		sLoop = Replace(sLoop,"{$ID}",Dvbbs.CheckNumeric(SQL(0,i)))
		sLoop = Replace(sLoop,"{$GroupName}",TPL_TagTransf(TPL_FormatTopic(SQL(1,i))))
		sLoop = Replace(sLoop,"{$GroupInfo}",TPL_TagTransf(TPL_FormatTopic(SQL(2,i))))
		sLoop = Replace(sLoop,"{$AppUserID}",Dvbbs.CheckNumeric(SQL(3,i)))
		sLoop = Replace(sLoop,"{$AppUserName}",TPL_TagTransf(SQL(4,i)))
		sLoop = Replace(sLoop,"{$UserNum}",Dvbbs.CheckNumeric(SQL(5,i)))
		sLoop = Replace(sLoop,"{$Stats}",TPL_IGStatsStr(SQL(6,i)))
		sLoop = Replace(sLoop,"{$PostNum}",Dvbbs.CheckNumeric(SQL(7,i)))
		sLoop = Replace(sLoop,"{$TopicNum}",Dvbbs.CheckNumeric(SQL(8,i)))
		sLoop = Replace(sLoop,"{$TodayNum}",Dvbbs.CheckNumeric(SQL(9,i)))
		sLoop = Replace(sLoop,"{$YesterdayNum}",Dvbbs.CheckNumeric(SQL(10,i)))
		sLoop = Replace(sLoop,"{$LimitUser}",TPL_TagTransf(Dvbbs.CheckNumeric(SQL(11,i))))
		sLoop = Replace(sLoop,"{$PassDate}",TPL_FormatTime(SQL(12,i)&"",sTimeFmt))
		sLoop = Replace(sLoop,"{$GroupLogo}",TPL_TagTransf(""&SQL(13,i)))
		sResult = sResult & sLoop
	Next
	TPL_Group=sResult
End Function  

Function TPL_User(sQuery, sTplLoop, sTimeFmt)
	Dim SQL,Rs,i,sLoop,sResult
	SET Rs = Dvbbs.Execute(sQuery)
	If Not Rs.eof Then
		SQL=Rs.GetRows(-1)
	Else
		TPL_User="<LI>暂未有会员数据！</LI>"
		Exit Function
	End If
	Rs.close:Set Rs = Nothing
	For i=0 To Ubound(SQL,2)
		sLoop = sTplLoop
		sLoop = Replace(sLoop,"{$UserID}",SQL(0,i))
		sLoop = Replace(sLoop,"{$UserName}",TPL_TagTransf(TPL_FormatTopic(SQL(1,i))))
		sLoop = Replace(sLoop,"{$UserTopic}",SQL(2,i))
		sLoop = Replace(sLoop,"{$UserPost}",SQL(3,i))
		sLoop = Replace(sLoop,"{$UserBest}",SQL(4,i))
		sLoop = Replace(sLoop,"{$UserWealth}",SQL(5,i))
		sLoop = Replace(sLoop,"{$UserCP}",SQL(6,i))
		sLoop = Replace(sLoop,"{$UserEP}",SQL(7,i))
		sLoop = Replace(sLoop,"{$UserDel}",SQL(8,i))
		sLoop = Replace(sLoop,"{$UserSex}",SQL(9,i))
		sLoop = Replace(sLoop,"{$JoinDate}",TPL_FormatTime(SQL(10,i),sTimeFmt))
		sLoop = Replace(sLoop,"{$UserLogins}",SQL(11,i))
		sResult = sResult & sLoop
	Next
	TPL_User=sResult
End Function

Function TPL_News(sQuery, sTplLoop, sTimeFmt)
	Dim SQL,Rs,i,sLoop,sResult
	SET Rs = Dvbbs.Execute(sQuery)
	If Not Rs.eof Then
		SQL=Rs.GetRows(-1)
	Else
		TPL_News="<li>暂未有公告数据！</li>"
		Exit Function
	End If
	Rs.close:Set Rs = Nothing
	Dim Topic
	Dim BoardNode,Nodes,TempObj
	Set TempObj = Application(Dvbbs.CacheName&"_boardlist").cloneNode(True)
	Set BoardNode = TempObj.documentElement.getElementsByTagName("board") 
	For i=0 To Ubound(SQL,2)
		Topic=SQL(2,i)
		Topic=TPL_FormatTopic(Topic)
		sLoop = sTplLoop
		If Instr(sLoop,"{$BoardName}") Then
			If Cstr(SQL(1,i)) >"0" Then
				For Each Nodes in BoardNode
					If Nodes.getAttribute("boardid") = Cstr(SQL(1,i)) Then
							sLoop = Replace(sLoop,"{$BoardName}",TPL_TagTransf(Nodes.getAttribute("boardtype")))
						Exit For
					End If
				Next
			Else
				sLoop = Replace(sLoop,"{$BoardName}","")
			End If
		End If
		sLoop = Replace(sLoop,"{$ID}",SQL(0,i))
		sLoop = Replace(sLoop,"{$Boardid}",SQL(1,i))
		sLoop = Replace(sLoop,"{$Topic}",Topic)
		sLoop = Replace(sLoop,"{$UserName}",TPL_TagTransf(SQL(3,i)))
		sLoop = Replace(sLoop,"{$PostTime}",TPL_FormatTime(SQL(4,i),sTimeFmt))
		sResult = sResult & sLoop
	Next
	Set BoardNode=Nothing 
	Set TempObj=Nothing 
	TPL_News=sResult
End Function

Function TPL_File(sQuery, sTplLoop, iTopiclen, sTimeFmt)
	Dim SQL,Rs,i,sLoop,sResult
	Set Rs = Dvbbs.Execute(sQuery)
	If Not Rs.eof Then
		SQL=Rs.GetRows(-1)
	Else
		TPL_File="document.write('<li>暂未有新展区文件！</li>');"
		Exit Function
	End If
	Rs.close:Set Rs = Nothing
	Dim Topic,Topiclen
	Topic=SQL(1,i)
	Topiclen=iTopiclen
	If Not Isnumeric(Topiclen) Or Topiclen = "" Then
		Topiclen = 20
	Else
		Topiclen = Cint(Topiclen)
	End If
	'F_ID,F_AnnounceID,F_BoardID,F_Username,F_Filename,F_Readme,F_Type,F_FileType,F_AddTime,F_Viewname,F_ViewNum,F_DownNum,F_FileSize 
	'F_Typ : 1=图片集,2=FLASH集,3=音乐集,4=电影集,0=文件集
	Dim FileArray,Filename,Picheight,Picwidth
	Dim RootID,ReplyID,F_AnnounceID
	Dim BoardNode,Nodes,TempObj
	Dim Bbsurl
	Bbsurl=Dvbbs.Get_ScriptNameUrl
	FileArray = "文件集||图片集||FLASH集||音乐集||电影集"
	FileArray = Split(FileArray,"||")
	Set TempObj = Application(Dvbbs.CacheName&"_boardlist").cloneNode(True)
	Set BoardNode = TempObj.documentElement.getElementsByTagName("board") 
	For i=0 To Ubound(SQL,2)
		Topic = SQL(5,i)
		Topic = TPL_FormatTopic(Topic)
		If Dvbbs.strLength(Topic)>Topiclen then
			Topic=Dvbbs.strCut(TPL_FormatTopic(Topic),Topiclen)
		End If
		sLoop = sTplLoop
		sLoop = Replace(sLoop,"{$ID}",SQL(0,i))
		sLoop = Replace(sLoop,"{$Boardid}",SQL(2,i))
		sLoop = Replace(sLoop,"{$UserName}",TPL_TagTransf(SQL(3,i)))
		sLoop = Replace(sLoop,"{$Readme}",TPL_TagTransf(Topic&""))
		sLoop = Replace(sLoop,"{$AddTime}",TPL_FormatTime(SQL(8,i),sTimeFmt))
		sLoop = Replace(sLoop,"{$ViewFilename}",TPL_TagTransf(SQL(9,i)&""))
		sLoop = Replace(sLoop,"{$ViewNum}",SQL(10,i))
		sLoop = Replace(sLoop,"{$DownNum}",SQL(11,i))
		sLoop = Replace(sLoop,"{$FileSize}",SQL(12,i))
		sLoop = Replace(sLoop,"{$FileType}",FileArray(SQL(6,i)))
		If Instr(SQL(1,i)&"","|") Then
			F_AnnounceID=Split(SQL(1,i),"|")
			RootID = F_AnnounceID(0)
			ReplyID = F_AnnounceID(1)
		Else
			RootID = ""
			ReplyID = ""
		End If
		sLoop = Replace(sLoop,"{$ReplyID}",ReplyID)
		sLoop = Replace(sLoop,"{$RootID}",RootID)
		If Instr(sLoop,"{$BoardName}") Then
			If Cstr(SQL(1,i)) >"0" Then
				For Each Nodes in BoardNode
					If Nodes.getAttribute("boardid") = Cstr(SQL(2,i)) Then
							sLoop = Replace(sLoop,"{$BoardName}",TPL_TagTransf(Nodes.getAttribute("boardtype")))
						Exit For
					End If
				Next
			Else
				sLoop = Replace(sLoop,"{$BoardName}","")
			End If
		End If
		'If SQL(9,i)<>"" Then
		'	Filename = Bbsurl & SQL(9,i)
		'Else
			Filename = SQL(4,i)
			If InStr(Filename,":") = 0 Or InStr(Filename,"//") = 0 Then
				Filename = Bbsurl & Dvbbs.Forum_Setting(76) & Filename
			End If
		'End If
		sLoop = Replace(sLoop,"{$Filename}",TPL_TagTransf(Filename))
		sResult = sResult & sLoop
	Next
	Set BoardNode=Nothing 
	Set TempObj=Nothing 
	TPL_File=sResult
End Function 

Function TPL_FormatTopic(str)
	'Dim re
	'Set re=new RegExp
	're.IgnoreCase =True
	're.Global=True
	're.Pattern="<(.[^>]*)>"
	'str=re.replace(str, "")
	're.Pattern="\[(.[^\[]*)\]"
	'str=re.replace(str, "")
	If str="" Then str="..."
	TPL_FormatTopic=Server.HtmlEnCode(Dvbbs.Replacehtml(str))
End Function

Function TPL_FormatTime(Strings,val)
	If IsDate(Strings) and val<>"" Then
		Strings = FormatdateTime(Strings,val)
	End If
	TPL_FormatTime = Strings
End Function

Function TPL_IGStatsStr(Stats)
	Select Case Stats
		Case 1
			TPL_IGStatsStr="正常"
		Case 2
			TPL_IGStatsStr="锁定"
		Case 3
			TPL_IGStatsStr="关闭"
		Case 0
			TPL_IGStatsStr="审核"
		Case Else
			TPL_IGStatsStr="未知"
	End Select
End Function

'需要用到公有对象dvstream
Function TPL_BytesToBstr(body)
    dvstream.Type = 1
    dvstream.Mode =3
    dvstream.Open
    dvstream.Write body
    dvstream.Position = 0
    dvstream.Type = 2
    dvstream.Charset = "GB2312"  
    TPL_BytesToBstr = dvstream.ReadText 
	dvstream.Close
End Function

'处理RSS调用，比较费时，可以考虑把数据读取放到一个单独iframe或者ajax页面。
Sub TPL_Rss(sAppID, iIntv, sXmlUrl, sXslt)
	Dim oXmlHttp,oXmlDom,oXSLTemplate,oXMLStyle,oProc
	On Error Resume Next 
	Set oXmlHttp = Dvbbs.iCreateObject("Microsoft.XmlHttp")
	Set oXMLStyle=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
	Set oXSLTemplate=Dvbbs.iCreateObject("Msxml2.XSLTemplate" & MsxmlVersion )
	Set oXmlDom = Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
	If Not oXMLStyle.LoadXML(sXslt) Then Exit Sub 
	oXmlHttp.Open "get",sXmlUrl,False 
	oXmlHttp.setRequestHeader "charset", "gb2312"
	oXmlHttp.SetRequestHeader "content-type", "text/xml"
	oXmlHttp.send()
	If Not oXmlDom.LoadXml(TPL_BytesToBstr(oXmlHttp.responseBody)) Then Exit Sub 
	oXSLTemplate.stylesheet=oXMLStyle
	Set oProc = oXSLTemplate.createProcessor()
	oProc.input = oXmlDom
	oProc.transform()
	If Err Then 
		Err.Clear
		TPL_UpdateCache sAppID,iIntv,""
	Else 
		TPL_UpdateCache sAppID,iIntv,oProc.output
	End If 
	Set oXmlHttp		= Nothing 
	Set oXMLStyle	= Nothing 
	Set oXSLTemplate = Nothing 
End Sub 
%>