<!--#include file="../conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="../inc/md5.asp"-->
<!--#include file="../inc/myadmin.asp"-->
<%
Head()
Dim	admin_flag
admin_flag=",18,"
CheckAdmin(admin_flag)
Dim body,username2,password2,oldpassword,oldusername,oldadduser,username1
'ȡ���û������Ա������	2002-12-13
Dim	groupsname,titlepic,rs
Set	rs=Dvbbs.Execute("select usertitle,grouppic	from [dv_UserGroups] where UserGroupID=1 ")
groupsname=rs(0)
titlepic=rs(1)
set	rs=Nothing

Dim id
id=Dvbbs.CheckNumeric(Request("id"))

Select Case Request("action")
	Case "updat" : update()
	Case "del" : Del()
	Case "pasword" : pasword()
	Case "newpass" : newpass()
	Case "add" : addadmin()
	Case "edit" : userinfo()
	Case "savenew" : savenew()
	Case Else
		userlist()
End Select
If ErrMsg<>"" Then Dvbbs_Error
Footer()

Sub	userlist()
%>
<table cellpadding="2" cellspacing="1" border="0" width="100%" align="center">
				<tr>
				  <th style="text-align:center;" colspan=5>����Ա����(����û������в���)</th>
				</tr>
				<tr	align=center>
				  <td width="30%" height=22 class="td1"><B>�û���</B></td><td width="25%" class="td2"><B>�ϴε�¼ʱ��</B></td><td width="15%" class="td1"><B>�ϴε�½IP</B></td><td width="15%" class="td2"><B>����</B></td>
				</tr>
<%
	set	rs=Dvbbs.Execute("select * from "&admintable&" order by LastLogin desc")
	do while not rs.eof
%>
				<tr>
				  <td class=td1><a	href="admin.asp?id=<%=rs("id")%>&action=pasword"><%=rs("username")%></a></td><td class=td2><%=rs("LastLogin")%></td><td class=td1><%=rs("LastLoginIP")%>&nbsp;</td><td class=td2><a	href="admin.asp?action=del&id=<%=rs("id")%>&name=<%=Rs("adduser")%>" onclick="{if(confirm('ɾ����ù���Ա�����ɽ����̨��\n\nȷ��ɾ����?')){return true;}return false;}">ɾ��</a>&nbsp;&nbsp;<a	href="admin.asp?id=<%=rs("id")%>&action=edit">�༭Ȩ��</a></td>
				</tr>
<%
	rs.movenext
	loop
	rs.close
	set	rs=nothing
%>
		   </table>
<%
	end	sub

Sub	Del()
	Dim	UserTitle,sql,rs
	Rem	���³�������Ա��ĵȼ����� 2004-4-29 Dvbbs.YangZheng
	Sql	= "SELECT Top 1	UserTitle From Dv_UserGroups Where MinArticle >	0 And ParentGID	= 4	Order By UserGroupID"
	Set	Rs = Dvbbs.Execute(Sql)
	If Rs.Eof And Rs.Bof Then
		UserTitle =	"������·"
	Else
		UserTitle =	Rs(0)
	End	If
	Dvbbs.Execute("DELETE FROM " & Admintable &	" WHERE	Id = " & id)
	Dvbbs.Execute("UPDATE [Dv_User]	SET	Usergroupid	= 4, UserClass = '"	& UserTitle	& "' WHERE Username	= '" & Replace(Request("name"),"'","")	& "'")
	body="<li>����Աɾ���ɹ���"
	Dv_suc(body)
End	Sub

Sub	pasword()
	Dim AcceptIP,i,AddIP,rs
	set	Rs=Dvbbs.Execute("select * from	"&admintable&" where id="&id)
	oldpassword=rs("password")
	oldadduser=rs("adduser")
	AcceptIP = Rs("AcceptIP") &""
	AddIP = Dvbbs.UserTrueIP
	AddIP = Left(AddIP, InStrRev(AddIP, ".")-1)
	AddIP = Left(AddIP, InStrRev(AddIP, ".")-1)
	AddIP = AddIP &".*.*"
  %>
