<!--#include file =../conn.asp-->
<!-- #include file="inc/const.asp" -->
<!-- #include file="../inc/dv_clsother.asp" -->
<%
Call Head()
Dim admin_flag
admin_flag=",2,"
CheckAdmin(admin_flag)
If request("action")="save" Then 
	Call saveconst()
Else
	Call consted()
End If
If founderr then call dvbbs_error()
footer()

Sub consted()
dim sel
%>
<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center">
<tr> 
<th colspan="2" style="text-align:center;"><b>��̳�������</b>����Ϊ���÷���̳�����Ƿ���̳��ҳ��棬����ҳ��Ϊ������ʾҳ�棩</th>
</tr>
<tr> 
<td width="100%" class="td2" colspan=2><B>˵��</B>��<BR>1����ѡ����ѡ���Ϊ��ǰ��ʹ������ģ�壬����ɲ鿴��ģ�����ã�������ģ��ֱ�Ӳ鿴��ģ�岢�޸����á������Խ�����������ñ����ڶ����̳������<BR>2����Ҳ���Խ������趨����Ϣ���沢Ӧ�õ�����ķ���̳���������У��ɶ�ѡ<BR>3�����������һ���������ñ�İ�������ã�ֻҪ����ð������ƣ������ʱ��ѡ��Ҫ���浽�İ����������Ƽ��ɡ�
<hr size=1 width="100%" color=blue>
</td>
</tr>
<FORM METHOD=POST ACTION="">
<tr> 
<td width="100%" class="td2" colspan=2>
�鿴�ְ��������ã���ѡ�������������Ӧ����&nbsp;&nbsp;
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
Response.Write " value=""forumads.asp?boardid="&rs(0)&""">"
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
<form method="POST" action="forumads.asp?action=save" name="advform">
<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center">
<tr> 
<td width="100%" class="td2" colspan=2>
<input type=checkbox class=checkbox name="getskinid" value="1" <%if request("getskinid")="1" or request("boardid")="" then Response.Write "checked"%>><a href="forumads.asp?getskinid=1">��̳Ĭ�Ϲ��</a><BR> ����˴�������̳Ĭ�Ϲ�����ã�Ĭ�Ϲ�����ð�������<FONT COLOR="blue">��</FONT>��������������ݣ��������б���������ʾ�����澫�������淢���ȣ�<FONT COLOR="blue">����</FONT>��ҳ�档<hr size=1 width="90%" color=blue>
</td>
</tr>
<tr> 
<td width="200px" class="td1" valign=top>
�����汣��ѡ��<BR>
�밴 CTRL ����ѡ<BR>
<select name="getboard" size="28" style="width:200px" multiple>
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
<table>
<tr>
<td width="200" class="td1"><B>��ҳ����������</B></td>
<td width="*" class="td1"> 
<textarea name="Forum_ads_0" cols="50" rows="3"><%=server.htmlencode(Dvbbs.Forum_ads(0))%></textarea>
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>��ҳβ��������</B></td>
<td width="*" class="td1"> 
<textarea name="Forum_ads_1" cols="50" rows="3"><%=server.htmlencode(Dvbbs.Forum_ads(1))%></textarea>
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>������ҳ�������</B></td>
<td width="*" class="td1"> 
<input type=radio class="radio" name="Forum_ads_2" value=0 <%if Dvbbs.Forum_ads(2)="0" then%>checked<%end if%>>�ر�&nbsp;
<input type=radio class="radio" name="Forum_ads_2" value=1 <%if Dvbbs.Forum_ads(2)="1" then%>checked<%end if%>>��&nbsp;
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>��̳��ҳ�������ͼƬ��ַ</B></td>
<td width="*" class="td1"> 
<input type="text" name="Forum_ads_3" size="35" value="<%=Dvbbs.Forum_ads(3)%>">
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>��̳��ҳ����������ӵ�ַ</B></td>
<td width="*" class="td1"> 
<input type="text" name="Forum_ads_4" size="35" value="<%=Dvbbs.Forum_ads(4)%>">
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>��̳��ҳ�������ͼƬ����</B></td>
<td width="*" class="td1"> 
<input type="text" name="Forum_ads_5" size="3" value="<%=Dvbbs.Forum_ads(5)%>">&nbsp;����
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>��̳��ҳ�������ͼƬ�߶�</B></td>
<td width="*" class="td1"> 
<input type="text" name="Forum_ads_6" size="3" value="<%=Dvbbs.Forum_ads(6)%>">&nbsp;����
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>������ҳ���¹̶����</B></td>
<td width="*" class="td1"> 
<input type=radio class="radio" name="Forum_ads_13" value=0 <%if Dvbbs.Forum_ads(13)="0" then%>checked<%end if%>>�ر�&nbsp;
<input type=radio class="radio" name="Forum_ads_13" value=1 <%if Dvbbs.Forum_ads(13)="1" then%>checked<%end if%>>��&nbsp;
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>��̳��ҳ���¹̶����ͼƬ��ַ</B></td>
<td width="*" class="td1"> 
<input type="text" name="Forum_ads_8" size="35" value="<%=Dvbbs.Forum_ads(8)%>">
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>��̳��ҳ���¹̶�������ӵ�ַ</B></td>
<td width="*" class="td1"> 
<input type="text" name="Forum_ads_9" size="35" value="<%=Dvbbs.Forum_ads(9)%>">
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>��̳��ҳ���¹̶����ͼƬ����</B></td>
<td width="*" class="td1"> 
<input type="text" name="Forum_ads_10" size="3" value="<%=Dvbbs.Forum_ads(10)%>">&nbsp;����
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>��̳��ҳ���¹̶����ͼƬ�߶�</B></td>
<td width="*" class="td1"> 
<input type="text" name="Forum_ads_11" size="3" value="<%=Dvbbs.Forum_ads(11)%>">&nbsp;����
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>�Ƿ�������������</B></td>
<td width="*" class="td1"> 
<input type=radio class="radio" name="Forum_ads_7" value=0 <%if Dvbbs.Forum_ads(7)="0" then%>checked<%end if%>>�ر�&nbsp;
<input type=radio class="radio" name="Forum_ads_7" value=1 <%if Dvbbs.Forum_ads(7)="1" then%>checked<%end if%>>��&nbsp;
</td>
</tr>
<tr> 
<td width="*" class="td1" valign="top" colspan=2><B>��̳�������������</B> <br>֧��HTML�﷨��JS���룬ÿ�������<font color="red">"#####"</font>(5��#��)�ֿ���</td>
</tr>
<tr>
<%
Dim Ads_14
If UBound(Dvbbs.Forum_ads)>13 Then
	Ads_14=Dvbbs.Forum_ads(14)
End If
%>
<td width="*" class="td1" colspan=2> 
<textarea name="Forum_ads_14" style="width:100%" rows="10"><%=Ads_14%></textarea>
</td>
</tr>
<tr> 
<td width="200" class="td1"><B>�Ƿ���ҳ�����ֹ��λ</B></td>
<td width="*" class="td1"> 
<input type=radio class="radio" name="Forum_ads_12" value=0 <%if Dvbbs.Forum_ads(12)="0" then%>checked<%end if%>>�ر�&nbsp;
<input type=radio class="radio" name="Forum_ads_12" value=1 <%if Dvbbs.Forum_ads(12)="1" then%>checked<%end if%>>��&nbsp;
</td>
</tr>
<tr>
<%
Dim Ads_15
If UBound(Dvbbs.Forum_ads)>14 Then
	Ads_15=Dvbbs.Forum_ads(15)
End If
%>
<td width="200" class="td1"><B>ҳ�����ֹ��λ����(����)</B><BR>��ȷ���Ѵ���ҳ�����ֹ��λ����<BR></td>
<td width="*" class="td1"> 
<input type=radio class="radio" name="Forum_ads_15" value=0 <%if Ads_15="0" then%>checked<%end if%>>�����б�&nbsp;
<input type=radio class="radio" name="Forum_ads_15" value=1 <%if Ads_15="1" then%>checked<%end if%>>��������&nbsp;
<input type=radio class="radio" name="Forum_ads_15" value=2 <%if Ads_15="2" then%>checked<%end if%>>���߶���ʾ&nbsp;
<input type=radio class="radio" name="Forum_ads_15" value=3 <%if Ads_15="3" then%>checked<%end if%>>���߶�����ʾ&nbsp;
</td>
</tr>

<%
Dim Ads_17
If UBound(Dvbbs.Forum_ads)>16 Then
	Ads_17=Dvbbs.Forum_ads(17)
Else
	Ads_17 = 0
End If
%>
<tr>
<td width="200" class="td1"><B>���ֹ��ÿ�й�����</B></td>
<td width="*" class="td1"> 
<input type="text" name="Forum_ads_17" size="3" value="<%=Ads_17%>">&nbsp;��
</td>
</tr>
<tr> 
<td width="*" class="td1" valign="top" colspan=2>֧��HTML�﷨��JS���룬ÿ����<font color="red">"#####"</font>(5��#��)�ֿ���</td>
</tr>
<tr>
<td width="*" class="td1" colspan=2>
<%
Dim Ads_16
If UBound(Dvbbs.Forum_ads)>15 Then
	Ads_16=Dvbbs.Forum_ads(16)
End If
%>
<textarea name="Forum_ads_16" style="width:100%" rows="10"><%=Ads_16%></textarea>
</td>
</tr>



<%
Dim Ads_18
If UBound(Dvbbs.Forum_ads)>17 Then
	Ads_18=Dvbbs.Forum_ads(18)
Else
	Ads_18 = 0
End If
%>
<tr>
<td width="200" class="td1"><B>���Ӷ�¥�������λ</B></td>
<td width="*" class="td1">
<input type=radio class="radio" name="Forum_ads_18" value="0"/>�ر�
<input type=radio class="radio" name="Forum_ads_18" value="1"/>����
</td>
</tr>
<tr> 
<td width="*" class="td1" valign="top" colspan=2>֧��HTML�﷨��JS���룬ÿ����<font color="red">"#####"</font>(5��#��)�ֿ���</td>
</tr>
<tr>
<td width="*" class="td1" colspan=2>
<%
Dim Ads_19
If UBound(Dvbbs.Forum_ads)>18 Then
	Ads_19=Dvbbs.Forum_ads(19)
End If
%>
<textarea name="Forum_ads_19" style="width:100%" rows="10"><%=Ads_19%></textarea>
</td>
</tr>

<%
Dim Ads_20
If UBound(Dvbbs.Forum_ads)>19 Then
	Ads_20=Dvbbs.Forum_ads(20)
Else
	Ads_20 = 0
End If
%>
<tr>
<td width="200" class="td1"><B>���Ӷ�¥�ײ����λ</B></td>
<td width="*" class="td1">
<input type=radio class="radio" name="Forum_ads_20" value="0"/>�ر�
<input type=radio class="radio" name="Forum_ads_20" value="1"/>����
</td>
</tr>
<tr> 
<td width="*" class="td1" valign="top" colspan=2>֧��HTML�﷨��JS���룬ÿ����<font color="red">"#####"</font>(5��#��)�ֿ���</td>
</tr>
<tr>
<td width="*" class="td1" colspan=2>
<%
Dim Ads_21
If UBound(Dvbbs.Forum_ads)>20 Then
	Ads_21=Dvbbs.Forum_ads(21)
End If
%>
<textarea name="Forum_ads_21" style="width:100%" rows="10"><%=Ads_21%></textarea>
</td>
</tr>

<%
Dim Ads_22
If UBound(Dvbbs.Forum_ads)>21 Then
	Ads_22=Dvbbs.Forum_ads(22)
Else
	Ads_22 = 0
End If
%>
<tr>
<td width="200" class="td1"><B>���Ӷ�¥���ҹ��λ</B></td>
<td width="*" class="td1">
<input type=radio class="radio" name="Forum_ads_22" value="0"/>�ر�
<input type=radio class="radio" name="Forum_ads_22" value="1"/>���
<input type=radio class="radio" name="Forum_ads_22" value="2"/>�ұ�
</td>
</tr>
<tr> 
<td width="*" class="td1" valign="top" colspan=2>֧��HTML�﷨��JS���룬ÿ����<font color="red">"#####"</font>(5��#��)�ֿ���</td>
</tr>
<tr>
<td width="*" class="td1" colspan=2>
<%
Dim Ads_23
If UBound(Dvbbs.Forum_ads)>22 Then
	Ads_23=Dvbbs.Forum_ads(23)
End If
%>
<textarea name="Forum_ads_23" style="width:100%" rows="10"><%=Ads_23%></textarea>
</td>
</tr>

<tr> 
<td width="200" class="td1">&nbsp;</td>
<td width="*" class="td1"> 
<div align="center"> 
<input type="submit" name="Submit" value="�� ��" class="button">
</div>
</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
<script language="JavaScript">
<!--
chkradio(document.advform.Forum_ads_18,<%=Ads_18%>);
chkradio(document.advform.Forum_ads_20,<%=Ads_20%>);
chkradio(document.advform.Forum_ads_22,<%=Ads_22%>);
//-->
</script>
<%
end sub

Sub SaveConst()
	Dim iSetting,i,Sql,did
	For i = 0 To 30
		If Trim(Request.Form("Forum_ads_"&i))="" Then
			If i = 1 Or i = 0 Then
				iSetting = ""
			ElseIf i = 17 Then
				iSetting = 1
			Else
				iSetting = 0
			End If
		Else
			iSetting=Replace(Trim(Request.Form("Forum_ads_"&i)),"$","")
		End If

		If i = 0 Then
			Dvbbs.Forum_ads = iSetting
		Else
			Dvbbs.Forum_ads = Dvbbs.Forum_ads & "$" & iSetting
		End If
	Next
	For i = 1 To Request("getboard").Count
		If isNumeric(Request("getboard")(i)) Then
			If did = "" Then
				did = Request("getboard")(i)
			Else
				did = did & "," & Request("getboard")(i)
			End If
		End If
	Next
	If Request("getskinid")="1" Then
		Sql = "Update Dv_Setup Set Forum_ads='"&Replace(Dvbbs.Forum_ads,"'","''")&"'"
		Dvbbs.Execute(sql)
	End If
	If Request("getboard")<>"" Then
		Sql = "Update Dv_Board Set Board_Ads='"&Replace(Dvbbs.Forum_ads,"'","''")&"' Where BoardID In ("&did&")"
		Dvbbs.Execute(Sql)
	End If
	RestoreBoardCache()
	Dvbbs.loadSetup()
	Dv_suc("������óɹ���")
End Sub
Sub RestoreBoardCache()
	Dim Board,node
	Dvbbs. LoadBoardList()
	For Each node in Application(Dvbbs.CacheName &"_style").documentElement.selectNodes("style/@id")
		Application.Contents.Remove(Dvbbs.CacheName & "_showtextads_"&node.text)
		For Each board in Application(Dvbbs.CacheName&"_boardlist").documentElement.selectNodes("board/@boardid")
			Dvbbs.LoadBoardData board.text
			Application.Contents.Remove(dvbbs.CacheName & "_Text_ad_"& board.text &"_"&node.text)
			Application.Contents.Remove(dvbbs.CacheName & "_Text_ad_"& board.text &"_"&node.text&"_-time")
		Next
		Application.Contents.Remove(dvbbs.CacheName & "_Text_ad_0_"& node.text)
		Application.Contents.Remove(dvbbs.CacheName & "_Text_ad_0_"& node.text&"_-time")
	Next
End Sub
%>