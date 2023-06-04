<%
Function CheckText(str)
	Dim Chk
	Dim Re,TempStr
	Chk = False
	If Not IsNull(Str) Then
		If Instr(Str,"=")>0 or Instr(Str,"%")>0 or Instr(Str,"?")>0 or Instr(Str,"&")>0 or Instr(Str,";")>0 or Instr(Str,",")>0 or Instr(Str,"'")>0 or Instr(Str,",")>0 or Instr(Str,chr(34))>0 or Instr(Str,chr(9))>0 or Instr(Str,"$")>0 or Instr(Str,"|")>0 Then
			Chk = False
		Else
			Chk = True
		End If
		Set Re=New RegExp
			Re.IgnoreCase =True
			Re.Global=True
			Re.Pattern="(\s)"
			TempStr = Re.Replace(Str,"")
			TempStr = Replace(TempStr,chr(32),"")
			TempStr = Replace(TempStr,"","")
			TempStr = Replace(TempStr,"","")
			If TempStr = "" Then
				Chk = False
			End If
		Set Re=Nothing
	End If
	CheckText = Chk
End Function

Function CheckNotIsEn(Str)
	Dim Re
	CheckNotIsEn = True
	If IsNull(Str) Then Exit Function
	Set Re=New RegExp
		Re.IgnoreCase =True
		Re.Global=True
		Re.Pattern="[^A-Za-z0-9-_]"
		CheckNotIsEn = Re.Test(Str)
	Set Re=Nothing
End Function

Function Dv_FilterJS(v)
	If Not Isnull(V) Then
		Dim t
		Dim re
		Dim reContent
		Set re=new RegExp
		re.IgnoreCase =True
		re.Global=True
		re.Pattern="&#36;"
		t=re.Replace(v,"$")
		re.Pattern="&#39;"
		t=re.Replace(t,"'")
		re.Pattern="(function|meta|value|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie)"
		t=re.Replace(t,"")
		re.Pattern="(on(finish|mouse|Exit=|error|click|key|load|focus|Blur))"
		t=re.Replace(t,"")
		're.Pattern="(&#([0-9][0-9]*))"
		't=re.Replace(t,"")
		Dv_FilterJS=t
		Set Re=Nothing
	End If
End Function

Function Dv_FilterJS_T(v)
	If Not Isnull(V) Then
		Dim t
		Dim re
		Dim reContent
		Set re=new RegExp
		re.IgnoreCase =True
		re.Global=True
		re.Pattern="&#36;"
		t=re.Replace(v,"$")
		re.Pattern="&#39;"
		t=re.Replace(t,"'")
		re.Pattern = "(\r\n|\n)"
		t = re.Replace(t,"<br/>")
		re.Pattern="(<s+cript(.[^>]*)>)"
		t = re.Replace(t,"&lt;&#83cript$2&gt;")
		re.Pattern="(<\/s+cript>)"
		t = re.Replace(t,"&lt;/&#83cript&gt;")
		re.Pattern="<\/p>\x0a+<p>" 
		t = re.Replace(t,"<p></p>")
		re.Pattern="([^\x0d])\x0a"
		t = re.Replace(t,"$1<br>")
		re.Pattern="\x0d\x0a([^\x0d]*)" 
		t = re.Replace(t,"<p>$1</p>")
		re.Pattern="(<body(.[^>]*)>)"
		t = re.Replace(t,"<body>")
		re.Pattern="(<\!(.[^>]*)>)"
		t = re.Replace(t,"&lt;$2&gt;")
		re.Pattern="(<\!)"
		t = re.Replace(t,"&lt;!")
		re.Pattern="(-->)"
		t = re.Replace(t,"--&gt;")
		re.Pattern="(javascript:)"
		t = re.Replace(t,"<i>javascript</i>:")
		re.Pattern="<((asp|\!|%))"
		t = re.Replace(t,"&lt;$1")
		t = Replace(t, "	", "&nbsp;")
		t = Replace(t, "  ", "&nbsp;&nbsp;")
		re.Pattern="<(\w+)(&nbsp;)+([^>]*)>"
		t = re.Replace(t,"<$1 $3>")
		re.Pattern="(function|meta|value|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|alert)"
		t=re.Replace(t,"<i>$1</i>")
		re.Pattern="(on(finish|mouse|Exit=|error|click|key|load|focus|Blur))"
		t=re.Replace(t,"<i>on$2</i>")
		're.Pattern="(&#([0-9][0-9]*))"
		't=re.Replace(t,"<i>&#$2</i>")
		Dv_FilterJS_T=t
		Set Re=Nothing
	End If
End Function