<form action="?action=newpass" method=post>
<table cellpadding="2" cellspacing="1" border="0" width="100%" align="center">
			   <tr>
				  <th colspan=2 style="text-align:center;">����Ա���Ϲ������������޸�
				  </th>
				</tr>
			   <tr >
			<td	width="26%"	align="right" class=td1>��̨��¼���ƣ�</td>
			<td	width="74%"	class=td1>
			  <input type=hidden name="oldusername"	value="<%=rs("username")%>">
			  <input type=text name="username2"	value="<%=rs("username")%>">  (����ע������ͬ)
			</td>
		  </tr>
		  <tr >
			<td	width="26%"	align="right" class=td1>��̨��¼���룺</td>
			<td	width="74%"	class=td1>
			  <input type="password" name="password2" value="<%=oldpassword%>">	 (����ע�����벻ͬ,��Ҫ�޸���ֱ������)
			</td>
		  </tr>
		  <tr>
			<td	width="26%"	align="right" class=td1 height=23>ǰ̨�û����ƣ�</td>
			<td	width="74%"	class=td1><%=oldadduser%>
			</td>
		 </tr>
		<tr>
			<td	width="26%"	align="right" class=td1 height=23>����ֻ������½IP�б���
			</td>
			<td	width="74%"	class=td1>
			<textarea name="AddAcceptIP" cols="40" rows="8"><%
			If AcceptIP<>"" or not IsNull(AcceptIP) Then
				AcceptIP=Split(Trim(AcceptIP),"|")
				For i=0 To Ubound(AcceptIP)
					Response.Write AcceptIP(i)
					If i<Ubound(AcceptIP) Then Response.Write vbCrLf
				Next
			End If
			%></textarea><br><input type=button value="�������ѵ�ǰIP" onclick="AddAcceptIP.value+='\n<%=AddIP%>'"> <%=dvbbs.UserTrueIP%>
			<fieldset class="fieldset" style="margin:2px 2px 2px 2px">
			<legend><B>����˵��</B></legend>
			<ol>
			<LI><b>��ղ���д����������IP��½��̨��</b>
			<LI><b><font color=red>��������IP�εķ�ʽ���磺10.10.*.*��</font></b>
			<LI><b>ע�⣺�ύ�����´ε�½������Ч����IP��������޷���½��̨��</b>
			<LI>����IP�󣬸ù���Ա����IP�����������IP�б����ܵ�½��̨��	<LI>���������Ӷ������IP��ÿ��IP�ûس��ָ�������IP����д��ʽ��202.152.12.1��������202.152.12.1���IP�ĵ�½��̨����202.152.12.*����������202.152.12��ͷ��IP��½��̨��
			<LI>�����Ӷ��IP��ʱ����ע�����һ��IP�ĺ��治Ҫ�ӻس���
			</ol></fieldset>
			</td>
		  </tr>
		  <tr align="center">
			<td	colspan="2"	class=td1>
			  <input type=hidden name="adduser"	value="<%=oldadduser%>">
			  <input type=hidden name=id value="<%=id%>">
			  <input type="submit" name="Submit" value="�� ��">
			</td>
		  </tr>
		</table>
		</form>
<%		 Rs.close
		 Set Rs=nothing
End	Sub

Sub	newpass()
	dim	passnw,usernw,aduser
	Dim AcceptIP,Tempstr,i,rs,sql
	set	rs=Dvbbs.Execute("select * from	"&admintable&" where id="&id)
	oldpassword=rs("password")
	if request("username2")="" then
		ErrMsg = "<li>���������Ա���֡�<a href=?>�� <font color=red>����</font> ��</a>"
		exit sub
	else
		usernw=trim(request("username2"))
	end	if
	if request("password2")="" then
		ErrMsg = "<li>�������������롣<a href=?>�� <font color=red>����</font> ��</a>"
		exit sub
	elseif trim(request("password2"))=oldpassword then
		passnw=request("password2")
	else
		passnw=md5(request("password2"),16)
	end	if
	if request("adduser")="" then
		ErrMsg = "<li>���������Ա���֡�<a	href=?>�� <font	color=red>����</font> ��</a>"
		exit sub
	else
		aduser=trim(request("adduser"))
	end	if
	Tempstr = Trim(Request.Form("AddAcceptIP"))
	If Tempstr<>"" Then
		Tempstr = Split(Tempstr,vbCrLf)
		For i = 0 To ubound(Tempstr)
			If Tempstr(i)<>"" and Tempstr(i)<>" " and Isnumeric(Replace(Replace(Tempstr(i),".",""),"*","")) and Instr(Tempstr(i),",")=0 Then
				If i=0 or AcceptIP="" Then
					AcceptIP = Tempstr(i)
				Else
					AcceptIP = AcceptIP & "|" & Tempstr(i)
				End If
			End If
		Next
	End If
	If Len(AcceptIP)>=255 Then
		ErrMsg = "<li>����IP�б�̫�࣬���������ơ�<a href=?>�� <font color=red>����</font> ��</a>"
		exit sub
	End If
	set	rs=Dvbbs.iCreateObject("adodb.recordset")
	sql="select	* from "&admintable&" where	username='"&trim(Replace(request("oldusername"),"'",""))&"'"
	rs.open	sql,conn,1,3
	if not rs.eof and not rs.bof then
	Rs("username") = usernw
	Rs("adduser") = aduser
	Rs("password") = passnw
	Rs("AcceptIP") = AcceptIP
