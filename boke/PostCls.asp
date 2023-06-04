<%
'Product DvBoke version 1.00
'Copyright (C) 2004,2005 AspSky.Net. All rights reserved.
'Written By Dvbbs.net Fssunwin
'Web: http://www.aspsky.net/ , http://www.dvbbs.net/
'Email: eway@aspsky.net Sunwin@artbbs.net

Class Cls_DvBoke_Post
Public RootID,PostID
Public PostUserName,CatID,sCatID,PostUserID,Title,Content,JoinTime,sType,SearchKey,PostTitleNote,IsLock,IsBest,Weather
Public Show_Upload,IsTopic,EditMode,MaxLen

Private Act,PageHtml
Private Sub Class_Initialize()
	Show_Upload = 0	'是否显示上传
	IsTopic = 0
	EditMode = "Default"
	RootID = 0
	PostID = 0
	PostUserName = ""
	CatID = -1
	sCatID = -1
	sType = -1	'0=文章,1=收藏,2=链接,3=交易,4=相册
	PostUserID = 0
	Title = ""
	Content = ""
	JoinTime = Now()
	IsLock = 0
	IsBest = 0
	Weather = 0
	MaxLen = 250
	PostTitleNote = ""
End Sub
Private Sub class_terminate()
End Sub

Public Property Let Action(Str)
	Act = Lcase(Str)
End Property

