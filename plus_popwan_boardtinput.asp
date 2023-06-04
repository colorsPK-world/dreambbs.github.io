<!--#include file="Conn.asp"-->
<!-- #include file="inc/const.asp" -->
<%
Dvbbs.LoadTemplates("")
Dvbbs.ErrType = 1	'转到不显示顶部和导航的错误显示页
Dvbbs.Head()

	If Not (Dvbbs.master Or Dvbbs.GroupSetting(70)="1") Then
		Dvbbs.AddErrcode(28)
		Dvbbs.ShowErr()
	End If

Dim action

Dim G_CurrentFolder,G_Msg
G_CurrentFolder = "Plus_popwan/DefaultInput/board/"

action = Request("action")

info()

Select Case action
	Case "add" : add()
	Case "edit" : edit()
	Case "save" : save()
	Case "del" : del()
	Case "demo" : demo()
	Case Else
		Call main()
End Select

Dvbbs.ActiveOnline()
Dvbbs.Footer()
Dvbbs.PageEnd()


Sub info()
%>
<br/>
<div class="tableborder" style="width:97%;">导航：<a href="?action=add">添加模板</a> | <a href="plus_popwan_boardtinput.asp">模板列表</a></div>
<br/>
<%
End Sub

Sub add()
%>
<form action="?act=add&action=save" method="post" name="theform">
<table class="tableborder" cellspacing="1">
	<tr><th colspan="2">新建模板</th></tr>
	<tr>
		<td width="20%">文件名</td>
		<td><input type="text" name="f_name" size="35"><font color="red">*</font>格式：英文+数字+下划线&nbsp;如：abc_123</td>
	</tr>
	<tr>
		<td>论坛名称</td>
		<td><input type="text" name="boardtype" size="35"></td>
	</tr>
	<tr>
		<td>版面说明</td>
		<td><textarea name="Readme" cols="80" rows="5"></textarea></td>
	</tr>
	<tr>
		<td>版面规则</td>
		<td><textarea name="Rules" cols="80" rows="5"></textarea></td>
	</tr>
	<tr>
		<td>首页显示论坛图片</td>
		<td><input type="text" name="indexIMG" size="35"></td>
	</tr>
	<tr>
		<td>URL外部连接</td>
		<td><input type=text name="Board_Setting_50" value="0" size="50"></td>
	</tr>
	<tr> 
		<td height="24">&nbsp;</td>
		<td><input type="submit" name="Submit" value="提交" class="button"></td>
	</tr>
</table>
</form>
<%
End Sub

Sub edit()
Dim f_name,Content
f_name = Replace(Request("f_name"),".html","")
If IsSafeParam(f_name,"^[a-zA-Z0-9_]+$") Then
	Content = Dvbbs.ReadTextFile(G_CurrentFolder&f_name&".html")
	Response.Write "<div style=""border:1px red solid;display : none;"">"&Content&"</div>" & vbNewLine
	%>
	<form action="?act=edit&action=save" method="post" name="theform">
	<table class="tableborder" cellspacing="1">
		<tr><th colspan="2">编辑模板：<%=f_name%></th></tr>
		<tr>
			<td width="20%">文件名</td>
			<td width="80%"><input type="text" name="f_name" size="35" value="<%=f_name%>"><font color="red">*</font>格式：英文+数字+下划线&nbsp;如：abc_123</td>
			<input type="hidden" name="f_oldname" value="<%=f_name%>"/>
		</tr>
		<tr>
			<td>论坛名称</td>
			<td><input type="text" name="boardtype" size="35"></td>
		</tr>
		<tr>
			<td>版面说明</td>
			<td><textarea name="Readme" cols="80" rows="5"></textarea></td>
		</tr>
		<tr>
			<td>版面规则</td>
			<td><textarea name="Rules" cols="80" rows="5"></textarea></td>
		</tr>
		<tr>
			<td>首页显示论坛图片</td>
			<td><input type="text" name="indexIMG" size="35"></td>
		</tr>
		<tr>
			<td>URL外部连接</td>
			<td><input type=text name="Board_Setting_50" value="0" size="50"></td>
		</tr>
		<tr> 
			<td height="24">&nbsp;</td>
			<td><input type="submit" name="Submit" value="提交" class="button"></td>
		</tr>
	</table>
	</form>
	<script type="text/javascript" language="javascript">
	<!--
	document.theform.boardtype.value=document.getElementById('boardtype').innerHTML;
	document.theform.Readme.value=document.getElementById('readme').innerHTML;
	document.theform.Rules.value=document.getElementById('rules').innerHTML;
	document.theform.indexIMG.value=document.getElementById('indeximg').innerHTML;
	document.theform.Board_Setting_50.value=document.getElementById('board_setting_50').innerHTML;
	//-->
	</script>
	<%
