<!--#include file="conn.asp"-->
<!--#include file="inc/Const.asp"-->
<!--#include file="inc/md5.asp"-->
<!--#include file="boke/config.asp"-->
<!--#include file="boke/checkinput.asp"-->
<%
Dim ErrMsg
If not Dvbbs.master or  Instr(","&session("flag")&",",",38,")=0 Then Response.Redirect "index.asp"
'Set MyBoardOnline=new Cls_UserOnlne 
'Dvbbs.GetForum_Setting
'Dvbbs.CheckUserLogin
'Response.Write "test"
'DvBoke.Execute("update Dv_Boke_user set SysCatID=1 where SysCatID=0")
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta name=keywords content="动网先锋,动网论坛,dvbbs,博客,blog,boke">
<title>动网博客系统管理页面</title>
<link rel="stylesheet" type="text/css" href="<%=Dvbbs.CacheData(33,0)%>skins/css/main.css" />

<SCRIPT LANGUAGE="JavaScript">
<!--
function alertreadme(str,url){
{if(confirm(str)){
location.href=url;
return true;
}return false;}
}
//-->
</SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0"  align=center class="tableBorder">
<tr> 
<th width="100%" colspan=2 height=25>动网博客系统管理
</th>
</tr>
<tr>
<td class="td1" colspan=2>
<p><B>注意</B>：
<BR>① 删除博客系统栏目或话题前请先将其中文章、评论和用户转移到其他栏目或分栏中，不需要的文章或评论可在信息管理中批量删除
<BR>② 删除用户博客栏目前请先将其中文章和评论转移到该用户的其它栏目后再执行删除操作
</td>
</tr>
<tr>
<td class="td2" height=25>
<B>管理操作选项</B></td>
<td class="td2"><a href="?s=8">设置</a> | 
<a href="?s=1&t=1">栏目</a> | <a href="?s=1&t=2">话题</a> | <a href="?s=2">用户管理</a> | <a href="?s=3">用户栏目</a> | <a href="?s=4">公告管理</a> | <a href="?s=5">上传管理</a> | <a href="?s=6">关键字</a> | <a href="?s=7">模板</a> | <a href="?s=9">数据更新</a>
</td>
</tr>
</table>
<p></p>
<%
Select Case Request("s")
Case "1"
	Boke_SysCat()
Case "2"
	Boke_User()
Case "3"
	Boke_UserCat()
Case "4"
	Boke_SysNews()
Case "5"
	Boke_UploadFile()
Case "6"
	Boke_KeyWord()
Case "7"
	Boke_Skins()
Case "8"
	Boke_Setting()
Case "9"
	Boke_Update()
Case Else
	Boke_Setting()
End Select
Dvbbs.PageEnd()
Sub Boke_UploadFile()
	Dim FID,Sql,Rs
	If Request.QueryString("act")="del" Then
		Dim FileSize,SpaceSize,objFSO,FilePath,ViewPath
		FID = DvBoke.CheckNumeric(Request("fid"))
		If FID = 0 Then
			ErrMsg = "文件参数错误，请重新选取正确的文件再进行操作!"
			Dvbbs_error()
			Exit Sub
		End If
		Set Rs = DvBoke.Execute("Select ID,BokeUserID,UserID,UserName,CatID,sType,TopicID,PostID,IsTopic,Title,FileName,sFileName,FileType,FileSize,FileNote,DownNum,ViewNum,DateAndTime,PreviewImage,IsLock From Dv_Boke_Upfile where id="&FID)
		If Not Rs.Eof THen
			FileSize = Formatnumber((Rs("FileSize")/1024)/1024,2)
			ViewPath = Rs("PreviewImage")
			FilePath = Rs("FileName")
			If Not FilePath = "" Then
				FilePath = DvBoke.System_UpSetting(19)&FilePath
			End If
			SpaceSize = DvBoke.Execute("Select SpaceSize From Dv_Boke_User where UserID="&Rs("BokeUserID"))(0)
			If SpaceSize>0 Then
				SpaceSize = SpaceSize - FileSize
				If SpaceSize<0 Then SpaceSize = 0
				DvBoke.Execute("Update Dv_Boke_User set SpaceSize = "&SpaceSize&" where UserID="&Rs("BokeUserID"))
			End If
			DvBoke.Execute("delete from Dv_Boke_Upfile where id="&FID)
			Set objFSO = Dvbbs.iCreateObject("Scripting.FileSystemObject")
			If ViewPath<>"" Then
				If objFSO.FileExists(Server.MapPath(ViewPath)) Then
					objFSO.DeleteFile(Server.MapPath(ViewPath))
				End If
			End If
			If objFSO.FileExists(Server.MapPath(FilePath)) Then
				objFSO.DeleteFile(Server.MapPath(FilePath))
			End If
			Set objFSO = Nothing
		End If
		Dv_suc("文件已成功删除！")
		Exit Sub
	End If
%>
	<table width="100%" border="0" cellspacing="1" cellpadding="5"  align="center" class="tableBorder">
	<tr> 
	<th width="100%" height="25" align="left" ID="TableTitleLink">
	博客上传文件管理
	</th>
	</tr>
	<tr><td class="td1">说明：
	<ul>
	<li><font color="red">未知</font>文件:是指作者上传后未发表或未使用的文件。</li>
	</ul></td></tr>
	</table>

	<br/>
	<table width="100%" border="0" cellspacing="1" cellpadding="5"  align="center" class="tableBorder">
	<tr> 
	<th width="100%" colspan="5" height="25" align="left" ID="TableTitleLink">
	上传信息列表
	</th>
	</tr>
	<tr>
	<td class="bodytitle" height="24" width="15%">
	演示
	</td>
	<td class="bodytitle" height="24" width="35%">
	名称/ 路径
	</td>
	<td class="bodytitle" height="24" width="15%">
	作者
	</td>
	<td class="bodytitle" height="24" width="15%">
	上传时间
	</td>
	<td class="bodytitle" height="24" width="20%">
	操作
	</td>
	</tr>
<%
	
	Dim CurrentPage,Page_Count,Pcount,i
	Dim TotalRec,EndPage
	Dim ViewFile
	CurrentPage=Request("page")
	If CurrentPage="" Or Not IsNumeric(CurrentPage) Then
		CurrentPage=1
	Else
		CurrentPage=Clng(CurrentPage)
		If Err Then
			CurrentPage=1
			Err.Clear
		End If
	End If
	'ID=0 ,BokeUserID=1 ,UserID=2 ,UserName=3 ,CatID=4 ,sType=5 ,TopicID=6 ,PostID=7 ,IsTopic=8 ,Title=9 ,FileName=10 ,sFileName=11 ,FileType=12 ,FileSize=13 ,FileNote=14 ,DownNum=15 ,ViewNum=16 ,DateAndTime=17 ,PreviewImage=18 ,IsLock=19
	Sql = "Select ID,BokeUserID,UserID,UserName,CatID,sType,TopicID,PostID,IsTopic,Title,FileName,sFileName,FileType,FileSize,FileNote,DownNum,ViewNum,DateAndTime,PreviewImage,IsLock From Dv_Boke_Upfile order by ID Desc"
	If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase
	Set Rs=Dvbbs.iCreateObject("Adodb.RecordSet")
	Rs.Open Sql,Boke_Conn,1,1
	If Not (Rs.Eof And Rs.Bof) Then
		Rs.PageSize = 30
		Rs.AbsolutePage=CurrentPage
		Page_Count=0
		TotalRec=Rs.RecordCount
		While (Not Rs.Eof) And (Not Page_Count = 30)
		ViewFile = Rs(18)
		If ViewFile = "" Then
			ViewFile = DvBoke.System_UpSetting(19) & Rs(10)
		End If