''''''''''''''
'�����û��ĵļ���
	'Dvbbs.Execute("update [dv_user]	set	usergroupid=1,userclass='"&groupsname&"',titlepic='"&titlepic&"' where username='"&trim(request("adduser"))&"'")	'
	body="<li>����Ա���ϸ��³ɹ������ס������Ϣ��<br> ����Ա��"&request("username2")&"	<BR> ��	  �룺"&request("password2")&" <a href=?>�� <font	color=red>����</font> ��</a>"
	Dv_suc(body)
	rs.update
	End	if
	rs.close
	set	rs=nothing
end	sub

sub	addadmin()
%>
<form action="?action=savenew" method=post>
<table cellpadding="2" cellspacing="1" border="0" width="100%" align="center">
<tr>
	<th colspan=2 style="text-align:center;">����Ա�����������ӹ���Ա</th>
</tr>
<tr>
	<td	width="26%"	align="right" class=td1>��̨��¼���ƣ�</td>
	<td	width="74%"	class=td1>
	<input type=text name="username2" size=30>  (����ע������ͬ)
	</td>
</tr>
<tr>
	<td	width="26%"	align="right" class=td1>��̨��¼���룺</td>
	<td	width="74%"	class=td1>
	<input type="password" name="password2" size=33>	(����ע�����벻ͬ)
	</td>
</tr>
<tr>
	<td	width="26%"	align="right" class=td1 height=23>ǰ̨�û����ƣ�</td>
	<td	width="74%"	class=td1><input type=text	name="username1" size=30>  (��ѡ����д�������޸�)
	</td>
</tr>
<tr align="center">
	<td	colspan="2"	class=td1>
	<input type="hidden" name="isdisp" value="1" />
	<input type="submit" class="button" name="Submit" value="�� ��">
	</td>
</tr>
</table>
</form>
<%
end	sub

sub	savenew()
dim	adminuserid
	if request.form("username2")=""	then
		ErrMsg = "�������̨��¼�û�����"
		exit sub
	end	if
	if request.form("username1")=""	then
		ErrMsg = "������ǰ̨��¼�û�����"
		exit sub
	end	if
	if request.form("password2")=""	then
		ErrMsg = "�������̨��¼���룡"
		exit sub
	end	if
	dim isdisp,rs
	If request("isdisp")="" then
		isdisp=1
	else
		isdisp=cint(request("isdisp"))
	end if

	set	rs=Dvbbs.Execute("select userid	from [dv_user] where username='"&replace(request.form("username1"),"'","")&"'")
	if rs.eof and rs.bof then
		ErrMsg = "��������û�������һ����Ч��ע���û���"
		exit sub
	else
		adminuserid=rs(0)
	end	if

	set	rs=Dvbbs.Execute("select username from "&admintable&" where	username='"&replace(request.form("username2"),"'","")&"'")
	if not (rs.eof and rs.bof) then
		ErrMsg = "��������û����Ѿ��ڹ����û��д��ڣ�"
		exit sub
	end	if
	if isdisp=1 then
	Dvbbs.Execute("update [dv_user]	set	usergroupid=1 ,	userclass='"&groupsname&"',titlepic='"&titlepic&"' where userid="&adminuserid&" ")
	end if
	Dvbbs.Execute("insert into "&Admintable&" (username,[password],adduser)	values ('"&replace(request.form("username2"),"'","")&"','"&md5(replace(request.form("password2"),"'",""),16)&"','"&replace(request.form("username1"),"'","")&"')")
	body="�û�ID:"&adminuserid&" ���ӳɹ������ס�¹���Ա��̨��¼��Ϣ�������޸��뷵�ع���Ա������"
	Dv_suc(body)
