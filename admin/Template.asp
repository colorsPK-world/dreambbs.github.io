<!--#include file="../conn.asp"-->
<!--#include file="inc/const.asp"-->
<%
Head()
Dim admin_flag
admin_flag=",22,"
CheckAdmin(admin_flag)

Dim action,SkinID,StyleID
StyleID=Dvbbs.CheckNumeric(request("StyleID"))
action=Request("action")

If Application(Dvbbs.CacheName &"_style").documentElement.selectSingleNode("style[@id='"& StyleID &"']") Is Nothing Then
	If Not Application(Dvbbs.CacheName &"_style").documentElement.selectSingleNode("style/@id") Is Nothing Then
		StyleID=Application(Dvbbs.CacheName &"_style").documentElement.selectSingleNode("style/@id").text 
	Else
		Response.Write "ģ�������޷���ȡ,��������µ���"
		Response.End
	End If
End If

Dim StyleFolder,FilePath,typeList
StyleFolder = Application(Dvbbs.CacheName &"_style").documentElement.selectSingleNode("style[@id='"& StyleID &"']/@folder").text
FilePath = "../Resource/"& StyleFolder &"/"
typeList = Split("0,strings,pic,html",",")
'Response.Write FilePath

Response.Write "<table border=""0"" cellspacing=""1"" cellpadding=""3"" align=""center"" width=""100%"">"
Response.Write "<tr>"
Response.Write "<th width=""100%"" style=""text-align:center;"" colspan=""2"">��̳ģ�����"
Response.Write "</th>"
Response.Write "</tr>"
Response.Write "<tr>"
Response.Write "<td class=""td2"" colspan=""2"">"
Response.Write "<p><b>ע��</b>��<br />��������������½����޸�ģ�壬���Ա༭��̳���԰��ͷ�񣬿����½�ģ��ҳ�棬����ʱ�밴�����ҳ����ʾ������д������Ϣ��<br />����̳��ǰ����ʹ�õ�Ĭ��ģ�岻��ɾ��<br />������޸ķ�ģ��ҳ�����ƻ�ɾ����ģ��ҳ�����ڹر���̳֮�������������ܻ�Ӱ����̳���ʡ�"
Response.Write "</td>"
Response.Write "</tr>"
Response.Write "<tr>"
Response.Write "<td class=""td2"" width=""20%"" height=""25"" align=""left"">"
Response.Write "<b>��̳ģ�����ѡ��</b></td>"
Response.Write "<td class=""td2"" width=""80%""><a href=""template.asp"">ģ�������ҳ</a>"
Response.Write " | <a href=""http://bbs.dvbbs.net/loadtemplates.asp"" target = ""_blank"" title="""">��ȡ�ٷ�ģ������</a></td>"
Response.Write "</tr>"
Response.Write "</table>"

Select Case action
	Case "edit"
		Call Edit() 
	Case "manage"
		If Request("mostyle")="�� ��" Then
			Main()
		ElseIf Request("mostyle") = "ɾ ��" Then
			'DelStyle()
		End If
	Case "saveedit"
		Call Saveedit()
	Case "rename"
		rename()
	Case "editmain"
		editmain()
	Case "savemain"
		Savemain() 
	Case Else
		Main()
End Select
%>

<%
Rem ��ҳ�� ģ��ҳ�б� 2007-10-9
Sub Main()
	Response.Write "<p></p>"
	Response.Write "<table border=""0"" cellspacing=""1"" cellpadding=""3"" align=""center"" width=""100%"">"
	Response.Write "<tr>"
	Response.Write "<th width=""100%"" style=""text-align:center;"" colspan=""2"">��ǰ��̳ģ�����"
	Response.Write "</th>"
	Response.Write "</tr>"
	Response.Write "<tr>"
	Response.Write "<form method=post action=""?action=manage"">"
	Response.Write "<td class=""td2"" height=30 align=left>"
	Response.Write "��ѡ�����ģ�壺 "
	'����ϵͳ��������ȡ������ģ�����ƺ�ID
	Dim Templateslist,rs,i
	Response.Write "<select name=""StyleID"" size=""1"">"
	For Each Templateslist in Application(Dvbbs.CacheName &"_style").documentElement.selectNodes("style")
		Response.Write "<option value="""& Templateslist.selectSingleNode("@id").text &""""
		If CLng(Templateslist.selectSingleNode("@id").text) = CLng(StyleID) Then 
			Response.Write " selected"
		End If 
		Response.Write ">"&Templateslist.selectSingleNode("@type").text &"</option>"
	Next 
	Response.Write "</select>"
	Response.Write "&nbsp;&nbsp;"
	Response.Write "<input type=submit class=""button"" value=""�� ��"" name=""mostyle"">&nbsp;&nbsp;&nbsp;"
	'Response.Write "<input type=submit class=""button"" value=""ɾ ��"" name=""mostyle"">"
	Response.Write "<br /><br /><b>˵����</b>ɾ��������ɾ����ģ���������ݣ����á�"
	Response.Write "</td>"
	Response.Write "</form>"
	Response.Write "<form method=post action=""?action=rename"">"
	Response.Write "<td class=""td2"" align=left>"
	Response.Write "<select name=""StyleID"" size=1>"
	For Each Templateslist in Application(Dvbbs.CacheName &"_style").documentElement.selectNodes("style")
		Response.Write "<option value="""& Templateslist.selectSingleNode("@id").text &""""
		If CLng(Templateslist.selectSingleNode("@id").text) = CLng(StyleID) Then 
			Response.Write " selected"
		End If 
		Response.Write ">"&Templateslist.selectSingleNode("@type").text &"</option>"
	Next 
	Response.Write "</select>"
	Response.Write "&nbsp;&nbsp;"
	Response.Write "����Ϊ��<input type=text size=20 name=""StyleName"" value="""
	Response.Write """>&nbsp;&nbsp;"
	Response.Write "<input type=submit class=""button"" name=submit value=""�޸�"">"
	Response.Write "</td>"
	Response.Write "</form>"

	Response.Write "</tr>"

	Response.Write "<tr>"
	Response.Write "<th style=""text-align:center;"" colspan=2>"
	Response.Write Application(Dvbbs.CacheName &"_style").documentElement.selectSingleNode("style[@id='"& StyleID &"']/@type").text &"����ģ����Դ����</th></tr><tr><td height=25 class=""bodytitle"" colspan=2>"
	Response.Write "ͨ����˵����ҳ��ģ�������̳��ÿ��ҳ��ķ��ģ�壬���������ֶ������ֶε���������Ϊ��Page_ҳ��������Ҫ��׺��"
	Response.Write "</td>"
	Response.Write "</tr>"

	Dim pageList,pageName
	pageList = "Main_Style,index,dispbbs,showerr,login,online,usermanager,fmanage,boardstat,admin,paper_even_toplist,query,show,dispuser,help_permission,postjob,post,boardhelp,indivgroup"
	pageName = Split(pageList,",")
	pageName(0) = "pub"
	For i=0 To UBound(pageName)
		Response.Write "<tr onmouseover=""this.style.backgroundColor='#B3CFEE';this.style.color='red'"" onmouseout=""this.style.backgroundColor='';this.style.color=''"">"
		Response.Write "<td height=""25"">"
		Response.Write "<li>"
		If i=0 Then
			Response.Write "��ҳ��ģ��(Main_Style) &nbsp;&nbsp;</li></td><td height=""25"" align=""left"">"
		Else
			Response.Write "��ҳ��ģ��(page_"&pageName(i)&") &nbsp;&nbsp;</li></td><td height=""25"" align=""left"">"
		End If
		Response.Write "�༭��ģ�飺"
		Response.Write "<a href=""?action=edit&stype=1&page="&pageName(i)&"&StyleID="& StyleID &""">���԰�</a>"
		Response.Write " | <a href=""?action=edit&stype=2&page="&pageName(i)&"&StyleID="& StyleID &""">ͼƬ</a>"
		Response.Write " | <a href=""?action=edit&stype=3&page="&pageName(i)&"&StyleID="& StyleID &""">������</a>"
		If i=0 Then
			Response.Write " | <a href=""?action=editmain&stype=2&StyleID="&StyleID&""">��������</a>"
		End if
		Response.Write "</td>"
		Response.Write "</tr>"
	Next

	Response.Write "</table><p></p>"
End Sub

Rem �޸�ģ������ 2007-10-8 By Dv.����
Sub rename()
	Dim stylename
	stylename=Dvbbs.checkStr(Request("stylename"))
	If Trim(stylename)=""  Then 
		Errmsg=ErrMsg + "<br /><li>�޸������������µ�ģ�����ơ�"
		Dvbbs_error()
	End If
	Dvbbs.Execute("update [Dv_Templates] set Type='"&StyleName&"' where id="&StyleID&"")
	Dv_suc("ģ�����޸ĳɹ�!")
	Dvbbs.loadSetup()
	Dvbbs.Loadstyle()
End Sub

Sub editmain() '�������ò���
	Dim stype,NowEditinfo
	Dim mystr
	stype=Request("stype")	
	Select Case stype
		Case "2"
			NowEditinfo="��������"
			mystr="mainsetting"
		Case Else
			Errmsg=ErrMsg + "<br /><li>���ύ�˴���Ĳ���."
			Dvbbs_error()	
	End Select
	Dim TemplateStr
	Response.Write "<form action=""?action=savemain&stype="&stype&"&StyleID="&StyleID&""" method=post>"
	Response.Write "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"" align=""center"">"
	Response.Write "<tr>"
	Response.Write "<th width=""100%"" style=""text-align:center;"" colspan=2>"
	Response.Write NowEditinfo
	Response.Write "("&mystr&")����</th></tr>"
	Select Case stype
		Case "2"		
			TemplateStr = Dvbbs.ReadTextFile(FilePath &"pub_html0.htm")
			TemplateStr = split(TemplateStr,"||")
			If ubound(TemplateStr) < 13 Then
				TemplateStr = Dvbbs.ReadTextFile(FilePath &"pub_html0.htm")&"||skins/Default/"
				TemplateStr = split(TemplateStr,"||")
			End if
			Response.Write "<tr><td class=""td2"" height=40 align=""center"" colspan=2>"
			Response.Write "<table cellspacing=""1"" cellpadding=""0"" border=""0"" align=""left"" width=""100%"">"
			Response.Write "<tr>"
			Response.Write "<td width=""300"" align=""right"" colspan=""1"" class=""td2"">������ȣ�</td>"
			Response.Write "<td align=""left"" class=""td2"" colspan=""3"" >"
			Response.Write "<input type=""text"" size=""5"" name=""TemplateStr"" value="""&TemplateStr(0)&""">&nbsp;(ʵ������:��<b>780px</b> һ��Ҫд��λ(px),���߰ٷֱ� ,��<b>98%</b>)&nbsp;"&mystr&"(0)"
			Response.Write "</td>"
			Response.Write "</tr>"
			Dim j,vtitle
			vtitle="aa|��������������ɫ��|��ʾ���ӵ�ʱ��������ӣ�ת�����ӣ��ظ��ȵ���ɫ��|��ҳ������ɫ��|һ���û�����������ɫ��|һ���û������ϵĹ�����ɫ��|��������������ɫ��|���������ϵĹ�����ɫ��|����Ա����������ɫ��|����Ա�����ϵĹ�����ɫ��|�������������ɫ��|��������ϵĹ�����ɫ��|����߿���ɫ��|���ͼƬ·����"
			vtitle=split(vtitle,"|")
			For j=1 to UBound(vtitle)
				'If j=4 or j=6 or j=8 or j=10 Then
					'Response.Write "<input type=""hidden"" size=""10"" value="""&TemplateStr(j)&""" name=""TemplateStr"">"
				'Else
					Response.Write "<tr>"
					Response.Write "<td colspan=""4"" style=""background:#6595D6;height:3px; dislpay:none"">"
					Response.Write "</tr>"
					Response.Write "<tr>"
					Response.Write "<td height=""25"" width=""300"" align=""right"">"&vtitle(j)&"</td>"
					Response.Write "<td width=""20"" style=""background:"&TemplateStr(j)&";""></td>"
					Response.Write "<td width=""180"" align=""left"">"
					Response.Write "<input type=""text"" size=""10"" value="""&TemplateStr(j)&""" name=""TemplateStr"">&nbsp;"&mystr&"("&j&")"
					Response.Write "</td>"
					Response.Write "</tr>"
				'End If
			Next
			Response.Write "</table>"		
			Response.Write "</td></tr>"		
		Case Else
				
	End Select
	Response.Write "<tr><td class=""td2"" height=""25"" align=""center"">"
	Response.Write "<input type=""reset"" class=""button"" name=""Submit"" value=""�� ��"">"
	Response.Write "</td>"
	Response.Write "<td class=""td2"" height=""25"" align=""center"">"
	Response.Write "<input type=""submit"" class=""button"" name=""B1"" value=""�� ��"">"
	Response.Write "</table>"
	Response.Write "</form>"
End Sub

Sub savemain() ' �����������
	Dim stype,NowEditinfo,TemplateStr,tempstr,Main_Style,FileName
	stype=Request("stype")
	TemplateStr=""
	Select Case stype
		Case "2"
			NowEditinfo="��������"
			For Each TempStr in Request.form("TemplateStr")
				If TempStr<>"" Then
					TemplateStr=TemplateStr&TempStr&"||"
				Else
					TemplateStr=TemplateStr&Chr(1)&"||"
				End If
			Next
			TemplateStr=Left(TemplateStr,Len(TemplateStr)-2)
			
			FileName = FilePath &"pub_html0.htm"
		Case Else
			Errmsg=ErrMsg + "<br /><li>���ύ�˴���Ĳ���."
			Dvbbs_error()	
	End Select
	TemplateStr=Dvbbs.checkStr(TemplateStr)
	'Response.Write TemplateStr
	Dvbbs.writeToFile FileName,TemplateStr
	Dvbbs.Loadstyle()
	Dv_suc("��ģ��"&NowEditinfo&"�޸ĳɹ�!")
	If stype=2 Then
			'createsccfile()
	End If
End Sub

Sub Edit()
	Dim Page,mystr,rs,i
	Dim FileName,TempStr,TemplateStr,stype
	Dim TempStyleHelp,StyleHelpValue
	stype=Dvbbs.checkStr(request("stype"))
	page=Dvbbs.checkStr(request("page"))

	FileName = page &"_"& typeList(stype)

	If Not IsNumeric(stype) Then 
		Errmsg=ErrMsg + "<br /><li>�������ʽ����"
		Dvbbs_error()
	End If
	
	Response.Write "<form name=""template"" action=""?action=saveedit&page="&page&"&stype="&stype&"&StyleID="&StyleID&""" method=post>"
	Response.Write "<table border=""0"" cellspacing=""1"" cellpadding=""3"" align=""center"" width=""100%"">"
	Response.Write "<tr>"
	Response.Write "<th width=""100%"" style=""text-align:center;"" colspan=3>"
	'Response.Write Rs(1)
	Response.Write "��ҳ��ģ��("
	Response.Write page
	Response.Write ")"
	Response.Write "<input Type=""hidden"" name=""dvbbs"" value=""OK!"">"
	Select Case stype
		Case 1
			Response.Write "���԰�"
			mystr="template.Strings"
			If page="main_style" Then mystr="Dvbbs.lanstr"
		Case 2
			Response.Write "ͼƬ��Դ(��ǰĬ��·��{$PicUrl}Ϊ��"&Dvbbs.Forum_PicUrl&")"
			mystr="template.pic"
			If page="main_style" Then mystr="Dvbbs.mainpic"
		Case 3
			Response.Write "������"
			mystr="template.html"
			If page="main_style" Then mystr="Dvbbs.mainhtml"
	End Select
	
	Response.Write "����</th></tr>"

	'If TemplateStr(Ubound(TemplateStr))="" Then TemplateStr(Ubound(TemplateStr))="del"
	'Response.Write CountFilesNumber(FilePath,FileName)
	For i=0 To CountFilesNumber(FilePath,FileName)-1
		TemplateStr = Dvbbs.ReadTextFile(FilePath & FileName &i&".htm")

		Response.Write "<tr><td class=""td2"" width=20% height=40 align=left>"
		Response.Write mystr&"("&i&")"
		Response.Write "<br /><a href=""javascript:;"" onclick=""rundvscript(t"&i&",'page="&page&"&index="&i&"&stype="&stype&"');"" title=""�������ȡ�ⲿ��ģ��Ĺٷ�����"">��ȡ�ٷ�����</a>"
		Response.Write "</td>"		
		Response.Write "<td class=""td2"" width=80% height=25 align=left>"
		Select Case stype
			Case 1
				If LenB(TemplateStr)>70 Then
				Response.Write "<textarea name=""TemplateStr"" id=""t"&i&"""  cols=""100"" rows=""3"">"
				Response.Write server.htmlencode(TemplateStr)
				Response.Write "</textarea>"
				Else
				Response.Write "<input Type=""text"" name=""TemplateStr"" id=""t"&i&""" value="""
				Response.Write server.htmlencode(TemplateStr)
				Response.Write """ size=50>"
				End If
				Response.Write "<INPUT TYPE=""hidden"" NAME=""ReadME"" id=""r"&i&""" value="""&StyleHelpValue&""">"
				Response.Write "<a href=# onclick=""helpscript(r"&i&");return false;"" class=""helplink""><img src=""skins/images/help.gif"" border=0 title=""������Ĺ���������""></a>"
			Case 2
				Response.Write "<input Type=""text"" name=""TemplateStr"" id=""t"&i&""" value="""
				Response.Write server.htmlencode(TemplateStr)
				Response.Write """ size=20> "
				If server.htmlencode(TemplateStr)<>"" And (Instr(server.htmlencode(TemplateStr),".gif") or Instr(server.htmlencode(TemplateStr),".jpg")) Then
					If InStr(TemplateStr,"{$PicUrl}")>0 Then
						Response.Write "<img src="&server.htmlencode(Replace(TemplateStr,"{$PicUrl}",MyDbPath&Dvbbs.Forum_PicUrl))&"  border=0>"
					Else
						Response.Write "<img src="&server.htmlencode(MyDbPath & TemplateStr)&"  border=0>"
					End If
				End if
			Case 3
				If page="pub"  And i=0 Then 
					Response.Write "<input type=hidden name=""TemplateStr"" value="""
					Response.Write server.htmlencode(TemplateStr)
					Response.Write """>"
					Response.Write "���ֶ����ڻ������ã�  <a href=""?action=editmain&stype=2&StyleID="&StyleID&""">�������޸Ļ�������</a>"
					Response.Write "</td><td class=""td2"">"
					Response.Write "<a href=# onclick=""helpscript(r"&i&");return false;"" class=""helplink""><img src=""skins/images/help.gif"" border=0 title=""������Ĺ���������""></a>"
				Else
					
					Response.Write "<textarea name=""TemplateStr"" id=""t"&i&""" cols=""100"" rows=""5"">"
					Response.Write server.htmlencode(TemplateStr)
					Response.Write "</textarea>"
					Response.Write "</td><td class=""td2""><a href=""javascript:admin_Size(-5,'t"&i&"')""><img src=""skins/images/minus.gif"" unselectable=""on"" border='0'></a> <a href=""javascript:admin_Size(5,'t"&i&"')""><img src=""skins/images/plus.gif"" unselectable=""on"" border='0'></a>"
					Response.Write "<img src=skins/images/viewpic.gif onclick=runscript(t"&i&")>"
					Response.Write "<a href=# onclick=""helpscript(r"&i&");return false;"" class=""helplink""><img src=""skins/images/help.gif"" border=0 title=""������Ĺ���������""></a> "		
				End If
				Response.Write "<INPUT TYPE=""hidden"" NAME=""ReadME"" id=""r"&i&""" value="""&StyleHelpValue&""">"
			End Select
			
		Response.Write "</td></tr>"
	Next
	Response.Write "<tr><td class=""td2"" height=""25"" align=""center"" colspan=""3"">&nbsp;"
	Response.Write "</td></tr>"
	Response.Write "<tr><td class=""td2"" height=""25"" align=""center"">"
	Response.Write "<input type=""reset"" class=""button"" name=""Submit"" value=""�� ��"">"
	Response.Write "</td>"
	Response.Write "<td class=""td2"" height=""25"" colspan=2 align=""center"">"
	Response.Write "<input type=""submit"" class=""button"" name=""B1"" value=""�� ��"">"
	Response.Write "</td></tr>"
	Response.Write "<tr>"
	Response.Write "<td colspan=3 Class=""td2"">"
	Response.Write "<br /><li>��Ҫ��ʾ��ģ���к�XSLT����ģ��޸ı����ϸ���XML�﷨��׼��"
	Response.Write "<br /><li>ģ��༭���������������ֶΣ����ڶ�Ӧ���ı���������""del""����ôģ�����ݵ���žͻ�ǰ�ơ�"
	Response.Write "<br /><li>�������ı�ģ�����ݵ���ţ����Ѹ���Ŀ��������գ���ֻ��Ҫ��������ա�"
	Response.Write "</td></tr>"
	Response.Write "</table><p></p>"
	Response.Write "</form>"