%>
<tr>
<td class="td1">
<%
If Rs(12)=1 Then
	'修改图片路径为非父路径 2005-10-6 Dv.Yz
	Response.Write "<a href="""&DvBoke.System_UpSetting(19)&Rs(10)&""" target=""_blank""><img src="""&ViewFile&""" border=""1"" width=""80"" height=""60""></a>"
Else
	Response.Write "其它"
End If
%>
</td>
<td class="td1">
《<b><%=Rs(9)%></b>》
<br/><u><%=Rs(10)%></u>
</td>
<td class="td2">
<%=Rs(3)%>
</td>
<td class="td1">
<%=Rs(17)%>
</td>
<td class="td2">
<%If Rs(19)=4 Then%>
<font color="red">未知</font>
<%Else%>
<a href="Userid_<%=Rs(1)%>.showtopic.<%=Rs(6)%>.html" target="_blank">查看</a>
<%End If%>
| <a href="?s=5&act=del&fid=<%=Rs(0)%>">删除</a>
</td>
</tr>
<%
			Page_Count = Page_Count + 1
		Rs.MoveNext
		Wend
		Pcount=Rs.PageCount
%>
<tr><td colspan=5 class=td1>共有<%=TotalRec%>条记录，分页：
<%
	Dim Searchstr
	Searchstr = "?s=5"
	if currentpage > 4 then
		response.write "<a href="""&Searchstr&"&page=1"">[1]</a> ..."
	end if
	if Pcount>currentpage+3 then
		endpage=currentpage+3
	else
		endpage=Pcount
	end if
	for i=currentpage-3 to endpage
	if not i<1 then
		if i = clng(currentpage) then
        response.write " <font color=""red"">["&i&"]</font>"
		else
        response.write " <a href="""&Searchstr&"&page="&i&""">["&i&"]</a>"
		end if
	end if
	next
	if currentpage+3 < Pcount then 
		response.write "... <a href="""&Searchstr&"&page="&Pcount&""">["&Pcount&"]</a>"
	end if
%>
</td>
</tr>
<%
End If
Rs.Close
Set Rs = Nothing
%>
</table>
<%
End Sub


Sub Boke_Update()
	If Request.QueryString("t")<>"" Then
		Select Case Request.QueryString("t")
			Case "1"
				Boke_Update_Users()
			Case "2"
				Boke_Update_SysCats()
			Case "3"
				Boke_Update_ChatCats()
			Case "4"
				Boke_Update_System()
			Case "5"
				Boke_Update_UserInfo()
		End Select
		Exit Sub
	End If
%>
	<table width="100%" border="0" cellspacing="1" cellpadding="5"  align="center" class="tableBorder">
	<tr> 
	<th width="100%" colspan="2" height="25" align="left" ID="TableTitleLink">
	博客信息更新
	</th>
	</tr>
	<tr>
	<td class="td2" colspan="2">
	说明:
	</td>
	</tr>
	<tr>
	<td width="10%" class="td2">
	<input type="button" name="act" value="博客用户统计" class="button" onclick="location.href='?s=9&t=1'"/>
	</td>
	<td align="left" width="90%" class="td1">重新统计当前博客用户总数</td>
	</tr>
	<tr>
	<td width="10%" class="td2">
	<input type="button" name="act" value="博客索引数据统计" class="button" onclick="location.href='?s=9&t=2'"/>
	</td>
	<td align="left" width="90%" class="td1">重新统计当前博客索引用户数，帖子数信息</td>
	</tr>
	<tr>
	<td width="10%" class="td2">
	<input type="button" name="act" value="博客话题数据统计" class="button" onclick="location.href='?s=9&t=3'"/>
	</td>
	<td align="left" width="90%" class="td1">重新统计当前博客话题帖子数信息</td>
	</tr>
	<tr>
	<td width="10%" class="td2">
	<input type="button" name="act" value="博客总数据统计" class="button" onclick="location.href='?s=9&t=4'"/>
	</td>
	<td align="left" width="90%" class="td1">重新统计当前博客帖子数信息</td>
	</tr>
	<tr>
	<td width="10%" class="td2">
	<input type="button" name="act" value="博客用户数据总更新" class="button" onclick="location.href='?s=9&t=5'"/>
	</td>
	<td align="left" width="90%" class="td1">更新所有博客用户的相关数据,包括文章数、评论数以及博客用户首页缓存数据等</td>
	</tr>
	</table>
<%

End Sub

Sub Boke_Update_Users()
	Dim AllUsers
	AllUsers = DvBoke.Execute("Select Count(*) From Dv_Boke_User")(0)
	DvBoke.Execute("update Dv_Boke_System set S_UserNum = "&AllUsers)
	DvBoke.LoadSetup(1)
	Dv_suc("博客用户统计完成,当前共有"&AllUsers&"位博客用户!")
End Sub

Sub Boke_Update_SysCats()
	Dim SucMsg,Rs
	Dim uCatNum,TopicNum,PostNum,TodayNum,LastUpTime
	Dim Nodes,ChildNode
	Set Nodes = DvBoke.SysCat.selectNodes("rs:data/z:row")
	If Nodes.Length>0 Then
		For Each ChildNode in Nodes
			uCatNum = DvBoke.Execute("Select Count(*) From Dv_Boke_User where SysCatID="&ChildNode.getAttribute("scatid"))(0)
			TopicNum= DvBoke.Execute("Select Sum(TopicNum) From Dv_Boke_User where SysCatID="&ChildNode.getAttribute("scatid"))(0)
			PostNum= DvBoke.Execute("Select Sum(PostNum) From Dv_Boke_User where SysCatID="&ChildNode.getAttribute("scatid"))(0)
			TodayNum= DvBoke.Execute("Select Sum(TodayNum) From Dv_Boke_User where SysCatID="&ChildNode.getAttribute("scatid"))(0)
			Set Rs = DvBoke.Execute("Select top 1 LastUpTime From Dv_Boke_User where SysCatID="&ChildNode.getAttribute("scatid")&" order by LastUpTime desc")
			If Rs.Eof Then
				LastUpTime = Now()
			Else
				LastUpTime = Rs(0)
			End If
			Rs.Close
			If IsNull(TopicNum) Then
				TopicNum = 0
			End If
			If IsNull(PostNum) Then
				PostNum = 0
			End If
			If IsNull(TodayNum) Then
				TodayNum = 0
			End If
			DvBoke.Execute("update Dv_Boke_SysCat set uCatNum="&uCatNum&",TopicNum="&TopicNum&",PostNum="&PostNum&",TodayNum="&TodayNum&",LastUpTime='"&LastUpTime&"' where sCatID="&ChildNode.getAttribute("scatid"))
			SucMsg = SucMsg &"<li>"&ChildNode.getAttribute("scattitle")&" :共有"&uCatNum&"用户，"&TopicNum&"篇文章，"&PostNum&"篇评论，今日发表共"&TodayNum&"篇，最后更新时间："&LastUpTime&"</li>"
		Next
	End If
	DvBoke.LoadSetup(1)
	Dv_suc(SucMsg)
End Sub

Sub Boke_Update_ChatCats()
	Dim SucMsg,Rs,DayStr
	Dim TopicNum,PostNum,TodayNum,LastUpTime
	Dim Nodes,ChildNode
	If Dv_Boke_DataBase = 1 Then
		DayStr = "d"
	Else
		DayStr = "'d'"
	End If
	Set Nodes = DvBoke.SysChatCat.selectNodes("rs:data/z:row")
	If Nodes.Length>0 Then
		For Each ChildNode in Nodes
			TopicNum= DvBoke.Execute("Select Count(TopicID) From Dv_Boke_Topic where sCatID="&ChildNode.getAttribute("scatid"))(0)
			PostNum= DvBoke.Execute("Select Count(PostID) From Dv_Boke_Post where ParentID>0 and  sCatID="&ChildNode.getAttribute("scatid"))(0)
			TodayNum= DvBoke.Execute("Select Count(PostID) From Dv_Boke_Post where sCatID="&ChildNode.getAttribute("scatid")&" and DateDiff("&DayStr&",JoinTime,"&bSqlNowString&") = 0")(0)

			Set Rs = DvBoke.Execute("Select top 1 JoinTime From Dv_Boke_Post where sCatID="&ChildNode.getAttribute("scatid")&" order by JoinTime desc")
			If Rs.Eof Then
				LastUpTime = Now()
			Else
				LastUpTime = Rs(0)
			End If
			Rs.Close

			DvBoke.Execute("update Dv_Boke_SysCat set  TopicNum="&TopicNum&",PostNum="&PostNum&",TodayNum="&TodayNum&",LastUpTime='"&LastUpTime&"' where sCatID="&ChildNode.getAttribute("scatid"))
			SucMsg = SucMsg &"<li>"&ChildNode.getAttribute("scattitle")&" :"&TopicNum&"篇文章，"&PostNum&"篇评论，今日发表共"&TodayNum&"篇，最后更新时间："&LastUpTime&"</li>"
		Next
	End If
	DvBoke.LoadSetup(1)
	Dv_suc(SucMsg)
End Sub

Sub Boke_Update_System()
	Dim SucMsg,Rs,DayStr
	Dim S_LastPostTime,S_TopicNum,S_PhotoNum,S_FavNum,S_TodayNum,S_PostNum
	If Dv_Boke_DataBase = 1 Then
		DayStr = "d"
	Else
		DayStr = "'d'"
	End If
	S_TopicNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Topic] Where sType=0")(0)
	S_PhotoNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Topic] Where sType=4")(0)
	S_FavNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Topic] Where sType=1")(0)
	S_PostNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Post] Where ParentID>0")(0)
	S_TodayNum = DvBoke.Execute("Select Count(*) From [Dv_Boke_Post] Where DateDiff("&DayStr&",JoinTime,"&bSqlNowString&") = 0")(0)
	Set Rs = DvBoke.Execute("Select Top 1 JoinTime From [Dv_Boke_Post] order by JoinTime desc")
	If Rs.Eof Then
		S_LastPostTime = Now()
	Else
		S_LastPostTime = Rs(0)
	End If
	DvBoke.Execute("update Dv_Boke_System set S_LastPostTime='"&S_LastPostTime&"',S_TopicNum="&S_TopicNum&",S_PhotoNum="&S_PhotoNum&",S_FavNum="&S_FavNum&",S_TodayNum="&S_TodayNum&",S_PostNum="&S_PostNum)
	
	SucMsg = "<li>博客系统总信息： :文章共"&S_TopicNum&"篇，相册共"&S_PhotoNum&"篇，收藏共"&S_FavNum&"篇，评论共"&S_PostNum&"篇，今日发表共"&S_TodayNum&"篇，最后更新时间："&S_LastPostTime&"</li>"
	
	DvBoke.LoadSetup(1)
	Dv_suc(SucMsg)
End Sub

Sub Boke_Update_UserInfo()
	Dim BokeUserCount,Rs,i
	BokeUserCount = DvBoke.Execute("Select Count(*) From [Dv_Boke_User]")(0)
	If BokeUserCount = "" Or IsNull(BokeUserCount) Then Exit Sub
%>
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="tableBorder" align=center>
<tr><td colspan=2 class=td1>
下面开始更新论坛用户资料，预计本次共有<%=BokeUserCount%>个用户需要更新
<table width="100%" border="0" cellspacing="1" cellpadding="1">
<tr> 
<td bgcolor=000000>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr> 
<td bgcolor=ffffff height=9><img src="skins/default/bar/bar3.gif" width=0 height=16 id=img2 name=img2 align=absmiddle></td></tr></table>
</td></tr></table> <span id=txt2 name=txt2 style="font-size:9pt">0</span><span style="font-size:9pt">%</span></td></tr>
</table>
<%
	Dim uTopicNum,uFavNum,uPostNum,uTodayNum,uPhotoNum,uXmlData,DayStr,SucMsg,iBokeCat
	Dim Node,XmlDoc,NodeList,ChildNode,BokeBody
	Dim tRs,Sql
	Dim DvCode
	Set DvCode = New DvBoke_UbbCode
	If Dv_Boke_DataBase = 1 Then
		DayStr = "d"
	Else
		DayStr = "'d'"
	End If
	i = 0
	Set Rs = DvBoke.Execute("Select UserID,BokeName,XmlData From [Dv_Boke_User]")
	Do While Not Rs.Eof
		i = i + 1
		uTopicNum = DvBoke.Execute("Select Count(*) From Dv_Boke_Topic Where sType=0 And UserID = " & Rs(0))(0)
		uFavNum = DvBoke.Execute("Select Count(*) From Dv_Boke_Topic Where sType=1 And UserID = " & Rs(0))(0)
		uPhotoNum = DvBoke.Execute("Select Count(*) From Dv_Boke_Topic Where sType=4 And UserID = " & Rs(0))(0)
		uTodayNum = DvBoke.Execute("Select Count(*) From Dv_Boke_Post Where BokeUserID = " & Rs(0) & " And DateDiff("&DayStr&",JoinTime,"&bSqlNowString&") = 0")(0)
		uPostNum = DvBoke.Execute("Select Count(*) From Dv_Boke_Post Where ParentID>0 And BokeUserID = " & Rs(0))(0)
		'目前仅更新首页主题列表数据
		Set iBokeCat = Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
		If Rs(2)="" Or IsNull(Rs(2)) Then
			iBokeCat.Load(Server.MapPath(DvBoke.Cache_Path &"usercat.config"))
		Else
			If Not iBokeCat.LoadXml(Rs(2)) Then
				iBokeCat.Load(Server.MapPath(DvBoke.Cache_Path &"usercat.config"))
			End If
		End If
		Set Node = iBokeCat.selectNodes("xml/boketopic")
		If Not (Node Is Nothing) Then
			For Each NodeList in Node
				iBokeCat.DocumentElement.RemoveChild(NodeList)
			Next
		End If
		Set Node=iBokeCat.createNode(1,"boketopic","")
		Set XmlDoc=Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument")
		If Not IsNumeric(DvBoke.BokeSetting(6)) Then DvBoke.BokeSetting(6) = "10"
		Sql = "Select Top "&DvBoke.BokeSetting(6)&" TopicID,CatID,sCatID,UserID,UserName,Title,TitleNote,PostTime,Child,Hits,IsView,IsLock,sType,LastPostTime,IsBest,S_Key,Weather From [Dv_Boke_Topic] Where UserID="&Rs(0)&" and sType <>2 order by PostTime desc"
		Set tRs = DvBoke.Execute(LCase(Sql))
		If Not tRs.Eof Then
			tRs.Save XmlDoc,1
			XmlDoc.documentElement.RemoveChild(XmlDoc.documentElement.selectSingleNode("s:Schema"))
			Set ChildNode = XmlDoc.documentElement.selectNodes("rs:data/z:row")
			For Each NodeList in ChildNode
				If tRs("TitleNote")="" Or IsNull(tRs("TitleNote")) Then
					BokeBody = DvBoke.Execute("Select Content From Dv_Boke_Post Where ParentID=0 and Rootid="&tRs(0))(0)
					If Len(BokeBody) > 250 Then
						BokeBody = SplitLines(BokeBody,DvBoke.BokeSetting(2))
					End If
				Else
					BokeBody = tRs("TitleNote")
				End If
				BokeBody = DvCode.UbbCode(BokeBody) & "...<br/>[<a href=""boke.asp?"&Rs(1)&".showtopic."&tRs("TopicID")&".html"">阅读全文</a>]"
				NodeList.attributes.getNamedItem("titlenote").text = BokeBody
				NodeList.attributes.getNamedItem("posttime").text = tRs("PostTime")
				NodeList.attributes.getNamedItem("lastposttime").text = tRs("LastPostTime")
				tRs.MoveNext
			Next
			Set ChildNode=XmlDoc.documentElement.selectSingleNode("rs:data")
			Node.appendChild(ChildNode)
		End If
		tRs.Close
		Set tRs = Nothing
		iBokeCat.documentElement.appendChild(Node)
		'End
		DvBoke.Execute("Update Dv_Boke_User set XmlData = '"&Replace(iBokeCat.documentElement.xml,"'","''")&"',TopicNum="&uTopicNum&",FavNum="&uFavNum&",PhotoNum="&uPhotoNum&",TodayNum="&uTodayNum&",PostNum="&uPostNum&" where UserID="&Rs(0))
		Response.Write "<script>img2.width=" & Fix((i/BokeUserCount) * 400) & ";" & VbCrLf
		Response.Write "txt2.innerHTML=""更新完"&Rs(1)&"的数据，正在更新下一个用户数据，" & FormatNumber(i/BokeUserCount*100,4,-1) & """;" & VbCrLf
		Response.Write "img2.title=""" & Rs(1) & "(" & i & ")"";</script>" & VbCrLf
		Response.Flush
	Rs.MoveNext
	Loop
	Rs.Close
	Set Rs=Nothing
	Response.Write "<script>img2.width=400;txt2.innerHTML=""100"";</script>"

	SucMsg = "<li>更新所有用户数据成功！</li>"	
	Dv_suc(SucMsg)
End Sub

Sub Boke_SysNews()
	Dim Bodystr,Bodystr1,Node,Node1,createCDATASection
	Set Node = DvBoke.SystemDoc.documentElement.selectSingleNode("/bokesystem/topnews")
	If Node Is Nothing Then
		Set Node = DvBoke.SystemDoc.createNode(1,"topnews","")
		DvBoke.SystemDoc.documentElement.appendChild(Node)
	End If
	Bodystr = Node.text
	Set Node1 = DvBoke.SystemDoc.documentElement.selectSingleNode("/bokesystem/managenews")
	If Node1 Is Nothing Then
		Set Node1 = DvBoke.SystemDoc.createNode(1,"managenews","")
		DvBoke.SystemDoc.documentElement.appendChild(Node1)
	End If
	Bodystr1 = Node1.text
	'Response.Write Bodystr1
	%>
	<table width="100%" border="0" cellspacing="1" cellpadding="5"  align="center" class="tableBorder">
	<tr> 
	<th width="100%" colspan="2" height="25" align="left" ID="TableTitleLink">
	首页公告信息
	</th>
	</tr>
	<%
	If Request.Form("act") = "save" Then
		Node.text = Request.Form("boketopnews")
		DvBoke.SaveSystemCache()
		Manage_Suc "您成功编辑了博客首页公告信息","2","?s=4"
	ElseIf Request.Form("act") = "save1" Then
		Node1.text = Request.Form("bokemanagenews")
		DvBoke.SaveSystemCache()
		Manage_Suc "您成功编辑了个人博客管理首页系统通知信息","2","?s=4"
	Else
	%>
	<form method="post" action="?s=4">
	<tr>
	<td class="td2" width="20%">
	编辑信息内容:
	</td>
	<td class="td2"width="80%">
	<input type="hidden" name="act" value="save">
	<textarea name="boketopnews" rows="0" cols="0" style="display:none;"><%=Server.Htmlencode(Bodystr)%></textarea>
	<iframe id="EditFrame" src="boke/edit_plus/FCKeditor/editor/fckeditor.html?InstanceName=boketopnews&Toolbar=Default" width="100%" height="200" frameborder="no" scrolling="no"></iframe>
	<input type="submit" value="提交更改" class="button">
	</td>
	</tr>
	</form>
	<tr> 
	<td width="100%" class="td1" colspan="2" height="25" align="left">&nbsp;
	</td>
	</tr>
	<tr> 
	<th width="100%" colspan="2" height="25" align="left" ID="TableTitleLink">
	个人博客管理首页系统通知
	</th>
	</tr>
	<form method="post" action="?s=4">
	<tr>
	<td class="td2" width="20%">
	编辑信息内容:
	</td>
	<td class="td2"width="80%">
	<input type="hidden" name="act" value="save1">
	<textarea name="bokemanagenews" rows="0" cols="0" style="display:none;"><%=Server.Htmlencode(Bodystr1)%></textarea>
	<iframe id="EditFrame" src="boke/edit_plus/FCKeditor/editor/fckeditor.html?InstanceName=bokemanagenews&Toolbar=Default" width="100%" height="200" frameborder="no" scrolling="no"></iframe>
	<input type="submit" value="提交更改" class="button">
	</td>
	</tr>
	</form>
	<%
	End If
	%>
	</table>
	<%
