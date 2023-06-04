<%
'博客系统是否独立数据库,1表示独立数据库,0表示在动网论坛数据库中
Const Dv_Boke_InDvbbsData = 1
'博客系统数据库类型,0表示ACCESS,1表示SQL Server
Const Dv_Boke_DataBase = 0
'是否支持模拟HTML,需要服务器支持Isapiwrite并做相关设置
Const Is_Isapi_Rewrite = 0

If Dvbbs.forum_setting(99)="0" And Not Dvbbs.Master Then
	Response.redirect "showerr.asp?ErrCodes=<li>对不起，本论坛的博客功能已经关闭！</li>&action=OtherErr"
End If

Dim bSqlNowString,DvBoke,Boke_Conn
If Dv_Boke_InDvbbsData = 1 Then
	If Dv_Boke_DataBase = 1 Then
		bSqlNowString = "GetDate()"
	Else
		bSqlNowString = "Now()"
	End If
Else
	bSqlNowString = SqlNowString
End If
MyDbPath = ""

'独立博客系统数据库链接函数
Sub Boke_ConnectionDatabase()
	Dim ConnStr
	If Dv_Boke_InDvbbsData = 0 Then
		If Not IsObject(Conn) Then ConnectionDatabase
		Set Boke_Conn = Conn
		Exit Sub
	End If
	If Dv_Boke_DataBase = 1 Then
		'sql数据库连接参数：数据库名、用户密码、用户名、连接名（本地用local，外地用IP）
		Dim SqlDatabaseName,SqlPassword,SqlUsername,SqlLocalName
		SqlDatabaseName = "dvbbs8"
		SqlPassword = "dvbbs"
		SqlUsername = "dvbbs"
		SqlLocalName = "(local)"
		ConnStr = "Provider = Sqloledb; User ID = " & SqlUsername & "; Password = " & SqlPassword & "; Initial Catalog = " & SqlDatabaseName & "; Data Source = " & SqlLocalName & ";"
	Else
		Dim Db
		'免费用户第一次使用请修改本处数据库地址并相应修改data目录中数据库名称
		Db = MyDbPath & "Boke/data/Dvboke.mdb"
		ConnStr = "Provider = Microsoft.Jet.OLEDB.4.0;Data Source = " & Server.MapPath(db)
	End If
	'On Error Resume Next
	Set Boke_Conn = Dvbbs.iCreateObject("ADODB.Connection")
	Boke_Conn.Open ConnStr
	If Err Then
		err.Clear
		Set Boke_Conn = Nothing
		Response.Write "插件数据库连接出错，请检查连接字串。"'注释，需要把这几个字翻译成英文。
		Response.End
	End If
End Sub
%>
<!--#Include File="Cls_Main.asp"-->
<%
Set DvBoke = New Cls_DvBoke
%>