end	sub

sub	userinfo()
dim	menu(10,10),trs,k
menu(0,0)="�������"
menu(0,1)="<a href=setting.asp target=frmright>��������</a>@@1"
menu(0,2)="<a href=ForumAds.asp target=frmright>������</a>@@2"
menu(0,3)="<a href=log.asp target=frmright>��̳��־</a>@@3"
menu(0,4)="<a href=help.asp target=frmright>��������</a>@@4"
menu(0,5)="<a href=wealth.asp target=frmright>��������</a>@@5"
menu(0,6)="<a href=message.asp target=frmright>���Ź���</a>@@6"
menu(0,7)="<a href=announcements.asp?boardid=0&action=AddAnn target=_blank>�������</a>@@7"
Rem С�� ȥ��Ȧ��
menu(0,8)="<a href=""ForumPay.asp"" target=main>���׹���</a>@@8"
menu(0,9)="<a href=""javascript:void(0);"" target=frmright>&nbsp;&nbsp;</a>@@9"
menu(0,10)="<a href=""ForumNewsSetting.asp"" target=main>��ҳ����</a>@@10"

menu(1,0)="��̳����"
menu(1,1)="<a href=board.asp?action=add target=frmright>����(����)����</a> | <a href=board.asp target=frmright>����</a>@@11"
menu(1,2)="<a href=board.asp?action=permission target=frmright>�ְ����û�Ȩ������</a>@@12"
menu(1,3)="<a href=boardunite.asp target=frmright>�ϲ���������</a>@@13"
menu(1,4)="<a href=update.asp target=frmright>�ؼ���̳���ݺ��޸�</a>@@14"
menu(1,5)="<a href=link.asp?action=add target=frmright>������̳����</a> | <a href=link.asp target=frmright>����</a>@@15"

menu(2,0)="�û�����"
menu(2,1)="<a href=user.asp target=frmright>�û�����(Ȩ��)����</a>@@16"
menu(2,2)="<a href=group.asp target=frmright>��̳�û���(�ȼ�)����</a>@@17"
menu(2,3)="<a href=admin.asp?action=add target=frmright>����Ա����</a> | <a href=admin.asp target=frmright>����</a>@@18"
menu(2,4)="<a href=Update_User.asp target=frmright>�����û�����</a>@@19"
menu(2,5)="<a href=update.asp?action=updateuser target=frmright>�ؼ��û���������</a>@@20"
menu(2,6)="<a href=SendEmail.asp target=frmright>�û��ʼ�Ⱥ������</a>@@21"

menu(3,0)="�������"
menu(3,1)="<a href=template.asp target=frmright>������ģ���ܹ���</a>@@22"
menu(3,2)="<a href=label.asp target=frmright>�Զ����ǩ����</a>@@23"

menu(4,0)="��̳���ӹ���"
menu(4,1)="<a href=alldel.asp target=frmright>����ɾ��</a> | <a href=alldel.asp?action=moveinfo	target=frmright>�����ƶ�</a>@@24"
menu(4,2)="<a href=../recycle.asp target=_blank>����վ����</a>@@25"
menu(4,3)="<a href=postdata.asp?action=Nowused target=frmright>��ǰ�������ݱ�����</a>@@26"
menu(4,4)="<a href=postdata.asp target=frmright>���ݱ�������ת��</a>@@27"

menu(5,0)="�滻/���ƴ���"
menu(5,1)="<a href=badword.asp?reaction=badword target=frmright>�໰��������</a>@@28"
menu(5,2)="<a href=badword.asp?reaction=splitreg target=frmright>ע������ַ�</a>@@29"
menu(5,3)="<a href=lockip.asp?action=add target=frmright>IP�����޶�����</a> | <a href=lockip.asp target=frmright>����</a>@@30"
menu(5,4)="<a href=address.asp?action=add target=frmright>��̳IP������</a> | <a href=address.asp target=frmright>����</a>@@31"

menu(6,0)="���ݴ���(Access)"
menu(6,1)="<a href=data.asp?action=CompressData target=frmright>ѹ�����ݿ�</a>@@32"
menu(6,2)="<a href=data.asp?action=BackupData target=frmright>�������ݿ�</a>@@33"
menu(6,3)="<a href=data.asp?action=RestoreData target=frmright>�ָ����ݿ�</a>@@34"
menu(6,4)="<a href=data.asp?action=SpaceSize target=frmright>ϵͳ�ռ�ռ��</a>@@35"