End Sub

Sub Boke_Skins()
Dim Rs,Sql
Dim S_ID,S_Name,S_Builder,S_Path,S_ViewPic,S_Info
S_ID = 0

If Request("act")="save" Then
	S_ID = DvBoke.CheckNumeric(Request.Form("S_ID"))
	If Request.Form("S_Name") = "" or Len(Request.Form("S_Name"))>50 Then
		ErrMsg = "模板名称不能为空或超出50个字符!"
		Dvbbs_error()
		Exit Sub
	End If
	If Request.Form("S_Path")="" or Len(Request.Form("S_Path"))>150 Then
		ErrMsg = "模板路径不能为空或超出150个字符!"
		Dvbbs_error()
		Exit Sub
	End If
	If Len(Request.Form("S_Info"))>250 Then
		ErrMsg = "模板信息及说明不能超出250个字符!"
		Dvbbs_error()
		Exit Sub
	End If
	Sql  = "Select S_ID,S_SkinName,S_Path,S_ViewPic,S_Info,S_Builder From Dv_Boke_Skins where S_ID="&S_ID
	If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase
	Set Rs=Dvbbs.iCreateObject("Adodb.RecordSet")
	Rs.Open Sql,Boke_Conn,1,3
	If Rs.Eof and Rs.Bof Then
		Rs.AddNew
	End If
	Rs("S_SkinName") = Request.Form("S_Name")
	Rs("S_Path") = Request.Form("S_Path")
	Rs("S_ViewPic") = Request.Form("S_ViewPic")
	Rs("S_Info") = Request.Form("S_Info")
	Rs("S_Builder") = Request.Form("S_Builder")
	Rs.Update
	Rs.Close
	Set Rs = Nothing
	Dv_suc("模板数据保存成功")
	Exit Sub
ElseIf Request("act") = "edit" Then
	S_ID = DvBoke.CheckNumeric(Request("S_ID"))
	If S_ID>0 Then
		Sql  = "Select S_ID,S_SkinName,S_Path,S_ViewPic,S_Info,S_Builder From Dv_Boke_Skins where S_ID="&S_ID
		Set Rs = DvBoke.Execute(Sql)
		If Not Rs.Eof Then
			S_ID = Rs(0)
			S_Name = Rs(1)
			S_Builder = Rs(5)
			S_Path = Rs(2)
			S_ViewPic = Rs(3)
			S_Info = Rs(4)&""
		End If
		Rs.Close
		Set Rs = Nothing
	End If
ElseIf Request("act") = "addsys" Then
	S_ID = DvBoke.CheckNumeric(Request("S_ID"))
	If S_ID>0 Then
		Sql  = "Select S_ID,S_SkinName From Dv_Boke_Skins where S_ID="&S_ID
		Set Rs = DvBoke.Execute(Sql)
		If Not Rs.Eof Then
			S_Name = Rs(1)
			DvBoke.Execute("Update Dv_Boke_System Set SkinID = "&S_ID)
			DvBoke.LoadSetup(1)
			Dv_suc("已将模板["& S_Name &"]设为系统默认模板!")
		End If
		Rs.Close
		Set Rs = Nothing
		Exit Sub
	End If
ElseIf Request("act")="del" Then
	Dim NewS_ID
	S_ID = DvBoke.CheckNumeric(Request("S_ID"))
	If S_ID>0 Then
		If Clng(DvBoke.System_Node.getAttribute("skinid")) = S_ID Then
			ErrMsg = "不能删除系统默认模板，请重新选取!"
			Dvbbs_error()
			Exit Sub
		End If
		Sql  = "Select S_ID,S_SkinName From Dv_Boke_Skins where S_ID="&S_ID
		Set Rs = DvBoke.Execute(Sql)
		If Not Rs.Eof Then
			S_Name = Rs(1)
			NewS_ID = DvBoke.Execute("Select Top 1 S_ID From Dv_Boke_Skins Order by S_ID")(0)
			If NewS_ID>0 Then
				DvBoke.Execute("Update Dv_Boke_User Set SkinID = "&NewS_ID&" where SkinID="&S_ID)
				DvBoke.Execute("Delete from Dv_Boke_Skins where S_ID="&S_ID)
				Dv_suc("模板["& S_Name &"]删除成功!")
			Else
				ErrMsg = "请添加可用模板后再进行删除操作!"
				Dvbbs_error()
			End If
		Else
			ErrMsg = "模板的不存在，删除失败!"
			Dvbbs_error()
		End If
		Rs.Close
		Set Rs = Nothing
	Else
		ErrMsg = "模板的参数错误，删除失败!"
		Dvbbs_error()
	End If
	Exit Sub
End If
%>
<table width="100%" border="0" cellspacing="1" cellpadding="5"  align="center" class="tableBorder">
<tr> 
<th width="100%" colspan="2" height="25" align="left" ID="TableTitleLink">
模板信息管理
</th>
</tr>
<form method="post" action="?s=7&act=save">
<tr>
<td class="td2" width="20%">模板名称</td>
<td class="td2"width="80%">
<input type="text" name="S_Name" value="<%=S_Name%>">
</td>
</tr>
<tr>
<td class="td2">提供者</td>
<td class="td2">
<input type="text" name="S_Builder" value="<%=S_Builder%>">
</td>
</tr>
<tr>
<td class="td2">模板路径</td>
<td class="td2">
<input type="text" name="S_Path" size="50" value="<%=S_Path%>">
</td>
</tr>
<tr>
<td class="td2">演示图片</td>
<td class="td2">
<input type="text" name="S_ViewPic" size="50" value="<%=S_ViewPic%>">
</td>
</tr>
<tr>
<td class="td2">信息及说明</td>
<td class="td2">
<textarea name="S_Info" rows="5" cols="50"><%=Server.Htmlencode(S_Info)%></textarea>
</td>
</tr>
<tr>
<td class="td2" colspan="2" align="center">
<input type="hidden" name="S_ID" value="<%=S_ID%>">
<input type="submit" value="保存" class="button">
</td>
</tr>
</form>
</table>
<br/>
<table width="100%" border="0" cellspacing="1" cellpadding="5"  align="center" class="tableBorder">
<tr> 
<th width="100%" colspan="5" height="25" align="left" ID="TableTitleLink">
模板信息列表
</th>
</tr>
<tr>
<td class="bodytitle" height="24" width="15%">
演示
</td>
<td class="bodytitle" height="24" width="20%">
名称/ 路径
</td>
<td class="bodytitle" height="24" width="15%">
提供者
</td>
<td class="bodytitle" height="24" width="30%">
信息及说明
</td>
<td class="bodytitle" height="24" width="20%">
操作
</td>
</tr>
<%
	
	Dim CurrentPage,Page_Count,Pcount,i
	Dim TotalRec,EndPage

	CurrentPage=Request("page")
	If CurrentPage="" Or Not IsNumeric(CurrentPage) Then
		CurrentPage=1
	Else
		CurrentPage=Clng(CurrentPage)
		If Err Then
			CurrentPage=1
			Err.Clear
		End If
	End If
	Sql = "Select S_ID,S_SkinName,S_Path,S_ViewPic,S_Info,S_Builder From Dv_Boke_Skins order by S_id Desc"
	If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase
	Set Rs=Dvbbs.iCreateObject("Adodb.RecordSet")
	Rs.Open Sql,Boke_Conn,1,1
	If Not (Rs.Eof And Rs.Bof) Then
		Rs.PageSize = 30
		Rs.AbsolutePage=CurrentPage
		Page_Count=0
		TotalRec=Rs.RecordCount
		While (Not Rs.Eof) And (Not Page_Count = 30)

