<%@ LANGUAGE = VBScript CodePage = 936%>
<%
Option Explicit
Response.Buffer = True  
Response.Charset = "GB2312"

Dim Startime
Dim SqlNowString,Dvbbs,template,MyBoardOnline
Dim Conn,Plus_Conn,Db,MyDbPath
Startime = Timer()
MyDbPath = ""

Const DvCodeFile = "DV_getcode.asp" '验证码文件，Inc/Main82.js 还有一处需要修改，直接修改文件名，同时在空间上修改相应的文件名。
Const IsUrlreWrite = 0 '论坛伪静态设置 0=关闭,1=开启（需要在IIS添加ISAPI筛选，详细查看安装帮助）。
'系统采用XML版本设置
'最高版本为.4.0 依次为： Const MsxmlVersion=".3.0" Const MsxmlVersion=".2.6" 最低版本Const MsxmlVersion=""
Const MsxmlVersion=".3.0"
'可修改设置一：========================定义数据库类别，1为SQL数据库，0为Access数据库=============================
Const IsSqlDataBase = 0

'================================================================================================================
If IsSqlDataBase = 1 Then
	'必修改设置二：========================SQL数据库设置=============================================================
	'sql数据库连接参数：数据库名(SqlDatabaseName)、用户密码(SqlPassword)、用户名(SqlUsername)、
	'连接名(SqlLocalName)（本地用local，外地用IP）
	Const SqlDatabaseName = "dvbbs83"
	Const SqlPassword = "dvbbs83"
	Const SqlUsername = "dvbbs83"
	Const SqlLocalName = "(local)"
	'================================================================================================================
	SqlNowString = "GetDate()"
Else
	'必修改设置三：========================Access数据库设置==========================================================
	'免费用户第一次使用请修改本处数据库地址并相应修改data目录中数据库名称，如:将dvbbs8.mdb修改为dvbbs8.asp
	Db = "data/makedream.mdb#.asp"
	'================================================================================================================
	SqlNowString = "Now()"
End If

Const EnabledSession= true
Const IsDeBug = 1
Set Dvbbs = New Cls_Forum
Set template = New cls_templates
Sub ConnectionDatabase
	Dim ConnStr
	If IsSqlDataBase = 1 Then
		ConnStr = "Provider = Sqloledb; User ID = " & SqlUsername & "; Password = " & SqlPassword & "; Initial Catalog = " & SqlDatabaseName & "; Data Source = " & SqlLocalName & ";"
	Else
		ConnStr = "Provider = Microsoft.Jet.OLEDB.4.0;Data Source = " & Server.MapPath(MyDbPath & db)
	End If
	On Error Resume Next
	Set conn = Dvbbs.iCreateObject("ADODB.Connection")
	conn.open ConnStr
	If Err Then
		err.Clear
		Set Conn = Nothing
		Response.Write "数据库连接出错，请检查连接字串。"'注释，需要把这几个字翻译成英文。
		Response.End
	End If
End Sub
'-----------------------------------------------------------------------------------------------------
'独立道具库连接设置
Sub Plus_ConnectionDatabase
	Dim ConnStr
	If IsSqlDataBase = 1 Then
		'sql数据库连接参数：数据库名、用户密码、用户名、连接名（本地用local，外地用IP）
		Dim SqlDatabaseName,SqlPassword,SqlUsername,SqlLocalName
		SqlDatabaseName = "dvbbs8"
		SqlPassword = "dvbbs"
		SqlUsername = "dvbbs"
		SqlLocalName = "(local)"
		ConnStr = "Provider = Sqloledb; User ID = " & SqlUsername & "; Password = " & SqlPassword & "; Initial Catalog = " & SqlDatabaseName & "; Data Source = " & SqlLocalName & ";"
	Else
		Dim Db
		'免费用户第一次使用请修改本处数据库地址并相应修改data目录中数据库名称，如将dvbbs8.mdb修改为dvbbs8.asp
		Db = MyDbPath & "data/Dv_Plus_Tools.mdb"
		ConnStr = "Provider = Microsoft.Jet.OLEDB.4.0;Data Source = " & Server.MapPath(db)
	End If
	On Error Resume Next
	Set Plus_Conn = Dvbbs.iCreateObject("ADODB.Connection")
	Plus_Conn.open ConnStr
	If Err Then
		err.Clear
		Set Plus_Conn = Nothing
		Response.Write "插件数据库连接出错，请检查连接字串。"'注释，需要把这几个字翻译成英文。
		Response.End
	End If
End Sub
'-----------------------------------------------------------------------------------------------------
%>
