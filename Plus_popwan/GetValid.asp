<%
	Dim xmlhttp
	Set xmlhttp = Server.CreateObject("MSXML2.ServerXMLHTTP")
	xmlhttp.setTimeouts 10000, 10000, 10000, 10000
	xmlhttp.Open "POST","http://union.popwan.com/other/image.aspx?time=" & Now(),False
	xmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlhttp.send()
	Response.BinaryWrite xmlhttp.responseBody 
	Response.End
%>