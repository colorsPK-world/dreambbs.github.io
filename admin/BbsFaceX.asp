<!--#include file="../conn.asp"-->
<!--#include file="inc/const.asp"-->
<%
Head()
Dim admin_flag
admin_flag=",38,"
CheckAdmin(admin_flag)
If "save"=request("action") Then
	Dim sConfig,aTitle,aFrom,aTo,aWidth,aHeight,aNWidth,aNHeight,i,iDel
	aTitle=Split(request("title"),",")
	aFrom=Split(request("from"),",")
	aTo=Split(request("to"),",")
	aWidth=Split(request("width"),",")
	aHeight=Split(request("height"),",")
	aNWidth=Split(request("nwidth"),",")
	aNHeight=Split(request("nheight"),",")
	sConfig=""
	iDel=0
	For i=0 To UBound(aTitle)
		If "1"=Trim(request("isdel_"&i)) Then 
			iDel = iDel + 1
		ElseIf ""<>Trim(aTitle(i)) Then 
			If ""<>sConfig Then sConfig=sConfig&","
			sConfig=sConfig&"{t:"""&Trim(aTitle(i))&""",b:"&Dvbbs.CheckNumeric(Trim(aFrom(i)))&",e:"&Dvbbs.CheckNumeric(Trim(aTo(i)))&",w:"&Dvbbs.CheckNumeric(Trim(aWidth(i)))&",h:"&Dvbbs.CheckNumeric(Trim(aHeight(i)))&",nw:"&Dvbbs.CheckNumeric(Trim(aNWidth(i)))&",nh:"&Dvbbs.CheckNumeric(Trim(aNHeight(i)))&",p:'../images/emot/'}"&VBNewline
		End If 
	Next 
	If iDel<UBound(aTitle) Then 
		sConfig="var global_emot_config=["&sConfig&"];"&VBNewline
		If "1"=request("isdel_"&request("default_set")) Then 
			sConfig=sConfig&("var global_emot_default=0;")
		Else 
			sConfig=sConfig&("var global_emot_default="&CInt(request("default_set"))&";")
		End If 
		On Error Resume Next 
		DvStream.charset="gb2312"
		DvStream.Mode = 3
		DvStream.open()
		DvStream.WriteText(sConfig)
		DvStream.SaveToFile Server.MapPath("../images/emot/Config.js"),2
		DvStream.close()
		If Err Then
			Err.clear
			%>
			<table width="100%" border="0" cellspacing="1" cellpadding="3" align=center>
			<tr> 
			<td height="23"><b><font color=red>���������ļ�ʧ�ܣ�</font></b>����������images/emot/Ŀ¼û��д����޸�Ȩ�ޡ������Կ���Ȩ�޺��ٱ��棬���߸������������ճ����images/emot/config.js���滻ԭ�����������ݡ�</td>
			</tr>
			<tr> 
			<td><textarea style="width:500px;height:200px;" onfocus="this.select()"><%=sConfig%></textarea></td>
			</tr>
			</table>
			<%
		End If 
	Else
		%>
		<table width="100%" border="0" cellspacing="1" cellpadding="3" align=center>
		<tr> 
		<td height="23"><b><font color=red>����ȫ��ɾ���������ٱ���һ�ױ��顣</font></b></td>
		</tr>
		</table>
		<%
	End If 
End If 
SetForm
Sub SetForm()
%>
<script language="javascript" src="../images/emot/config.js?rnd=<%=Now()%>"></script>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align=center>
<tr> 
<td height="23"><B>˵��</B>��<br>�١�ͼƬͳһ�������̳Images/emot/Ŀ¼���ļ���ΪemX.gif������X��ʾ��λ����λ�������֡�������λǰ�油0��<br>�ڡ��˴�����Ϊ�༭�������뷢������ʱ��<BR>�ۡ��˴�����ֻ�������ļ����������漰ɾ��ͼƬ������<BR>�ܡ����ӷǹٷ���ͼ����ѡ�����ŶΣ������10000��ʼ���Ա�����ٷ���ͼ��ų�ͻ��
</td>
</tr>
</table>
<form name="form1" action="?action=save" method="post" style="margin:0px;padding:0px;">
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<tr> 
<th colspan="2">��ͼ���ã������޸��������ã�Ҳ������������ͼ��</th>
</tr>
<script language="javascript">
<!--
var a=global_emot_config,d=document;
for (var i=0; i<a.length; ++i){
	d.writeln('<tr><td colspan="2" height="5"></td></tr><tr> <td width="20%" align="right">���⣺</td><td><input type="text" name="title" value="'+a[i]['t']+'" size="30" '+(global_emot_default==i?'style="font-weight:bold"':'')+' />&nbsp;<input type="checkbox" name="isdel_'+i+'" value="1" style="border:none" />ɾ��&nbsp;<input type="radio" name="default_set" value="'+i+'" style="border:none;" '+(global_emot_default==i?'checked="checked"':'')+' />��ΪĬ��</td></tr>');
	d.writeln('<tr> <td width="20%" align="right">��ʼ��ţ�</td><td><input type="text" name="from" value="'+a[i]['b']+'" size="10" /></td></tr>');
	d.writeln('<tr> <td width="20%" align="right">������ţ�</td><td><input type="text" name="to" value="'+a[i]['e']+'" size="10" /></td></tr>');
	d.writeln('<tr> <td width="20%" align="right">���ȣ�</td><td><input type="text" name="width" value="'+a[i]['w']+'" size="10" /></td></tr>');
	d.writeln('<tr> <td width="20%" align="right">�߶ȣ�</td><td><input type="text" name="height" value="'+a[i]['h']+'" size="10" /></td></tr>');
	d.writeln('<tr> <td width="20%" align="right">һ����ʾ������</td><td><input type="text" name="nwidth" value="'+a[i]['nw']+'" size="10" /></td></tr>');
	d.writeln('<tr> <td width="20%" align="right">��ʾ�����У�</td><td><input type="text" name="nheight" value="'+a[i]['nh']+'" size="10" /></td></tr>');
}
//-->
</script>
<tr><td colspan="2" height="5"></td></tr>
<tr> 
<td width="20%" align="right">���⣺</td>
<td><input type="text" name="title" value="" size="30" />&nbsp;*��д��������ͼ��ÿ�������ܺ���Ӣ�Ķ��š�</td>
</tr>
<tr> 
<td width="20%" align="right">��ʼ��ţ�</td>
<td><input type="text" name="from" value="" size="10" /></td>
</tr>
<tr> 
<td width="20%" align="right">������ţ�</td>
<td><input type="text" name="to" value="" size="10" /></td>
</tr>
<tr> 
<td width="20%" align="right">���ȣ�</td>
<td><input type="text" name="width" value="" size="10" /></td>
</tr>
<tr> 
<td width="20%" align="right">�߶ȣ�</td>
<td><input type="text" name="height" value="" size="10" /></td>
</tr>
<tr> 
<td width="20%" align="right">һ����ʾ������</td>
<td><input type="text" name="nwidth" value="" size="10" /></td>
</tr>
<tr> 
<td width="20%" align="right">��ʾ�����У�</td>
<td><input type="text" name="nheight" value="" size="10" /></td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<tr> 
<td width="20%" align="right"></td>
<td><input type="submit" name="sub1" value=" �ύ���� " /></td>
</tr>
</table>
</form>
<%
End Sub 
%>