End Sub

Sub SaveEdit()
	If Request("dvbbs")<>"OK!" Then
		Errmsg=ErrMsg + "<br /><li>���ύ�˷Ƿ�����"
		Dvbbs_error()
		Exit Sub
	End If
	Dim Page,i
	Dim TempStr,TemplateStr,stype
	Dim TempStyleHelp,StyleHelpValue
	stype=Dvbbs.checkStr(request("stype"))
	page=Dvbbs.checkStr(request("page"))
	If Not IsNumeric(stype) Then 
		Errmsg=ErrMsg + "<br /><li>�������ʽ����"
		Dvbbs_error()
	End If
	'ģ����,���»���.	
	If stype="3" Then
		Select Case Request("page")
			Case "page_dispbbs"
				TemplateStr=Request.form("TemplateStr")(1)
				Set TempStr=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument" & MsxmlVersion)
				If Not TempStr.Loadxml(TemplateStr) Then
					Errmsg=ErrMsg + "��̳��ҳģ��template.html(0)δ��ͨ��XMLУ��,�����±༭�޸�,ȷ������."
					Set TempStr=Nothing
					Dvbbs_error()
					Exit Sub
				End If
			Case "page_index"
				TemplateStr=Request.form("TemplateStr")(1)
				Set TempStr=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument" & MsxmlVersion)
				If Not TempStr.Loadxml(TemplateStr) Then
					Errmsg=ErrMsg + "��̳��ҳģ��template.html(0)δ��ͨ��XMLУ��,�����±༭�޸�,ȷ������."
					Set TempStr=Nothing
					Dvbbs_error()
					Exit Sub
				End If
				TemplateStr=Request.form("TemplateStr")(2)
				Set TempStr=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
				If Not TempStr.Loadxml(TemplateStr)  Then
					Errmsg=ErrMsg + "��̳��ҳģ��template.html(1)δ��ͨ��XMLУ��,�����±༭�޸�,ȷ������."
					Set TempStr=Nothing
					Dvbbs_error()
					Exit Sub
				End If
				TemplateStr=Request.form("TemplateStr")(4)
				Set TempStr=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
				If Not TempStr.Loadxml(TemplateStr)  Then
					Errmsg=ErrMsg + "��̳��ҳģ��template.html(3)δ��ͨ��XMLУ��,�����±༭�޸�,ȷ������."
					Set TempStr=Nothing
					Dvbbs_error()
					Exit Sub
				End If
			Case "page_query"
				TemplateStr=Request.form("TemplateStr")(1)
				Set TempStr=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument" & MsxmlVersion)
				If Not TempStr.Loadxml(TemplateStr) Then
					Errmsg=ErrMsg + "��̳��ҳģ��template.html(0)δ��ͨ��XMLУ��,�����±༭�޸�,ȷ������."
					Set TempStr=Nothing
					Dvbbs_error()
					Exit Sub
				End If
			Case "main_style"
				TemplateStr=Request.form("TemplateStr")(23)
				Set TempStr=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument" & MsxmlVersion)
				If Not TempStr.Loadxml(TemplateStr) Then
					Errmsg=ErrMsg + "��̳��ҳģ��Dvbbs.mainhtml(22)δ��ͨ��XMLУ��,�����±༭�޸�,ȷ������."
					Set TempStr=Nothing
					Dvbbs_error()
					Exit Sub
				End If
		End Select
	End If

	TemplateStr=""
	i=0
	Dim FileName
	FileName = page &"_"& typeList(stype)
	REM ��ȡ�����ֶ����� �� д��ģ���ļ� By Dv.����  2007-10-9
	For Each TempStr in Request.form("TemplateStr")
		Dvbbs.writeToFile FilePath & FileName &i&".htm",Replace(TempStr,Chr(13)&Chr(10)&Chr(13)&Chr(10),Chr(13)&Chr(10))
		Dvbbs.Name="tpl" & LCase(Replace(Replace(FilePath,"../",""),"/","\")&FileName&i)
		Dvbbs.RemoveCache
		i=i+1
	Next
	'Response.end
	If stype="3" Then
		Select Case Request("page")
			Case "page_dispbbs"
					Application.Lock
					Application.Contents.Remove(Dvbbs.CacheName & "_dispbbsemplate_"& Request("StyleID"))
					Application.unLock
			Case "page_index"
				Application.Lock
				Application.Contents.Remove(Dvbbs.CacheName & "_listtemplate_"& Request("StyleID"))
				Application.Contents.Remove(Dvbbs.CacheName & "_indextemplate_"& Request("StyleID"))
				Application.Contents.Remove(Dvbbs.CacheName & "_shownews_"&Request("StyleID"))
				Application.unLock
			Case "page_query"
					Application.Lock
					Application.Contents.Remove(Dvbbs.CacheName & "_querytemplate_"& Request("StyleID"))
					Application.unLock
			Case "main_style"
				RestoreBoardCache()
			Case Else
		End Select
	End If

	Select Case stype
		Case 1
			Dv_suc(page&"���԰��޸ĳɹ�!")
		Case 2
			Dv_suc(page&"ͼƬ��Դ�޸ĳɹ�!")
		Case 3
			Dv_suc(page&"�������޸ĳɹ�!")		
	End Select
	'���»��档�˴�����ģ�����ݱ仯��ʱ����Ҫ���µĴ��롣����©���������������ӡ�
	Dvbbs.Loadstyle()
End Sub

'Response.Write CountFilesNumber("../Resource/Style_1/","pub_html")
Rem ����ָ���ļ����� ��ͬǰ׺���ļ�����  By Dv.����  2007-10-9
Function CountFilesNumber(ByVal path,ByVal folderspec)
    Dim objfso,f,fc,i
    Set objfso=Dvbbs.iCreateObject("Scripting.FileSystemObject")
	path = Server.MapPath(path)
	Set f = objfso.getfolder(path) 

	For Each fc In f.Files
		fc = LCase(fc)
		folderspec = LCase(folderspec)
		path = LCase(path)

		fc=Replace(fc,path,"")		
		If InStr(fc,folderspec)=2 And Trim(Right(fc,4))=".htm" Then
			i=i+1
			'Response.Write fc & "----" & folderspec &"<br />"
		End If
	Next 

    CountFilesNumber = i
	Set fc = Nothing
    Set f = Nothing
    Set objfso=nothing
End Function
%>

<%footer()Rem End Html%>