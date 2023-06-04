<!--#include FILE="conn.asp"-->
<!--#include file="inc/const.asp" -->
<!--#include file="boke/config.asp"-->
<%
Dim ShowHead,isSystem
ShowHead = Request.QueryString("ShowHead")
DvBoke.Stats = "提示信息"
isSystem = 0
If DvBoke.BokeUserID = 0 Then isSystem = 1
If ShowHead <> "1" Then
	DvBoke.Nav(isSystem)
Else
	DvBoke.Head(isSystem)
End If
Page_Main()
DvBoke.Footer
Dvbbs.PageEnd()
'--------------------------------------------------------
'	相关调用说明：
'	DvBoke.ShowCode(2)	-- 信息编号
'	DvBoke.ShowCode("提示内容") -- 自定义内容
'	DvBoke.ShowMsg(0)	-- 输出形式 0=正常 1=不显示顶部
'
'--------------------------------------------------------

Sub Page_Main()
	DvBoke.LoadPage("SysDescription.xslt")
	ShowSkins = DvBoke.Page_Strings(0).text
	Dim Codes,ShowCodes,i,Description,Count
	Dim ShowSkins,TempStr
	Count = DvBoke.Page_Strings.length
	Description = ""
	TempStr = DvBoke.Page_Strings(1).text
	Codes = Request.QueryString("Codes")
	ShowCodes = Split(Codes,",")
	For i=0 to UBound(ShowCodes)
		If IsNumeric(ShowCodes(i)) Then
			If Clng(ShowCodes(i)) <= Count and Clng(ShowCodes(i))>1 Then
				Description = Description & Replace(TempStr,"{$msg}",DvBoke.Page_Strings(ShowCodes(i)).text)
			End If
		Else
			Description = Description & Replace(TempStr,"{$msg}",Server.Htmlencode(ShowCodes(i)))
		End If
	Next
	If Request.QueryString("RefreshID")<>"" and IsNumeric(Request.QueryString("RefreshID")) Then
		ShowSkins = Replace(ShowSkins,"{$refreshinfro}",DvBoke.Page_Strings(42).text)
		Dim RefreshUrl
		Select Case Request.QueryString("RefreshID")
		Case "0"
			RefreshUrl = "bokeindex.asp"
			ShowSkins = Replace(ShowSkins,"{$refreshname}"," <a href="""&RefreshUrl&"""><U>博客首页</U></a>")
			
		Case "-1"
			RefreshUrl = DvBoke.ModHtmlLinked&DvBoke.BokeName&".index.html"
			ShowSkins = Replace(ShowSkins,"{$refreshname}"," <a href="""&RefreshUrl&"""><U>"&DvBoke.BokeUserName&"的个人博客首页</U></a>")
		Case Else
			RefreshUrl = DvBoke.ModHtmlLinked&DvBoke.BokeName&".showtopic."&Request.QueryString("RefreshID")&".html"
			ShowSkins = Replace(ShowSkins,"{$refreshname}"," <a href="""&RefreshUrl&"""><U>主题页面</U></a>")
		End Select
		ShowSkins = Replace(ShowSkins,"{$refresh}","<meta http-equiv=refresh content=""3;URL="&RefreshUrl&"""/>")
	Else
		ShowSkins = Replace(ShowSkins,"{$refresh}","")
		ShowSkins = Replace(ShowSkins,"{$refreshinfro}","")
	End If

	ShowSkins = Replace(ShowSkins,"{$description}",Description)
	Response.Write ShowSkins
End Sub

%>