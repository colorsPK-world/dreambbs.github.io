<%
'����޸�2007.4.24
'����޸�2008.3.6 �����ļ�������Ϣ��ʾ
Dim ServerHttp :ServerHttp = Dvbbs.Get_ScriptNameUrl
Dim UserPointInfo(4)
Dim FileInfo
FileInfo = 1	'�Ƿ���ʾ�����ļ��������Ϣ������ʾ������Ϊ0 by �ꡤ���� 2008.3.6 ��л������.NET hxyman
If CInt(Request.Form("ajaxPost")) Then
	FileInfo = 0
End If
Const NOScript=1        Rem �Ƿ����ű����˹���
Const NOWrongHTML=0     Rem �Ƿ������˴���HTML��ǹ���
Const MaxLoopcount=100	Rem UBB���뿱��ѭ������������������ѭ������˱���
Const Issupport=1		Rem ���ַ�����vbscript���ܲ�֧��SubMatches���ϣ������� Issupport=0
Const Maxsize=4			Rem ǩ���������ֵ
Const can_Post_Style="1,2,3"	Rem can_Post_Style�ǲ�����styleʹ�õ��û�����б�������Ը����Լ���Ҫ�޸�
Dim Mtinfo
Mtinfo="<fieldset style=""border : 1px dotted #ccc;text-align : left;line-height:22px;text-indent:10px""><legend><b>ý���ļ���Ϣ</b></legend><div>�ļ���Դ��$4</div>"&_
"<div>�����Ե���ؼ��ϵĲ��Ű�ť���߲��š�ע�⣬���Ŵ�ý���ļ�����һЩ���ա�</div>"&_
"<div>����˵����������̳ϵͳ��ֹ�˸��ļ����Զ����Ź��ܡ�</div>"&_
"<div>���ڸ��û�û�з����Զ����Ŷ�ý���ļ���Ȩ�޻��߸ð��汻���óɲ�֧�ֶ�ý�岥�š�</div></fieldset>"
Const DV_UBB_TITLE=" title=""dvubb"" "
Const UBB_TITLE="dvubb"

%>
<script language=vbscript runat=server>
Dim Ubblists
'[/img]���:1.[/upload]���:2.[/dir]���:3.[/qt]���:4.[/mp]���:5.
'[/rm]���:6.[/sound]���:7.[/flash]���:8.[/money]���:9.[/point]���:10.
'[/usercp]���:11.[/power]���:12.[/post]���:13.[/replyview]���:14.[/usemoney]���:15.
'[/url]���:16.[/email]���:17.http���:18.https���:19.ftp���:20.rtsp���:21.
'mms���:22.[/html]���:23.[/code]���:24.[/color]���:25.[/face]���:26.[/align]���:27.
'[/quote]���:28.[/fly]���:29.[/move]���:30.[/shadow]���:31.[/glow]���:32.[/size]���:33.
'[/i]���:34.[/b]���:35.[/u]���:36.[em���:37.www.���:38.[/payto]���:40.[/username]���:41.[/center]���:42.