%>
<tr>
<td class="td1">
<%
If Rs(3)<>"" Then
	Response.Write "<img src=""../"&Rs(3)&""" border=""1"" width=""80"" height=""60"">"
Else
	Response.Write "<img src=""../boke/images/viewskins_bck.png"" border=""1"" width=""80"" height=""60"">"
End If
%>
</td>
<td class="td1">
<b><%=Rs(1)%></b>
<br/><u><%=Rs(2)%></u>
</td>
<td class="td2">
<%=Rs(5)%>&nbsp;
</td>
<td class="td1">
<%=Rs(4)%>&nbsp;
</td>
<td class="td2">
<a href="?s=7&act=edit&s_id=<%=Rs(0)%>">编辑</a> | <a href="?s=7&act=del&s_id=<%=Rs(0)%>">删除</a>
 | 
<%If Clng(DvBoke.System_Node.getAttribute("skinid")) = Rs(0) Then%>
 <font color="red">系统默认</font>
<%Else%>
 <a href="?s=7&act=addsys&s_id=<%=Rs(0)%>">设为默认</a>
<%End If%>
</td>
</tr>
<%
			Page_Count = Page_Count + 1
		Rs.MoveNext
		Wend
		Pcount=Rs.PageCount
%>
<tr><td colspan=5 class=td1>共有<%=TotalRec%>条记录，分页：
<%
	Dim Searchstr
	Searchstr = "?s=7"
	if currentpage > 4 then
		response.write "<a href="""&Searchstr&"&page=1"">[1]</a> ..."
	end if
	if Pcount>currentpage+3 then
		endpage=currentpage+3
	else
		endpage=Pcount
	end if
	for i=currentpage-3 to endpage
	if not i<1 then
		if i = clng(currentpage) then
        response.write " <font color=""red"">["&i&"]</font>"
		else
        response.write " <a href="""&Searchstr&"&page="&i&""">["&i&"]</a>"
		end if
	end if
	next
	if currentpage+3 < Pcount then 
		response.write "... <a href="""&Searchstr&"&page="&Pcount&""">["&Pcount&"]</a>"
	end if
%>
</td>
</tr>
<%
End If
Rs.Close
Set Rs = Nothing
%>
</table>
<%
End Sub

'博客系统栏目管理
Sub Boke_SysCat()
	Dim Rs,i,TableClass,t,tStr
	t = Request("t")
	If t = "" Or Not IsNumeric(t) Then t = 1
	t = Cint(t)
	If t = 1 Then
		tStr = "栏目"
	Else
		tStr = "话题"
	End If
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0"  align=center class="tableBorder">
<tr> 
<th width="100%" colspan=6 height=25 align=left ID="TableTitleLink">&nbsp;&nbsp;博客系统<%=tStr%>管理 | <a href="?s=1&t=<%=t%>&Action=Add">添加<%=tStr%></a>
</th>
</tr>
<%
If Request("Action")="Add" Then
%>
<FORM METHOD=POST ACTION="?s=1&t=<%=t%>&Action=Save">
<tr align=center>
<td class="td2" height=24 colspan=6>
<B>添加博客系统<%=tStr%></B>
</td>
</tr>
<tr>
<td class="td1" height=24 width="35%" align=right>
<B><%=tStr%>名称</B>：
</td>
<td class="td1" width="65%">
<input type="text" name="Title" size="50">
</td>
</tr>
<tr>
<td class="td2" height=24 width="35%" align=right>
<B><%=tStr%>说明</B>：
</td>
<td class="td2" width="65%">
<textarea name="Note" cols="50" rows="5"></textarea>
</td>
</tr>
<tr align=center>
<td class="td1" height=24 colspan=6>
<input type=submit name=submit value="添加博客<%=tStr%>" class="button">
</td>
</tr>
</FORM>
<%
ElseIf Request("Action")="Save" Then
	If Request("Title")="" Then
		Manage_Err "请填写"&tStr&"的名称","6","?s=1&t="&t&""
		Exit Sub
	End If
	If t=1 Then
		DvBoke.Execute("Insert Into Dv_Boke_SysCat (sCatTitle,sCatNote) Values ('"&Replace(Request("Title"),"'","''")&"','"&Replace(Request("Note"),"'","''")&"')")
	Else
		DvBoke.Execute("Insert Into Dv_Boke_SysCat (sCatTitle,sCatNote,stype) Values ('"&Replace(Request("Title"),"'","''")&"','"&Replace(Request("Note"),"'","''")&"',1)")
	End If
	
	Manage_Suc "您成功添加了博客"&tStr&"","6","?s=1&t="&t&""
	DvBoke.LoadSetup(1)
ElseIf Request("Action")="Edit" Then
	If Request("ID") = "" Or Not IsNumeric(Request("ID")) Then
		Manage_Err "非法的"&tStr&"参数","6","?s=1&t="&t&""
		Exit Sub
	End If
	Set Rs = DvBoke.Execute("Select * From Dv_Boke_SysCat Where sCatID = " & Request("ID"))
	If Rs.Eof And Rs.Bof Then
		Manage_Err "非法的"&tStr&"参数","6","?s=1&t="&t&""
		Rs.Close
		Set Rs=Nothing
		Exit Sub
	End If
%>
<FORM METHOD=POST ACTION="?s=1&t=<%=t%>&Action=SaveEdit">
<input type=hidden value="<%=Request("ID")%>" name="ID">
<tr align=center>
<td class="td2" height=24 colspan=6>
<B>编辑博客系统<%=tStr%></B>
</td>
</tr>
<tr>
<td class="td1" height=24 width="35%" align=right>
<B><%=tStr%>名称</B>：
</td>
<td class="td1" width="65%">
<input type="text" name="Title" size="50" value="<%=Server.HtmlEncode(Rs("sCatTitle"))%>">
</td>
</tr>
<tr>
<td class="td2" height=24 width="35%" align=right>
<B><%=tStr%>说明</B>：
</td>
<td class="td2" width="65%">
<textarea name="Note" cols="50" rows="5"><%=Server.HtmlEncode(Rs("sCatNote")&"")%></textarea>
</td>
</tr>
<tr align=center>
<td class="td1" height=24 colspan=6>
<input type=submit name=submit value="编辑博客<%=tStr%>" class="button">
</td>
</tr>
</FORM>
<%
ElseIf Request("Action")="SaveEdit" Then
	If Request("Title")="" Then
		Manage_Err "请填写"&tStr&"的名称","6","?s=1&t="&t&""
		Exit Sub
	End If
	If Request("ID") = "" Or Not IsNumeric(Request("ID")) Then
		Manage_Err "非法的"&tStr&"参数","6","?s=1&t="&t&""
		Exit Sub
	End If
	DvBoke.Execute("Update Dv_Boke_SysCat Set sCatTitle='"&Replace(Request("Title"),"'","''")&"',sCatNote='"&Replace(Request("Note"),"'","''")&"' Where sCatID = " & Request("ID"))
	Manage_Suc "您成功编辑了博客"&tStr&"","6","?s=1&t="&t&""
	DvBoke.LoadSetup(1)
ElseIf Request("Action")="Del" Then
	If Request("ID") = "" Or Not IsNumeric(Request("ID")) Then
		Manage_Err "非法的"&tStr&"参数","6","?s=1&t="&t&""
		Exit Sub
	End If
	DvBoke.Execute("Delete From Dv_Boke_SysCat Where sCatID = " & Request("ID"))
	Manage_Suc "您成功删除了博客"&tStr&"","6","?s=1&t="&t&""
	DvBoke.LoadSetup(1)
Else
%>
<tr>
<td class="td1" colspan=6 height=25>
<B>说明</B>：点击用户数可查看此分栏的用户博客列表
</td>
</tr>
<tr align=center>
<td class="bodytitle" height=24>
<B><%=tStr%></B>
</td>
<td class="bodytitle">
<B>今日</B>
</td>
<td class="bodytitle">
<B>文章</B>
</td>
<td class="bodytitle">
<B>回复</B>
</td>
<td class="bodytitle">
<B>用户数</B>
</td>
<td class="bodytitle" align=left>
<B>操作</B>
</td>
</tr>
<%
	i = 0
	'TableClass = "td1"
	Set Rs=DvBoke.Execute("Select * From Dv_Boke_SysCat Where sType = "&t&"-1 Order By sCatID")
	Do While Not Rs.Eof
	If TableClass = "td2" Then
		TableClass="td1"
	Else
		TableClass="td2"
	End If
%>
<tr align=center>
<td class="<%=TableClass%>" height=24>
<%=Rs("sCatTitle")%>
</td>
<td class="<%=TableClass%>">
<%=Rs("TodayNum")%>
</td>
<td class="<%=TableClass%>">
<%=Rs("TopicNum")%>
</td>
<td class="<%=TableClass%>">
<%=Rs("PostNum")%>
</td>
<td class="<%=TableClass%>">
<%=Rs("uCatNum")%> 个
</td>
<td class="<%=TableClass%>" align=left>
<a href="?s=1&t=<%=t%>&Action=Edit&ID=<%=Rs("sCatID")%>">编辑</a> | 设置 | 
<%
	If Rs("uCatNum") = 0 And Rs("TopicNum") = 0 Then
%>
<a href=# onclick="alertreadme('删除将包括该<%=tStr%>的所有信息，确定删除吗?','?s=1&t=<%=t%>&Action=Del&ID=<%=Rs("sCatID")%>')">删除</a>
<%
	Else
%>
<a href=# onclick="alertreadme('该分栏含有用户博客，必须先删除其下属分栏方能删除本分栏！','#')">删除</a>
<%
	End If
%>
</td>
</tr>
<%
	Rs.MoveNext
	Loop
	Rs.Close
	Set Rs=Nothing
End If
%>
</table>
<%
End Sub

Sub Boke_KeyWord()
	Dim Rs,Sql,i,TableClass,KeyWord
	Dim CurrentPage,Page_Count,Pcount
	Dim TotalRec,EndPage
	Dim KeyID
	CurrentPage=Request("page")
	If CurrentPage="" Or Not IsNumeric(CurrentPage) Then
		CurrentPage=1
	Else
		CurrentPage=Clng(CurrentPage)
		If Err Then
			CurrentPage=1
			Err.Clear
		End If
	End If
	KeyWord = Dvbbs.CheckStr(Request("KeyWord"))
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0"  align=center class="tableBorder">
<tr> 
<th width="100%" colspan=4 height=25 align=left ID="TableTitleLink">&nbsp;&nbsp;博客系统关键字管理
</th>
</tr>
<FORM METHOD=POST ACTION="?s=6">
<tr>
<td class="td1" colspan=4 height=25>
<B>搜索</B>：<input type="text" value="<%=KeyWord%>" name="KeyWord">
<input type=submit name=submit value="查询" class="button">
可根据用户名、博客名、关键字、链接等模糊查询
</td>
</tr>
</FORM>
<%
If Request("Action")="Edit" Then
	If Request("KeyID") = "" Or Not IsNumeric(Request("KeyID")) Then
		Manage_Err "非法的关键字参数","4","?s=6"
		Exit Sub
	End If
	Set Rs = DvBoke.Execute("Select * From Dv_Boke_KeyWord Where KeyID = " & Request("KeyID"))
	If Rs.Eof And Rs.Bof Then
		Manage_Err "非法的关键字参数","4","?s=6"
		Rs.Close
		Set Rs=Nothing
		Exit Sub
	End If
%>
<FORM METHOD=POST ACTION="?s=6&Action=SaveEdit">
<input type=hidden value="<%=Request("KeyID")%>" name="KeyID">
<tr align=center>
<td class="td2" height=24 colspan=6>
<B>编辑博客系统用户关键字</B>
</td>
</tr>
<tr>
<td class="td1" height=24 width="35%" align=right>
<B>关 键 字</B>：
</td>
<td class="td1" width="65%">
<input type="text" name="KeyWord" size="50" value="<%=Server.HtmlEncode(Rs("KeyWord"))%>">
</td>
</tr>
<tr>
<td class="td1" height=24 width="35%" align=right>
<B>替换文本</B>：
</td>
<td class="td1" width="65%">
<input type="text" name="nKeyWord" size="50" value="<%=Server.HtmlEncode(Rs("nKeyWord"))%>">
</td>
</tr>
<tr>
<td class="td1" height=24 width="35%" align=right>
<B>链接地址</B>：
</td>
<td class="td1" width="65%">
<input type="text" name="LinkUrl" size="50" value="<%=Server.HtmlEncode(Rs("LinkUrl")&"")%>">
</td>
</tr>
<tr>
<td class="td1" height=24 width="35%" align=right>
<B>链接标题</B>：
</td>
<td class="td1" width="65%">
<input type="text" name="LinkTitle" size="50" value="<%=Server.HtmlEncode(Rs("LinkTitle")&"")%>">
<input type=checkbox name="NewWindows" value="<%=Rs("NewWindows")%>" <%If Rs("NewWindows")=1 Then Response.Write "checked"%>>
新窗口打开
</td>
</tr>
<tr align=center>
<td class="td1" height=24 colspan=6>
<input type=submit name=submit value="编辑博客关键字" class="button">
</td>
</tr>
</FORM>
<%
ElseIf Request("Action")="SaveEdit" Then
	Dim nKeyWord,LinkUrl,LinkTitle,NewWindows
	KeyID = Request.Form("KeyID")
	KeyWord = DvBoke.CheckStr(Request.Form("KeyWord"))
	nKeyWord = DvBoke.CheckStr(Request.Form("nKeyWord"))
	LinkUrl = DvBoke.CheckStr(Request.Form("LinkUrl"))
	LinkTitle = DvBoke.CheckStr(Request.Form("LinkTitle"))
	NewWindows = Request.Form("NewWindows")

	If KeyID = "" Or Not IsNumeric(KeyID) Then KeyID = 0
	KeyID = cCur(KeyID)
	If NewWindows = "" Or Not IsNumeric(NewWindows) Then NewWindows = 0
	NewWindows = Cint(NewWindows)
	If KeyWord = "" Or nKeyWord = "" Then
		Manage_Err "非法的关键字参数","4","?s=6"
		Exit Sub
	Else
		KeyWord = Server.HtmlEncode(KeyWord)
		nKeyWord = Server.HtmlEncode(nKeyWord)
	End If
	If LinkUrl <> "" Then LinkUrl = Server.HtmlEncode(Dv_FilterJS(LinkUrl))
	If LinkTitle <> "" Then LinkTitle = Server.HtmlEncode(Dv_FilterJS(LinkTitle))

	DvBoke.Execute("Update Dv_Boke_KeyWord Set KeyWord = '"&KeyWord&"',nKeyWord = '"&nKeyWord&"',LinkUrl = '"&LinkUrl&"',LinkTitle = '"&LinkTitle&"',NewWindows = "&NewWindows&" Where KeyID = " & KeyID)
	Manage_Suc "您成功编辑了博客关键字","4","?s=6"
ElseIf Request("Action")="Del" Then
	Dim iKeyID
	KeyID = Request.Form("KeyID")
	If KeyID = "" Then
		Manage_Err "非法的关键字ID","4","?s=6"
		Exit Sub
	End If
	iKeyID = Replace(Replace(KeyID,",","")," ","")
	If Not IsNumeric(iKeyID) Then
		Manage_Err "非法的关键字ID","4","?s=6"
		Exit Sub
	End If
	DvBoke.Execute("Delete From Dv_Boke_KeyWord Where KeyID In ("&KeyID&")")
	Manage_Suc "您成功删除了博客关键字","4","?s=6"
Else
%>
<tr align=center>
<td class="bodytitle" width="20%" height=24 align=left>
&nbsp;<B>用户</B>
</td>
<td class="bodytitle"  width="40%" align=left>
<B>关键字</B>
</td>
<td class="bodytitle"  width="30%" align=left>
<B>链接</B>
</td>
<td class="bodytitle"  width="10%" align=left>
<B>操作</B>
</td>
</tr>
<FORM METHOD=POST ACTION="?s=6&Action=Del">
<%
	If KeyWord <> "" Then
		Sql = "Select k.*,u.UserName,u.BokeName From Dv_Boke_KeyWord k Inner Join Dv_Boke_User u On k.UserID=u.UserID Where u.UserName Like '%"&KeyWord&"%' Or u.BokeName Like '%"&KeyWord&"%'  Or k.KeyWord Like '%"&KeyWord&"%' Or k.nKeyWord Like '%"&KeyWord&"%' Or k.LinkUrl Like '%"&KeyWord&"%' Or k.LinkTitle Like '%"&KeyWord&"%' Order By KeyID Desc"
	Else
		Sql = "Select k.*,u.UserName,u.BokeName From Dv_Boke_KeyWord k Inner Join Dv_Boke_User u On k.UserID=u.UserID Order By KeyID Desc"
	End If
	If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase
	Set Rs=Dvbbs.iCreateObject("Adodb.RecordSet")
	Rs.Open Sql,Boke_Conn,1,3
	If Not (Rs.Eof And Rs.Bof) Then
		Rs.PageSize = 30
		Rs.AbsolutePage=CurrentPage
		Page_Count=0
		TotalRec=Rs.RecordCount
		While (Not Rs.Eof) And (Not Page_Count = 30)
			If TableClass = "td2" Then
				TableClass="td1"
			Else
				TableClass="td2"
			End If
%>
<tr align=center>
<td class="<%=TableClass%>" height=24 align=left>
<%=Server.HtmlEncode(Rs("UserName"))%>(<%=Server.HtmlEncode(Rs("BokeName"))%>)
</td>
<td class="<%=TableClass%>" align=left>
<%=Server.HtmlEncode(Rs("KeyWord"))%>(<%=Server.HtmlEncode(Rs("nKeyWord"))%>)
</td>
<td class="<%=TableClass%>" align=left>
<a href="<%=Server.HtmlEncode(Rs("LinkUrl")&"")%>" target=_blank title="<%=Server.HtmlEncode(Rs("LinkTitle")&"")%>"><%=Server.HtmlEncode(Rs("LinkUrl")&"")%></a>
</td>
<td class="<%=TableClass%>" align=left>
<input type="checkbox" name="KeyID" value="<%=Rs("KeyID")%>">
<a href="?s=6&Action=Edit&KeyID=<%=Rs("KeyID")%>">编辑</a>
</td>
</tr>
<%
			Page_Count = Page_Count + 1
		Rs.MoveNext
		Wend
		Pcount=Rs.PageCount
%>
<tr><td colspan=3 class=td1 align=center>分页：
<%
	Dim Searchstr
	Searchstr = "?s=6&KeyWord=" & KeyWord
	if currentpage > 4 then
		response.write "<a href="""&Searchstr&"&page=1"">[1]</a> ..."
	end if
	if Pcount>currentpage+3 then
		endpage=currentpage+3
	else
		endpage=Pcount
	end if
	for i=currentpage-3 to endpage
	if not i<1 then
		if i = clng(currentpage) then
        response.write " <font color=red>["&i&"]</font>"
		else
        response.write " <a href="""&Searchstr&"&page="&i&""">["&i&"]</a>"
		end if
	end if
	next
	if currentpage+3 < Pcount then 
		response.write "... <a href="""&Searchstr&"&page="&Pcount&""">["&Pcount&"]</a>"
	end if
%>
</td>
<td align=left class=td1>
<input type=submit name=submit value="删除" class="button">
</td>
</tr>
</FORM>
<%
	End If
	Rs.Close
	Set Rs=Nothing
End If
%>
</table>
<%
End Sub

Sub Boke_UserCat()
	Dim Rs,Sql,i,TableClass,KeyWord
	Dim CurrentPage,Page_Count,Pcount
	Dim TotalRec,EndPage
	Dim KeyID
	CurrentPage=Request("page")
	If CurrentPage="" Or Not IsNumeric(CurrentPage) Then
		CurrentPage=1
	Else
		CurrentPage=Clng(CurrentPage)
		If Err Then
			CurrentPage=1
			Err.Clear
		End If
	End If
	KeyWord = Dvbbs.CheckStr(Request("KeyWord"))
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0"  align=center class="tableBorder">
<tr> 
<th width="100%" colspan=6 height=25 align=left ID="TableTitleLink">&nbsp;&nbsp;博客系统用户栏目管理
</th>
</tr>
<tr>
<td class="td1" colspan=6 height=25>
<B>说明</B>：点击栏目名称进入该栏目文章列表
</td>
</tr>
<FORM METHOD=POST ACTION="?s=3">
<tr>
<td class="td1" colspan=6 height=25>
<B>搜索</B>：<input type="text" value="<%=KeyWord%>" name="KeyWord">
<input type=submit name=submit value="查询" class="button">
可根据用户名、博客名、栏目名、栏目说明等模糊查询
</td>
</tr>
</FORM>
<%
If Request("Action")="Edit" Then
	If Request("ID") = "" Or Not IsNumeric(Request("ID")) Then
		Manage_Err "非法的关键字参数","6","?s=3"
		Exit Sub
	End If
	Set Rs = DvBoke.Execute("Select * From Dv_Boke_UserCat Where uCatID = " & Request("ID"))
	If Rs.Eof And Rs.Bof Then
		Manage_Err "非法的关键字参数","6","?s=3"
		Rs.Close
		Set Rs=Nothing
		Exit Sub
	End If
%>
<FORM METHOD=POST ACTION="?s=3&Action=SaveEdit">
<input type=hidden value="<%=Request("ID")%>" name="ID">
<tr align=center>
<td class="td2" height=24 colspan=6>
<B>编辑博客系统用户栏目</B>
</td>
</tr>
<tr>
<td class="td1" height=24 width="35%" align=right>
<B>栏目名称</B>：
</td>
<td class="td1" width="65%">
<input type="text" name="Title" size="50" value="<%=Server.HtmlEncode(Rs("uCatTitle"))%>">
</td>
</tr>
<tr>
<td class="td2" height=24 width="35%" align=right>
<B>栏目说明</B>：
</td>
<td class="td2" width="65%">
<textarea name="Note" cols="50" rows="5"><%=Server.HtmlEncode(Rs("uCatNote")&"")%></textarea>
</td>
</tr>
<tr align=center>
<td class="td1" height=24 colspan=6>
<input type=submit name=submit value="编辑用户博客栏目" class="button">
</td>
</tr>
</FORM>
<%
ElseIf Request("Action")="SaveEdit" Then
	If Request("Title")="" Then
		Manage_Err "请填写栏目的名称","6","?s=3"
		Exit Sub
	End If
	If Request("ID") = "" Or Not IsNumeric(Request("ID")) Then
		Manage_Err "非法的栏目参数","6","?s=3"
		Exit Sub
	End If
	DvBoke.Execute("Update Dv_Boke_UserCat Set uCatTitle='"&Replace(Request("Title"),"'","''")&"',uCatNote='"&Replace(Request("Note"),"'","''")&"' Where uCatID = " & Request("ID"))
	Manage_Suc "您成功编辑了博客栏目","6","?s=3"
ElseIf Request("Action")="Del" Then
	KeyID = Request("ID")
	If KeyID = "" Or Not IsNumeric(KeyID) Then
		Manage_Err "非法的栏目ID","4","?s=3"
		Exit Sub
	End If
	DvBoke.Execute("Delete From Dv_Boke_UserCat Where uCatID=" & KeyID)
	Manage_Suc "您成功删除了用户博客栏目","6","?s=3"
Else
%>
<tr align=center>
<td class="bodytitle" height=24 align=left>
&nbsp;<B>用户</B>
</td>
<td class="bodytitle" align=left>
<B>栏目名称</B>
</td>
<td class="bodytitle" align=left>
<B>今日</B>
</td>
<td class="bodytitle" align=left>
<B>文章</B>
</td>
<td class="bodytitle" align=left>
<B>评论</B>
</td>
<td class="bodytitle" align=left>
<B>操作</B>
</td>
</tr>
<FORM METHOD=POST ACTION="?s=6&Action=Del">
<%
	If KeyWord <> "" Then
		Sql = "Select k.*,u.UserName,u.BokeName From Dv_Boke_UserCat k Inner Join Dv_Boke_User u On k.UserID=u.UserID Where u.UserName Like '%"&KeyWord&"%' Or u.BokeName Like '%"&KeyWord&"%'  Or k.uCatTitle Like '%"&KeyWord&"%' Or k.uCatNote Like '%"&KeyWord&"%' Order By uCatID Desc"
	Else
		Sql = "Select k.*,u.UserName,u.BokeName From Dv_Boke_UserCat k Inner Join Dv_Boke_User u On k.UserID=u.UserID Order By uCatID Desc"
	End If
	If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase
	Set Rs=Dvbbs.iCreateObject("Adodb.RecordSet")
	Rs.Open Sql,Boke_Conn,1,3
	If Not (Rs.Eof And Rs.Bof) Then
		Rs.PageSize = 30
		Rs.AbsolutePage=CurrentPage
		Page_Count=0
		TotalRec=Rs.RecordCount
		While (Not Rs.Eof) And (Not Page_Count = 30)
			If TableClass = "td2" Then
				TableClass="td1"
			Else
				TableClass="td2"
			End If
%>
<tr align=center>
<td class="<%=TableClass%>" height=24 align=left>
<%=Server.HtmlEncode(Rs("UserName"))%>(<%=Server.HtmlEncode(Rs("BokeName"))%>)
</td>
<td class="<%=TableClass%>" align=left>
<%=Server.HtmlEncode(Rs("uCatTitle"))%>
</td>
<td class="<%=TableClass%>" align=left>
<%=Rs("TodayNum")%>
</td>
<td class="<%=TableClass%>" align=left>
<%=Rs("TopicNum")%>
</td>
<td class="<%=TableClass%>" align=left>
<%=Rs("PostNum")%>
</td>
<td class="<%=TableClass%>" align=left>
<a href="?s=3&Action=Edit&ID=<%=Rs("uCatID")%>">编辑</a> | 
<%
	If Rs("TopicNum") = 0 Then
%>
<a href=# onclick="alertreadme('删除将包括该栏目的所有信息，确定删除吗?','?s=3&Action=Del&ID=<%=Rs("uCatID")%>')">删除</a>
<%
	Else
%>
<a href=# onclick="alertreadme('该分栏含有用户博客文章，必须先删除或移动栏目内的文章方能删除本分栏！','#')">删除</a>
<%
	End If
%>
</td>
</tr>
<%
			Page_Count = Page_Count + 1
		Rs.MoveNext
		Wend
		Pcount=Rs.PageCount
%>
<tr><td colspan=6 class=td1 align=center>分页：
<%
	Dim Searchstr
	Searchstr = "?s=3&KeyWord=" & KeyWord
	if currentpage > 4 then
		response.write "<a href="""&Searchstr&"&page=1"">[1]</a> ..."
	end if
	if Pcount>currentpage+3 then
		endpage=currentpage+3
	else
		endpage=Pcount
	end if
	for i=currentpage-3 to endpage
	if not i<1 then
		if i = clng(currentpage) then
        response.write " <font color=red>["&i&"]</font>"
		else
        response.write " <a href="""&Searchstr&"&page="&i&""">["&i&"]</a>"
		end if
	end if
	next
	if currentpage+3 < Pcount then 
		response.write "... <a href="""&Searchstr&"&page="&Pcount&""">["&Pcount&"]</a>"
	end if
%>
</td>
</tr>
</FORM>
<%
	End If
	Rs.Close
	Set Rs=Nothing
End If
%>
</table>
<%
End Sub

Sub Boke_User()
	Dim Rs,Sql,i,TableClass,KeyWord
	Dim CurrentPage,Page_Count,Pcount
	Dim TotalRec,EndPage
	Dim ID,tRs
	CurrentPage=Request("page")
	If CurrentPage="" Or Not IsNumeric(CurrentPage) Then
		CurrentPage=1
	Else
		CurrentPage=Clng(CurrentPage)
		If Err Then
			CurrentPage=1
			Err.Clear
		End If
	End If
	KeyWord = Dvbbs.CheckStr(Request("KeyWord"))
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0"  align=center class="tableBorder">
<tr> 
<th width="100%" colspan=6 height=25 align=left ID="TableTitleLink">&nbsp;&nbsp;博客系统用户管理
</th>
</tr>
<FORM METHOD=POST ACTION="?s=2">
<tr>
<td class="td1" colspan=6 height=25>
<B>搜索</B>：<input type="text" value="<%=KeyWord%>" name="KeyWord">
<input type=submit name=submit value="查询" class="button">
可根据用户名、博客名、标题、说明等模糊查询
</td>
</tr>
</FORM>
<%
If Request("Action")="Edit" Then
	If Request("ID") = "" Or Not IsNumeric(Request("ID")) Then
		Manage_Err "非法的用户参数","6","?s=2"
		Exit Sub
	End If
	Set Rs=DvBoke.Execute("Select * From Dv_Boke_User Where UserID = " & Request("ID"))
%>
<tr>
<td class="td2" colspan=6 height=25>
<B>编辑博客用户资料</B> | <a href="<%=Dvbbs.CacheData(33,0)%>user.asp?action=modify&userid=<%=Request("ID")%>">点击编辑此用户论坛资料</a>
</td>
</tr>
<FORM METHOD=POST ACTION="?s=2&Action=SaveEdit">
<input type="hidden" name="ID" value="<%=Request("ID")%>">
<tr>
<td class="td1" height=25>
博客类别：
</td>
<td class="td1" colspan=5 height=25>
<Select Name="SysCatID" Size=1>
<%
	Set tRs=DvBoke.Execute("Select * From Dv_Boke_SysCat Order By sCatID")
	Do While Not tRs.Eof
		Response.Write "<Option value="""&tRs("sCatID")&""""
		If Rs("SysCatID")=tRs("sCatID") Then Response.Write " Selected"
		Response.Write ">"&tRs("sCatTitle")&"</Option>"
	tRs.MoveNext
	Loop
	tRs.Close
	Set tRs=Nothing
%>
</Select>
</td>
</tr>
<tr>
<td class="td1" height=25>
使用模板：
</td>
<td class="td1" colspan=5 height=25>
<Select Name="SkinID" Size=1>
<%
	Set tRs=DvBoke.Execute("Select * From Dv_Boke_Skins Order By s_ID")
	Do While Not tRs.Eof
		Response.Write "<Option value="""&tRs("s_ID")&""""
		If Rs("SkinID")=tRs("s_ID") Then Response.Write " Selected"
		Response.Write ">"&tRs("S_SkinName")&"</Option>"
	tRs.MoveNext
	Loop
	tRs.Close
	Set tRs=Nothing
%>
</Select>
</td>
</tr>
<tr>
<td class="td1" height=25 width="20%">
用户名：
</td>
<td class="td1" colspan=5 height=25>
<%=Rs("UserName")%>
</td>
</tr>
<tr>
<td class="td1" height=25>
博客名：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="BokeName" value="<%=Rs("BokeName")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
博客笔名：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="NickName" value="<%=Rs("NickName")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
博客密码：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="PassWord" value="">
如果不修改请留空
</td>
</tr>
<tr>
<td class="td1" height=25>
博客标题：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="BokeTitle" value="<%=Server.HtmlEncode(Rs("BokeTitle")&"")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
博客子标题：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="BokeChildTitle" value="<%=Server.HtmlEncode(Rs("BokeChildTitle")&"")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
博客公告：
</td>
<td class="td1" colspan=5 height=25>
<textarea name=BokeNote rows=4 cols=80><%=Server.HtmlEncode(Rs("BokeNote")&"")%></textarea>
</td>
</tr>
<tr>
<td class="td1" height=25>
开通时间：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="JoinBokeTime" value="<%=Rs("JoinBokeTime")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
今日信息数：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="TodayNum" value="<%=Rs("TodayNum")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
文章总数：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="TopicNum" value="<%=Rs("TopicNum")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
评论总数：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="PostNum" value="<%=Rs("PostNum")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
收藏总数：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="FavNum" value="<%=Rs("FavNum")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
相片总数：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="PhotoNum" value="<%=Rs("PhotoNum")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
TrackBacks数：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="TrackBacks" value="<%=Rs("TrackBacks")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
访问用户数：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="PageView" value="<%=Rs("PageView")%>">
</td>
</tr>
<tr>
<td class="td1" height=25>
空间大小：
</td>
<td class="td1" colspan=5 height=25>
<input type=text name="SpaceSize" value="<%=Rs("SpaceSize")%>">
-1 为不限制
</td>
</tr>
<tr>
<td class="td1" height=25>
</td>
<td class="td1" colspan=5 height=25>
<input type=submit name="submit" value="修改用户资料" class="button">
</td>
</tr>
</FORM>
<%
	Rs.Close
	Set Rs=Nothing
ElseIf Request("Action")="SaveEdit" Then
	If Request("SysCatID")="" Or Not IsNumeric(Request("SysCatID")) Or Request("SkinID")="" Or Not IsNumeric(Request("SkinID")) Or Request("TodayNum")="" Or Not IsNumeric(Request("TodayNum")) Or Request("TopicNum")="" Or Not IsNumeric(Request("TopicNum")) Or Request("PostNum")="" Or Not IsNumeric(Request("PostNum")) Or Request("FavNum")="" Or Not IsNumeric(Request("FavNum")) Or Request("PhotoNum")="" Or Not IsNumeric(Request("PhotoNum")) Or Request("TrackBacks")="" Or Not IsNumeric(Request("TrackBacks")) Or Request("PageView")="" Or Not IsNumeric(Request("PageView")) Or Request("SpaceSize")="" Or Not IsNumeric(Request("SpaceSize")) Or Request("JoinBokeTime")="" Or Not IsDate(Request("JoinBokeTime")) Then
		Manage_Err "非法的参数。请注意是否完整填写了信息，以及各项信息是否按正确的日期或数字格式填写。","6","?s=2"
		Exit Sub
	End If
	If Request("ID") = "" Or Not IsNumeric(Request("ID")) Then
		Manage_Err "非法的用户参数","6","?s=2"
		Exit Sub
	End If
	If Request("BokeName") = "" Then
		Manage_Err "请填写用户博客名称","6","?s=2"
		Exit Sub
	End If
	If Request("NickName") = "" Then
		Manage_Err "请填写用户博客笔名","6","?s=2"
		Exit Sub
	End If
	Dim NewPassWord
	If Request("PassWord") <> "" Then
		NewPassWord = MD5(Request("PassWord"),16)
	End If
	Sql = "Select * From Dv_Boke_User Where UserID = " & Request("ID")
	If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase
	Set Rs=Dvbbs.iCreateObject("Adodb.RecordSet")
	Rs.Open Sql,Boke_Conn,1,3
	If Not (Rs.Eof And Rs.Bof) Then
		Rs("BokeName")=Replace(Request("BokeName"),"'","")
		Rs("NickName")=Replace(Request("NickName"),"'","")
		Rs("BokeTitle")=Replace(Request("BokeTitle"),"'","")
		Rs("BokeChildTitle")=Replace(Request("BokeChildTitle"),"'","")
		Rs("BokeNote")=Replace(Request("BokeNote"),"'","")
		If NewPassWord<>"" Then Rs("PassWord")=NewPassWord
		Rs("SysCatID")=Request("SysCatID")
		Rs("SkinID")=Request("SkinID")
		Rs("TodayNum")=Request("TodayNum")
		Rs("TopicNum")=Request("TopicNum")
		Rs("PostNum")=Request("PostNum")
		Rs("FavNum")=Request("FavNum")
		Rs("PhotoNum")=Request("PhotoNum")
		Rs("TrackBacks")=Request("TrackBacks")
		Rs("PageView")=Request("PageView")
		Rs("SpaceSize")=Request("SpaceSize")
		Rs("JoinBokeTime")=Request("JoinBokeTime")
		Rs.Update
	End If
	Rs.Close
	Set Rs=Nothing
	Manage_Suc "您成功编辑了博客用户资料","6","?s=2"
ElseIf Request("Action")="Del" Then
	ID = Request("ID")
	If ID = "" Or Not IsNumeric(ID) Then
		Manage_Err "非法的用户参数","6","?s=2"
		Exit Sub
	End If
	Set Rs = DvBoke.Execute("Select SysCatID,TodayNum,TopicNum,PostNum,FavNum,PhotoNum From Dv_Boke_User Where UserID="&ID)
	If Rs.Eof Then
		Manage_Err "该用户已不存在","6","?s=2"
		Exit Sub
	Else
		DvBoke.Execute("Update Dv_Boke_SysCat Set uCatNum = uCatNum-1,TopicNum = TopicNum -"&Rs(2)&",PostNum = PostNum - "&Rs(3)&" Where sCatID=" & Rs(0))
		DvBoke.Execute("Update Dv_Boke_System Set S_UserNum = S_UserNum-1,S_TopicNum = S_TopicNum -"&Rs(2)&",S_PostNum = S_PostNum - "&Rs(3)&",S_PhotoNum = S_PhotoNum - "&Rs(5)&",S_FavNum = S_FavNum - "&Rs(4))
	End If
	Rs.Close
	Set Rs = Nothing

	'删除用户文章
	DvBoke.Execute("Delete From [Dv_Boke_Topic] Where UserID = "&ID)
	DvBoke.Execute("Delete From [Dv_Boke_Post] Where BokeUserID = "&ID)
	DvBoke.Execute("Delete From [Dv_Boke_Post] Where BokeUserID = "&ID)
	DvBoke.Execute("Delete From [Dv_Boke_Upfile] Where BokeUserID = "&ID)
	DvBoke.Execute("Delete From [Dv_Boke_KeyWord] Where UserID = "&ID)
	DvBoke.Execute("Delete From [Dv_Boke_UserCat] Where UserID = "&ID)
	DvBoke.Execute("Delete From [Dv_Boke_UserSave] Where UserID = "&ID)
	DvBoke.Execute("Delete From Dv_Boke_User Where UserID=" & ID)
	'删除用户上传目录
	Dim objFSO,UserFolder
	Set objFSO = Dvbbs.iCreateObject("Scripting.FileSystemObject")
	UserFolder = DvBoke.System_UpSetting(19) & ID
	If objFSO.FolderExists(Server.MapPath(UserFolder)) Then
		objFSO.DeleteFolder(Server.MapPath(UserFolder))
	End If
	Set objFSO = Nothing
	DvBoke.LoadSetup(1)
	Manage_Suc "您成功删除了博客用户","6","?s=2"
Else
%>
<tr align=center>
<td class="bodytitle" height=24 align=left>
&nbsp;<B>用户</B>
</td>
<td class="bodytitle" align=left>
<B>类别</B>
</td>
<td class="bodytitle" align=left>
<B>今日</B>
</td>
<td class="bodytitle" align=left>
<B>文章</B>
</td>
<td class="bodytitle" align=left>
<B>评论</B>
</td>
<td class="bodytitle" align=left>
<B>操作</B>
</td>
</tr>
<FORM METHOD=POST ACTION="?s=2&Action=Move">
<%
	If KeyWord <> "" Then
		Sql = "Select u.*,c.sCatTitle From Dv_Boke_User u Inner Join Dv_Boke_SysCat c On u.SysCatID=c.sCatID Where u.UserName Like '%"&KeyWord&"%' Or u.BokeName Like '%"&KeyWord&"%' Or u.BokeTitle Like '%"&KeyWord&"%' Or u.BokeChildTitle Like '%"&KeyWord&"%' Order By u.JoinBokeTime Desc"
	Else
		Sql = "Select u.*,c.sCatTitle From Dv_Boke_User u Inner Join Dv_Boke_SysCat c On u.SysCatID=c.sCatID Order By u.JoinBokeTime Desc"
	End If
	If Not IsObject(Boke_Conn) Then Boke_ConnectionDatabase
	Set Rs=Dvbbs.iCreateObject("Adodb.RecordSet")
	Rs.Open Sql,Boke_Conn,1,3
	If Not (Rs.Eof And Rs.Bof) Then
		Rs.PageSize = 30
		Rs.AbsolutePage=CurrentPage
		Page_Count=0
		TotalRec=Rs.RecordCount
		While (Not Rs.Eof) And (Not Page_Count = 30)
			If TableClass = "td2" Then
				TableClass="td1"
			Else
				TableClass="td2"
			End If
%>
<tr align=center>
<td class="<%=TableClass%>" height=24 align=left>
<%=Server.HtmlEncode(Rs("UserName"))%>(<%=Server.HtmlEncode(Rs("BokeName"))%>)
</td>
<td class="<%=TableClass%>" align=left>
<%=Server.HtmlEncode(Rs("sCatTitle"))%>
</td>
<td class="<%=TableClass%>" align=left>
<%=Rs("TodayNum")%>
</td>
<td class="<%=TableClass%>" align=left>
<%=Rs("TopicNum")%>
</td>
<td class="<%=TableClass%>" align=left>
<%=Rs("PostNum")%>
</td>
<td class="<%=TableClass%>" align=left>
<a href="?s=2&Action=Edit&ID=<%=Rs("UserID")%>">编辑</a> | 
<%
	If Rs("TopicNum") = 0 Then
%>
<a href=# onclick="alertreadme('删除将包括该用户的所有信息，确定删除吗?','?s=2&Action=Del&ID=<%=Rs("UserID")%>')">删除</a>
<%
	Else
%>
<a href=# onclick="alertreadme('该分栏含有用户文章，必须先删除或移动用户的文章方能删除本分栏！','#')">删除</a>
<%
	End If
%>
</td>
</tr>
<%
			Page_Count = Page_Count + 1
		Rs.MoveNext
		Wend
		Pcount=Rs.PageCount
%>
<tr><td colspan=6 class=td1 align=center>分页：
<%
	Dim Searchstr
	Searchstr = "?s=2&KeyWord=" & KeyWord
	if currentpage > 4 then
		response.write "<a href="""&Searchstr&"&page=1"">[1]</a> ..."
	end if
	if Pcount>currentpage+3 then
		endpage=currentpage+3
	else
		endpage=Pcount
	end if
	for i=currentpage-3 to endpage
	if not i<1 then
		if i = clng(currentpage) then
        response.write " <font color=red>["&i&"]</font>"
		else
        response.write " <a href="""&Searchstr&"&page="&i&""">["&i&"]</a>"
		end if
	end if
	next
	if currentpage+3 < Pcount then 
		response.write "... <a href="""&Searchstr&"&page="&Pcount&""">["&Pcount&"]</a>"
	end if
%>
</td>
</tr>
</FORM>
<%
	End If
	Rs.Close
	Set Rs=Nothing
End If
%>
</table>
<%
End Sub

Sub Boke_Setting()
	Dim i,Rs
	Dim Boke_Setting,UploadSetting
%>
<iframe width="260" height="165" id="colourPalette" src="images/post/nc_selcolor.htm" style="visibility:hidden; position: absolute; left: 0px; top: 0px;border:1px gray solid" frameborder="0" scrolling="no" ></iframe>
<table width="100%" border="0" cellspacing="0" cellpadding="0"  align=center class="tableBorder">
<tr> 
<th width="100%" colspan=6 height=25 align=left ID="TableTitleLink">&nbsp;&nbsp;博客系统设置
</th>
</tr>
<a name="top"></a>
<tr>
<td class="td1" colspan=6 height=25>
<a href="<%=Dvbbs.CacheData(33,0)%>setting.asp#settingxu">系统博客开关</a> | <a href="?s=8#setting1">基本信息</a> | <a href="?s=8#setting2">基本设置</a> | <a href="?s=8#setting3">上传设置</a> | <a href="?s=8&Action=Weather">天气设置</a>
</td>
</tr>
<%
If Request("Action")="Save" Then
	Dim BokeName,BokeUrl,BokeDomain
	Dim TempStr,iSetting
	BokeName = DvBoke.CheckStr(Request.Form("BokeName"))
	BokeUrl = DvBoke.CheckStr(Request.Form("BokeUrl"))
	BokeDomain = DvBoke.CheckStr(Request.Form("BokeDomain"))

	UploadSetting = ""
	For i=0 To 20
		Tempstr = Trim(Request.Form("UploadSetting("&i&")"))
		If Tempstr = "" Then
			UploadSetting = UploadSetting & 1
		Else
			UploadSetting = UploadSetting & Replace(Replace(Tempstr,"|",""),",","")
		End If
		If i<20 Then
			UploadSetting = UploadSetting & "|"
		End If
	Next

	If Request("t") = "1" Then
		UploadSetting = ""
		Dim iWeather_A,iWeather_B
		Dim TempStr_A,TempStr_B
		If Request("WeatherNum") <> "-1" Then
			For i = 0 To Request("WeatherNum")
				Tempstr_A = Trim(Request.Form("Weather_A("&i&")"))
				Tempstr_B = Trim(Request.Form("Weather_B("&i&")"))
				If Tempstr_A <> "" And Tempstr_B <> "" Then
					iWeather_A = iWeather_A & Replace(Replace(Tempstr_A,"|",""),",","")
					iWeather_B = iWeather_B & Replace(Replace(Tempstr_B,"|",""),",","")
				End If
				If i < cLng(Request("WeatherNum")) And Tempstr_A <> "" And Tempstr_B <> "" Then
					iWeather_A = iWeather_A & "|"
					iWeather_B = iWeather_B & "|"
				End If
			Next
		End If
		If Request("nWeather_A")<>"" And Request("nWeather_B")<>"" Then
			If iWeather_A <> "" Then
				iWeather_A = iWeather_A & "|" & Request("nWeather_A")
				iWeather_B = iWeather_B & "|" & Request("nWeather_B")
			Else
				iWeather_A = Request("nWeather_A")
				iWeather_B = Request("nWeather_B")
			End If
		End If
		For i = 0 To 100
			If Trim(Request.Form("Boke_Setting("&i&")"))="" Or i = 13 Or i = 14 Then
				iSetting=1
				If i=13 Then
					iSetting = iWeather_A
				End If
				If i=14 Then
					iSetting = iWeather_B
				End If
			Else
				iSetting=Replace(Trim(Request.Form("Boke_Setting("&i&")")),",","")
			End If
	
			If i = 0 Then
				Boke_Setting = iSetting
			Else
				Boke_Setting = Boke_Setting & "," & iSetting
			End If
		Next
	Else
		For i = 0 To 100
			If Trim(Request.Form("Boke_Setting("&i&")"))="" or i = 12 Then
				iSetting=1
				If i=12 Then
					iSetting = UploadSetting
				End If
			Else
				iSetting=Replace(Trim(Request.Form("Boke_Setting("&i&")")),",","")
			End If
	
			If i = 0 Then
				Boke_Setting = iSetting
			Else
				Boke_Setting = Boke_Setting & "," & iSetting
			End If
		Next
	End If

	Boke_Setting = DvBoke.CheckStr(Boke_Setting)

	'Response.Write Boke_Setting

	DvBoke.Execute("UpDate Dv_Boke_System Set s_name='"&BokeName&"',s_url='"&BokeUrl&"',s_sdomain='"&BokeDomain&"',s_setting='"&Boke_Setting&"'")
	DvBoke.LoadSetup(1)
	
	Manage_Suc "您成功编辑了博客系统设置","2","?s=8"
ElseIf Request("Action")="Weather" Then
	Set Rs=DvBoke.Execute("Select Top 1 * From Dv_Boke_System")
	Boke_Setting = Rs("S_Setting")
	If Boke_Setting = "" Or IsNull(Boke_Setting) Then Boke_Setting = "1,1,0,1,1,1,20,20,15,3,1,1,1|0|0|999|bbs.dvbbs.net|12|1|Arial|0|images/WaterMap.gif|0.7|110|35|4|120|100|1|1|1|Boke/UploadFile/|0,1,1,-1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
	Boke_Setting = Split(Boke_Setting,",")
	If Ubound(Boke_Setting) < 100 Then Boke_Setting = Split("1,1,0,1,1,1,20,20,15,3,1,1,1|0|0|999|bbs.dvbbs.net|12|1|Arial|0|images/WaterMap.gif|0.7|110|35|4|120|100|1|1|1|Boke/UploadFile/|0,1,1,-1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1",",")
	Dim Weather_A,Weather_B
	Weather_A = Split(Boke_Setting(13),"|")
	Weather_B = Split(Boke_Setting(14),"|")
%>
<FORM METHOD=POST ACTION="?s=8&Action=Save&t=1">
</table>
<BR>
<%
	For i = 0 To 12
		Response.Write "<input type=hidden value="""&Boke_Setting(i)&""" name=""Boke_Setting("&i&")"">" & Chr(13)
	Next
%>
<input type="hidden" name="BokeName" value="<%=Rs("s_name")%>">
<input type="hidden" name="BokeUrl" value="<%=Rs("s_url")%>">
<input type="hidden" name="BokeDomain" value="<%=Rs("s_sdomain")%>">
<input type="hidden" name="WeatherNum" value="<%=Ubound(Weather_A)%>">
<table border="0" cellspacing="1" cellpadding="3"  align=center class="tableBorder">
<tr> 
<th width="100%" colspan=3  align=Left id=tabletitlelink  height=25><b>博客天气设置</b>[<a href="#top">顶部</a>]
</th></tr>
<tr>
<td class="td1" colspan=6 height=25>
<B>注意</B>：天气图片默认位置于boke/images/weather/目录下，新增的天气请将相关图片置于此目录
</td>
</tr>
<%
	For i = 0 To Ubound(Weather_A)
%>
<tr> 
<td width="50%" class=td1> <U>天气信息</U></td>
<td width="50%" class=td1>  
<input type="text" name="Weather_A(<%=i%>)" size="15" value="<%=Weather_A(i)%>">
图片
<input type="text" name="Weather_B(<%=i%>)" size="15" value="<%=Weather_B(i)%>">
<img src="boke/images/weather/<%=Weather_B(i)%>">
</td>
</tr>
<%
	Next
%>
<tr> 
<td width="50%" class=td1> <U>新的天气</U></td>
<td width="50%" class=td1>  
<input type="text" name="nWeather_A" size="15" value="">
图片
<input type="text" name="nWeather_B" size="15" value="">
</td>
</tr>
<tr> 
<td class=td1>&nbsp;</td>
<td class=td1>
<input type=submit name=submit value="提交更改" class="button">
</td>
</tr>
</table>
</form>
<%
Else
	Set Rs=DvBoke.Execute("Select Top 1 * From Dv_Boke_System")
	Boke_Setting = Rs("S_Setting")
	If Boke_Setting = "" Or IsNull(Boke_Setting) Then Boke_Setting = "1,1,0,1,1,1,20,20,15,3,1,1,1|0|0|999|bbs.dvbbs.net|12|1|Arial|0|images/WaterMap.gif|0.7|110|35|4|120|100|1|1|1|Boke/UploadFile/|0,1,1,-1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
	Boke_Setting = Split(Boke_Setting,",")
	If Ubound(Boke_Setting) < 100 Then Boke_Setting = Split("1,1,0,1,1,1,20,20,15,3,1,1,1|0|0|999|bbs.dvbbs.net|12|1|Arial|0|images/WaterMap.gif|0.7|110|35|4|120|100|1|1|1|Boke/UploadFile/|0,1,1,-1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1",",")
	UploadSetting = Split(Boke_Setting(12),"|")
	If Ubound(UploadSetting) < 2 Then UploadSetting = Split("1|0|0|999|bbs.dvbbs.net|12|1|Arial|0|images/WaterMap.gif|0.7|110|35|4|120|100|1|1|1|Boke/UploadFile/|0","|")
%>
</table>
<FORM METHOD=POST ACTION="?s=8&Action=Save">
<a name="setting1"></a>
<BR>
<table border="0" cellspacing="1" cellpadding="3"  align=center class="tableBorder">
<tr> 
<th width="100%" colspan=3  align=Left id=tabletitlelink  height=25><b>基本信息</b>[<a href="#top">顶部</a>]
</th></tr>
<tr> 
<td width="50%" class=td1> <U>博客名称</U></td>
<td width="50%" class=td1>  
<input type="text" name="BokeName" size="35" value="<%=Rs("s_name")%>">
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>博客说明</U></td>
<td width="50%" class=td1>  
<textarea name="Boke_Setting(17)" cols="50" rows="3" ID="TDStopReadme"><%=Server.HtmlEncode(Boke_Setting(17)&"")%></textarea>
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>博客地址</U><BR>请填写完整URL地址，如http://www.dvbbs.net/boke/，<font color="red">不能省略最后的/号</font>，此设置将影响到Rss和Trackback的正常运行</td>
<td width="50%" class=td1>  
<input type="text" name="BokeUrl" size="35" value="<%=Rs("s_url")%>">
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>二级域名根</U><BR>请按照dvbbs.net这样的形式书写，如有多个二级域名，请用“|”隔开，<font color="red">如关闭二级域名，请留空</font><BR>此设置需系统支持，填写后请阅读博客系统设置文档进行相应配置<BR>该功能正常开启状态表现为博客用户可根据“用户博客标识.二级域名根”进入自己的博客，如：shatan.dvbbs.net<BR>如系统不支持二级域名设置，可以到 <a href="http://domain.iboker.com/reg.asp" target=_blank>domain.iboker.com</a> 免费申请</td>
<td width="50%" class=td1>  
<input type="text" name="BokeDomain" size="35" value="<%=Rs("s_sdomain")%>">
</td>
</tr>
</table>
<a name="setting2"></a>
<BR>
<table width="100%" border="0" cellspacing="1" cellpadding="3"  align=center class="tableBorder">
<tr> 
<th width="100%" colspan=3  align=Left id=tabletitlelink  height=25><b>基本设置</b>[<a href="#top">顶部</a>]
</th></tr>
<tr> 
<td width="50%" class=td1> <U>新用户申请</U></td>
<td width="50%" class=td1>  
<input type=radio class=radio name="Boke_Setting(0)" value=0 <%if Boke_Setting(0)="0" then%>checked<%end if%>>关闭&nbsp;
<input type=radio class=radio name="Boke_Setting(0)" value=1 <%if Boke_Setting(0)="1" then%>checked<%end if%>>开启&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>是否开启全文搜索（建议关闭）</U></td>
<td width="50%" class=td1>  
<input type=radio class=radio name="Boke_Setting(1)" value=0 <%if Boke_Setting(1)="0" then%>checked<%end if%>>关闭&nbsp;
<input type=radio class=radio name="Boke_Setting(1)" value=1 <%if Boke_Setting(1)="1" then%>checked<%end if%>>开启&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>游客发表评论</U></td>
<td width="50%" class=td1>  
<input type=radio class=radio name="Boke_Setting(2)" value=0 <%if Boke_Setting(2)="0" then%>checked<%end if%>>关闭&nbsp;
<input type=radio class=radio name="Boke_Setting(2)" value=1 <%if Boke_Setting(2)="1" then%>checked<%end if%>>开启&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>用户注册验证码</U></td>
<td width="50%" class=td1>  
<input type=radio class=radio name="Boke_Setting(3)" value=0 <%if Boke_Setting(3)="0" then%>checked<%end if%>>关闭&nbsp;
<input type=radio class=radio name="Boke_Setting(3)" value=1 <%if Boke_Setting(3)="1" then%>checked<%end if%>>开启&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>新文章验证码</U></td>
<td width="50%" class=td1>  
<input type=radio class=radio name="Boke_Setting(4)" value=0 <%if Boke_Setting(4)="0" then%>checked<%end if%>>关闭&nbsp;
<input type=radio class=radio name="Boke_Setting(4)" value=1 <%if Boke_Setting(4)="1" then%>checked<%end if%>>开启&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>评论验证码</U></td>
<td width="50%" class=td1>  
<input type=radio class=radio name="Boke_Setting(5)" value=0 <%if Boke_Setting(5)="0" then%>checked<%end if%>>关闭&nbsp;
<input type=radio class=radio name="Boke_Setting(5)" value=1 <%if Boke_Setting(5)="1" then%>checked<%end if%>>开启&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>新文章、评论时间间隔</U></td>
<td width="50%" class=td1>  
<input type="text" name="Boke_Setting(6)" size="35" value="<%=Boke_Setting(6)%>"> 秒
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>默认分页信息数</U></td>
<td width="50%" class=td1>  
<input type="text" name="Boke_Setting(7)" size="35" value="<%=Boke_Setting(7)%>"> 条
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>相片分页信息数</U></td>
<td width="50%" class=td1>  
<input type="text" name="Boke_Setting(8)" size="35" value="<%=Boke_Setting(8)%>"> 张
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>每行相片数</U></td>
<td width="50%" class=td1>  
<input type="text" name="Boke_Setting(9)" size="35" value="<%=Boke_Setting(9)%>"> 张
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>图片自动按比例缩放</U></td>
<td width="50%" class=td1>  
<input type=radio class=radio name="Boke_Setting(10)" value=0 <%if Boke_Setting(10)="0" then%>checked<%end if%>>关闭&nbsp;
<input type=radio class=radio name="Boke_Setting(10)" value=1 <%if Boke_Setting(10)="1" then%>checked<%end if%>>开启&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>图片按滚轮缩放</U></td>
<td width="50%" class=td1>  
<input type=radio class=radio name="Boke_Setting(11)" value=0 <%if Boke_Setting(11)="0" then%>checked<%end if%>>关闭&nbsp;
<input type=radio class=radio name="Boke_Setting(11)" value=1 <%if Boke_Setting(11)="1" then%>checked<%end if%>>开启&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>用户上传空间大小</U></td>
<td width="50%" class=td1>  
<input type="text" name="Boke_Setting(15)" value="<%=Boke_Setting(15)%>">MB (填写-1为无限)
</td>
</tr>
</table>
<a name="setting3"></a>
<BR>
<table border="0" cellspacing="1" cellpadding="3"  align=center class="tableBorder">
<tr> 
<th width="100%" colspan=3  align=Left id=tabletitlelink  height=25><b>上传设置</b>[<a href="#top">顶部</a>]
</th></tr>
<tr> 
	<td width="50%" class=td1> <U>用户上传设置沿用用户组默认设置</U><BR>建议开启，开启后沿用不同用户组的是否允许上传及上传文件大小限制</td>
	<td width="43%" class=td1>
<input type=radio class=radio name="UploadSetting(0)" value=0 <%if UploadSetting(0)="0" then%>checked<%end if%>>否&nbsp;
<input type=radio class=radio name="UploadSetting(0)" value=1 <%if UploadSetting(0)="1" then%>checked<%end if%>>是&nbsp;
	</td>
</tr>
<tr> 
	<td class=td2><U>用户上传文件大小</U><BR>设置后将不沿用用户的用户组上传设置，所有用户组都将使用此设置</td>
	<td class=td2> 
	<input type="text" name="UploadSetting(1)" size="6" value="<%=UploadSetting(1)%>">&nbsp;K
	</td>
</tr>
<tr> 
<td class=td1> <U>上传文件限制</U><br>(文件后缀名，以"|"分隔)</td>
<td class=td1>  
<input type="text" name="Boke_Setting(16)" value="<%=Boke_Setting(16)%>" size="40">
</td>
</tr>
<tr>
	<td class=td1 ><U>选取上传组件</U></td>
	<td class=td1 >
	<select name="UploadSetting(2)" id="UploadSetting(2)" onChange="chkselect(options[selectedIndex].value,'know2');">
	<option value="999">关闭
	<option value="0">无组件上传类
	<option value="1">Aspupload3.0组件 
	<option value="2">SA-FileUp 4.0组件
	<option value="3">DvFile-Up V1.0组件
	</option></select><div id="know2"></div>
	</td>
</tr>
<tr> 
	<td class=td2><U>选取生成预览图片组件</U></td>
	<td class=td2> 
	<select name="UploadSetting(3)" id="UploadSetting(3)" onChange="chkselect(options[selectedIndex].value,'know3');">
	<option value="999">关闭
	<option value="0">CreatePreviewImage组件
	<option value="1">AspJpeg组件
	<option value="2">SA-ImgWriter组件
	</select><div id="know3"></div>
	</td>
</tr>
<tr> 
	<td class=td1><U>生成预览图片大小设置（宽度|高度）</U></td>
	<td class=td1>
		宽度：<INPUT TYPE="text" NAME="UploadSetting(14)" size=10 value="<%=UploadSetting(14)%>"> 象素
		高度：<INPUT TYPE="text" NAME="UploadSetting(15)" size=10 value="<%=UploadSetting(15)%>"> 象素
	</td>
</tr>
<tr> 
	<td class=td2><U>生成预览图片大小规则选项</U></td>
	<td class=td2> 
		<SELECT name="UploadSetting(16)" id="UploadSetting(16)">
		<OPTION value=0>固定</OPTION>
		<OPTION value=1>等比例缩小</OPTION>
		</SELECT>
	</td>
</tr>
<tr> 
	<td class=td1><U>图片水印设置开关</U></td>
	<td class=td1> 
		<SELECT name="UploadSetting(17)" id="UploadSetting(17)">
		<OPTION value="0">关闭水印效果</OPTION>
		<OPTION value="1">水印文字效果</OPTION>
		<OPTION value="2">水印图片效果</OPTION>
		</SELECT>
	</td>
</tr>
<tr> 
	<td class=td2><U>上传图片添加水印文字信息（可为空或0）</U></td>
	<td class=td2> 
	<INPUT TYPE="text" NAME="UploadSetting(4)" size=40 value="<%=UploadSetting(4)%>">
	</td>
</tr>
<tr> 
	<td class=td1><U>上传添加水印字体大小</U></td>
	<td class=td1> 
	<INPUT TYPE="text" NAME="UploadSetting(5)" size=10 value="<%=UploadSetting(5)%>"> <b>px</b>
	</td>
</tr>
<tr> 
	<td class=td2><U>上传添加水印字体颜色</U></td>
	<td class=td2>
	<input type="hidden" name="UploadSetting(6)" id="UploadSetting(6)" value="<%=UploadSetting(6)%>">
	<img border=0 src="images/post/rect.gif" style="cursor:pointer;background-Color:<%=UploadSetting(6)%>;" onclick="Getcolor(this,'UploadSetting(6)');" title="选取颜色!">
	</td>
</tr>
<tr> 
	<td class=td1><U>上传添加水印字体名称</U></td>
	<td class=td1>
	<SELECT name="UploadSetting(7)" id="UploadSetting(7)">
	<option value="宋体">宋体</option>
	<option value="楷体_GB2312">楷体</option>
	<option value="新宋体">新宋体</option>
	<option value="黑体">黑体</option>
	<option value="隶书">隶书</option>
	<OPTION value="Andale Mono" selected>Andale Mono</OPTION> 
	<OPTION value=Arial>Arial</OPTION> 
	<OPTION value="Arial Black">Arial Black</OPTION> 
	<OPTION value="Book Antiqua">Book Antiqua</OPTION>
	<OPTION value="Century Gothic">Century Gothic</OPTION> 
	<OPTION value="Comic Sans MS">Comic Sans MS</OPTION>
	<OPTION value="Courier New">Courier New</OPTION>
	<OPTION value=Georgia>Georgia</OPTION>
	<OPTION value=Impact>Impact</OPTION>
	<OPTION value=Tahoma>Tahoma</OPTION>
	<OPTION value="Times New Roman" >Times New Roman</OPTION>
	<OPTION value="Trebuchet MS">Trebuchet MS</OPTION>
	<OPTION value="Script MT Bold">Script MT Bold</OPTION>
	<OPTION value=Stencil>Stencil</OPTION>
	<OPTION value=Verdana>Verdana</OPTION>
	<OPTION value="Lucida Console">Lucida Console</OPTION>
	</SELECT>
	</td>
</tr>
<tr> 
	<td class=td2><U>上传水印字体是否粗体</U></td>
	<td class=td2> 
		<SELECT name="UploadSetting(8)" id="UploadSetting(8)">
		<OPTION value=0>否</OPTION>
		<OPTION value=1>是</OPTION>
		</SELECT>
	</td>
</tr>
<!-- 上传图片添加水印LOGO图片定义 -->
<tr> 
	<td class=td1><U>上传图片添加水印LOGO图片信息（可为空或0）</U><br>填写LOGO的图片相对路径</td>
	<td class=td1> 
	<INPUT TYPE="text" NAME="UploadSetting(9)" size=40 value="<%=UploadSetting(9)%>">
	</td>
</tr>
<tr> 
	<td class=td2><U>上传图片添加水印透明度</U></td>
	<td class=td2> 
	<INPUT TYPE="text" NAME="UploadSetting(10)" size=10 value="<%=UploadSetting(10)%>"> 如60%请填写0.6
	</td>
</tr>
<tr> 
	<td class=td2><U>水印图片去除底色</U><br>保留为空则水印图片不去除底色</td>
	<td class=td2> 
	<INPUT TYPE="text" NAME="UploadSetting(18)" ID="UploadSetting(18)" size=10 value="<%=UploadSetting(18)%>"> 
	<img border=0 src="images/post/rect.gif" style="cursor:pointer;background-Color:<%=UploadSetting(18)%>;" onclick="Getcolor(this,'UploadSetting(18)');" title="选取颜色!">
	</td>
</tr>
<tr> 
	<td class=td1><U>水印文字或图片的长宽区域定义</U><br>如水印图片的宽度和高度</td>
	<td class=td1> 
	宽度：<INPUT TYPE="text" NAME="UploadSetting(11)" size=10 value="<%=UploadSetting(11)%>"> 象素
	高度：<INPUT TYPE="text" NAME="UploadSetting(12)" size=10 value="<%=UploadSetting(12)%>"> 象素
	</td>
</tr>
<tr> 
	<td class=td2><U>上传图片添加水印LOGO位置坐标</U></td>
	<td class=td2>
	<SELECT NAME="UploadSetting(13)" id="UploadSetting(13)">
		<option value="0">左上</option>
		<option value="1">左下</option>
		<option value="2">居中</option>
		<option value="3">右上</option>
		<option value="4">右下</option>
	</SELECT>
	</td>
</tr>
<!-- 上传图片添加水印LOGO图片定义 -->
<%
If IsObjInstalled("Scripting.FileSystemObject") Then 
%>
<tr> 
<td class=td1><U>是否采用文件、图片防盗链</U></td>
<td class=td1>
<input type=radio class=radio name="UploadSetting(20)" value=0 <%if UploadSetting(20)="0" Then %>checked<%end if%>>关闭&nbsp;
<input type=radio class=radio name="UploadSetting(20)" value=1 <%if UploadSetting(20)="1" Then %>checked<%end if%>>打开&nbsp;
</td>
</tr>
<tr> 
<td class=td2><U>上传目录设定</U></td>
<td class=td2>
<%
If UploadSetting(19)="" Or UploadSetting(19)="0" Then UploadSetting(19)="Boke/UploadFile/"
%>
<input type=text name="UploadSetting(19)" value=<%=UploadSetting(19)%>>如果修改了此项，请用FTP手工创建目录和移动原有上传文件。
</td>
</tr>
<%
Else
%>
<input type=hidden name="UploadSetting(20)" value=<%=UploadSetting(20)%>>
<input type=hidden name="UploadSetting(19)" value=<%=UploadSetting(19)%>>
<%
Rs.Close
Set Rs=Nothing
End If
%>
<!--天气-->
<input type="hidden" name="Boke_Setting(13)" value="<%=Boke_Setting(13)%>">
<input type="hidden" name="Boke_Setting(14)" value="<%=Boke_Setting(14)%>">
<!--天气-->
<tr> 
<td class=td1>&nbsp;</td>
<td class=td1>
<input type=submit name=submit value="提交更改" class="button">
</td>
</tr>
</table><BR>
</FORM>

<div id="Issubport999" style="display:none"></div>
<SCRIPT LANGUAGE="JavaScript">
<!--
function chkselect(s,divid)
{
var divname='Issubport';
var chkreport;
	s=Number(s)
	if (divid=="know1")
	{
	divname=divname+s;
	}
	if (divid=="know2")
	{
	s+=4;
	if (s==1003){s=999;}
	divname=divname+s;
	}
	if (divid=="know3")
	{
	s+=9;
	if (s==1008){s=999;}
	divname=divname+s;
	}
document.getElementById(divid).innerHTML=divname;
chkreport=document.getElementById(divname).innerHTML;
document.getElementById(divid).innerHTML=chkreport;
}
//SELECT表单选取
function CheckSel(Voption,Value)
{
	var obj = document.getElementById(Voption);
	for (i=0;i<obj.length;i++){
		if (obj.options[i].value==Value){
		obj.options[i].selected=true;
		break;
		}
	}
}
var ColorImg;
var ColorValue;
function hideColourPallete() {
	document.getElementById("colourPalette").style.visibility="hidden";
}
function Getcolor(img_val,input_val){
	var obj = document.getElementById("colourPalette");
	ColorImg = img_val;
	ColorValue = document.getElementById(input_val);
	if (obj){
	obj.style.left = getOffsetLeft(ColorImg) + "px";
	obj.style.top = (getOffsetTop(ColorImg) + ColorImg.offsetHeight) + "px";
	if (obj.style.visibility=="hidden")
	{
	obj.style.visibility="visible";
	}else {
	obj.style.visibility="hidden";
	}
	}
}
//Colour pallete top offset
function getOffsetTop(elm) {
	var mOffsetTop = elm.offsetTop;
	var mOffsetParent = elm.offsetParent;
	while(mOffsetParent){
		mOffsetTop += mOffsetParent.offsetTop;
		mOffsetParent = mOffsetParent.offsetParent;
	}
	return mOffsetTop;
}

//Colour pallete left offset
function getOffsetLeft(elm) {
	var mOffsetLeft = elm.offsetLeft;
	var mOffsetParent = elm.offsetParent;
	while(mOffsetParent) {
		mOffsetLeft += mOffsetParent.offsetLeft;
		mOffsetParent = mOffsetParent.offsetParent;
	}
	return mOffsetLeft;
}
function setColor(color)
{
	if (ColorValue){ColorValue.value = color;}
	if (ColorImg){ColorImg.style.backgroundColor = color;}
	document.getElementById("colourPalette").style.visibility="hidden";
}
CheckSel('UploadSetting(2)','<%=UploadSetting(2)%>');
CheckSel('UploadSetting(3)','<%=UploadSetting(3)%>');
CheckSel('UploadSetting(7)','<%=UploadSetting(7)%>');
CheckSel('UploadSetting(13)','<%=UploadSetting(13)%>');
CheckSel('UploadSetting(16)','<%=UploadSetting(16)%>');
CheckSel('UploadSetting(17)','<%=UploadSetting(17)%>');
//-->
</SCRIPT>
<%
Dim InstalledObjects(12)
InstalledObjects(1) = "JMail.Message"				'JMail 4.3
InstalledObjects(2) = "CDONTS.NewMail"				'CDONTS
InstalledObjects(3) = "Persits.MailSender"			'ASPEMAIL
'-----------------------
InstalledObjects(4) = "Adodb.Stream"				'Adodb.Stream
InstalledObjects(5) = "Persits.Upload"				'Aspupload3.0
InstalledObjects(6) = "SoftArtisans.FileUp"			'SA-FileUp 4.0
InstalledObjects(7) = "DvFile.Upload"				'DvFile-Up V1.0
'-----------------------
InstalledObjects(9) = "CreatePreviewImage.cGvbox"	'CreatePreviewImage
InstalledObjects(10) = "Persits.Jpeg"				'AspJpeg
InstalledObjects(11) = "SoftArtisans.ImageGen"		'SoftArtisans ImgWriter V1.21
InstalledObjects(12) = "sjCatSoft.Thumbnail"		'sjCatSoft.Thumbnail V2.6

For i=1 to 12
	Response.Write "<div id=""Issubport"&i&""" style=""display:none"">"
	If IsObjInstalled(InstalledObjects(i)) Then Response.Write InstalledObjects(i)&":<font color=red><b>√</b>服务器支持!</font>" Else Response.Write InstalledObjects(i)&"<b>×</b>服务器不支持!" 
	Response.Write "</div>"