Public Sub LoadForm()
	DvBoke.BokeChannelToJS()
	DvBoke.LoadPage("topic.xslt")
	PageHtml = DvBoke.Page_Strings(10).text
	If Show_Upload = 1 and sType<>2 Then
		PageHtml = Replace(PageHtml,"{$Show_Upload}",DvBoke.Page_Strings(13).text)
	Else
		PageHtml = Replace(PageHtml,"{$Show_Upload}","")
	End If
	If IsTopic = 1 Then
		PageHtml = Replace(PageHtml,"{$TopicFunction1}",DvBoke.Page_Strings(11).text)
		PageHtml = Replace(PageHtml,"{$TopicFunction2}",DvBoke.Page_Strings(12).text)
		PageHtml = Replace(PageHtml,"{$TopicFunction3}",DvBoke.Page_Strings(33).text)
		PageHtml = Replace(PageHtml,"{$WeatherList}",WeatherList)
		PageHtml = Replace(PageHtml,"{$Weather}",Weather)
		If DvBoke.System_Setting(4) = "1" Then
			PageHtml = Replace(PageHtml,"{$getcode}",DvBoke.Page_Strings(34).text)
			Dvbbs.LoadTemplates("")
			PageHtml = Replace(PageHtml,"{$Dv_GetCode}",Dvbbs.GetCode)
		Else
			PageHtml = Replace(PageHtml,"{$getcode}","")
		End If
	Else
		PageHtml = Replace(PageHtml,"{$TopicFunction1}","")
		PageHtml = Replace(PageHtml,"{$TopicFunction2}","")
		PageHtml = Replace(PageHtml,"{$TopicFunction3}","")
		If DvBoke.System_Setting(5) = "1" Then
			PageHtml = Replace(PageHtml,"{$getcode}",DvBoke.Page_Strings(34).text)
			Dvbbs.LoadTemplates("")
			PageHtml = Replace(PageHtml,"{$Dv_GetCode}",Dvbbs.GetCode)
		Else
			PageHtml = Replace(PageHtml,"{$getcode}","")
		End If
	End If
	Select Case sType
	Case 2
		PageHtml = Replace(PageHtml,"{$TitleNote}",DvBoke.Page_Strings(18).text)
		PageHtml = Replace(PageHtml,"{$Show_PostContent}",DvBoke.Page_Strings(15).text)
	Case Else
		PageHtml = Replace(PageHtml,"{$TitleNote}",DvBoke.Page_Strings(17).text)
		PageHtml = Replace(PageHtml,"{$maxlen}",MaxLen)
		PageHtml = Replace(PageHtml,"{$Show_PostContent}",DvBoke.Page_Strings(16).text)
		PageHtml = Replace(PageHtml,"{$Editmode}",EditMode)
	End Select
	
	If (Not (Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@cachebokebody") Is Nothing)) And Content="" Then
		PageHtml = Replace(PageHtml,"{$Content}",Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@cachebokebody").text)
	Else
		PageHtml = Replace(PageHtml,"{$Content}",Server.HTMLEncode(Content))
	End If


	If Not IsDate(JoinTime) Then JoinTime = Now()
	PageHtml = Replace(PageHtml,"{$PostUserName}",Server.HTMLEncode(PostUserName))
	If (Not (Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@cacheboketopic") Is Nothing)) And Title="" Then
		PageHtml = Replace(PageHtml,"{$Title}",Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@cacheboketopic").text)
	Else
		PageHtml = Replace(PageHtml,"{$Title}",Server.HTMLEncode(Title))
	End If
	PageHtml = Replace(PageHtml,"{$SearchKey}",Server.HTMLEncode(SearchKey))
	PageHtml = Replace(PageHtml,"{$PostTitleNote}",Server.HTMLEncode(PostTitleNote))
	PageHtml = Replace(PageHtml,"{$PostData}",FormatDateTime(JoinTime,1))
	PageHtml = Replace(PageHtml,"{$sCatList}",sCatList(sCatID))
	PageHtml = Replace(PageHtml,"{$stype}",sType)
	PageHtml = Replace(PageHtml,"{$Cat_Val}",CatID)
	PageHtml = Replace(PageHtml,"{$Lock}",IsLock)
	PageHtml = Replace(PageHtml,"{$Best}",IsBest)
	PageHtml = Replace(PageHtml,"{$RootID}",RootID)
	PageHtml = Replace(PageHtml,"{$PostID}",PostID)
	PageHtml = Replace(PageHtml,"{$action}",Act)
	PageHtml = Replace(PageHtml,"{$bokename}",DvBoke.BokeName)
	If DvBoke.BokeSetting(8) = "0" Then
		PageHtml = Replace(PageHtml,"{$isalipay}","")
		PageHtml = Replace(PageHtml,"{$Show_Payto}","")
	Else
		PageHtml = Replace(PageHtml,"{$isalipay}",DvBoke.Page_Strings(31).text)
		If sType = 3 And Request("action")<>"edit" Then
			PageHtml = Replace(PageHtml,"{$Show_Payto}",DvBoke.Page_Strings(32).text)
			If DvBoke.BokeUserID > 0 Then
				PageHtml = Replace(PageHtml,"{$paytomail}",Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@useremail").text)
			Else
				PageHtml = Replace(PageHtml,"{$paytomail}","")
			End If
		Else
			PageHtml = Replace(PageHtml,"{$Show_Payto}","")
		End If
	End If
End Sub

Public Sub ShowForm()
		Response.Write PageHtml
End Sub

Public Property Get FormHtml()
	FormHtml = PageHtml
End Property

Public Function sCatList(ID)
	Dim PageHtml_Str,Rs
	Set Rs = DvBoke.Execute("Select * From Dv_Boke_SysCat Where sType = 1 Order By sCatID")
	Do While Not Rs.Eof
		PageHtml_Str = PageHtml_Str & "<Option value="""&Rs("sCatID")&""" "
		If Cint(ID) = Rs("sCatID") Then PageHtml_Str = PageHtml_Str & "selected"
		PageHtml_Str = PageHtml_Str & ">"&Rs("sCatTitle")&"</Option>"
	Rs.MoveNext
	Loop
	Rs.Close
	Set Rs=Nothing
	sCatList = PageHtml_Str
End Function

Public Function WeatherList()
	Dim Weather_A,Weather_B,Weather_A_Str,Weather_B_Str,i
	Weather_A = Split(DvBoke.System_Setting(13),"|")
	Weather_B = Split(DvBoke.System_Setting(14),"|")
	For i = 0 To Ubound(Weather_A)
		Weather_A_Str = Weather_A_Str & "<Option value="""&Weather_B(i)&"|"&i&""">"&Weather_A(i)&"</Option>"
	Next
	WeatherList = Weather_A_Str
End Function

End Class
%>