Class Dvbbs_UbbCode
	Public Re,reed,isgetreed,Board_Setting,WapPushUrl,xml,isxhtml,pageReload
	Public UpFileInfoScript,UpFileCount'UpFileInfoScript����������ʾ�ļ������Ϣ�Ľű���UpFileCount������������ҳ�����ļ������� 2008.3.6
	Public ismanager1
	Public Property Let PostType(ByVal vNewvalue)
		If PostType=2 Then
			Board_Setting=Split("1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1",",")
			Board_Setting(6)=1
			Board_Setting(5)=0:Board_Setting(7)=1
			Board_Setting(8)=1:Board_Setting(9)=1
			Board_Setting(10)=0:Board_Setting(11)=0
			Board_Setting(12)=0:Board_Setting(13)=0
			Board_Setting(14)=0:Board_Setting(15)=0
			Board_Setting(23)=0:Board_Setting(44)=0
		Else
			If Dvbbs.BoardID >0 Then
				Board_Setting=Dvbbs.Board_Setting
			Else
				Board_Setting=Split("1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1",",")
				Board_Setting(6)=1
				Rem �����Ҫ���� ֧�� URL �Զ�ʶ��  �޸� Board_Setting(5)=1
				Board_Setting(5)=0:Board_Setting(7)=1
				Board_Setting(8)=1:Board_Setting(9)=1
				Board_Setting(10)=0:Board_Setting(11)=0
				Board_Setting(12)=0:Board_Setting(13)=0
				Board_Setting(14)=0:Board_Setting(15)=0
				Board_Setting(23)=0:Board_Setting(44)=0
			End If
		End If
	End Property
	Private Sub Class_Initialize()
		Set re=new RegExp
		re.IgnoreCase =true
		re.Global=true
		Set xml=Dvbbs.iCreateObject("msxml2.DOMDocument"& MsxmlVersion)
		If Dvbbs.UserID=0 Then
			UserPointInfo(0)=0:UserPointInfo(1)=0:UserPointInfo(2)=0:UserPointInfo(3)=0:UserPointInfo(4)=0
		Else
			UserPointInfo(0)=CCur(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userwealth").text)
			UserPointInfo(1)=CCur(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userep").text)
			UserPointInfo(2)=CCur(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@usercp").text)
			UserPointInfo(3)=CCur(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userpower").text)
			UserPointInfo(4)=CCur(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userpost").text)
		End If
	End Sub
	Private Sub class_terminate()
		Set xml=Nothing
		Set Re=Nothing
	End Sub
	Function istext(Str)
			Dim text,text1
			text=Str
			text1=Str
		 If text1=Dvbbs.Replacehtml(text) Then
		 	istext=True
		 End If
	End Function
	Function TextFormat(Str)
		Dim tmp,i
		Str=replace(Str,Chr(13)& Chr(10),Chr(13))
		Str=replace(Str,Chr(10),Chr(13))
		TMP=Split(Str,Chr(13))
		Str=""
		For i=0 to UBound(tmp)
			If i=UBound(tmp) Then
				Str=Str & tmp(i)
			Else
				Str=Str & tmp(i) &"<br />"
			End If
		Next
		TextFormat=Str
	End Function
	Rem ������DHTML����
	Public Function Dv_UbbCode_DHTML(s,PostUserGroup,PostType,sType)
		Dim matches,match,CodeStr
        If InStr(Ubblists,",39,")>0 And (InStr(Ubblists,",table,")>0 Or InStr(Ubblists,",td,")>0 Or InStr(Ubblists,",th,")>0 Or InStr(Ubblists,",tr,")>0 ) And NOWrongHTML = 1 Then
                s = server.htmlencode(s)
                s="<form name=""scode"&replyid_a&""" method=""post"" action=""""><table class=""tableborder2"" cellspacing=""1"" cellpadding=""3"" width=""100%"" align=""center"" border=""0""><tr><th height=""22"">�������ݺ�������</th></tr><tr><td class=""tablebody1"" align=""middle"" width=""98%""><textarea id=""CodeText"" style=""BORDER-RIGHT: 1px dotted; BORDER-TOP: 1px dotted; OVERFLOW-Y: visible; OVERFLOW: visible; BORDER-LEFT: 1px dotted; WIDth: 98%; COLOR: #000000; BORDER-BOTTOM: 1px dotted"" rows=""20"" cols=""120"">"&s&"</textarea></td></tr><tr><td class=""tablebody2"" align=""middle"" width=""98%""></td></tr></table></form>"
                Dv_UbbCode_DHTML=s
                Exit Function
        Else
            If Board_Setting(5)="0" Then
                    re.Pattern ="<(\/?(i|b|p))>"
                    s=re.Replace(s,Chr(1)&"$1"&Chr(2))
                    re.Pattern="(>)("&vbNewLine&"){1,2}(<)"
                    s=re.Replace(s,"$1$3")
                    re.Pattern="(<div class=""quote"">)((.|\n)*?)(<\/div>)"
                    Do While re.Test(s)
                        s=re.Replace(s,"[quote]$2[/quote]")
                    Loop
                    re.Pattern = "(<\/tr>)"
                    s = re.Replace(s,"[br]")
                    re.Pattern = "(<br/>)"
                    s = re.Replace(s,"[br]")
                    re.Pattern = "(<br>)"
                    s = re.Replace(s,"[br]")
                    re.Pattern = "<(\/?s(ub|up|trike))>"
                    s = re.Replace(s,"[$1]")
                    re.Pattern = "(<)(\/?font[^>]*)(>)"
                    s = re.Replace(s,CHR(1)&"$2"&CHR(2))
                    re.Pattern="<([^<>]*?)>"
                    Do while re.Test(s)
                        s=re.Replace(s,"")
                    Loop
                    re.Pattern = "(\x01)(\/?font[^\x02]*)(\x02)"
                    s = re.Replace(s,"<$2>")
                    re.Pattern = "\[(\/?s(ub|up|trike))\]"
                    s = re.Replace(s,"<$1>")
                    re.Pattern="(\[quote\])((.|\n)*?)(\[\/quote\])"
                    Do While re.Test(s)
                        s=re.Replace(s,"<div class=""quote"">$2</div>")
                    Loop
                    re.Pattern="\x01(\/?(i|b|p))\x02"
                    s=re.Replace(s,"<$1>")
                    re.Pattern = "(\[br\])"
                    s = re.Replace(s,"<br/>")
                End If
                re.Pattern="<((asp|\!|%))"
                s=re.Replace(s,"&lt;$1")
        End If
        Dv_UbbCode_DHTML=s
	End Function
	'��̳���ݲ���UBBCODE����ڣ����ݡ��û���ID��ģʽ(1=����/2=���桢���ŵ�)��ģʽ2(0=�°�/1=�ϰ�)
	Public Function Dv_UbbCode(s,PostUserGroup,PostType,sType)
		Dim mt,i,tmp
		If FileInfo Then
			Rem ��ֹ��ǩ���ֱ�ռ��,���Ҫǿ���滻��ȥ��IF,2008.3.6.
			re.Pattern = "\<scr"&"ipt[\s\S]*\<\/scri"&"pt\>"
			s = re.Replace(s,"")
			s = Replace(s,"UpFileSize","UpFileSize.")
			s = Replace(s,"LoadTime","LoadTime.")
		End If

		'If Not xml.loadxml("<div>" & replace(s,"&","&amp;") &"</div>") Then
            'If NOScript = 1 Then
                'If Dv_FilterJS(s) Then
                    're.Pattern = "(&nbsp;)"
                    's = re.Replace(s,Chr(9))
                    're.Pattern = "(<br/>)"
                    's = re.Replace(s,vbNewLine)
                    're.Pattern = "(<br>)"
                    's = re.Replace(s,vbNewLine)
                    're.Pattern = "(<p>)"
                    's = re.Replace(s,"")
                    're.Pattern = "(<\/p>)"
                    's = re.Replace(s,vbNewLine)
                    's=server.htmlencode(s)
                    's="<form name=""scode"&replyid_a&""" method=""post"" action=""""><table class=""tableborder2"" cellspacing=""1"" cellpadding=""3"" width=""100%"" align=""center"" border=""0""><tr><th height=""22"">�������ݺ��ű�,����ܵ���ҳ�治�����Ĵ���</th></tr><tr><td class=""tablebody1"" align=""middle"" width=""98%""><textarea id=""CodeText"" style=""BORDER-RIGHT: 1px dotted; BORDER-TOP: 1px dotted; OVERFLOW-Y: visible; OVERFLOW: visible; BORDER-LEFT: 1px dotted; WIDth: 98%; COLOR: #000000; BORDER-BOTTOM: 1px dotted"" rows=""20"" cols=""120"">"&s&"</textarea></td></tr><tr><td class=""tablebody2"" align=""middle"" width=""98%""><b>˵����</b>������ʾ���Ǵ������ݡ��������ȼ�������û���⣬���޸�֮��������.</td></tr><tr><td class=""tablebody1"" align=""middle"" width=""98%""><input type=""button"" name=""run"" value=""���д���"" onclick=""Dvbbs_ViewCode("&replyid_a&");""></td></tr></table></form>"
                    'Dv_UbbCode=s
                    'Exit Function
                'End If
            'End If
		'End If
		mt=canusemt(PostUserGroup)
		re.Pattern = "(\[br\])"
		s = re.Replace(s,"<br />")
		'Ubbת��
		'[img]ͼƬ��ǩ
		If InStr(Ubblists,",1,")>0 Or sType=1 Then
				s=Dv_UbbCode_iS2(s,"img",_
				"<a href=""$1"" target=""_blank"" ><img "& DV_UBB_TITLE &" src=""$1"" border=""0"" /></a>",_
				"<img  "& DV_UBB_TITLE &" src=""skins/default/filetype/gif.gif"" border=""0"" alt="" /><a  href=""$1"" target=""_blank"" >$1</a>",_
				PostUserGroup,Cint(Board_Setting(7)),_
				"")
		End If
		'upload code
		If InStr(Ubblists,",2,")>0 Or sType=1 Then
			s=Dv_UbbCode_U(s,PostUserGroup,Cint(Board_Setting(7)))
		End If
		'media code
		If InStr(Ubblists,",3,")>0 Or sType=1 Then
			s=Dv_UbbCode_iS2(s,"DIR",_
			"<object "& DV_UBB_TITLE &" classid=""clsid:166B1BCA-3F9C-11CF-8075-444553540000"" "&_
			"codebase=""http://download.macromedia.com/pub/shockwave/cabs/director/sw.cab#version=7,0,2,0"" "&_
			"width=""$1"" height=""$2""><param name=""src"" value=""$3"" /><embed "& DV_UBB_TITLE &" src=""$3"""&_
			" pluginspage=""http://www.macromedia.com/shockwave/download/"" width=""$1"" height=""$2""></embed></object>",_
			"<a href=""$3"" target=""_blank"">$3</a>",_
			PostUserGroup,Cint(Board_Setting(9) * mt),_
			"=*([0-9]*),*([0-9]*)")
		End If
		'qt
		If InStr(Ubblists,",4,")>0 Or sType=1 Then
			s=Dv_UbbCode_iS2(s,"QT",_
			"<embed "& DV_UBB_TITLE &" src=""$3"" width=""$1"" height=""$2"" autoplay=""true"" loop=""false"" controller=""true"" playeveryframe=""false"" cache=""false"" scale=""TOFIT"" bgcolor=""#000000"" kioskmode=""false"" targetcache=""false"" pluginspage=""http://www.apple.com/quicktime/"" />",_
			"<embed "& DV_UBB_TITLE &" src=""$3"" width=""$1"" height=""$2"" autoplay=""false"" loop=""false"" controller=""true"" playeveryframe=""false"" cache=""false"" scale=""TOFIT"" bgcolor=""#000000"" kioskmode=""false"" targetcache=""false"" pluginspage=""http://www.apple.com/quicktime/"" />"&_
			 replace(Mtinfo,"$4","$3"),_
			PostUserGroup,Cint(Board_Setting(9) * mt),_
			"=*([0-9]*),*([0-9]*)")
		End If
		'mp
		If InStr(Ubblists,",5,")>0 Or sType=1 Then
			s=Dv_UbbCode_iS2(s,"mp",_
			"<object "& DV_UBB_TITLE &" align=""middle"" classid=""CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95"" class=""object"" id=""MediaPlayer"" width=""$1"" height=""$2"" >"&_
			"<param name=""ShowStatusBar"" value=""-1"" /><param name=""Filename"" value=""$3"" />"&_
			"<embed "& DV_UBB_TITLE &" type=""application/x-oleobject"" "&_
			"codebase=""http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701"" flename=""mp"" src=""$3"" width=""$1"" height=""$2""></embed></object>",_
			"<object "& DV_UBB_TITLE &" align=""middle"" classid=""CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95"" class=""object"" id=""MediaPlayer"" width=""$1"" height=""$2"" >"&_
			"<param name=""ShowStatusBar"" value=""-1"" /><param name=""Filename"" value=""$3"" /><param name=""AUTOSTART"" value=""false"" />"&_
			"<embed "& DV_UBB_TITLE &" type=""application/x-oleobject"" "&_
			"codebase=""http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701"" flename=""mp"" src=""$3"" width=""$1"" height=""$2""></embed></object>"&_
			replace(Mtinfo,"$4","$3"),_
			PostUserGroup,Cint(Board_Setting(9) * mt),"=*([0-9]*),*([0-9]*)")
			'Dv7 MediaPlayer�Զ��岥��ģʽ��
			s=Dv_UbbCode_iS2(s,"mp",_
			"<object "& DV_UBB_TITLE &" align=""middle"" classid=""CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95"" class=""object"" id=""MediaPlayer"" width=""$1"" height=""$2"" >"&_
			"<param name=""AUTOSTART"" value=""$3"" /><param name=""ShowStatusBar"" value=""-1"" /><param name=""Filename"" value=""$4"" />"&_
			"<embed "& DV_UBB_TITLE &" type=""application/x-oleobject"" codebase=""http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701"" flename=""mp"" src=""$4"" width=""$1"" height=""$2""></embed></object>",_
			"<object "& DV_UBB_TITLE &" align=""middle"" classid=""CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95"" class=""object"" id=""MediaPlayer"" width=""$1"" height=""$2"" >"&_
			"<param name=""AUTOSTART"" value=""false"" /><param name=""ShowStatusBar"" value=""-1"" /><param name=""Filename"" value=""$4"" />"&_
			"<embed "& DV_UBB_TITLE &" type=""application/x-oleobject"" codebase=""http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701"" flename=""mp"" src=""$4"" width=""$1"" height=""$2""></embed></object>"&_
			 Mtinfo,PostUserGroup,Cint(Board_Setting(9) * mt),"=*([0-9]*),*([0-9]*),*([0|1|true|false]*)")
		End If
		'rm
		If InStr(Ubblists,",6,")>0 Or sType=1 Then
			s=Dv_UbbCode_iS2(s,"rm",_
			"<div><object "& DV_UBB_TITLE &" classid=""clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA"" class=""object"" id=""RAOCX"" width=""$1"" height=""$2"">"&_
			"<param name=""src"" value=""$3"" />"&_
			"<param name=""CONSOLE"" value=""Clip1"" />"&_
			"<param name=""CONtrOLS"" value=""imagewindow"" />"&_
			"<param name=""AUTOSTART"" value=""true"" /></object></div>"&_
			"<div><object "& DV_UBB_TITLE &" classid=""CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA"" height=""32"" id=""video2"" width=""$1"">"&_
			"<param name=""src"" value=""$3"" /><param name=""AUTOSTART"" value=""-1"" />"&_
			"<param name=""CONtrOLS"" value=""controlpanel"" />"&_
			"<param name=""CONSOLE"" value=""Clip1"" /></object></div>",_
			"<div><object "& DV_UBB_TITLE &" classid=""clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA"" class=""object"" id=""RAOCX"" width=""$1"" height=""$2"">"&_
			"<param name=""src"" value=""$3"" />"&_
			"<param name=""CONSOLE"" value=""Clip1"" />"&_
			"<param name=""CONtrOLS"" value=""imagewindow"" />"&_
			"<param name=""AUTOSTART"" value=""false"" /></object></div>"&_
			"<div><object "& DV_UBB_TITLE &" classid=""CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA"" height=""32"" id=""video2"" width=""$1"">"&_
			"<param name=""src"" value=""$3"" /><param name=""AUTOSTART"" value=""false"" />"&_
			"<param name=""CONtrOLS"" value=""controlpanel"" />"&_
			"<param name=""CONSOLE"" value=""Clip1"" /></object></div>"& replace(Mtinfo,"$4","$3"),_
			PostUserGroup,Cint(Board_Setting(9) * mt),"=*([0-9]*),*([0-9]*)")
			'Dv7 RealPlayer�Զ��岥��ģʽ��
			s=Dv_UbbCode_iS2(s,"rm",_
			"<div><object "& DV_UBB_TITLE &" classid=""clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA"" class=""object"" id=""RAOCX"" width=""$1"" height=""$2"">"&_
			"<param name=""src"" value=""$4"" /><param name=""CONSOLE"" value=""$4"" /><param name=""CONtrOLS"" value=""imagewindow"" />"&_
			"<param name=""AUTOSTART"" value=""$3"" /></object></div>"&_
			"<div><object "& DV_UBB_TITLE &" classid=""CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA"" height=""32"" id=""video"" width=""$1"">"&_
			"<param name=""src"" value=""$4"" />"&_
			"<param name=""AUTOSTART"" value=""$3"" />"&_
			"<param name=""CONtrOLS"" value=""controlpanel"" /><param name=""CONSOLE"" value=""$4"" /></object></div>",_
			"<div><object "& DV_UBB_TITLE &" classid=""clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA"" class=""object"" id=""RAOCX"" width=""$1"" height=""$2"">"&_
			"<param name=""src"" value=""$4"" /><param name=""CONSOLE"" value=""$4"" /><param name=""CONtrOLS"" value=""imagewindow"" />"&_
			"<param name=""AUTOSTART"" value=""false"" /></object></div>"&_
			"<div><object "& DV_UBB_TITLE &" classid=""CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA"" height=""32"" id=""video"" width=""$1"">"&_
			"<param name=""src"" value=""$4"" />"&_
			"<param name=""AUTOSTART"" value=""false"" />"&_
			"<param name=""CONtrOLS"" value=""controlpanel"" /><param name=""CONSOLE"" value=""$4"" /></object></div>"&_
			Mtinfo,PostUserGroup,Cint(Board_Setting(9) * mt),"=*([0-9]*),*([0-9]*),*([0|1|true|false]*)")
		End If
		'��������
		If InStr(Ubblists,",7,")>0 Or sType=1 Then
			s=Dv_UbbCode_iS2(s,"sound",_
			"<a href=""$1"" target=""_blank""><img "& DV_UBB_TITLE &" src=""skins/default/filetype/mid.gif"" border=""0"" alt=""��������"" /></a><bgsound src=""$1"" loop=""-1"" />",_
			"<a href=""$1"" target=""_blank"">$1</a>"& replace(Mtinfo,"$4","$1"),_
			PostUserGroup,Cint(Board_Setting(9) * mt),"")
		End If
		'flash code
		If InStr(Ubblists,",8,")>0 Or sType=1 Then
			s=Dv_UbbCode_iS2(s,"flash",_
			"<a href=""$1"" target=""_blank""><img "& DV_UBB_TITLE &" src=""skins/default/filetype/swf.gif"" border=""0"" alt=""������´������͸�FLASH����!"" height=""16"" width=""16"" />[ȫ������]</a><br/>"&_
			"<object "& DV_UBB_TITLE &" codebase=""http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0"" classid=""clsid:D27CDB6E-AE6D-11cf-96B8-444553540000""  width=""500"" height=""400"">"&_
			"<param name=""movie"" value=""$1"" /><PARAM NAME=""AllowScriptAccess"" VALUE=""never""><param name=""quality"" value=""high"" />"&_
			"<embed "& DV_UBB_TITLE &" src=""$1"" quality=""high"" pluginspage=""http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"" type=""application/x-shockwave-flash"" width=""500"" height=""400"">$1</embed></object>",_
			"<img "& DV_UBB_TITLE &" src=""skins/default/filetype/swf.gif"" border=""0""> <a href=$1 target=""_blank"">$1</a>"& replace(Mtinfo,"$4","$1"),_
			PostUserGroup,Cint(Board_Setting(44)),"")

			s=Dv_UbbCode_iS2(s,"flash",_
			"<a href=""$3"" target=""_blank""><img "& DV_UBB_TITLE &" src=""skins/default/filetype/swf.gif"" border=""0"" alt=""������´������͸�FLASH����!"" height=""16"" width=""16"" />[ȫ������]</a><br/>"&_
			"<object "& DV_UBB_TITLE &" codebase=""http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0"" classid=""clsid:D27CDB6E-AE6D-11cf-96B8-444553540000""  width=""$1"" height=""$2"">"&_
			"<param name=""movie"" value=""$3"" /><PARAM NAME=""AllowScriptAccess"" VALUE=""never""><param name=""quality"" value=""high"" />"&_
			"<embed "& DV_UBB_TITLE &" src=""$3"" quality=""high"" pluginspage=""http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"" type=""application/x-shockwave-flash"" width=""$1"" height=""$2"">$3</embed></object>",_
			"<a href=""$3"" target=""_blank"">$3</a>",PostUserGroup,Cint(Board_Setting(44)),"=*([0-9]*),*([0-9]*),*(?:true|false)*")
		End If

		'point view
		If InStr(Ubblists,",9,")>0 Or sType=1 Then
			s=Dv_UbbCode_Get(s,PostUserGroup,PostType,"money",_
			"<hr/><font color=""gray"">����������Ҫ��Ǯ���ﵽ<b>$1</b>�ſ������</font><br />$2<hr/>",_
			"<span class=""info""><font color="""&Dvbbs.Mainsetting(1)&""">����������Ҫ��Ǯ���ﵽ<b>$1</b>�ſ������</font></span>",_
			UserPointInfo(0),Cint(Board_Setting(10)))
		End If
		If InStr(Ubblists,",10,")>0 Or sType=1 Then
			s=Dv_UbbCode_Get(s,PostUserGroup,PostType,"point",_
			"<hr/><font color=""gray"">����������Ҫ���ִﵽ<b>$1</b>�ſ������</font><br/>$2<hr/>",_
			"<span class=""info""><font color="""&Dvbbs.Mainsetting(1)&""">����������Ҫ���ִﵽ<b>$1</b>�ſ������</font></span>",_
			UserPointInfo(1),Cint(Board_Setting(11)))
		End If
		If InStr(Ubblists,",11,")>0 Or sType=1 Then
			s=Dv_UbbCode_Get(s,PostUserGroup,PostType,_
			"UserCP","<hr/><font color=""gray"">����������Ҫ�����ﵽ<b>$1</b>�ſ������</font><br/>$2<hr/>",_
			"<span class=""info""><font color="""&Dvbbs.Mainsetting(1)&""">����������Ҫ�����ﵽ<b>$1</b>�ſ������</font></span>",_
			UserPointInfo(2),Cint(Board_Setting(12)))
		End If
		If InStr(Ubblists,",12,")>0 Or sType=1 Then
			s=Dv_UbbCode_Get(s,PostUserGroup,PostType,_
			"Power","<hr /><font color=""gray"">����������Ҫ�����ﵽ<b>$1</b>�ſ������</font><br/>$2<hr/>",_
			"<span class=""info""><font color="""&Dvbbs.Mainsetting(1)&""">����������Ҫ�����ﵽ<b>$1</b>�ſ������</font></span>",_
			UserPointInfo(3),Cint(Board_Setting(13)))
		End If
		If InStr(Ubblists,",13,")>0 Or sType=1 Then
			s=Dv_UbbCode_Get(s,PostUserGroup,PostType,"Post",_
			"<hr /><font color=""gray"">����������Ҫ�������ﵽ<b>$1</b>�ſ������</font><br/>$2<hr />",_
			"<span class=""info""><font color="""&Dvbbs.Mainsetting(1)&""">����������Ҫ�������ﵽ<b>$1</b>�ſ������</font></span>",_
			UserPointInfo(4),Cint(Board_Setting(14)))
		End If
		If InStr(Ubblists,",14,")>0 Or sType=1 Then
			s=UBB_REPLYVIEW(s,PostUserGroup,PostType)
		End If
		If InStr(Ubblists,",15,")>0 Or sType=1 Then
			s=UBB_USEMONEY(s,PostUserGroup,PostType)
		End If
		'url code
		If InStr(Ubblists,",16,")>0 Or sType=1 Then
			s=Dv_UbbCode_S1(s,"url","<a href=""$1"" target=""_blank"">$1</a>")
			s=Dv_UbbCode_UF(s,"url","<a href=""$1"" target=""_blank"">$2</a>","0")
		End If
		'email code
		If InStr(Ubblists,",17,")>0 Or sType=1 Then
			s=Dv_UbbCode_S1(s,"email","<img "& DV_UBB_TITLE &" align=""absmiddle"" src=""skins/default/email1.gif"" alt=""""/><a href=""mailto:$1"">$1</a>")
			s=Dv_UbbCode_UF(s,"email","<img "& DV_UBB_TITLE &" align=""absmiddle"" src=""skins/default/email1.gif"" alt=""""/><a href=""mailto:$1"" target=""_blank"">$2</a>","0")
		End If
		If InStr(Ubblists,",37,")>0 Or sType=1 Then
			If (Cint(Board_Setting(8)) = 1 Or PostUserGroup<4) And InStr(Lcase(s),"[em")>0 Then
				re.Pattern="\[em([0-9]+)\]"
				s=re.Replace(s,"<img "& DV_UBB_TITLE &" src="""&EmotPath&"em$1.gif"" border=""0"" align=""middle"" alt="""" />")
			End If
		End If
		If InStr(Ubblists,",23,")>0 Or sType=1 Then
			s=Dv_UbbCode_C(s,"html")
		End If
		If InStr(Ubblists,",24,")>0 Or sType=1 Then
			s=Dv_UbbCode_S1(s,"code","<div class=""htmlcode""><b>��������Ϊ�������:</b><br/>$1</div>")
		End If
		If InStr(Ubblists,",25,")>0 Or sType=1 Then
			s=Dv_UbbCode_UF(s,"color","<font color=""$1"">$2</font>","1")
		End If
		If InStr(Ubblists,",26,")>0 Or sType=1 Then
			s=Dv_UbbCode_UF(s,"face","<font face=""$1"">$2</font>","1")
		End If
		If InStr(Ubblists,",27,")>0 Or sType=1 Then
			s=Dv_UbbCode_Align(s)
		End If
		If InStr(Ubblists,",42,")>0 Or sType=1 Then
			s=Dv_UbbCode_S1(s,"center","<div align=""center"">$1</div>")
		End If
		If InStr(Ubblists,",28,")>0 Or sType=1 Then
			s=Dv_UbbCode_Q(s)
		End If
		If InStr(Ubblists,",29,")>0 Or sType=1 Then
			s=Dv_UbbCode_S1(s,"fly","<marquee width=""90%"" behavior=""alternate"" scrollamount=""3"">$1</marquee>")
		End If
		If InStr(Ubblists,",30,")>0 Or sType=1 Then
			s=Dv_UbbCode_S1(s,"move","<marquee scrollamount=""3"">$1</marquee>")
		End If
		If InStr(Ubblists,",31,")>0 Or sType=1 Then
			s=Dv_UbbCode_iS1(s,"shadow","<div style=""width:$1px;filter:shadow(color=$2, strength=$3)"">$4</div>")
		End If
		If InStr(Ubblists,",32,")>0 Or sType=1 Then
			s=Dv_UbbCode_iS1(s,"glow","<div style=""width:$1px;filter:glow(color=$2, strength=$3)"">$4</div>")
		End If
		If InStr(Ubblists,",33,")>0 Or sType=1 Then
			s=Dv_UbbCode_UF(s,"size","<font size=""$1"">$2</font>","1")
		End If
		If InStr(Ubblists,",34,")>0 Or sType=1 Then
			s=Dv_UbbCode_S1(s,"i","<i>$1</i>")
		End If
		If InStr(Ubblists,",35,")>0 Or sType=1 Then
			s=Dv_UbbCode_S1(s,"b","<b>$1</b>")
		End If
		If InStr(Ubblists,",36,")>0 Or sType=1 Then
			s=Dv_UbbCode_S1(s,"u","<u>$1</u>")
		End If
		If InStr(Ubblists,",41,")>0 Or sType=1 Then
			s= Dv_UbbCode_name(s)
		End If
		'���û�и��¹��������ݣ�����Ա��ʧЧ�ģ���������ע��ȥ������������������ݸ��£���������� 2005.10.10 By Winder.F
		'If InStr(Lcase(s),"[username")>0 Then s= Dv_UbbCode_name(s)

		If InStr(s,"payto:") = 0 Then
			s = Replace(s,"https://www.alipay.com/payt","https://www.alipay.com/payto:")
		End If
		If InStr(Ubblists,",40,")>0 Then
			s=Dv_Alipay_PayTo(s)
		End If

		If xml.loadxml("<div>" & replace(s,"&","&amp;") &"</div>") Then
			isxhtml=True
			'checkimg�Ѿ�д��checkXHTML
			'���ӹ���Ա�Ƿ�������iframe��ǩ by ţͷ
			s=checkXHTML(mt,PostUserGroup,ismanager1)
		Else
			Rem ������DHTML����
			isxhtml=False
			s=Dv_UbbCode_DHTML(s,PostUserGroup,PostType,sType)
			s=bbimg(s)
		End If

		If FileInfo Then
			s = s & UpFileInfoScript   '�������ļ������Ϣ��JS���ӵ�����S�� 2008.3.6
			UpFileInfoScript = ""
		End If
		If pageReload Then
			Rem  �ظ��ɼ����� ajaxˢ��һ��
			s = s & "<scr"&"ipt type=""text/javascript"">var reload=1;</scr"&"ipt>"
		End If

		Dv_UbbCode = s
	End Function
	Private Function checkXHTML(mt,PostUserGroup,ismanager)
		Dim node,newnode,nodetext,attributes1,attributes2
		Dim NodeName,Attribute,AttName
		Dim hasname,hasvalue
		Rem  ��xhtml ��ʽ����
		Rem �����к����ʵ�й���
		Dim Stylestr,style,style1,newstyle,style_a,style_b
		Dim XML1,titletext,thissrc,objcount

		For Each Node in xml.documentElement.getElementsByTagName("*")
			NodeName = LCase(Node.nodeName)
			If NodeName="link" _
			Or NodeName="meta" _
			Or NodeName="script"  _
			Or NodeName="layer"  _
			Or NodeName="xss"  _
			Or NodeName="base"  _
			Or NodeName="html"  _
			Or NodeName="xhtml"  _
			Or NodeName="xml"  _
			Then
				Set newnode=xml.createTextNode(node.xml)
				node.parentNode.replaceChild newnode,node
			ElseIf NodeName="iframe" Or NodeName="frameset" Then
			    If ismanager-1<>0 Then
				    Set newnode=xml.createTextNode(node.xml)
				    node.parentNode.replaceChild newnode,node
				End If
			End If
            'response.Write G_UserList(26, G_ItemList(10, G_Floor)-1)&"<hr />"
			If NodeName="a" Then
				Node.setAttribute "target","_blank"
			End If

			'ȥ��STYLE���
			If NodeName="style" Then
				node.parentNode.removeChild(Node)
			End If
			If NodeName="embed" Then
				node.setAttribute "quality","high"
'				node.setAttribute "wmode","opaque"
			End If
			'���е����Եļ�����

			For Each Attribute in node.attributes
				AttName = LCase(Attribute.nodeName)

				If Left(AttName,2) = "on" Then
					node.removeAttribute AttName
				Else
					nodetext=replaceasc(Attribute.text)
					If InStr(nodetext,"script:")>0 or InStr(nodetext,"document.")>0 Or InStr(nodetext,"xss:") > 0 Or InStr(nodetext,"expression") > 0 Then
						node.removeAttribute AttName
					End If
				End If

				Select Case NodeName
					Case "object"
						If AttName = "data" Then
							node.removeAttribute AttName
						End If
					Case "param"
						If Cint(Board_Setting(9) * mt)=0 Then
							hasname=0
							hasvalue=0
							If AttName="name" and Attribute.text = "autostart" Then
								hasname=1
							ElseIf AttName = "value" Then
								If hasvalue=1 Then
									node.setAttribute AttName,"false"
								End If
							End If
						End If
					Case "embed"
						If Cint(Board_Setting(9) * mt)=0 Then
							If AttName="autoplay" Then
								node.setAttribute AttName,"false"
							ElseIf AttName = "title" Then
								If Attribute.text<>UBB_TITLE Then
									node.setAttribute "title",UBB_TITLE
								End If
							ElseIf AttName = "src" Then
								node.setAttribute "src",Attribute.text
							Else
								'node.removeAttribute AttName
							End If
						End If

				End Select
			Next
			'�Ѷ�ͼƬ�Ĵ����Ƶ����ȥ��ԭ����checkimg���� hxyman 2008-1-6
			If NodeName="img" Then
				Set titletext=node.attributes.getNamedItem("title")
				If titletext is nothing Then
					titletext=""
				Else
					titletext=titletext.text
				End If
				If titletext=UBB_TITLE Then
					Rem �Ƿ������ָı�ͼƬ��С�Ĺ��ܣ��������Ҫ��������
					Rem Node.attributes.setNamedItem(xml.createNode(2,"onmousewheel","")).text="return bbimg(this);"
					Node.attributes.setNamedItem(xml.createNode(2,"onload","")).text="imgresize(this);"
					Node.attributes.setNamedItem(xml.createNode(2,"alt","")).text="ͼƬ��������´��ڴ򿪲鿴"
				Else
					Rem �Ƿ������ָı�ͼƬ��С�Ĺ��ܣ��������Ҫ��������
					Rem Node.attributes.setNamedItem(xml.createNode(2,"onmousewheel","")).text="return bbimg(this);"
					Node.attributes.setNamedItem(xml.createNode(2,"onload","")).text="imgresize(this);"
					Node.attributes.setNamedItem(xml.createNode(2,"style","")).text="cursor: pointer;"
					Node.attributes.setNamedItem(xml.createNode(2,"alt","")).text="ͼƬ��������´��ڴ򿪲鿴"
					Node.attributes.setNamedItem(xml.createNode(2,"onclick","")).text="javascript:window.open(this.src);"
					If Not node.parentNode is Nothing Then
						If node.parentNode.nodename = "a" Then
								node.attributes.removeNamedItem("onclick")
						End If
					End If
				End If
			End If
		Next

		Dim i

		If instr(","& can_Post_Style &",",","& PostUserGroup &",") = 0 Then
			For Each Node in xml.documentElement.selectNodes("//@*")
				If LCase(Node.nodeName)="style" Then
					Stylestr=node.text
					Stylestr=split(Stylestr,";")
					newstyle=""
				 	For each style in Stylestr
				 		style1=split(style,":")
				 		If UBound(style1)>0 Then
				 			style_a=LCase(Trim(style1(0)))
					 		style_b=LCase(Trim(style1(1)))
					 		If UBound(style1)>1 Then
					 				For i =2 to UBound(style1)
					 				style_b=style_b& ":"& style1(i)
					 				Next
					 		End If
					 		'�Ե�POSITION:,top,left��������
					 		If (style_a<>"top" and style_a<>"left" and style_a<>"bottom" and style_a<>"right" and style_a<>"" and style_a<> "position") Then
						 			'ȥ������������
						 			If style_a="width" Then
						 				If InStr(style_b,"px")>0 Then
						 					style_b=replace(style_b,"px","")
						 					If IsNumeric(style_b) Then
						 						If CLng(style_b)>600 Then style_b=600
						 					End If
						 					style_b=style_b&"px"
						 				ElseIf InStr(style_b,"%")>0 Then
						 					style_b=replace(style_b,"%","")
						 					If IsNumeric(style_b) Then
						 						If CLng(style_b)>100 Then style_b=100
						 					End If
						 					style_b=style_b&"%"
						 			End If
					 				'ȥ�����������
						 			If style_a = "font-size" Then
						 				If InStr(style_b,"px")>0 Then
						 					style_b=replace(style_b,"px","")
						 					If IsNumeric(style_b) Then
						 						If CLng(style_b)> 200 Then style_b=200
						 					End If
						 					style_b=style_b&"px"
						 				ElseIf InStr(style_b,"%")> 0 Then
						 					style_b=replace(style_b,"%","")
						 					If IsNumeric(style_b) Then
						 						If CLng(style_b)>100 Then style_b=100
						 					End If
						 					style_b=style_b&"%"
						 				End If
						 			End If
					 			End If
					 			newstyle=newstyle&style_a&":"&style_b&";"
					 		End If
				 		End If
					Next
					node.text=newstyle
				End If
			Next
		End If
		checkXHTML=replace(Mid(xml.documentElement.xml,6,Len (xml.documentElement.xml)-11),"&amp;","&")
	End Function
	Function checkimg(textstr)
		Dim node,titletext
		If xml.loadxml("<div>" & replace(textstr,"&","&amp;") &"</div>")Then
			For Each Node in xml.documentElement.getElementsByTagName("img")
				Set titletext=node.attributes.getNamedItem("title")
				If titletext is nothing Then
					titletext=""
				Else
					titletext=titletext.text
				End If
				If titletext=UBB_TITLE Then
					Rem �Ƿ������ָı�ͼƬ��С�Ĺ��ܣ��������Ҫ��������
					Rem Node.attributes.setNamedItem(xml.createNode(2,"onmousewheel","")).text="return bbimg(this);"
					Node.attributes.setNamedItem(xml.createNode(2,"onload","")).text="imgresize(this);"
					Node.attributes.setNamedItem(xml.createNode(2,"alt","")).text="ͼƬ��������´��ڴ򿪲鿴"
				Else
					Rem �Ƿ������ָı�ͼƬ��С�Ĺ��ܣ��������Ҫ��������
					Rem Node.attributes.setNamedItem(xml.createNode(2,"onmousewheel","")).text="return bbimg(this);"
					Node.attributes.setNamedItem(xml.createNode(2,"onload","")).text="imgresize(this);"
					Node.attributes.setNamedItem(xml.createNode(2,"style","")).text="cursor: pointer;"
					Node.attributes.setNamedItem(xml.createNode(2,"alt","")).text="ͼƬ��������´��ڴ򿪲鿴"
					Node.attributes.setNamedItem(xml.createNode(2,"onclick","")).text="javascript:window.open(this.src);"
					If Not node.parentNode is Nothing Then
						If node.parentNode.nodename = "a" Then
								node.attributes.removeNamedItem("onclick")
						End If
					End If
				End If
			Next
			checkimg=replace(Mid(xml.documentElement.xml,6,Len (xml.documentElement.xml)-11),"&amp;","&")
		Else
			checkimg=textstr
		End If
	End Function
	Rem �ַ�ת��
	Private Function replaceasc(strText)
		Dim s,match,po,i
		s=replace(strText,"&amp;","&")
		If InStr(s,"\")=0 And InStr(s,"&#")=0 Then
			replaceasc=LCase(strText)
			Exit Function
		End If
		re.Pattern="(&#x)([0-9|a-z]{1,2})"
		Set match = re.Execute(s)
		For i= 0 to  match.count -1
			po=re.Replace(match.item(i),"$2")
			po="&H"+po
			If IsNumeric(po) Then
				s=Replace(s,match.item(i),Chr(po))
			End If
		Next
		re.Pattern="(&#0*)"
		s=re.Replace(s,"&#")
		re.Pattern="&#([0-9]{1,3})"
		Set match = re.Execute(s)
		For i= 0 to  match.count -1
			po=re.Replace(match.item(i),"$1")
			s=Replace(s,"&#"&po&";",Chr(po))
			s=Replace(s,"&#"&po&"",Chr(po))
		Next
		re.Pattern="(\\0*)"
		s=re.Replace(s,"\")
		re.Pattern="(\\)([0-9|a-z]{1,2})"
		Set match = re.Execute(s)
		For i= 0 to  match.count -1
			po=re.Replace(match.item(i),"$2")
			po="&H"+po
			If IsNumeric(po) Then
				s=Replace(s,match.item(i),Chr(po))
			End If
		Next
		s=replace(s,Chr(13),"")
		s=replace(s,Chr(10),"")
		s=replace(s,Chr(9),"")
		s=replace(s,"/*","")
		s=replace(s,"*/","")
		replaceasc=LCase(replace(s,Chr(0),""))
	End Function
	Private Function bbimg(strText)
		Dim s
		s=strText
		re.Pattern="<img(.[^>]*)([/| ])>"
		s=re.replace(s,"<img$1/>")
		If InStr(Ubblists,",40,")=0 Then
			re.Pattern="<img(.[^>]*)/>"
			s=re.replace(s,"<img$1 onload=""imgresize(this);""/>")
		End If
		bbimg=s
	End Function
	'ǩ��UBBת��
	Public Function Dv_SignUbbCode(s,PostUserGroup)
		Dim ii
		Dim po
		Dim mt
		mt=canusemt(PostUserGroup)
		If Dvbbs.forum_setting(66)="0" Then
			s= server.htmlEncode(s)
			re.Pattern="\[\/(img|dir|qt|mp|rm|sound|flash)\]"
            If NOScript = 1 Then
                If re.Test(s) Then
                    If Dv_FilterJS2(s) Then
                        re.Pattern="\[(br)\]"
                        s=re.Replace(s,"<$1>")
                        re.Pattern = "(&nbsp;)"
                        s = re.Replace(s,Chr(9))
                        re.Pattern = "(<br/>)"
                        s = re.Replace(s,vbNewLine)
                        re.Pattern = "(<br />)"
                        s = re.Replace(s,vbNewLine)
                        re.Pattern = "(<p>)"
                        s = re.Replace(s,"")
                        re.Pattern = "(<\/p>)"
                        s = re.Replace(s,vbNewLine)
                        s=server.htmlencode(s)
                        s="<form name=""scode"&replyid_a&""" method=""post"" action=""""><table class=""tableborder2"" cellspacing=""1"" cellpadding=""3"" width=""100%"" align=""center"" border=""0""><tr><th height=""22"">�������ݺ��ű�,����ܵ���ҳ�治�����Ĵ���</th></tr><tr><td class=""tablebody1"" align=""middle"" width=""98%""><textarea id=""CodeText"" style=""BORDER-RIGHT: 1px dotted; BORDER-TOP: 1px dotted; OVERFLOW-Y: visible; OVERFLOW: visible; BORDER-LEFT: 1px dotted; WIDth: 98%; COLOR: #000000; BORDER-BOTTOM: 1px dotted"" rows=""20"" cols=""120"">"&s&"</textarea></td></tr><tr><td class=""tablebody2"" align=""middle"" width=""98%""><b>˵����</b>������ʾ���Ǵ������ݡ��������ȼ�������û���⣬���޸�֮��������.</td></tr><tr><td class=""tablebody1"" align=""middle"" width=""98%""><input type=""button"" name=""run"" value=""���д���"" onclick=""Dvbbs_ViewCode("&replyid_a&");""></td></tr></table></form>"
                        s = Replace(s, vbNewLine, "")
                        s = Replace(s, Chr(10), "")
                        s = Replace(s, Chr(13), "")
                        Dv_SignUbbCode=s
                        Exit Function
                    End If
                End If
            End If
			re.Pattern="([^"&Chr(13)&"])"& Chr(10)
			s= re.Replace(s,"$1<br />")
			re.Pattern=Chr(13)&Chr(10)&"(.*)"
			s= re.Replace(s,"<p>$1</p>")
		Else
            If NOScript = 1 Then
				If Dv_FilterJS(s) Then
					re.Pattern="\[(br)\]"
					s=re.Replace(s,"<$1>")
					re.Pattern = "(&nbsp;)"
					s = re.Replace(s,Chr(9))
					re.Pattern = "(<br/>)"
					s = re.Replace(s,vbNewLine)
					re.Pattern = "(<br>)"
					s = re.Replace(s,vbNewLine)
					re.Pattern = "(<p>)"
					s = re.Replace(s,"")
					re.Pattern = "(<\/p>)"
					s = re.Replace(s,vbNewLine)
					s=server.htmlencode(s)
					s="<form name=""scode"&replyid_a&""" method=""post"" action=""""><table class=""tableborder2"" cellspacing=""1"" cellpadding=""3"" width=""100%"" align=""center"" border=""0""><tr><th height=""22"">�������ݺ��ű�,����ܵ���ҳ�治�����Ĵ���</th></tr><tr><td class=""tablebody1"" align=""middle"" width=""98%""><textarea id=""CodeText"" style=""BORDER-RIGHT: 1px dotted; BORDER-TOP: 1px dotted; OVERFLOW-Y: visible; OVERFLOW: visible; BORDER-LEFT: 1px dotted; WIDth: 98%; COLOR: #000000; BORDER-BOTTOM: 1px dotted"" rows=""20"" cols=""120"">"&s&"</textarea></td></tr><tr><td class=""tablebody2"" align=""middle"" width=""98%""><b>˵����</b>������ʾ���Ǵ������ݡ��������ȼ�������û���⣬���޸�֮��������.</td></tr><tr><td class=""tablebody1"" align=""middle"" width=""98%""><input type=""button"" name=""run"" value=""���д���"" onclick=""Dvbbs_ViewCode("&replyid_a&");""></td></tr></table></form>"
					Dv_SignUbbCode=s
					Exit Function
				End If
            End If
			re.Pattern="<((asp|\!|%))"
			s=re.Replace(s,"&lt;$1")
			re.Pattern="(>)("&vbNewLine&")(<)"
			s=re.Replace(s,"$1$3")
			re.Pattern="(>)("&vbNewLine&vbNewLine&")(<)"
			s=re.Replace(s,"$1$3")
		End If
		s = Replace(s, "  ", "&nbsp;&nbsp;")
		s = Replace(s, vbNewLine, "<br/>")
		s = Replace(s, Chr(13), "")
		'�������ò�֧��UBB���룬���˳�
		If Cint(Dvbbs.Forum_setting(65))=0 Then
			Dv_SignUbbCode=s
			Exit Function
		End If
		'img code
		If InStr(Lcase(s),"[/img]")>0 Then  s=Dv_UbbCode_iS2(s,"img","<img "& DV_UBB_TITLE &" src=""$1"" border=""0"" />","<img "& DV_UBB_TITLE &" src=""skins/default/filetype/gif.gif"" border=""0"" /><a href=""$1"" target=""_blank"">$1</a>",PostUserGroup,Cint(Dvbbs.forum_setting(67)),"")
		'media code
		If InStr(Lcase(s),"[/sound]")>0 Then s=Dv_UbbCode_iS2(s,"sound","<a href=""$1"" target=""_blank""><img "& DV_UBB_TITLE &" src=""skins/default/filetype/mid.gif""  border=""0"" alt=""��������"" /></a><bgsound src=""$1"" loop=""-1"">","<a href=""$1"" target=""_blank"">$1</a>",PostUserGroup,Cint(Board_Setting(9) * mt),"")

		'flash code
		If InStr(Lcase(s),"[/flash]")>0 Then
			s=Dv_UbbCode_iS2(s,"flash",_
			"<a href=""$1"" target=""_blank""><img "& DV_UBB_TITLE &" src=""skins/default/filetype/swf.gif"" border=""0"" alt=""������´������͸�FLASH����!"" height=""16"" width=""16"" />[ȫ������]</a><br/>"&_
			"<object "& DV_UBB_TITLE &" codebase=""http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0"" classid=""clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"" width=""500"" height=""400"">"&_
			"<param name=""movie"" value=""$1"" /><param name=""quality"" value=""high"" />"&_
			"<embed "& DV_UBB_TITLE &" src=""$1"" quality=""high"" pluginspage=""http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"" type=""application/x-shockwave-flash"" width=""500"" height=""400"">$1</embed></object>",_
			"<img "& DV_UBB_TITLE &" src=""skins/default/filetype/swf.gif"" border=""0"" alt=""""> <a href=""$1"" target=""_blank"">$1</a>��ע�⣺Flash���ݿ��ܺ��ж�����룩",_
			PostUserGroup,Cint(Dvbbs.forum_setting(71)),"")

			s=Dv_UbbCode_iS2(s,"flash",_
			"<a href=""$3"" target=""_blank""><img "& DV_UBB_TITLE &" src=""skins/default/filetype/swf.gif"" border=""0"" alt=""������´������͸�FLASH����!"" height=""16"" width=""16"" />[ȫ������]</a><br/>"&_
			"<object "& DV_UBB_TITLE &" codeBase=""http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0"" classid=""clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"" width=""$1"" height=""$2"">"&_
			"<param name=""movie"" value=""$3"" /><param name=""quality"" value=""high"" />"&_
			"<embed "& DV_UBB_TITLE &" src=""$3"" quality=""high"" pluginspage=""http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"" type=""application/x-shockwave-flash"" width=""$1"" height=""$2"">$3</embed></object>",_
			"<a href=""$3"" target=""_blank"">$3</a>��ע�⣺Flash���ݿ��ܺ��ж�����룩",_
			PostUserGroup,Cint(Dvbbs.forum_setting(71)),"=*([0-9]*),*([0-9]*)")
		End If

		'url code
		If InStr(Lcase(s),"[/url]")>0 Then
			s=Dv_UbbCode_S1(s,"url","<a href=""$1"" target=""_blank"">$1</a>")
			s=Dv_UbbCode_UF(s,"url","<a href=""$1"" target=""_blank"">$2</a>","0")
		End If
		'email code
		If InStr(Lcase(s),"[/email]")>0 Then
			s=Dv_UbbCode_S1(s,"email","<img "& DV_UBB_TITLE &" src=""skins/default/email1.gif"" alt="""" /><a href=""mailto:$1"">$1</a>")
			s=Dv_UbbCode_UF(s,"email","<img "& DV_UBB_TITLE &" src=""skins/default/email1.gif"" alt="""" /><a href=""mailto:$1"" target=""_blank"">$2</a>","0")
		End If
		If InStr(Lcase(s),"[/html]")>0 Then s=Dv_UbbCode_C(s,"html")
		If InStr(Lcase(s),"[/color]")>0 Then s=Dv_UbbCode_UF(s,"color","<font color=""$1"">$2</font>","1")
		If InStr(Lcase(s),"[/face]")>0 Then s=Dv_UbbCode_UF(s,"face","<font face=""$1"">$2</font>","1")
		If InStr(Lcase(s),"[/align]")>0 Then s=Dv_UbbCode_Align(s)

		If InStr(Lcase(s),"[/shadow]")>0 Then s=Dv_UbbCode_iS1(s,"shadow","<div style=""width:$1px;filter:shadow(color=$2, strength=$3)"">$4</div>")
		If InStr(Lcase(s),"[/glow]")>0 Then s=Dv_UbbCode_iS1(s,"glow","<div style=""width:$1px;filter:glow(color=$2, strength=$3)"">$4</div>")
		If InStr(Lcase(s),"[/i]")>0 Then s=Dv_UbbCode_S1(s,"i","<i>$1</i>")
		If InStr(Lcase(s),"[/b]")>0 Then s=Dv_UbbCode_S1(s,"b","<b>$1</b>")
		If InStr(Lcase(s),"[/u]")>0 Then s=Dv_UbbCode_S1(s,"u","<u>$1</u>")
		If InStr(Lcase(s),"[/size]")>0 Then
			s=Dv_UbbCode_UF(s,"size","<font size=""$1"">$2</font>","1-"&Maxsize&"")
		End If
		REM ��ǩ���ƶ�(����ʹ�������������ȥ��)
		'If InStr(Lcase(s),"[/fly]")>0 Then s=Dv_UbbCode_S1(s,"fly","<marquee width=90% behavior=alternate scrollamount=""3"">$1</marquee>")
		'If InStr(Lcase(s),"[/move]")>0 Then s=Dv_UbbCode_S1(s,"move","<marquee scrollamount=""3"">$1</marquee>")
		'������HTML֧�֣���ת��HREF
		REM ����ǩ���Ƿ񿪷�HTML�ж� 2004-5-6 Dvbbs.YangZheng
		If Board_Setting(5)="1" And Dvbbs.Forum_Setting(66) = "1" Then
			'�Զ�ʶ����ַ
			If InStr(Lcase(s),"http://")>0 Then
				re.Pattern = "(^|[^<=""])(http:(\/\/|\\\\)(([\w\/\\\+\-~`@:%])+\.)+([\w\/\\\.\=\?\+\-~`@\':!%#]|(&amp;)|&)+)"
				s = re.Replace(s,"$1<a target=""_blank"" href=$2>$2</a>")
			End If
			'�Զ�ʶ��www�ȿ�ͷ����ַ
			If InStr(Lcase(s),"www.")>0 or InStr(Lcase(s),"bbs.")>0 Then
				re.Pattern = "(^|[^\/\\\w\=])((www|bbs)\.(\w)+\.([\w\/\\\.\=\?\+\-~`@\'!%#]|(&amp;))+)"
				s = re.Replace(s,"$1<a target=""_blank"" href=http://$2>$2</a>")
			End If
		End If
		s=bbimg(s)
		Dv_SignUbbCode=s
	End Function

	Private Function Dv_UbbCode_S1(strText,uCodeC,tCode)
		Dim s
		s=strText
		re.Pattern="\["&uCodeC&"\][\s\n]*\[\/"&uCodeC&"\]"
		s=re.Replace(s,"")
		re.Pattern="\[\/"&uCodeC&"\]"
		s=re.replace(s, Chr(1)&"/"&uCodeC&"]")
		re.Pattern="\["&uCodeC&"\]([^\x01]*)\x01\/"&uCodeC&"\]"
		s=re.Replace(s,tCode)
		re.Pattern="\x01\/"&uCodeC&"\]"
		s=re.replace(s,"[/"&uCodeC&"]")
		Dv_UbbCode_S1=s
	End Function

	Private Function Dv_UbbCode_UF(strText,uCodeC,tCode,Flag)
		Dim s
		Dim LoopCount
		LoopCount=0
		s=strText
		re.Pattern="\["&uCodeC&"=([^\]]*)\][\s\n ]*\[\/"&uCodeC&"\]"
		s=re.Replace(s,"")
		re.Pattern="\[\/"&uCodeC&"\]"
		s=re.replace(s, chr(1)&"/"&uCodeC&"]")
		re.Pattern="\["&uCodeC&"=([^\]]*)\]([^\x01]*)\x01\/"&uCodeC&"\]"
		If Flag="1" Then
			Do While Re.Test(s)
				s=re.Replace(s,tCode)
				LoopCount=LoopCount+1
				If LoopCount>MaxLoopCount Then Exit Do
			Loop
		ElseIf Flag="0" Then
			s=re.Replace(s,tCode)
		Else
			re.Pattern="\["&uCodeC&"=(["&Flag&"]*)\]([^\x01]*)\x01\/"&uCodeC&"\]"
			Do While Re.Test(s)
				s=re.Replace(s,tCode)
				LoopCount=LoopCount+1
				If LoopCount>MaxLoopCount Then Exit Do
			Loop
		End If
		re.Pattern="\x01\/"&uCodeC&"\]"
		s=re.replace(s,"[/"&uCodeC&"]")
		Dv_UbbCode_UF=s

	End Function

	Private Function Dv_UbbCode_iS1(strText,uCodeC,tCode)
		Dim s
		s=strText
		re.Pattern="\["&uCodeC&"=[^\]]*\][\s\n]\[\/"&uCodeC&"\]"
		s=re.Replace(s,"")
		re.Pattern="\[\/"&uCodeC&"\]"
		s=re.replace(s, chr(1)&"/"&uCodeC&"]")
		re.Pattern="\["&uCodeC&"=([0-9]+),(#?[\w]+),([0-9]+)\]([^\x01]*)\x01\/"&uCodeC&"\]"
		s=re.Replace(s,tCode)
		re.Pattern="\x01\/"&uCodeC&"\]"
		s=re.replace(s, "[/"&uCodeC&"]")
		Dv_UbbCode_iS1=s
	End Function

	Private Function Dv_UbbCode_iS2(strText,uCodeC,tCode1,tCode2,PostUserGroup,Flag,iCode)
		'Response.Write iCode
		Dim s
		s=strText
		re.Pattern="\["&uCodeC&iCode&"\][\s\n]*\[\/"&uCodeC&"\]"
		s=re.replace(s,"")
		re.Pattern="\[\/"&uCodeC&"\]"
		s=re.replace(s, chr(1)&"/"&uCodeC&"]")
		If uCodeC<>"flash" Then
			re.Pattern="\["&uCodeC&"[^\]]*\](([^\x01\n]*)(\.swf|\.swi)([^\x01\n]*))\x01\/"&uCodeC&"\]"
			s=re.Replace(s,"�Ƿ�"&uCodeC&"��ý���ǩ���ļ���ַ��$1")
		End If
		If uCodeC="img" Then
			re.Pattern="\["&uCodeC&iCode&"\]([^""\x01\n]*)\x01\/"&uCodeC&"\]"
		Else
			re.Pattern="\["&uCodeC&iCode&"\]([^""\x01\n\s]*)\x01\/"&uCodeC&"\]"
		End If
		If Flag = 1  Then
			s=re.Replace(s,tCode1)
		Else
			s=re.Replace(s,tCode2)
		End If
		re.Pattern="\x01\/"&uCodeC&"\]"
		s=re.replace(s,"[/"&uCodeC&"]")
		Dv_UbbCode_iS2=s
	End Function

	Private Function Dv_UbbCode_Align(strText)
		Dim s
		s=strText
		re.Pattern="\[align=(center|left|right)\][\s\n]*\[\/align\]"
		s=re.Replace(s,"")
		re.Pattern="\[\/align\]"
		s=re.replace(s,chr(1)&"/align]")
		re.Pattern="\[align=(center|left|right)\]([^\x01]*)\x01\/align\]"
		s=re.Replace(s,"<div align=""$1"">$2</div>")
		re.Pattern="\x01\/align\]"
		s=re.replace(s,"[/align]")
		Dv_UbbCode_Align=s
	End Function

	Private Function Dv_UbbCode_U(strText,PostUserGroup,Flag)	'(�������ݣ��û��飬�Ƿ񿪷�ͼƬ��ǩ)
		Dim s
		Dim downUrl
		Dim Match
		If Dvbbs.Forum_Setting(76)="" Or Dvbbs.Forum_Setting(76)="0" Then Dvbbs.Forum_Setting(76)="UploadFile/"
		If right(Dvbbs.Forum_Setting(76),1)<>"/" Then Dvbbs.Forum_Setting(76)=Dvbbs.Forum_Setting(76)&"/"
		s=strText
		re.Pattern="\[upload=([^\]\n]*)\][\s\n]\[\/UPLOAD\]"
		s=re.Replace(s,"")
		re.Pattern="\[\/UPLOAD\]"
		s=re.replace(s, chr(1)&"/upload]")
		re.Pattern="\[upload=(gif|jpg|jpeg|bmp|png)(,|)([^\]]*)\]UploadFile/([^\x01\n]*)\x01\/UPLOAD\]"

		If Dvbbs.Forum_Setting(75)="0" Then
			If Flag = 1 or PostUserGroup<4 Then
				s= re.Replace(s,"<br/><img "& DV_UBB_TITLE &" src=""skins/default/filetype/$1.gif"" border=""0"" />���������ͼƬ���£�$3<br/><a href="""&Dvbbs.Forum_Setting(76)&"$4"" target=""_blank"" ><img "& DV_UBB_TITLE &" src="""&Dvbbs.Forum_Setting(76)&"$4"" border=""0"" alt=""�������´������ͼƬ"" /></a>")
			Else
				s= re.Replace(s,"<br/><img "& DV_UBB_TITLE &" src=""skins/default/filetype/$1.gif"" border=""0"" /><a href="""&Dvbbs.Forum_Setting(76)&"$4"" target=""_blank"">"&Dvbbs.Forum_Setting(76)&"$4</a>")
			End If
		Else
			If Flag = 1 or PostUserGroup<4 Then
				s= re.Replace(s,"<br/><img "& DV_UBB_TITLE &" src=""skins/default/filetype/$1.gif"" border=""0"" />���������ͼƬ����$3��<br/><a href=""showimg.asp?BoardID="&Dvbbs.BoardID&"&filename=$4"" target=""_blank"" ><img "& DV_UBB_TITLE &" src=""showimg.asp?BoardID="&Dvbbs.BoardID&"&filename=$4"" border=""0"" /></a>")
			Else
				s= re.Replace(s,"<br/><img "& DV_UBB_TITLE &" src=""skins/default/filetype/$1.gif"" border=""0"" /><a href=""showimg.asp?BoardID="&Dvbbs.BoardID&"&filename=$4"" target=""_blank"">showimg.asp?BoardID="&Dvbbs.BoardID&"&filename=$4</a>")
			End If
		End If
		

		re.Pattern="\[upload=(swf|swi)(,|)([^\]]*)\]UploadFile/([^\x01\n]*)\x01\/UPLOAD\]"
		
		If Dvbbs.Forum_Setting(75)="0" Then
			If Board_Setting(44) = 1 or PostUserGroup<4 Then
					s= re.Replace(s,"<br/><img "& DV_UBB_TITLE &" src=""skins/default/filetype/swf.gif"" border=""0"" /><a href="""&Dvbbs.Forum_Setting(76)&"$4"" target=""_blank"">��������FLASH�ļ�$3</a>��<br/>"&_
					"<embed "& DV_UBB_TITLE &" src="""&Dvbbs.Forum_Setting(76)&"$4"" quality=""high"" pluginspage=""http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"" type=""application/x-shockwave-flash"" width=""500"" height=""300""></embed>")
			Else
				s= re.Replace(s,"<br/><img "& DV_UBB_TITLE &" src=""skins/default/filetype/swf.gif"" border=""0"" /><a href="""&Dvbbs.Forum_Setting(76)&"$4"" target=""_blank"">"&Dvbbs.Forum_Setting(76)&"$4</a>")
			End If
		Else
			s= re.Replace(s,"<br/><img "& DV_UBB_TITLE &" src=""skins/default/filetype/swf.gif"" border=""0"" /><a href=""showimg.asp?BoardID="&Dvbbs.BoardID&"&filename=$4"" target=""_blank"">��̳�����˷����������������FLASH�ļ�</a>")
		End If
		re.Pattern="\[upload=(mp3|mid|wav|rmi|cda)(,|)([^\]]*)\]UploadFile/([^\x01\n]*)\x01\/UPLOAD\]"
		s= re.Replace(s,"��������:$3<br /><EMBED src="""&dvbbs.forum_setting(76)&"$4"" width=""550"" height=""60"" type=audio/mpeg volume=""0"" loop=""-1"" autostart=""0""></EMBED><br />")	

		re.Pattern="\[upload=(\w+)(,|)([^\]]*)\]viewFile\.asp\?id=([0-9]*)\x01\/UPLOAD\]"

		'������Ϣ------------------------------------------
		If Dvbbs.BoardID>0 Then
			Dim TempStr,RowStr,UploadAddr,PromptInfo
			Dim BoardUserLimited


			'���²���������ʾ�ļ������Ϣ
			If FileInfo Then
				Dim F_ID,F_ID2,F_i,F_RS,SqlStr,F_Data,F_Del
				Dim i,m,n,x Rem X��M��Ϊ��ʱ������������ѭ���м�����
				'F_ID�������յ�ǰ���ӳ��ֵ������ļ���ID��Ϣ�����Զ��ŷָ�����
				'F_i������¼���������ļ�����������ʹ�ǲ����ڵ��ļ�Ҳ��¼����
				'F_RS�������ղ�ѯ��䷵�صļ�¼��
				'SqlStr����Ĳ�ѯ��䣬��ѯ�������г��ֵ������ļ�����Ϣ
				F_i = 0
				F_Del = 0 '�ļ��Ƿ��Ѿ���ɾ��
				If re.Test(s) Then
					Set match = re.Execute(s)
					Dim item
					For Each item In match
						If Not IsNumeric(re.Replace(item,"$4")) Then Exit For
						If F_i=0 Then
							F_ID = re.Replace(item,"$4")
						Else
							F_ID = F_ID &"," & re.Replace(item,"$4")
						End If
						F_i = F_i+1
					Next
				End If
				F_i = F_i-1 '��Ϊ�ղŵ�ѭ���ж����һ�Σ�����Ҫ��ȥ1�����ǵ�ǰ�����г��ֵ������ļ�������
				ReDim F_Temp(2,F_i) 'F_Data�������ղ�ѯ��䷵�ص��ļ���ϢF_Temp�Ƕ���Щ��Ϣ���������е�˳����������Ժ������
				If F_ID <> "" Then
					SqlStr = "Select F_ID,F_FileSize,F_DownNum From Dv_Upfile Where F_ID In("& F_ID &") order by F_ID"
					'Response.Write SqlStr &"<br />" '����SQL���
					Set F_RS=dvbbs.execute(SqlStr)
					If F_RS.Bof And F_RS.Eof Then
						F_Data = ""
						F_Del=1
					Else
						F_Data = F_RS.GetRows(-1)
						F_Del=0
					End If
					Set F_RS=Nothing
					'����ȡ���ļ�����Ϣ������������F_Data��
					If F_Del=0 Then
						F_ID2=Split(F_ID,",") '��F_ID�ָ�����飬�Ž�F_ID2�У�˳���ǰ����ļ����ֵ�˳�����е�
						m=0
						For Each i In F_ID2
							For n=0 To UBound(F_Data,2)
								If CStr(i) = CStr(F_Data(0,n)) Then '�������Ҫת�����Ͳ��ܱȽϣ�Ϊ�˷�ֹ�����ͳ�������ת��ΪSTR
									F_Temp(0,m)=F_Data(0,n)
									F_Temp(1,m)=F_Data(1,n)
									F_Temp(2,m)=F_Data(2,n)
								End If
							Next
							m=m+1
						Next
					End If
				Else
					F_i = -1
				End If
			End If
			'������Ϣ������ʾ�ļ��������Ϣ 2008.3.6
			TempStr = "<table border=""0"" cellspacing=""2"" class=""tableborder4"" style=""width:550px;"">"
			If FileInfo Then
				TempStr = TempStr & "<tr><td colspan=""2"" height=""20"" class=""tablebody2"">&nbsp;<B>������Ϣ</B>&nbsp;&nbsp;[�ļ���С��<a name=""UpFileSize"">&nbsp;</a>&nbsp;&nbsp;���ش�����<a name=""LoadTime"">&nbsp;</a>]</td></tr>" rem ��ʾ�ļ���Ϣ
			Else
				TempStr = TempStr & "<tr><td colspan=""2"" height=""20"" class=""tablebody2"">&nbsp;<B>������Ϣ</B></td></tr>"  rem ȡ���ļ���Ϣ��ʾ����
			End If
			TempStr = TempStr & "{$uploadaddr}"
			TempStr = TempStr & "{$row}"
			TempStr = TempStr & "</table>"

			BoardUserLimited = Split(Dvbbs.Board_Setting(55),"|")
			RowStr=""
			PromptInfo = "confirm('���ؽ��۳���"
			If UBound(BoardUserLimited)=12 Then
				If BoardUserLimited(9)>0 Then
					RowStr = RowStr & "<tr class=""tablebody1""><td style=""width:50%;height:20px;text-align:center"">�۳������</td><td>"&BoardUserLimited(9)&"</td></tr>"
					PromptInfo = PromptInfo&"\n"&BoardUserLimited(9)&"���"
				End If
				If BoardUserLimited(10)>0 Then
					RowStr = RowStr & "<tr class=""tablebody1""><td style=""width:50%;height:20px;text-align:center"">�۳���Ǯ��</td><td>"&BoardUserLimited(10)&"</td></tr>"
					PromptInfo = PromptInfo&"\n"&BoardUserLimited(10)&"��Ǯ"
				End If
				If BoardUserLimited(11)>0 Then
					RowStr = RowStr & "<tr class=""tablebody1""><td style=""width:50%;height:20px;text-align:center"">�۳�������</td><td>"&BoardUserLimited(11)&"</td></tr>"
					PromptInfo = PromptInfo&"\n"&BoardUserLimited(11)&"����"
				End If
			End If
			PromptInfo = PromptInfo&"')"
			If RowStr<>"" Then
				TempStr = Replace(TempStr,"{$row}",RowStr)
			Else
				TempStr = Replace(TempStr,"{$row}","")
			End If

			
				If RowStr="" Then
					UploadAddr = "<tr><td colspan=""2"" height=""20"" class=""tablebody1""><img "& DV_UBB_TITLE &" src=""skins/default/filetype/$1.gif"" border=""0"" /><a href=""viewFile.asp?BoardID="&Dvbbs.Boardid&"&ID=$4"" target=""_blank"">���������ļ�:$3</a></td></tr>"
				Else
					UploadAddr = "<tr><td colspan=""2"" height=""20"" class=""tablebody1""><img "& DV_UBB_TITLE &" src=""skins/default/filetype/$1.gif"" border=""0"" /><a href=""viewFile.asp?BoardID="&Dvbbs.Boardid&"&ID=$4"" target=""_blank"" onClick=""return "&PromptInfo&";"">���������ļ�:$3</a></td></tr>"
				End If
			TempStr = Replace(TempStr,"{$uploadaddr}",UploadAddr)
			s = re.Replace(s,TempStr)
			If FileInfo Then
				'�����������һ���ű���������ʾ�ļ������Ϣ
				x=0
				UpFileCount = CInt(UpFileCount) '��UpFileCountת��Ϊ���Σ�������û�и�ֵ��ʱ��ͻ���Ϊ0����
				If F_Del=0 then
					If CInt(F_i)>=0 Then
						UpFileInfoScript =  "<scr"&"ipt type=""text/javascript"" language=""javascript"">" & VBCrLf
						For x=0 To F_i
							If F_temp(1,x)="" Then
								UpFileInfoScript = UpFileInfoScript & "document.getElementsByName(""UpFileSize"")["&UpFileCount&"].innerHTML='��ɾ��';" & VBCrLf
							Else
								UpFileInfoScript = UpFileInfoScript & "document.getElementsByName(""UpFileSize"")["&UpFileCount&"].innerHTML='"& FileSizeFormat(F_Temp(1,x))& "';" & VBCrLf
							End If
							If F_Temp(2,x)="" Then
								UpFileInfoScript = UpFileInfoScript & "document.getElementsByName(""LoadTime"")["&UpFileCount&"].innerHTML='0';" & VBCrLf
							Else
								UpFileInfoScript = UpFileInfoScript & "document.getElementsByName(""LoadTime"")["&UpFileCount&"].innerHTML='"& F_Temp(2,x)&"';" & VBCrLf
							End If
							UpFileCount = UpFileCount+1
						Next
						UpFileInfoScript = UpFileInfoScript & "</sc"&"ript>" & VBCrLf
					End If
				Else
					If CInt(F_i)>=0 Then
						UpFileInfoScript =  "<scr"&"ipt type=""text/javascript"" language=""javascript"">" & VBCrLf
						For x=0 To F_i
							UpFileInfoScript = UpFileInfoScript & "document.getElementsByName(""UpFileSize"")["&UpFileCount&"].innerHTML='��ɾ��';" & VBCrLf
							UpFileInfoScript = UpFileInfoScript & "document.getElementsByName(""LoadTime"")["&UpFileCount&"].innerHTML='0';" & VBCrLf
							UpFileCount = UpFileCount+1
						Next
						UpFileInfoScript = UpFileInfoScript & "</sc"&"ript>" & VBCrLf
					End If
				End If
				'�������һ���ű���������ʾ�ļ������Ϣ
			End If
		End If

		re.Pattern="\x01\/upload]"
		re.Pattern="\[upload=(\w+)(,|)([^\]]*)\]([^\x01]*)\x01\/UPLOAD\]"
		s= re.Replace(s,"<img "& DV_UBB_TITLE &" src=""skins/default/filetype/$1.gif"" border=""0"" /><a href=""$4"" target=""_blank"">���������ļ�</a>")
		re.Pattern="\x01\/upload]"
		s=re.replace(s,"[/upload]")
		Dv_UbbCode_U=s
	End Function

	Private Function Dv_UbbCode_Q(strText)
		Dim s
		Dim LoopCount
		LoopCount=0
		s=strText
		re.Pattern="\[quote\]((.|\n)*?)\[\/quote\]"
		Do While re.Test(s)
			s=re.Replace(s,"<div class=""quote"">$1</div>")
			LoopCount=LoopCount+1
			If LoopCount>MaxLoopCount Then Exit Do
		Loop
		Dv_UbbCode_Q=s
	End Function

	Private Function Dv_UbbCode_name(strText)
		Dim s
		Dim po,match
		s=strText
		re.Pattern="\[\/username\]"
		s=re.Replace(s,Chr(1)&"/username]")
		re.Pattern="\[username=([^\]]+)]([^\x01]*)\x01\/username\]"
		If Cint(Board_Setting(56))=1 Then
			Set match = re.Execute(s)
			If match.count>0 Then
				po=re.Replace(match.item(0),",$1,")
				If  Dvbbs.Membername<>"" and (Dvbbs.Membername=UserName or InStr(po,","&Dvbbs.Membername&",")>0 or Dvbbs.master) Then
					s=re.Replace(s,"<hr /><font color=""red"">����������ר�ŷ���<b>$1</b>���</font><br/>$2<hr />")
				Else

					s=re.Replace(s,"<hr /><font color=""gray"">����������ר�ŷ���<b>$1</b>���</font><br/><hr />")
				End If
			End If
		Else
		s=re.Replace(s,"$2")
		End If
		re.Pattern="\x01\/username\]"
		s=re.Replace(s,"[/username]")
		Set match=Nothing
		Dv_UbbCode_name=s
	End Function

	Private Function Dv_UbbCode_Get(strText,PostUserGroup,PostType,uCodeC,tCode1,tCode2,UsePoint,Flag)'��������,���������,��������,,,,,,�û�����,�Ƿ񿪷�ubb��ǩ
		Dim s,ii,match
		Dim LoopCount
		s=strText
		UsePoint=CLng(UsePoint)
		re.Pattern="\["&uCodeC&"= *[0-9]*\][\s\n]*\[\/"&uCodeC&"\]"
		s=re.replace(s,"")
		re.Pattern="\[\/"&uCodeC&"\]"
		s=re.replace(s,Chr(1)&"/"&uCodeC&"]")
		re.Pattern="\["&uCodeC&"= *([0-9]+)\]([^\x01]*)\x01\/"&uCodeC&"\]"
		If Issupport=1 Then
			Dim matches
			Set matches = re.Execute(s)
			re.Global=False
			For Each match In matches
				If (Flag=1 or PostUserGroup<4) and PostType=1 Then
					ii=int(match.SubMatches(0))
					If  Dvbbs.Membername<>"" and (Dvbbs.Membername=UserName or UsePoint>=ii or Dvbbs.master) Then
						s=re.Replace(s,tCode1)
					Else
						s=re.Replace(s,tCode2)
					End If
				Else
					s=re.Replace(s,"$2")
				End If
				LoopCount=LoopCount+1
				If LoopCount>MaxLoopCount Then Exit For
			Next
			Set matches=Nothing
		Else
			Dim Test
			re.Global=False
			Test=re.Test(s)
			Do While Test
				If (Flag=1 or PostUserGroup<4) and PostType=1 Then
					Set match = re.Execute(s)
					ii=int(re.Replace(match.item(0),"$1"))
					If  Dvbbs.Membername<>"" and (Dvbbs.Membername=UserName or UsePoint>=ii or Dvbbs.master) Then
						s=re.Replace(s,tCode1)
					Else
						s=re.Replace(s,tCode2)
					End If
				Else
					s=re.Replace(s,"$2")
				End If
				LoopCount=LoopCount+1
				If LoopCount>MaxLoopCount Then Exit Do
				Test=re.Test(s)
			Loop
			Set match=Nothing
		End If
		re.Global=true
		re.Pattern="\x01\/"&uCodeC&"\]"
		s=re.replace(s,"[/"&uCodeC&"]")
		Dv_UbbCode_Get=s
	End Function

	Private Function UBB_REPLYVIEW(strText,PostUserGroup,PostType)
		Dim s
		Dim vrs
		s=strText
		re.Pattern="\[replyview\][\s\n]*\[\/replyview\]"
		s=re.Replace(s,"")
		re.Pattern="\[\/replyview\]"
		s=re.replace(s, chr(1)&"/replyview]")
		re.Pattern="\[replyview\]([^\x01]*)\x01\/replyview\]"
		If (Board_Setting(15)="1" or PostUserGroup<4) and PostType=1  Then
			If isgetreed<>1 Then
				Set vrs=dvbbs.execute("select AnnounceID from "&TotalUsetable&" where rootid="&Announceid&" and PostUserID="&Dvbbs.UserID)
				isgetreed=1
				If Not vRs.eof Then
					reed=1
				Else
					reed=0
				End If
				Set vrs=Nothing
			End If
			If Dvbbs.Membername<>"" and (reed=1 or Dvbbs.master  Or IsThisBoardMaster) Then
				s=re.Replace(s,"<hr noshade=""noshade"" size=""1"" /><font color=""gray"">��������ֻ��<b>�ظ�</b>��ſ������</font><br/>$1<hr noshade=""noshade"" size=""1"" />")
			Else
				s=re.Replace(s,"<hr noshade=""noshade"" size=""1"" /><font color="""&Dvbbs.Mainsetting(1)&""">��������ֻ��<b>�ظ�</b>��ſ������</font><hr noshade=""noshade"" size=""1"" />")
				pageReload = True
			End If
		Else
			s=re.Replace(s,"$1")
		End If
		re.Pattern="\x01\/replyview\]"
		s=re.replace(s, "[/replyview]")
		UBB_REPLYVIEW=s
	End Function

	Private Function UBB_USEMONEY(strText,PostUserGroup,PostType)
		Dim s
		Dim Test
		Dim ii,iii,match,buied
		Dim SplitBuyUser,iPostBuyUser
		Dim LoopCount
		s=strText
		re.Global=False
		re.Pattern="\[USEMONEY=*([0-9]+)\]((.|\n)*)\[\/USEMONEY\]"
		Test=re.Test(s)
		If Test Then
			If T_GetMoneyType >0 Then
				s=re.Replace(s,"<font color=""gray"">����ʹ���˽���������ã���˳�����UBBģʽʧЧ���������������ݣ�</font>&nbsp;&nbsp;<br />$2")
			Else
				If (Cint(Board_Setting(23))=1 or PostUserGroup<4) and PostType=1 Then
					Set match = re.Execute(s)
					ii=int(re.Replace(match.item(0),"$1"))
					If  Dvbbs.Membername<>"" and (Dvbbs.Membername=UserName or Dvbbs.master) Then
						If (Not IsNull(PostBuyUser)) And PostBuyUser<>"" Then
							SplitBuyUser=split(PostBuyUser,"|")
							iPostBuyUser="<option value=""0"">�ѹ����û�</option>"
							for iii=0 to ubound(SplitBuyUser)
								iPostBuyUser=iPostBuyUser & "<option value="""&iii&""">"&SplitBuyUser(iii)&"</option>"
							next
						Else
							iPostBuyUser="<option value=""0"">��û���û�����</option>"
						End If
						s=re.Replace(s,"<hr noshade=""noshade"" size=""1"" /><font color=""gray"">����������Ҫ�����ֽ�<b>$1</b>�ſ������</font>&nbsp;&nbsp;<select size=""1"" name=""buyuser"">"&iPostBuyUser&"</select><br/>$2<hr noshade=""noshade"" size=""1"" />")
						re.Global=true
						re.Pattern="\[\/?USEMONEY=*[0-9]*\]"
						s=re.Replace(s,"")
					Else
						buied=0
						If (Not IsNull(PostBuyUser)) and PostBuyUser<>"" Then
							If Instr("|"&PostBuyUser&"|","|"&Dvbbs.Membername&"|")>0 Then buied=1
						End If
						If buied=1 Then
							s=re.Replace(s,"<hr noshade=""noshade"" size=""1"" /><font color=""gray"">����������Ҫ�����ֽ�<b>$1</b>�ſ�����������Ѿ�������</font><br/>$2<hr noshade=""noshade"" size=""1"" />")
							re.Global=true
							re.Pattern="\[\/?USEMONEY=*[0-9]*\]"
							s=re.Replace(s,"")
						Else
							If Clng(UserPointInfo(0))>=ii Then
								s=re.Replace(s,"<form action=""BuyPost.asp"" mothod=""post""><font color="""&Dvbbs.Mainsetting(1)&""">����������Ҫ�����ֽ�<b>$1</b>�ſ����������Ŀǰ���ֽ�<b>"&UserPointInfo(0)&"</b>��<br/><br/>��������<input type=""hidden"" name=""boardid"" value="""&Dvbbs.boardid&""" /><input type=""hidden"" value="""&replyid_a&""" name=""replyid"" /><input type=""hidden"" value="""&AnnounceID_a&""" name=""id"" /><input type=""hidden"" value="""&RootID_a&""" name=""rootid""/><input type=""hidden"" value="""&totalusetable&""" name=""posttable"" /><input type=""submit"" name=""submit"" value=""�úڰ����ҡ������ˣ�"" />&nbsp;&nbsp;</font></form>")
							Else
								s=re.Replace(s,"<hr noshade=""noshade"" size=""1"" /><font color="""&Dvbbs.Mainsetting(1)&""">����������Ҫ�����ֽ�<b>$1</b>�ſ����������ֻ���ֽ�<b>"&UserPointInfo(0)&"</b>���޷�����</font><hr noshade=""noshade"" size=""1"" />")
							End If
						End If
					End If
				Else
					re.Global=true
					re.Pattern="\[\/?USEMONEY=*[0-9]*\]"
					s=re.Replace(s,"")
				End If
				Set match=Nothing
			End If
		End If
		re.Global=true
		UBB_USEMONEY=s
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
			t1=replaceasc(t1)
			If InStr(Dvbbs.forum_setting(77),"|")=0 Then
				Replacelist="(expression|xss:|function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit=|error|click|key|load|focus|Blur))"
			Else
				Replacelist="("&Dvbbs.forum_setting(77)&"expression|xss:|function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit|error|click|key|load|focus|Blur))"
			End If
			re.Pattern="<((.[^>]*"&Replacelist&"[^>]*)|"&Replacelist&")>"
			Test=re.Test(t1)
			If Test=False Then
				If IsNull(Ubblists)="" Then Dim Ubblists:Ubblists=",1,"
				re.Pattern=",[13-8],"
				If re.Test(Ubblists) Then
					If InStr(Dvbbs.forum_setting(77),"|")=0 Then
						Replacelist="(expression|xss:|function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit=|error|click|key|load|focus|Blur))"
					Else
						Replacelist="("&Dvbbs.forum_setting(77)&"expression|xss:|function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit|error|click|key|load|focus|Blur))"
					End If
					re.Pattern="(\[(.[^\]]*)\])((.[^\]]*"&Replacelist&"[^\]]*)|"&Replacelist&")(\[\/(.[^\]]*)\])"
					Test=re.Test(t1)
				End If
			End If
			Dv_FilterJS=test
		End If
	End Function

	Public Function Dv_FilterJS2(v)
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
			t1=replaceasc(t1)
			If InStr(Dvbbs.forum_setting(77),"|")=0 Then
				Replacelist="(expression|xss:|var |function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit=|error|click|key|load|focus|Blur))"	'|\[|\]
			Else
				Replacelist="("&Dvbbs.forum_setting(77)&"expression|xss:|var |function|meta|window\.|script|js:|about:|file:|Document\.|vbs:|frame|cookie|on(finish|mouse|Exit|error|click|key|load|focus|Blur))"
			End If
			re.Pattern="(\[(.[^\]]*)\])((.[^\]]*"&Replacelist&"[^\]]*)|"&Replacelist&")(\[\/(.[^\]]*)\])"
			Test=re.Test(t1)
			Dv_FilterJS2=test
		End If
	End Function

	Private Function Dv_UbbCode_C(strText,uCodeC)
		Dim s,matches,match,CodeStr,Floor
		Floor=1
		s=strText
		s=strText
		re.Pattern="\["&uCodeC&"\][\s\n]*\[\/"&uCodeC&"\]"
		s=re.replace(s,"")
		re.Pattern="\[\/"&uCodeC&"\]"
		s=re.replace(s,Chr(1)&"/"&uCodeC&"]")
		re.Pattern="\["&uCodeC&"\]([^\x01]*)\x01\/"&uCodeC&"\]"
		Set matches = re.Execute(s)
		re.Global=False
		For Each match In matches
			CodeStr=match.SubMatches(0)
			CodeStr = Replace(CodeStr,"&nbsp;",Chr(32),1,-1,1)
			CodeStr = Replace(CodeStr,"<p>","",1,-1,1)
			CodeStr = Replace(CodeStr,"</p>","&#13;&#10;",1,-1,1)
			CodeStr = Replace(CodeStr,"[br]","&#13;&#10;",1,-1,1)
			CodeStr = Replace(CodeStr,"<br/>","&#13;&#10;",1,-1,1)
			CodeStr = Replace(CodeStr,vbNewLine,"&#13;&#10;",1,-1,1)
			CodeStr = "<form name=""scode"& replyid_a &"_"& Floor &""" method=""post"" action=""""><table class=""tableborder1"" cellspacing=""1"" cellpadding=""3"" style=""width: 98%;"" align=""center""><tr><th height=""22"">�����ǳ������</th></tr><tr><td class=""tablebody"&(((Floor+1) Mod 2)+1)&""" align=""middle"" width=""98%""><textarea id=""CodeText"" style=""width: 100%;"" rows=""10"">"&CodeStr&"</textarea></td></tr><tr><td class=""tablebody"&(((Floor+1) Mod 2)+1)&""" align=""middle"" width=""98%""><b>˵����</b>������ʾ���Ǵ������ݡ��������ȼ�������û���⣬���޸�֮��������.</td></tr><tr><td class=""tablebody"&(((Floor+1) Mod 2)+1)&""" align=""middle"" width=""98%""><input type=""button"" name=""run"" value=""���д���00"" onclick=""Dvbbs_ViewCode('"& replyid_a &"_"& Floor &"');"" />&nbsp;<input type=""button"" name=""copy"" value=""���ƴ���"" onclick=""Dvbbs_CopyCode('"& replyid_a &"_"& Floor &"');"" disabled=""disabled"" />&nbsp;<input type=""button"" name=""save"" value=""�������"" onclick=""Dvbbs_SaveCode('"& replyid_a &"_"& Floor &"');"" disabled=""disabled""/></td></tr></table></form>"
			s = re.Replace(s,CodeStr)
			Floor=Floor+1
		Next
		re.Global=true
		Set matches=Nothing
		re.Pattern="\x01\/"&uCodeC&"\]"
		s=re.replace(s,"[/"&uCodeC&"]")
		Dv_UbbCode_C=s
	End Function

		Private Function Dv_Alipay_PayTo(strText)
		If Not Isnull(strText) Then
			Dim s,ss
			Dim match,match2,urlStr,re2
			Dim t(2),temp,check,fee,i,encode8_tmp
			s=strText
			Set re2=new RegExp
			re2.IgnoreCase =true
			re2.Global=False
			t(0)="���ҳе��˷�"
			t(1)="��ҳе��˷�"
			t(2)="������Ʒ�����ʵ�"
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
					urlStr="http://pay.dvbbs.net/payto.asp?t=tenpay&seller="&temp
					'urlStr="http://192.168.8.175:82/pay/payto.asp?t=tenpay&seller="&temp
					re2.Pattern="\(subject\)([^\n]+?)\(\/subject\)"
					If re2.Test(match.item(i)) Then
						Set match2 = re2.Execute(match.item(i))
						temp=re2.replace(match2.item(0),"$1")
						ss=ss&"<div style=""text-indent:0px;padding:0px 20px;""><b>��Ʒ����</b>��"&temp&"<br/>"
						urlStr = urlStr & "&subject=" & Server.UrlEncode(temp)
						re2.Pattern="\(body\)((.|\n)*?)\(\/body\)"
						If re2.Test(match.item(i)) Then
							Set match2 = re2.Execute(match.item(i))
							temp=re2.replace(match2.item(0),"$1")
							ss=ss&"<b>��Ʒ˵��</b>��"&unescape(temp)&"<br/>"
							urlStr = urlStr & "&body=" & Server.UrlEncode(Left(Dvbbs.Replacehtml(temp), 200) & "...")
							re2.Pattern="\(price\)([\d\.]+?)\(\/price\)"
							If re2.Test(match.item(i)) Then
								Set match2 = re2.Execute(match.item(i))
								temp=re2.replace(match2.item(0),"$1")
								ss=ss&"<b>��Ʒ�۸�</b>��"&temp&" Ԫ<br/>"
								urlStr=urlStr&"&price="&temp
								re2.Pattern="\(transport\)([1-3])\(\/transport\)"
								If re2.Test(match.item(i)) Then
									Set match2 = re2.Execute(match.item(i))
									temp=re2.replace(match2.item(0),"$1")
									check=true
									If int(temp)=2 Then
										ss=ss&"<b>�ʵ���Ϣ</b>��"&t(temp-1)&"<br/><b>�ʵݷ���</b>��"
										urlStr=urlStr&"&transport="&Server.UrlEncode(temp)

										re2.Pattern="\(express_fee\)([\d\.]+?)\(\/express_fee\)"
										If re2.Test(match.item(i)) Then
											Set match2 = re2.Execute(match.item(i))
											fee=re2.replace(match2.item(0),"$1")
											ss=ss&" ��� "&fee&" Ԫ "
											urlStr=urlStr&"&express_fee="&fee
										End If
										re2.Pattern="\(ordinary_fee\)([\d\.]+?)\(\/ordinary_fee\)"
										If re2.Test(match.item(i)) Then
											Set match2 = re2.Execute(match.item(i))
											fee=re2.replace(match2.item(0),"$1")
											ss=ss&" ƽ�� "&fee&" Ԫ"
											urlStr=urlStr&"&ordinary_fee="&fee
										Else
											check=False
										End If
									Else
										ss=ss&"<b>�ʵ���Ϣ</b>��"&t(temp-1)&"<br/>"
										urlStr=urlStr&"&transport="&Server.UrlEncode(temp)
									End If
									ss=ss&"<br/>"
									If check=true Then
										check=False
										re2.Pattern="\(ww\)([^\n]+?)\(\/ww\)"
										If re2.Test(match.item(i)) Then
											Set match2 = re2.Execute(match.item(i))
											temp=re2.replace(match2.item(0),"$1")
											encode8_tmp=EncodeUtf8(temp)
											ss=ss&"<b>��ϵ����</b>��<a target=""_blank"" href=""mailto:"&encode8_tmp&""">"&temp&"</a>"
											check=true
										End If
										re2.Pattern="\(qq\)(\d+?)\(\/qq\)"
										If re2.Test(match.item(i)) Then
											Set match2 = re2.Execute(match.item(i))
											temp=re2.replace(match2.item(0),"$1")
											If check=true Then
												ss=ss&"&nbsp;&nbsp;<a target=""_blank"" href=""http://wpa.qq.com/msgrd?V=1&Uin="&temp&"&Site=Dvbbs.Net&Menu=yes""><img border=""0"" src=""http://wpa.qq.com/pa?p=1:"&temp&":10"" alt=""��ϵ��"" /></a><br/>"
											Else
												ss=ss&"<b>��ϵ����</b>��<a target=""_blank"" href=""http://wpa.qq.com/msgrd?V=1&Uin="&temp&"&Site=Dvbbs.Net&Menu=yes""><img border=""0"" src=""http://wpa.qq.com/pa?p=1:"&temp&":10"" alt=""��ϵ��"" /></a><br/>"
											End If
										ElseIf check=true Then
											ss=ss&"<br/>"
										End If
										re2.Pattern="\(demo\)([^\n]+?)\(\/demo\)"
										If re2.Test(match.item(i)) Then
											Set match2 = re2.Execute(match.item(i))
											temp=re2.replace(match2.item(0),"$1")
											ss=ss&"<b>��ʾ��ַ</b>��"&temp&"<br/>"
											urlStr=urlStr&"&url="&Server.UrlEncode(temp)
										End If

										ss=ss&"<a href="""&Server.HtmlEncode(urlStr&"&partner=2088002048522272&type=1&readonly=true")&""" target=""_blank""><img src=""images/alipay/tenpay_2.gif"" border=""0"" alt=""ͨ���Ƹ�ͨ���ף����������ģ��������ѡ���ȫ����ݣ�"" /></a>&nbsp;&nbsp;<a href=""https://www.tenpay.com/zft/qa/qa_zj.shtml"" target=""_blank""><font color=""blue"">�鿴���װ�������������</font></a><br/></div>"
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
			re.Global=true
			re.Pattern="\x01\/payto\]"
			s=re.replace(s,"[/payto]")
			Dv_Alipay_PayTo=s
		End If
	End Function
	Function canusemt(GroupID)
		If Application(Dvbbs.CacheName &"_groupsetting").documentElement.selectSingleNode("usergroup[@usergroupid='"& GroupID &"']/@groupsetting") Is Nothing Then GroupID=7
		canusemt = Split(Application(Dvbbs.CacheName &"_groupsetting").documentElement.selectSingleNode("usergroup[@usergroupid='"& GroupID &"']/@groupsetting").text,",")(72)
	End Function

	Function FileSizeFormat(num) Rem ��ʽ��������� by ����.NET 2008.3.6
		If num > 1024 Then
			num = num/1024
			If num > 1024 Then
				FileSizeFormat = FormatNumber(num/1024,1,-1) &" MB"
				Exit Function
			Else
				FileSizeFormat = FormatNumber(num,1,-1) &" KB"
			End If
		Else
			FileSizeFormat = FormatNumber(num,1,-1) &" Bytes"
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
               retV += Hex2Utf8(Str2Hex(sa[i].substring(1,5))) + sa[i].substring(5,sa[i].length);

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