menu(7,0)="�ļ�����"
menu(7,1)="<a href=upUserface.asp target=frmright>�ϴ�ͷ�����</a>@@36"
menu(7,2)="<a href=uploadlist.asp target=frmright>�ϴ��ļ�����</a>@@37"
menu(7,3)="<a href=bbsface.asp?Stype=3 target=frmright>ע��ͷ�����</a> | <a href=bbsface.asp?Stype=2 target=frmright>�����������</a> | <a href=bbsface.asp?Stype=1 target=frmright>�����������</a>@@38"

menu(8,0)="�˵�����"
menu(8,1)="<a href=plus.asp target=frmright>��̳�˵�����</a>@@39"

menu(9,0)="�������Ĺ���"
menu(9,1)="<a href=plus_Tools_Info.asp?action=List target=frmright>������������</a>@@40"
menu(9,2)="<a href=plus_Tools_User.asp target=frmright>�û����߹���</a> | <a href=plus_Tools_User.asp?action=paylist target=frmright>������Ϣ����</a>@@41"
menu(9,3)="<a href=MoneyLog.asp target=frmright>����������־</a>@@42"
menu(9,4)="<a href=plus_Tools_Magicface.asp target=frmright>ħ����������</a>@@43"

menu(10,0)="��չģ�����"
menu(10,1)="<a href=../bokeadmin.asp target=frmright>��̳����ϵͳ����</a>@@44"
'menu(10,2)="<a href=myspace.asp target=frmright>��̳���˿ռ����</a>@@45"

Dim	j,tmpmenu,menuname,menurl
Dim Rs,i,adminPower,admin_username
Set	Rs=Dvbbs.Execute("select * from	"&admintable&" where id="&id)
admin_username = Rs("username")
adminPower=","&Rs("flag")&","
Rs.Close:Set Rs=Nothing
%>
<form action="admin.asp?action=updat"	method=post	name=adminflag>
<table cellpadding="2" cellspacing="1" border="0" width="100%" align="center">
	<tr><th	height=25><b>����ԱȨ�޹���</b>(��ѡ����Ӧ��Ȩ�޷��������Ա <%=admin_username%>)</th></tr>
	<tr><td	height=25 class="forumHeaderBackgroundAlternate"><b>>>ȫ��Ȩ��</b></td></tr>
	<tr>
		<td	class=td1>
		<%
		For i=0 To ubound(menu,1)
			Response.Write "<b>"&menu(i,0)&"</b><br>"
			'on error resume next
			For j=1	To UBound(menu,2)
				If IsEmpty(menu(i,j)) Then exit for
				'tmpmenu(0)Ϊ���ƣ�tmpmenu(1)Ϊ���
				tmpmenu=Split(menu(i,j),"@@")
				on error resume next
				Response.Write "<input type=""checkbox"" class=""checkbox"" name=""flag"" value="""&tmpmenu(1)&""""
				If InStr(adminPower,","&tmpmenu(1)&",")>0 Then Response.Write " checked"
				Response.write ">"&tmpmenu(1)&"."&tmpmenu(0)&"&nbsp;&nbsp;"
				If Err Then Err.Clear:Response.write "<Script language='javascript'>alert('"&i&"##"&j&"##"&menu(i,j)&"');</script>"
			Next
			Response.write "<br/><br/>"
		Next
		%>
		<input type=hidden name=id value="<%=id%>">
		<input type="submit" class="button" name="Submit" value="����">������<input name=chkall type=checkbox class="checkbox" value=on	onclick=CheckAll(this.form)>ѡ������Ȩ��
		</td>
	</tr>
</table>
</form>
<%
End	Sub

sub	update()
	' 1, 2,	3, 4, 5, 6,	7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35
	'Response.Write	request("flag")
	'response.end
	Dim rs,sql
	set	rs=Dvbbs.iCreateObject("adodb.recordset")
	sql="select	* from "&admintable&" where	id="&id
	rs.open	sql,conn,1,3
	if not rs.eof and not rs.bof then
		rs("flag")=replace(Request("flag")," ","")
			body="<li>����Ա���³ɹ������ס������Ϣ��"
			Dv_suc(body)
		rs.update
		if rs("adduser")=Dvbbs.membername then session("flag")=replace(request("flag")," ","")
	end	if
	rs.close
	set	rs=nothing
end	sub
%>