Rem Check for valid syntax in an email address.
Function IsValidEmail(email)
	Dim names, name, i, c
	IsValidEmail = True
	names = Split(email, "@")
	If UBound(names) <> 1 Then
	   IsValidEmail = False
	   Exit Function
	End If
	For Each name In names
	   If Len(name) <= 0 Then
		 IsValidEmail = False
		 Exit Function
	   End If
	   For i = 1 To Len(name)
		 c = Lcase(Mid(name, i, 1))
		 If InStr("abcdefghijklmnopqrstuvwxyz_-.", c) <= 0 and not IsNumeric(c) Then
		   IsValidEmail = False
		   Exit Function
		 End If
	   Next
	   If Left(name, 1) = "." or Right(name, 1) = "." Then
		  IsValidEmail = False
		  Exit Function
	   End If
	Next
	If InStr(names(1), ".") <= 0 Then
	   IsValidEmail = False
	   Exit Function
	End If
	i = Len(names(1)) - InStrRev(names(1), ".")
	If i <> 2 and i <> 3 Then
	   IsValidEmail = False
	   Exit Function
	End If
	If InStr(email, "..") > 0 Then
	   IsValidEmail = False
	End If
End Function

Function StrLength(str)
	ON ERROR RESUME NEXT
	Dim WINNT_CHINESE
	WINNT_CHINESE    = (len("论坛")=2)
	If WINNT_CHINESE Then
		Dim l,t,c
		Dim i
		l=len(str)
		t=l
		For i=1 To l
			c=asc(mid(str,i,1))
			If c<0 Then c=c+65536
			If c>255 Then
				t=t+1
			End If
		Next
		strLength=t
	Else 
		strLength=len(str)
	End If
	If err.number<>0 Then err.clear
End Function

Function CutStr(str,strlen)
	Dim l,t,c,i
	l=len(str)
	t=0
	For i=1 To l
		c=Abs(Asc(Mid(str,i,1)))
		If c>255 Then
			t=t+2
		Else
			t=t+1
		End If
		If t>=strlen Then
			cutStr=left(str,i)&"..."
			Exit for
		Else
			cutStr=str
		End If
	Next
	CutStr=replace(cutStr,chr(10),"")
End Function


Function SplitLines(Content,ContentNums) '切割内容
	Dim i
	Dim Str,SplitCode
	If IsNull(Content) or Not IsNumeric(ContentNums) Then Exit Function
	Str = Content
	SplitCode = Split(Str,"<br/>",ContentNums+1)
	If Ubound(SplitCode)>=Cint(ContentNums) Then
		Str=Replace(Str,SplitCode(ContentNums),"")
	End If
	If Len(Str) > 500 Then
		Str = Left(Str,500)
	End If
	SplitLines = Str
End Function

Function CheckAlipay()
	Dim seller,subject,price,transport,mail,express,demo,ww,qq,message,api_key
	seller = Request.Form("alipay_seller")
	subject = Request.Form("alipay_subject")
	message = Request.Form("body")
	price = Request.Form("alipay_price")
	transport = Request.Form("ialipay_transport")
	mail = Request.Form("alipay_mail")
	express = Request.Form("alipay_express")
	demo = Request.Form("alipay_demo")
	ww = Request.Form("alipay_ww")
	qq = Request.Form("alipay_qq")
	'api_key = Request.Form("alipay_key")
	If seller = "@" Or seller = "" Or subject = "" Or (Not IsNumeric(price)) Or message = "" Then
		CheckAlipay = ""
		Exit Function
	End If
	CheckAlipay = "[payto]"
	CheckAlipay = CheckAlipay & "(seller)"&seller&"(/seller)"
	CheckAlipay = CheckAlipay & "(subject)"&subject&"(/subject)"
	CheckAlipay = CheckAlipay & "(body)"&message&"(/body)"
	CheckAlipay = CheckAlipay & "(price)"&price&"(/price)"
	CheckAlipay = CheckAlipay & "(transport)"&transport&"(/transport)"
	If mail <> "" And IsNumeric(mail) Then CheckAlipay = CheckAlipay & "(ordinary_fee)"&mail&"(/ordinary_fee)"
	If express <> "" And IsNumeric(express) Then CheckAlipay = CheckAlipay & "(express_fee)"&express&"(/express_fee)"
	If demo <> "" And Not Lcase(demo) = "http://" Then CheckAlipay = CheckAlipay & "(demo)"&demo&"(/demo)"
	If ww <> "" Then CheckAlipay = CheckAlipay & "(ww)"&ww&"(/ww)"
	If qq <> "" Then CheckAlipay = CheckAlipay & "(qq)"&qq&"(/qq)"
	'If api_key<>"" Then  CheckAlipay = CheckAlipay & "(key)"&api_key&"(/key)"
	CheckAlipay = CheckAlipay & "[/payto]"
	CheckAlipay = Dvbbs.CheckStr(CheckAlipay)