Else
	G_Msg = "传递过来的参数不规范。无法读取模板文件。"
	Response.Redirect "showerr.asp?ErrCodes=<li>"& G_Msg &"&action=NoHeadErr"
	Exit Sub
End If
End Sub

Sub save()
	Dim demo,demo_head,demo_content,demo_foot
	
	demo_head = "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">" & vbNewLine
	demo_head = demo_head & "<html xml:lang=""zh-CN"" lang=""zh-CN"" xmlns=""http://www.w3.org/1999/xhtml"">" & vbNewLine
	demo_head = demo_head & "<head>" & vbNewLine
	demo_head = demo_head & "<meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312"" />" & vbNewLine
	demo_head = demo_head & "<title>demo</title>" & vbNewLine
	demo_head = demo_head & "<meta name=""MSSmartTagsPreventParsing"" content=""TRUE"" />" & vbNewLine
	demo_head = demo_head & "<meta http-equiv=""MSThemeCompatible"" content=""Yes"" />" & vbNewLine
	demo_head = demo_head & "</head>" & vbNewLine
	demo_head = demo_head & "<body>" & vbNewLine
	demo_head = demo_head & "<form id=""demoform"" name=""demoform"">" & vbNewLine

	demo_content = "<div id=""boardtype"">"& Request("boardtype") &"</div>" & vbNewLine
	demo_content = demo_content & "<div id=""readme"">"& Request("Readme") &"</div>" & vbNewLine
	demo_content = demo_content & "<div id=""rules"">"& Request("Rules") &"</div>" & vbNewLine
	demo_content = demo_content & "<div id=""indeximg"">"& Request("indexIMG") &"</div>" & vbNewLine
	demo_content = demo_content & "<div id=""board_setting_50"">"& Request("Board_Setting_50") &"</div>" & vbNewLine

	demo_foot = "</form>" & vbNewLine
	demo_foot = demo_foot & "</body>" & vbNewLine
	demo_foot = demo_foot & "</html>"

	demo = demo_head & demo_content & demo_foot
	savetofile demo
End Sub
Sub savetofile(content)
	Dim sLabelName, sLabelOldName, act
	act = Request("act")
	sLabelName=Replace(request("f_name"),".html","")
	sLabelOldName=Replace(request("f_oldname"),".html","")
	G_Msg=""
	If IsSafeParam(sLabelName,"^[a-zA-Z0-9_]+$") Then
		If act="add" Then
			If FileIsExist(G_CurrentFolder&sLabelName&".html") Then G_Msg="该模板名已存在，请修改模板名后重新提交。"
		Else
			If sLabelOldName<>"" And sLabelOldName<>sLabelName Then 
				If FileIsExist(G_CurrentFolder&sLabelName&".html") Then
					G_Msg="您试图修改模板名，但是该模板名已存在，请修改后重新提交。"
				Else
					If Not FileReName(G_CurrentFolder&sLabelOldName&".html", sLabelName&".html") Then 
						G_Msg="您试图修改模板名，但是没有成功。可能是权限不够。"
					End If
				End If 
			End If 
		End If
		If ""=G_Msg Then 
			On Error Resume Next
			Dvbbs.WriteToFile G_CurrentFolder&sLabelName&".html", Content
			If Err Then
				Err.Description
				Response.End
				Err.Clear
				G_Msg="模板保存失败。可能您的文件夹（Plus_popwan/DefaultInput/board）及其子目录没有写入和修改权限。"
			Else
				G_Msg="恭喜，模板保存成功！"
			End If
			Dvbbs.Dvbbs_suc(G_Msg)
		Else
			Response.Redirect "showerr.asp?ErrCodes=<li>"& G_Msg &"&action=NoHeadErr"
			Exit Sub
		End If
	Else
		G_Msg="模板名不规范。模板名只能由字母、数字和下划线组成。请修改后重新提交。"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& G_Msg &"&action=NoHeadErr"
		Exit Sub
	End If
End Sub

Sub main()
	ListLabelFolder(G_CurrentFolder)
End Sub
Sub ListLabelFolder(sLabelPath)
Dim Fso, Folder, File, G_i
Set Fso	= CreateFSO()
sLabelPath = Server.MapPath(sLabelPath)

Set Folder = Fso.GetFolder(sLabelPath)
%>
<table class="tableborder" cellspacing="1">
	<tr><th colspan="2">模板列表</th></tr>