Next
End If
End Sub

%>
</body>
</html>
<%



Sub Manage_Suc(Msg,ColNum,rUrl)
	Response.Write "<tr>"
	Response.Write "<td class=""td1"" colspan="&ColNum&" height=25>"
	Response.Write "<B>成功</B>："&Msg&"，<a href="""&rUrl&""">请返回</a>。"
	Response.Write "</td>"
	Response.Write "</tr>"
End Sub
Sub Manage_Err(Msg,ColNum,rUrl)
	Response.Write "<tr>"
	Response.Write "<td class=""td1"" colspan="&ColNum&" height=25>"
	Response.Write "<B>错误</B>："&Msg&"，<a href="""&rUrl&""">请返回</a>。"
	Response.Write "</td>"
	Response.Write "</tr>"
End Sub
Sub dvbbs_error()
	Response.Write"<br>"
	Response.Write"<table cellpadding=3 cellspacing=1 align=center class=""tableBorder"" style=""width:75%"">"
	Response.Write"<tr align=center>"
	Response.Write"<th width=""100%"" height=25 colspan=2>错误信息"
	Response.Write"</td>"
	Response.Write"</tr>"
	Response.Write"<tr>"
	Response.Write"<td width=""100%"" class=""td1"" colspan=2>"
	Response.Write ErrMsg
	Response.Write"</td></tr>"
	Response.Write"<tr>"
	Response.Write"<td class=""td1"" valign=middle colspan=2 align=center><a href=""javascript:history.go(-1)""><<返回上一页</a></td></tr>"
	Response.Write"</table>"
End Sub 
Sub Dv_suc(info)
	Response.Write"<br>"
	Response.Write"<table cellpadding=0 cellspacing=0 align=center class=""tableBorder"" style=""width:75%"">"
	Response.Write"<tr align=center>"
	Response.Write"<th width=""100%"" height=25 colspan=2>成功信息"
	Response.Write"</td>"
	Response.Write"</tr>"
	Response.Write"<tr>"
	Response.Write"<td width=""100%"" class=""td2"" colspan=2 height=25>"
	Response.Write info
	Response.Write"</td></tr>"
	Response.Write"<tr>"
	Response.Write"<td class=""td2"" valign=middle colspan=2 align=center><a href=""javascript:history.go(-1)"" ><<返回上一页</a></td></tr>"
	Response.Write"</table>"
End Sub
Function IsObjInstalled(strClassString)
	On Error Resume Next
	IsObjInstalled = False
	Err = 0
	Dim xTestObj
	Set xTestObj = Dvbbs.iCreateObject(strClassString)
	If Err = 0 Then IsObjInstalled = True
	If Err = -2147352567 Then IsObjInstalled = True
	Set xTestObj = Nothing
	Err = 0
End Function
%>