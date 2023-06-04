<!--#include FILE="conn.asp"-->
<!--#include file="inc/const.asp" -->
<!--#include file="boke/config.asp"-->
<!--#include File="boke/Upload_Class.asp" -->
<%
Dvbbs.Stats="查看文件"
Dim DownId,Rs,FileName,sFileName,Boke_Setting,UploadSetting
If Not IsNumeric(request("id")) Then
	Dvbbs.AddErrCode(35)
Else
	DownID=Clng(request("id"))
End If
Dvbbs.ShowErr()
'取得博客上传目录
Function CheckFolder()
	If DvBoke.System_UpSetting(19)="" Or DvBoke.System_UpSetting(19)="0" Then DvBoke.System_UpSetting(19)="Boke/UploadFile/"
	CheckFolder = Replace(Replace(DvBoke.System_UpSetting(19),Chr(0),""),".","")
	'在目录后加(/)
	If Right(CheckFolder,1)<>"/" Then CheckFolder=CheckFolder&"/"
End Function

'取得博客设置信息
Set Rs=DvBoke.Execute("Select Top 1 * From Dv_Boke_System")
Boke_Setting = Rs("S_Setting")
If Boke_Setting = "" Or IsNull(Boke_Setting) Then Boke_Setting = "1,1,0,1,1,1,20,20,15,3,1,1,1|0|0|999|bbs.dvbbs.net|12|1|Arial|0|images/WaterMap.gif|0.7|110|35|4|120|100|1|1|1|Boke/UploadFile/|0,1,1,-1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
Boke_Setting = Split(Boke_Setting,",")
If Ubound(Boke_Setting) < 100 Then Boke_Setting = Split("1,1,0,1,1,1,20,20,15,3,1,1,1|0|0|999|bbs.dvbbs.net|12|1|Arial|0|images/WaterMap.gif|0.7|110|35|4|120|100|1|1|1|Boke/UploadFile/|0,1,1,-1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1",",")
UploadSetting = Split(Boke_Setting(12),"|")
If Ubound(UploadSetting) < 2 Then UploadSetting = Split("1|0|0|999|bbs.dvbbs.net|12|1|Arial|0|images/WaterMap.gif|0.7|110|35|4|120|100|1|1|1|Boke/UploadFile/|0","|")
Rs.Close
Set Rs = Nothing
'输出文件
Set Rs = DvBoke.Execute("Select FileName,sFileName From Dv_Boke_Upfile where id="&DownID)
FileName = Rs("FileName")
sFileName = Rs("sFileName")
Rs.Close
Set Rs = Nothing
'判断是否防盗链
If UploadSetting(20) = "1" Then
    If Request.ServerVariables("HTTP_REFERER")="" Or InStr(Request.ServerVariables("HTTP_REFERER"),Request.ServerVariables("SERVER_NAME"))=0 Then
        Response.Redirect "index.asp"
    Else
        DvBoke.Execute("Update Dv_Boke_Upfile set DownNum=DownNum+1 where id="&DownID)
        downloadFile Server.MapPath(UploadSetting(19)&FileName),sFileName
    End If
Else
    DvBoke.Execute("Update Dv_Boke_Upfile set DownNum=DownNum+1 where id="&DownID)
    downloadFile Server.MapPath(UploadSetting(19)&FileName),sFileName
End If

Sub downloadFile(strFile,FileOldName)
	On error resume next
	Server.ScriptTimeOut=999999
	Dim S,fso,f,intFilelength,strFilename,DownFileName
	strFilename = strFile
	Response.Clear
	Set s = Dvbbs.iCreateObject("ADODB.Stream")
	s.Open
	s.Type = 1
	Set fso = Dvbbs.iCreateObject("Scripting.FileSystemObject")
	If Not fso.FileExists(strFilename) Then
		Response.Write("<h1>错误: </h1><br>系统找不到指定文件")
		Exit Sub
	End If
	Set f = fso.GetFile(strFilename)
		intFilelength = f.size
		s.LoadFromFile(strFilename)
		If err Then
			Response.Write("<h1>错误: </h1>" & err.Description & "<p>")
			Response.End
		End If
		Set fso=Nothing
		Dim Data
		Data=s.Read
		s.Close
		Set s=Nothing
		If FileOldName="" Or IsNull(FileOldName) Then DownFileName=f.name Else DownFileName=FileOldName
		If Response.IsClientConnected Then
			Response.AddHeader "Content-Disposition", "attachment; filename=" &  DownFileName
			Response.AddHeader "Content-Length", intFilelength
			Response.CharSet = "UTF-8"
			Response.ContentType = "application/octet-stream"
			Response.BinaryWrite Data
			Response.Flush
		End If
End Sub
%>