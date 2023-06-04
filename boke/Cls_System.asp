<%
'Product DvBoke version 1.00
'Copyright (C) 2004,2005 AspSky.Net. All rights reserved.
'Written By Dvbbs.net Fssunwin
'Web: http://www.aspsky.net/ , http://www.dvbbs.net/
'Email: eway@aspsky.net Sunwin@artbbs.net

Class Cls_DvBokeIndex
	Public XmlDoc,Nodes
	Public MustUpdate,UpTime,LastTime,SqlStr
	Private Cache_File,NodeName,TempXmlDoc,NeedUpdate

	Private Sub Class_Initialize()
		MustUpdate = 0	'设置强制更新
		UpTime = 10		'更新时间，以分钟为单位
		LastTime = Now()	'默认最后更新时间
		NeedUpdate = False
		Cache_File = Server.MapPath(DvBoke.Cache_Path &"Sysindex.config")
		Set XmlDoc=Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
		If Not XmlDoc.Load(Cache_File) Then
			XmlDoc.LoadXml("<?xml version=""1.0"" encoding=""Gb2312""?><index/>")
			MustUpdate = 1
			'Response.Write "请检察系统数据Sysindex.config文件是否存在！"
			'Exit Sub
		End If
	End Sub

	Private Sub class_terminate()
		If IsObject(TempXmlDoc) Then Set TempXmlDoc = Nothing
		Set XmlDoc = Nothing
	End Sub

	Public Property Let GetNode(Byval Str)
		Dim attributes
		NodeName = Str
		Set Nodes = XmlDoc.documentElement.selectSingleNode("/index/"&Str)
		If Nodes Is Nothing Then
			LastTime = Now()
			Set Nodes=XmlDoc.createNode(1,Str,"")
			Set attributes=XmlDoc.createAttribute("lasttime")
			attributes.text = LastTime
			Nodes.attributes.setNamedItem(attributes)
			XmlDoc.documentElement.appendChild(Nodes)
			MustUpdate = 1
		Else
			LastTime = CDate(Nodes.getAttribute("lasttime"))
		End If
	End Property

	Public Property Get GetXmlData()
		Response.Write XmlDoc.documentElement.xml
	End Property

	Public Sub GetData()
		If DateDiff("n",LastTime,Now())>UpTime or MustUpdate = 1 Then
			ReLoadData()
		End If
	End Sub

	Public Sub SaveCache()
		If NeedUpdate Then
			XmlDoc.save Cache_File
		End If
	End Sub

	'重新加载数据
	Public Sub ReLoadData()
		If Not IsObject(TempXmlDoc) Then
			Set TempXmlDoc = Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument")
		End If
		If Nodes.hasChildNodes Then
			Nodes.removeChild Nodes.selectSingleNode("rs:data")
		End If
		Dim Sql,Rs,ChildNode,NodeList,i,UpColumns,Columns
		UpColumns = ""
		Sql = Lcase(SqlStr)
		Set Rs = DvBoke.Execute(Sql)
		'Response.Write Sql & "<br>"
		On Error Resume Next
		If Not Rs.Eof Then
			Rs.Save TempXmlDoc,1
			If Err Then
				Response.Write Sql & "<br>"
				Err.Clear
				Exit Sub
			End If
			TempXmlDoc.documentElement.RemoveChild(TempXmlDoc.documentElement.selectSingleNode("s:Schema"))
			For i=0 to Rs.Fields.Count-1
				If IsDate(Rs(i)) Then
					UpColumns = UpColumns & Rs(i).name & ","
				End If
			Next
			Columns = Split(UpColumns,",")
			Set ChildNode = TempXmlDoc.documentElement.selectNodes("rs:data/z:row")
			For Each NodeList in ChildNode
				For i = 0 To Ubound(Columns)-1
					If NodeName = "postlist" and Columns(i)="content" Then
						NodeList.attributes.getNamedItem(Columns(i)).text = Left(Rs(Columns(i))&"",50)
					Else
						NodeList.attributes.getNamedItem(Columns(i)).text = Rs(Columns(i))
					End If
				Next
				Rs.MoveNext
			Next
			Set ChildNode = TempXmlDoc.documentElement.selectSingleNode("rs:data")
			Nodes.appendChild(ChildNode)
		End If
		Rs.Close
		Set Rs = Nothing
		Nodes.attributes.getNamedItem("lasttime").text = Now()
		NeedUpdate = True
	End Sub
	
End Class
%>