<%
	For Each File In Folder.Files
		G_i = G_i + 1
		response.write "<tr><td>" & File.name & "</td>" & vbNewLine
		Response.Write "<td><a href=""javascript:;"" onclick=""fillform('"&G_CurrentFolder&File.name&"','"&File.name&"')"">填写</a> | <a href='?action=edit&f_name="&File.name&"'>编辑</a> | <a href='?action=del&f_name="&File.name&"' onclick='return confirm(""您确定要删除"&File.name&"模板吗？删除之后不能恢复。"")'>删除</a></td></tr>" & vbNewLine
	Next 
	Set File = Nothing 
	Set Fso	= Nothing 
	If 0=G_i Then
		response.write "<tr><td colspan=""2"">暂未添加！</td></tr>"
	End If 
%>
</table>

<SCRIPT LANGUAGE="JavaScript">
<!--
	function fillform(path,file){
		var a=document.createElement("iframe");
		a.id = file;
		a.name = file;
		a.scrolling = "no";
		a.src = path;
		a.style.display = 'none';
		document.body.appendChild(a);
		alert('添加完成');
		var b=document.getElementById(file);
		//b.contentWindow.document.location.reload();
		var boardtype = b.contentWindow.document.getElementById('boardtype');
		var readme = b.contentWindow.document.getElementById('readme');
		var rules = b.contentWindow.document.getElementById('rules');
		var indeximg = b.contentWindow.document.getElementById('indeximg');
		var board_setting_50 = b.contentWindow.document.getElementById('board_setting_50');
		//填写
		parent.document.theform.boardtype.value=boardtype.innerHTML;
		parent.document.theform.Readme.value=readme.innerHTML;
		parent.document.theform.Rules.value=rules.innerHTML;
		parent.document.theform.indexIMG.value=indeximg.innerHTML;
		parent.document.theform.Board_Setting_50.value=board_setting_50.innerHTML;
		wndClose();
	};
	function wndClose(){
		try{
			parent.DvWnd.close();
		}
		catch(e){
			window.close();
		}
	};
//-->
</SCRIPT>
<%
End Sub

'删除文件
Sub del()
	Dim Fso, sLabelName, sRealPath
	sLabelName=Replace(request("f_name"),".html","")
	If IsSafeParam(sLabelName,"^[a-zA-Z0-9_]+$") Then 
		On Error Resume Next 
		sRealPath=Server.MapPath(G_CurrentFolder&sLabelName&".html")
		Set Fso=CreateFSO()
		If Fso.FileExists(sRealPath) Then
			Fso.DeleteFile sRealPath,True
			If Err Then
				Err.Clear
				G_Msg="在删除文件时发生错误，可能是没有足够的权限。请到空间上手动删除此文件。"
			Else
				G_Msg="成功删除文件："&sLabelName&""
			End If
		Else
			G_Msg="文件没有找到。可能已经被删除，或者没有足够的权限。"
		End If 
		Set Fso=Nothing
	Else
		G_Msg = "传递过来的路径因为安全原因被禁止。请到空间上手动删除该文件。"
		Response.Redirect "showerr.asp?ErrCodes=<li>"& G_Msg &"&action=NoHeadErr"
		Exit Sub
	End If
	Dvbbs.Dvbbs_suc(G_Msg)
End Sub


Function CreateFSO()
	On Error Resume Next 
	Set CreateFSO = Dvbbs.iCreateObject("Scripting.FileSystemObject")
	If Err Then 
		Err.Clear
		response.write "您的空间不支持FSO，或者FSO对象名由于安全原因被更改过，请与空间商联系！"
		response.End 
	End If
End Function

Function FileIsExist(Path)
	Dim Fso:FileIsExist=False 
	On Error Resume Next 
	Set Fso=CreateFSO()
	If Fso.FileExists(Server.MapPath(Path)) Then FileIsExist=True 
	Set Fso=Nothing 
End Function

Function FileReName(Path,NewName)
	Dim Fso,File
	FileReName=False 
	On Error Resume Next 
	Set Fso=CreateFSO()
	Set File=Fso.GetFile(Server.MapPath(Path))
	File.name=NewName
	Set File=Nothing 
	Set Fso=Nothing 
	FileReName=True 
End Function

Function IsSafeParam(Path,Param)
	Dim re
	IsSafeParam=False 
	Set re=new RegExp
	re.IgnoreCase =True
	re.Global=True
	re.Pattern=Param
	IsSafeParam=re.Test(Path)
	Set Re=Nothing
End Function
%>