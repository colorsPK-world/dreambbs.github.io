<!--#include file=../conn.asp-->
<!-- #include file="inc/const.asp" -->
<!--#include file="../inc/dv_clsother.asp"-->
<%
Head()
Dim admin_flag
admin_flag=",5,"
CheckAdmin(admin_flag)

If request("action")="save" Then
	Call savegrade()
Else
	Call grade()
End If
If  founderr Then dvbbs_error()
Footer()

sub grade()
dim sel
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr> 
<th colspan="2" style="text-align:center;">�û���������</th>
</tr>
<tr> 
<td width="100%" class=td2 colspan=2>
<B>˵��</B>��<BR>1����ѡ����ѡ���Ϊ��ǰ��ʹ������ģ�壬����ɲ鿴��ģ�����ã�������ģ��ֱ�Ӳ鿴��ģ�岢�޸����á������Խ�����������ñ����ڶ����̳������<BR>2����Ҳ���Խ������趨����Ϣ���沢Ӧ�õ�����ķ���̳���������У��ɶ�ѡ<BR>3�����������һ���������ñ�İ�������ã�ֻҪ����ð������ƣ������ʱ��ѡ��Ҫ���浽�İ����������Ƽ��ɡ�<BR>
4��Ĭ��ģ���еĻ�������Ϊ��̳����ҳ�棨<font color=blue>�������������̳����</font>��ʹ�ã����¼��ע�����ط�ֵ���������̳��������в�ͬ�Ļ������ã��緢����ɾ���ȣ���Ȼ��Ҳ���Ը���������趨�����趨���а���Ļ������ö���һ���ġ�
</td>
</tr>
<FORM METHOD=POST ACTION="">
<tr> 
<td width="100%" class="td2" colspan=2>
�鿴�ְ���������ã���ѡ�������������Ӧ����&nbsp;&nbsp;
<select onchange="if(this.options[this.selectedIndex].value!=''){location=this.options[this.selectedIndex].value;}">
<option value="">�鿴�ְ�������ѡ��</option>
<%
Dim ii,rs
set rs=Dvbbs.Execute("select boardid,boardtype,depth from dv_board order by rootid,orders")
do while not rs.eof
Response.Write "<option "
if rs(0)=dvbbs.boardid then
Response.Write " selected"
end if
Response.Write " value=""wealth.asp?boardid="&rs(0)&""">"
Select Case rs(2)
	Case 0
		Response.Write "��"
	Case 1
		Response.Write "&nbsp;&nbsp;��"
End Select
If rs(2)>1 Then
	For ii=2 To rs(2)
		Response.Write "&nbsp;&nbsp;��"
	Next
	Response.Write "&nbsp;&nbsp;��"
End If
Response.Write rs(1)
Response.Write "</option>"
rs.movenext
loop
rs.close
set rs=nothing
%>
</select>
</td>
</tr>
</FORM>
</table><BR>

<form method="POST" action=wealth.asp?action=save>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr> 
<td width="100%" class=td2 colspan=2>
<input type=checkbox class=checkbox name="getskinid" value="1" <%if request("getskinid")="1" or request("boardid")="" then Response.Write "checked"%>><a href="wealth.asp?getskinid=1">��̳Ĭ�ϻ���</a><BR> ����˴�������̳Ĭ�ϻ������ã�Ĭ�ϻ������ð�������<FONT COLOR="blue">��</FONT>��������������ݣ��緢���������������ȣ�<FONT COLOR="blue">����</FONT>��ҳ�档<hr size=1 width="90%" color=blue>
</td>
</tr>
<tr>
<td width="200" class="td1">
����������ñ���ѡ��<BR>
�밴 CTRL ����ѡ<BR>
<select name="getboard" size="40" style="width:100%" multiple>
<%
set rs=Dvbbs.Execute("select boardid,boardtype,depth from dv_board order by rootid,orders")
do while not rs.eof
Response.Write "<option "
if rs(0)=dvbbs.boardid then
Response.Write " selected"
end if
Response.Write " value="&rs(0)&">"
Select Case rs(2)
	Case 0
		Response.Write "��"
	Case 1
		Response.Write "&nbsp;&nbsp;��"
End Select
If rs(2)>1 Then
	For ii=2 To rs(2)
		Response.Write "&nbsp;&nbsp;��"
	Next
	Response.Write "&nbsp;&nbsp;��"
End If
Response.Write rs(1)
Response.Write "</option>"
rs.movenext
loop
rs.close
set rs=nothing
%>
</select>
</td>
<td class="td1" valign=top>
<table width=100%>
<tr> 
<th colspan="2" style="text-align:center;">�û���Ǯ�趨</th>
</tr>
<tr> 
<td width="40%" class=td1>ע���Ǯ��</td>
<td width="60%" class=td1> 
<input type="text" name="wealthReg" size="35" value="<%=Dvbbs.Forum_user(0)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>��¼���ӽ�Ǯ</td>
<td width="60%" class=td1> 
<input type="text" name="wealthLogin" size="35" value="<%=Dvbbs.Forum_user(4)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>�������ӽ�Ǯ</td>
<td width="60%" class=td1> 
<input type="text" name="wealthAnnounce" size="35" value="<%=Dvbbs.Forum_user(1)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>�������ӽ�Ǯ</td>
<td width="60%" class=td1> 
<input type="text" name="wealthReannounce" size="35" value="<%=Dvbbs.Forum_user(2)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>�������ӽ�Ǯ</td>
<td width="60%" class=td1> 
<input type="text" name="BestWealth" size="35" value="<%=Dvbbs.Forum_user(15)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>ɾ�����ٽ�Ǯ</td>
<td width="60%" class=td1> 
<input type="text" name="wealthDel" size="35" value="<%=Dvbbs.Forum_user(3)%>">
</td>
</tr>
<tr> 
<th colspan="2" style="text-align:center;">�û������趨</th>
</tr>
<tr> 
<td width="40%" class=td1>ע�����ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="epReg" size="35" value="<%=Dvbbs.Forum_user(5)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>��¼���ӻ���ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="epLogin" size="35" value="<%=Dvbbs.Forum_user(9)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>�������ӻ���ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="epAnnounce" size="35" value="<%=Dvbbs.Forum_user(6)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>�������ӻ���ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="epReannounce" size="35" value="<%=Dvbbs.Forum_user(7)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>�������ӻ���ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="bestuserep" size="35" value="<%=Dvbbs.Forum_user(17)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>ɾ�����ٻ���ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="epDel" size="35" value="<%=Dvbbs.Forum_user(8)%>">
</td>
</tr>
<tr> 
<th colspan="2" style="text-align:center;">�û������趨</th>
</tr>
<tr> 
<td width="40%" class=td1>ע������ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="cpReg" size="35" value="<%=Dvbbs.Forum_user(10)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>��¼��������ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="cpLogin" size="35" value="<%=Dvbbs.Forum_user(14)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>������������ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="cpAnnounce" size="35" value="<%=Dvbbs.Forum_user(11)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>������������ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="cpReannounce" size="35" value="<%=Dvbbs.Forum_user(12)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>������������ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="bestusercp" size="35" value="<%=Dvbbs.Forum_user(16)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>ɾ����������ֵ</td>
<td width="60%" class=td1> 
<input type="text" name="cpDel" size="35" value="<%=Dvbbs.Forum_user(13)%>">
</td>
</tr>
<tr> 
<td width="40%" class=td1>&nbsp;</td>
<td width="60%" class=td1> 
<div align="center"> 
<input type="submit" class="button" name="Submit" value="�� ��">
</div>
</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
<%
end sub

Sub savegrade()
	Dim Forum_user,iforum_setting,forum_setting,rs,sql,BoardIdStr,i
	Forum_user=Dvbbs.CheckNumeric(request.form("wealthReg")) & "," & Dvbbs.CheckNumeric(request.form("wealthAnnounce")) & "," & Dvbbs.CheckNumeric(request.form("wealthReannounce")) & "," & Dvbbs.CheckNumeric(request.form("wealthDel")) & "," & Dvbbs.CheckNumeric(request.form("wealthLogin")) & "," & Dvbbs.CheckNumeric(request.form("epReg")) & "," & Dvbbs.CheckNumeric(request.form("epAnnounce")) & "," & Dvbbs.CheckNumeric(request.form("epReannounce")) & "," & Dvbbs.CheckNumeric(request.form("epDel")) & "," & Dvbbs.CheckNumeric(request.form("epLogin")) & "," & Dvbbs.CheckNumeric(request.form("cpReg")) & "," & Dvbbs.CheckNumeric(request.form("cpAnnounce")) & "," & Dvbbs.CheckNumeric(request.form("cpReannounce")) & "," & Dvbbs.CheckNumeric(request.form("cpDel")) & "," & Dvbbs.CheckNumeric(request.form("cpLogin")) & "," & Dvbbs.CheckNumeric(request.form("BestWealth")) & "," & Dvbbs.CheckNumeric(request.form("BestuserCP")) & "," & Dvbbs.CheckNumeric(request.form("BestuserEP"))
	'response.write Forum_user
	
	'forum_info|||forum_setting|||forum_user|||copyright|||splitword|||stopreadme
	Set rs=Dvbbs.execute("select forum_setting from dv_setup")
	iforum_setting=split(rs(0),"|||")
	forum_setting=iforum_setting(0) & "|||" & iforum_setting(1) & "|||" & forum_user & "|||" & iforum_setting(3) & "|||" & iforum_setting(4) & "|||" & iforum_setting(5)
	forum_setting=dvbbs.checkstr(forum_setting)
	
	If request("getskinid")="1" Then
		sql = "update dv_setup set Forum_setting='"&forum_setting&"'"
		Dvbbs.Execute(sql)
		Dvbbs.Name="setup"
		Dvbbs.loadSetup()
	End If

	For i = 1 TO request("getboard").Count
		If isNumeric(request("getboard")(i)) Then
			If BoardIdStr = "" Then
				BoardIdStr = request("getboard")(i)
			Else
				BoardIdStr = BoardIdStr & "," & request("getboard")(i)
			End If
		End If
	Next

	If request("getboard")<>"" Then
		sql = "update dv_board set board_user='"&Forum_user&"' where boardid in ("&BoardIdStr&")"
		Dvbbs.Execute(sql)
		Dvbbs.ReloadBoardCache request("getboard")
	End If
	Dv_suc("��̳�������óɹ���")
End  Sub

%>