End Function

%>
<script language=vbscript runat=server>
Class DvBoke_UbbCode
Public Re,XmlDoc

	Private Sub Class_Initialize()
		Set Re = new RegExp
		Re.IgnoreCase = True
		Re.Global = True
	End Sub
	Private Sub class_terminate()
		Set Re = Nothing
	End Sub
	'编辑格式化数据
	Public Function FormatPostCode(StrData)
		Dim Str
		Str = StrData
		If IsNull(Str) or Str="" Then
			Exit Function
		End If
		Dim Nodes,ChildNode
		Set Nodes = DvBoke.BokeCat.selectNodes("xml/bokekeyword/rs:data/z:row")
		If Not (Nodes Is Nothing) Then
			Dim Target,Link2
			For Each ChildNode in Nodes
				If ChildNode.getAttribute("newwindows")=1 Then
					Target = "target=""_blank"""
				Else
					Target = ""
				End If
				Link2 = "<a href="""&ChildNode.getAttribute("linkurl")&""" title="""&ChildNode.getAttribute("linktitle")&""" class=""bokekeyword""  "&Target&">"&ChildNode.getAttribute("nkeyword")&"</a>"
				Str = Replace(Str,Link2,ChildNode.getAttribute("keyword"))
			Next
		End If
		FormatPostCode = Str
	End Function
	'提交格式化数据
	Public Function FormatCode(StrData)
		Dim Str
		Str = StrData
		If IsNull(Str) or Str="" Then
			Exit Function
		End If
		Dim Nodes,ChildNode
		Set Nodes = DvBoke.BokeCat.selectNodes("xml/bokekeyword/rs:data/z:row")
		If Not (Nodes Is Nothing) Then
			Dim Target,Link2
			For Each ChildNode in Nodes
				If ChildNode.getAttribute("newwindows")=1 Then
					Target = "target=""_blank"""
				Else
					Target = ""
				End If
				Link2 = "<a href="""&ChildNode.getAttribute("linkurl")&""" title="""&ChildNode.getAttribute("linktitle")&""" class=""bokekeyword""  "&Target&">"&ChildNode.getAttribute("nkeyword")&"</a>"
				Str = Replace(Str,ChildNode.getAttribute("keyword"),Link2)
			Next
		End If
		Re.Pattern = "<(\w*) class\s*=\s*([^>|\s]*)([^>]*)>"
		Str = re.Replace(Str,"<$1$3>")
		Re.Pattern = "<(\w*) style\s*=\s*([^>|\s]*)([^>]*)>"
		Str = re.Replace(Str,"<$1$3>")
		Re.Pattern = "<(\w[^>|\s]*)([^>]*)(on(finish|mouse|Exit|error|click|key|load|change|focus|blur))(.[^>]*)>"
		Str = re.Replace(Str,"<$1$2>")
		Re.Pattern = "<(\w[^>|\s]*)([^>]*)(&#|window\.|javascript:|js:|about:|file:|Document\.|vbs:|cookie| name| id)(.[^>]*)>"
		Str = re.Replace(Str,"<$1$2>")
		FormatCode = Str
	End Function
	'显示标记转换
	Public Function UbbCode(StrData)
		Dim FormatData
		Dim MainNode
		Dim Str,LacseStr
		Str = StrData
		If IsNull(Str) or Str="" Then
			Exit Function
		Else
			LacseStr = LCase(Str)
		End If

		'Set MainNode = XmlDoc.createNode(1,"XhtmlData","")
		'If Not XmlDoc.Load(FormatData) Then
			'DvBoke.ShowCode("您所提交的数据内容不符合标准，正文内容请使用合法的标记进行提交。")
			'DvBoke.ShowMsg(0)
			'Exit Function
		'End If
		'Response.Write XmlDoc.
		re.Pattern = "(\r\n|\n)"
		Str = re.Replace(Str,"<br/>")
		re.Pattern="(<s+cript(.[^>]*)>)"
		Str = re.Replace(Str,"&lt;&#83cript$2&gt;")
		re.Pattern="(<\/s+cript>)"
		Str = re.Replace(Str,"&lt;/&#83cript&gt;")
		re.Pattern="<\/p>\x0a+<p>" 
		Str = re.Replace(Str,"<p></p>")
		re.Pattern="([^\x0d])\x0a"
		Str = re.Replace(Str,"$1<br>")
		re.Pattern="\x0d\x0a([^\x0d]*)" 
		Str = re.Replace(Str,"<p>$1</p>")
		re.Pattern="(<body(.[^>]*)>)"
		Str = re.Replace(Str,"<body>")
		re.Pattern="(<\!(.[^>]*)>)"
		Str = re.Replace(Str,"&lt;$2&gt;")
		re.Pattern="(<\!)"
		Str = re.Replace(Str,"&lt;!")
		re.Pattern="(-->)"
		Str = re.Replace(Str,"--&gt;")
		re.Pattern="(javascript:)"
		Str = re.Replace(Str,"<i>javascript</i>:")
		re.Pattern="<((asp|\!|%))"
		Str = re.Replace(Str,"&lt;$1")
		Str = Replace(Str, "	", "&nbsp;")
		Str = Replace(Str, "  ", "&nbsp;&nbsp;")
		re.Pattern="<(\w+)(&nbsp;)+([^>]*)>"
		Str = re.Replace(Str,"<$1 $3>")

		If Dv_FilterJS(Str) Then
			re.Pattern = "(<br>)"
			Str = re.Replace(Str,vbNewLine)
			re.Pattern = "(<p>)"
			Str = re.Replace(Str,"")
			re.Pattern = "(<\/p>)"
			Str = re.Replace(Str,vbNewLine)
			Str = Server.HtmlEncode(Str)
			Str = "<u>以下内容为程序代码:</u><br/><div class=""htmlcode"">"&Str&"</div>"
			Str = Replace(Str, vbNewLine, "")
			Str = Replace(Str, CHR(10), "")
			Str = Replace(Str, CHR(13), "")
			UbbCode = Str
			Exit Function
		End If

		If InStr(LacseStr,"[/flash]")>0 Then
			Str = Dv_UbbCode_S2(Str,"\[FLASH\]","\[\/FLASH\]","FLASH","<a href=""$1"" TARGET=""_blank""><IMG SRC=""skins/default/filetype/swf.gif"" border=""0"" title=""点击开新窗口欣赏该FLASH动画!"" />[全屏欣赏]</a><br/><OBJECT codeBase=""http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0 classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"" width=""500"" height=""400""><PARAM NAME=""movie"" VALUE=""$1""><PARAM NAME=""quality"" VALUE=""high""><embed src=""$1"" quality=""high"" pluginspage=""http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"" type=""application/x-shockwave-flash"" width=""500"" height=""400"">$1</embed></OBJECT>","<IMG SRC=""skins/default/filetype/swf.gif"" border=""0""/><a href=""$1"" target=""_blank"">$1</a>（注意：Flash内容可能含有恶意代码）")

			Str = Dv_UbbCode_iS2(Str,"\[FLASH=(.[^\[]*)\]","\[\/FLASH\]","FLASH","<a href=""$3"" TARGET=""_blank""><IMG SRC=""skins/default/filetype/swf.gif"" border=""0"" title=""点击开新窗口欣赏该FLASH动画!""/>[全屏欣赏]</a><br/><OBJECT codeBase=""http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0"" classid=""clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"" width=""$1"" height=""$2""><PARAM NAME=""movie"" VALUE=""$3""><PARAM NAME=""quality"" VALUE=""high""><embed src=""$3"" quality=""high"" pluginspage=""http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"" type=""application/x-shockwave-flash"" width=""$1"" height=""$2"">$3</embed></OBJECT>","<a href=""$3"" target=""_blank"">$3</a>（注意：Flash内容可能含有恶意代码）","=*([0-9]*),*([0-9]*)")
		End If

		If InStr(LacseStr,"[/qt]")>0 Then
			Str=Dv_UbbCode_iS2(Str,"\[QT=(.[^\[]*)\]","\[\/QT\]","QT","<embed src=""$3"" width=""$1"" height=""$2"" autoplay=""true"" loop=""false"" controller=""true"" playeveryframe=""false"" cache=""false"" scale=""TOFIT"" bgcolor=""#000000"" kioskmode=""false"" targetcache=""false"" pluginspage=""http://www.apple.com/quicktime/""></embed>","<a href=""$3"" target=""_blank"">$3</a>","=*([0-9]*),*([0-9]*)")

		End If

		If InStr(LacseStr,"[/mp]")>0 Then
			Str = Dv_UbbCode_iS2(Str,"\[MP=(.[^\[]*)\]","\[\/MP\]","MP","<object align=""middle"" classid=""CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95"" class=""OBJECT"" id=""MediaPlayer"" width=""$1"" height=""$2""><PARAM NAME=""AUTOSTART"" VALUE=""$3""><param name=""ShowStatusBar"" value=""-1""><param name=""Filename"" value=""$4""><embed type=""application/x-oleobject"" codebase=""http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701"" flename=""mp"" src=""$4"" width=""$1"" height=""$2""></embed></object>","<a href=""$4"" target=""_blank"">$4</a>","=*([0-9]*),*([0-9]*),*([0|1|true|false]*)")
		End If

		If InStr(LacseStr,"[/rm]")>0 Then
			Str = Dv_UbbCode_iS2(Str,"\[RM=(.[^\[]*)\]","\[\/RM\]","RM","<OBJECT classid=""clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA"" class=""OBJECT"" id=""RAOCX"" width=""$1"" height=""$2""><PARAM NAME=""SRC"" VALUE=""$4""><PARAM NAME=""CONSOLE"" VALUE=""$4""><PARAM NAME=""CONTROLS"" VALUE=""imagewindow""><PARAM NAME=""AUTOSTART"" VALUE=""$3""></OBJECT><br/><OBJECT classid=""CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA"" height=""32"" id=""video"" width=""$1""><PARAM NAME=SRC VALUE=""$4""><PARAM NAME=AUTOSTART VALUE=$3><PARAM NAME=CONTROLS VALUE=controlpanel><PARAM NAME=""CONSOLE"" VALUE=""$4""></OBJECT>","<a href=""$4"" target=""_blank"">$4</a>","=*([0-9]*),*([0-9]*),*([0|1|true|false]*)")
		End If
		If Instr(LacseStr,"[/upload]") Then Str = Dv_UbbCode_U(Str)
		If Instr(LacseStr,"[/payto]") Then Str = Dv_Alipay_PayTo(Str)

		If InStr(LacseStr,"[/code]")>0 Then Str=Dv_UbbCode_S1(Str,"\[code\]","\[\/code\]","code","<u>以下内容为程序代码:</u><br/><div class=""htmlcode"">$1</div>")

		If DvBoke.System_Setting(11)="1" Then Str = bbimg(Str,500)
		UbbCode = Str
	End Function
	Private Function bbimg(strText,ssize)
		Dim s
		s=strText
		re.Pattern="<img(.[^>]*)>"
		If ssize=500 Then
			s=re.replace(s,"<img$1 onmousewheel=""return bbimg(this)"" onload=""javascript:if(this.width>screen.width-"&ssize&")this.style.width=screen.width-"&ssize&";""/>")
		Else
			s=re.replace(s,"<img$1 onmousewheel=""return bbimg(this)"" onload=""javascript:if(this.width>screen.width-"&ssize&")this.style.width=screen.width-"&ssize&";if(this.height>250)this.style.width=(this.width*250)/this.height;""/>")
		End If
		bbimg=s
	End Function
	Private Function Dv_UbbCode_S1(strText,uCodeL,uCodeR,uCodeC,tCode)
		Dim s
		s=strText
		re.Pattern=uCodeL
		s=re.replace(s, chr(1) & uCodeC & chr(2))
		re.Pattern=uCodeR
		s=re.replace(s, chr(1) & "/" & uCodeC & chr(2))
		re.Pattern="\x01"&uCodeC&"\x02\x01\/"&uCodeC&"\x02"
		s=re.Replace(s,"")
		re.Pattern="\x01"&uCodeC&"\x02(.[^\x01]*)\x01\/"&uCodeC&"\x02"
		s=re.Replace(s,tCode)
		re.Pattern="\x02"
		s=re.replace(s, "]")
		re.Pattern="\x01"
		s=re.replace(s, "[")
		Dv_UbbCode_S1=s
	End Function
	Private Function Dv_UbbCode_S2(strText,uCodeL,uCodeR,uCodeC,tCode1,tCode2)
		Dim s
		s=strText
		re.Pattern=uCodeL
		s=re.replace(s, chr(1) & uCodeC & chr(2))
		re.Pattern=uCodeR
		s=re.replace(s, chr(1) & "/" & uCodeC & chr(2))
		re.Pattern="\x01"&uCodeC&"\x02(.[^\x01]*)\x01\/"&uCodeC&"\x02"

		s=re.Replace(s,tCode1)
		re.Pattern="\x02"
		s=re.replace(s, "]")
		re.Pattern="\x01"
		s=re.replace(s, "[")
		Dv_UbbCode_S2=s
	End Function
	Private Function Dv_UbbCode_iS2(strText,uCodeL,uCodeR,uCodeC,tCode1,tCode2,iCode)
		Dim s
		s=strText
		re.Pattern=uCodeL
		s=re.replace(s, chr(1) & uCodeC & "=$1" & chr(2))
		re.Pattern=uCodeR
		s=re.replace(s, chr(1) & "/" & uCodeC & chr(2))
		If uCodeC="FLASH" Then
			re.Pattern="(.(swf|swi))"
			s=re.Replace(s,"")
		End If
		re.Pattern="\x01"&uCodeC&iCode&"\x02(.[^\x01]*)\x01\/"&uCodeC&"\x02"
		s=re.Replace(s,tCode1)
		re.Pattern="\x02"
		s=re.replace(s, "]")
		re.Pattern="\x01"
		s=re.replace(s, "[")
		Dv_UbbCode_iS2=s
	End Function
	Private Function Dv_UbbCode_U(strText)	'(帖子内容，用户组，是否开放图片标签)
		Dim s
		Dim FilePath
		FilePath = DvBoke.System_UpSetting(19)
		s=strText
		re.Pattern="\[UPLOAD=(gif|jpg|jpeg|bmp|png|swf|swi)\]"
		s=re.replace(s, chr(1) & "UPLOAD=$1" & chr(2))
		re.Pattern="\[\/UPLOAD\]"
		s=re.replace(s, chr(1) & "/UPLOAD" & chr(2))
		re.Pattern="\x01UPLOAD=(gif|jpg|jpeg|bmp|png)\x02\x01\/UPLOAD\x02"
		s=re.Replace(s,"")

		re.Pattern="\x01UPLOAD=(gif|jpg|jpeg|bmp|png)\x02(.[^\x01]*)\x01\/UPLOAD\x02"
		s= re.Replace(s,"<br/><IMG SRC=""skins/default/filetype/$1.gif"" border=""0 ""/><br/><A HREF="""&FilePath&"$2"" TARGET=""_blank""><IMG SRC="""&FilePath&"$2"" border=""0"" alt=""按此在新窗口浏览图片""/></A>")


		re.Pattern="\x01UPLOAD=(swf|swi)\x02(.[^\x01]*)\x01\/UPLOAD\x02"
		s= re.Replace(s,"<br><IMG SRC=""skins/default/filetype/swf.gif"" border=""0""/><A HREF="""&FilePath&"$2"" TARGET=_blank>点击浏览该FLASH文件</A>：<br/><embed src="""&FilePath&"$2"" quality=""high"" pluginspage=""http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"" type=""application/x-shockwave-flash"" width=""500"" height=""300""></embed>")

		re.Pattern="\x02"
		s=re.replace(s, "]")
		re.Pattern="\x01"
		s=re.replace(s, "[")
		re.Pattern="\[UPLOAD=(.[^\[]*)\]"
		s=re.replace(s, chr(1) & "UPLOAD=$1" & chr(2))
		re.Pattern="\[\/UPLOAD\]"
		s=re.replace(s, chr(1) & "/UPLOAD" & chr(2))
		re.Pattern="\x01UPLOAD=(.[^\x01]*)\x02\x01\/UPLOAD\x02"
		s=re.Replace(s,"")

		re.Pattern="\x01UPLOAD=(.[^\x01]*)\x02(BokeviewFile\.asp.[^\x01]*)\x01\/UPLOAD\x02"
		s= re.Replace(s,"<br><IMG SRC=""skins/default/filetype/$1.gif"" border=0> <a href=""$2"" target=_blank>点击浏览该文件</a>")
		re.Pattern="\x01UPLOAD=(.[^\x01]*)\x02(.[^\x01]*)\x01\/UPLOAD\x02"
		s= re.Replace(s,"<br/><IMG SRC=""skins/default/filetype/$1.gif"" border=""0""/><a href=""$2"" target=_blank>点击浏览该文件</a><br/><IMG src=""$2"" border=""0""/>")
		
		re.Pattern="\x02"
		s=re.replace(s, "]")
		re.Pattern="\x01"
		s=re.replace(s, "[")
		Dv_UbbCode_U=s
	End Function
	Public Function Dv_Alipay_PayTo(strText)
		If Not Isnull(strText) Then
			Dim s,ss
			Dim match,match2,urlStr,re2
			Dim t(2),temp,check,fee,i
			s=strText
			Set re2=new RegExp
			re2.IgnoreCase =True
			re2.Global=False
			t(0)="卖家承担运费"
			t(1)="买家承担运费"
			t(2)="虚拟物品不需邮递"
			s=strText
			re.Pattern="\[\/payto\]"
			s=re.replace(s, chr(1)&"/payto]")
			re.Pattern="\[payto\]([^\x01]+)\x01\/payto\]"
			Set match = re.Execute(s)
			re.Global=False
			For i=0 To match.count-1
				re2.Pattern="\(seller\)([^\n]+?)\(\/seller\)"
				If re2.Test(match.item(i)) Then
					Set match2 = re2.Execute(match.item(i))
					temp=re2.replace(match2.item(0),"$1")
					ss=""
					urlStr="http://pay.dvbbs.net/payto.asp?seller="&temp
					re2.Pattern="\(subject\)([^\n]+?)\(\/subject\)"
					If re2.Test(match.item(i)) Then
						Set match2 = re2.Execute(match.item(i))
						temp=re2.replace(match2.item(0),"$1")
						ss=ss&"<br><b>商品名称</b>："&temp&"<br><br>"
						urlStr=urlStr&"&subject="&temp
						re2.Pattern="\(body\)([^\n]*?)\(\/body\)"
						If re2.Test(match.item(i)) Then
							Set match2 = re2.Execute(match.item(i))
							temp=re2.replace(match2.item(0),"$1")
							ss=ss&"<b>商品说明</b>："&temp&"<br><br>"
							urlStr=urlStr&"&body="&temp
							re2.Pattern="\(price\)([\d\.]+?)\(\/price\)"
							If re2.Test(match.item(i)) Then
								Set match2 = re2.Execute(match.item(i))
								temp=re2.replace(match2.item(0),"$1")
								ss=ss&"<b>商品价格</b>："&temp&" 元<br><br>"
								urlStr=urlStr&"&price="&temp
								re2.Pattern="\(transport\)([1-3])\(\/transport\)"
								If re2.Test(match.item(i)) Then
									Set match2 = re2.Execute(match.item(i))
									temp=re2.replace(match2.item(0),"$1")
									check=True
									If int(temp)=2 Then
										re2.Pattern="\(express_fee\)([\d\.]+?)\(\/express_fee\)"
										If re2.Test(match.item(i)) Then
											Set match2 = re2.Execute(match.item(i))
											fee=re2.replace(match2.item(0),"$1")
											ss=ss&"<b>邮递信息</b>："&t(temp-1)&"，快递 "&fee&" 元<br><br>"
											urlStr=urlStr&"&transport="&temp&"&express_fee="&fee
										Else
											re2.Pattern="\(ordinary_fee\)([\d\.]+?)\(\/ordinary_fee\)"
											If re2.Test(match.item(i)) Then
												Set match2 = re2.Execute(match.item(i))
												fee=re2.replace(match2.item(0),"$1")
												ss=ss&"<b>邮递信息</b>："&t(temp-1)&"，平邮 "&fee&" 元<br><br>"
												urlStr=urlStr&"&transport="&temp&"&ordinary_fee="&fee
											Else
												check=False
											End If
										End If
									Else
										ss=ss&"<b>邮递信息</b>："&t(temp-1)&"<br><br>"
										urlStr=urlStr&"&transport="&temp
									End If
									If check=True Then
										check=False
										re2.Pattern="\(ww\)([^\n]+?)\(\/ww\)"
										If re2.Test(match.item(i)) Then
											Set match2 = re2.Execute(match.item(i))
											temp=re2.replace(match2.item(0),"$1")
											ss=ss&"<b>联系方法</b>：<a target=""_blank"" href=""http://amos1.taobao.com/msg.ww?v=2&amp;uid="&EncodeUtf8(temp)&"&amp;s=1""><img border=""0"" src=""http://amos1.taobao.com/online.ww?v=2&amp;uid="&EncodeUtf8(temp)&"&amp;s=1""/></a>"
											check=True
										End If
										re2.Pattern="\(qq\)(\d+?)\(\/qq\)"
										If re2.Test(match.item(i)) Then
											Set match2 = re2.Execute(match.item(i))
											temp=re2.replace(match2.item(0),"$1")
											If check=True Then
												ss=ss&"&nbsp;&nbsp;<a target=""_blank"" href=""http://wpa.qq.com/msgrd?V=1&Uin="&temp&"&Site=Dvbbs.Net&Menu=yes""><img border=""0"" SRC=""http://wpa.qq.com/pa?p=1:"&temp&":10"" alt=""联系我""></a><br><br>"
											Else
												ss=ss&"<b>联系方法</b>：<a target=""_blank"" href=""http://wpa.qq.com/msgrd?V=1&Uin="&temp&"&Site=Dvbbs.Net&Menu=yes""><img border=""0"" SRC=""http://wpa.qq.com/pa?p=1:"&temp&":10"" alt=""联系我""></a><br><br>"
											End If
										ElseIf check=True Then
											ss=ss&"<br><br>"
										End If
										re2.Pattern="\(demo\)([^\n]+?)\(\/demo\)"
										If re2.Test(match.item(i)) Then
											Set match2 = re2.Execute(match.item(i))
											temp=re2.replace(match2.item(0),"$1")
											ss=ss&"<b>演示地址</b>："&temp&"<br><br>"
											urlStr=urlStr&"&url="&temp
										End If
										ss=ss&"<a href="""&Server.HtmlEncode(urlStr&"&partner=2088002048522272&type=1&readonly=true")&""" target=""_blank""><img src=""images/alipay/alipay_7.gif"" border=0 alt=""通过支付宝交易，买卖都放心，免手续费、安全、快捷！""></a>&nbsp;&nbsp;<a href=""http://server.dvbbs.net/dvbbs/alipay/b.htm"" target=""_blank""><font color=""blue"">查看交易帮助，买卖放心</font></a><br>"
										s=re.replace(s,ss)
									End If
								End If
							End If
						End If
					End If
				End If
			Next
			Set match=Nothing
			Set re2=Nothing
			Set match2=Nothing
			re.Global=True
			re.Pattern="\x01\/payto\]"
			s=re.replace(s,"[/payto]")
			Dv_Alipay_PayTo=s
		End If
	End Function
	Public Function Dv_FilterJS(v)
		If Not Isnull(V) Then
			Dim t,test,Replacelist,t1
			t=v
			t1=v
			re.Pattern="&#36;"
			t1=re.Replace(t1,"$")
			re.Pattern="&#36"
			t1=re.Replace(t1,"$")
			re.Pattern="&#39;"
			t1=re.Replace(t1,"'")
			re.Pattern="&#39"
			t1=re.Replace(t1,"'")
			If InStr(Dvbbs.forum_setting(77),"|")=0 Then 
				Replacelist="(&#([0-9][0-9]*)|function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit=|error|click|key|load|focus|Blur))"
			Else
				Replacelist="("&Dvbbs.forum_setting(77)&"&#([0-9][0-9]*)|function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit|error|click|key|load|focus|Blur))"
			End If
			re.Pattern="<((.[^>]*"&Replacelist&"[^>]*)|"&Replacelist&")>"
			Test=re.Test(t1)
			If Test=False Then
				If InStr(Dvbbs.forum_setting(77),"|")=0 Then 
					'Replacelist="(&#([0-9][0-9]*)|function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit=|error|click|key|load|focus|Blur)|\[|\])"
					Replacelist="(&#([0-9][0-9]*)|function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit=|error|click|key|load|focus|Blur))"
				Else
					Replacelist="("&Dvbbs.forum_setting(77)&"&#([0-9][0-9]*)|function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit|error|click|key|load|focus|Blur))"
				End If
				re.Pattern="(\[(.[^\]]*)\])((.[^\]]*"&Replacelist&"[^\]]*)|"&Replacelist&")(\[\/(.[^\]]*)\])"
				Test=re.Test(t1)
			End If
			Dv_FilterJS=test
		End If
	End Function
End Class
</script>
<script type="text/javascript" runat="server" language=javascript>
 function EncodeUtf8(s1)
  {
      var s = escape(s1);
      var sa = s.split("%");
      var retV ="";
      if(sa[0] != "")
      {
         retV = sa[0];
      }
      for(var i = 1; i < sa.length; i ++)
      {
           if(sa[i].substring(0,1) == "u")
           {
               retV += Hex2Utf8(Str2Hex(sa[i].substring(1,5)));
               
           }
           else retV += "%" + sa[i];
      }
      
      return retV;
  }
  function Str2Hex(s)
  {
      var c = "";
      var n;
      var ss = "0123456789ABCDEF";
      var digS = "";
      for(var i = 0; i < s.length; i ++)
      {
         c = s.charAt(i);
         n = ss.indexOf(c);
         digS += Dec2Dig(eval(n));
           
      }
      //return value;
      return digS;
  }
  function Dec2Dig(n1)
  {
      var s = "";
      var n2 = 0;
      for(var i = 0; i < 4; i++)
      {
         n2 = Math.pow(2,3 - i);
         if(n1 >= n2)
         {
            s += '1';
            n1 = n1 - n2;
          }
         else
          s += '0';
          
      }
      return s;
      
  }
  function Dig2Dec(s)
  {
      var retV = 0;
      if(s.length == 4)
      {
          for(var i = 0; i < 4; i ++)
          {
              retV += eval(s.charAt(i)) * Math.pow(2, 3 - i);
          }
          return retV;
      }
      return -1;
  } 
  function Hex2Utf8(s)
  {
     var retS = "";
     var tempS = "";
     var ss = "";
     if(s.length == 16)
     {
         tempS = "1110" + s.substring(0, 4);
         tempS += "10" +  s.substring(4, 10); 
         tempS += "10" + s.substring(10,16); 
         var sss = "0123456789ABCDEF";
         for(var i = 0; i < 3; i ++)
         {
            retS += "%";
            ss = tempS.substring(i * 8, (eval(i)+1)*8);
            
            
            
            retS += sss.charAt(Dig2Dec(ss.substring(0,4)));
            retS += sss.charAt(Dig2Dec(ss.substring(4,8)));
         }
         return retS;
     }
     return "";
  } 
</script>