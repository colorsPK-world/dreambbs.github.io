<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="Plus_popwan/cls_setup.asp"-->
<%
	Dim Action
	Dvbbs.LoadTemplates("")
	Dvbbs.Stats = "社区游戏中心"
	Dvbbs.Nav()
	Dvbbs.Head_var 0,0,Plus_Popwan.Program,"plus_popwan.asp"
	Dvbbs.ActiveOnline()
	action = Request("action")
	Page_main()

	If action<>"frameon" Then
		Dvbbs.Footer
	End If
	Dvbbs.PageEnd()

'页面右侧内容部分
Sub Page_Center()
	Dim view
	view = Lcase(Request("view"))
	Select Case view
		Case "service"	: Service()
		Case "popmng"	:  PopManange()
		Case "regpopwan":  RegPopwan()
		Case "playgame"	:  PlayGame()
		Case "mygames"	:  MyGames()
		Case "nav"		:  PlusNav()
		Case "updategames"	: UpdateGames()
		Case "addplus"		:  addplus()
		Case "editpopwan"	:  Editpopwan()
		
		Case Else
			GameList()
	End Select

End Sub

Sub MyGames()
	'站点已开通游戏列表
	GameList()

		Dim XmlDom,Node,PUrl,DataToSend,Sign

		Sign = MD5(Dvbbs.membername&Plus_Popwan.ConfigNode.getAttribute("siteid")&Plus_Popwan.ConfigNode.getAttribute("key"),32)
		PUrl = "http://union.popwan.com/PlayGames/?"
		DataToSend = "siteid="&Plus_Popwan.ConfigNode.getAttribute("siteid")&"&username="&Server.urlencode(Dvbbs.membername)&"&sign="&Sign&"&encode=gb2312"
		PUrl = PUrl&DataToSend

%>
<div class="pw_tb0">
您已进入的游戏列表：
	<div class="pw_par1" id="usergames">
	
<%
		'Response.Write PUrl
		'Response.End
		Set XmlDom = Plus_Popwan.HttpPost(PUrl)
		If XmlDom Is Nothing Then
			Response.Write "尚未有进入游戏的信息，赶快来尝试我们为您提供的游戏乐趣吧！</div></div>"
			Exit Sub
		End If
		'Plus_Popwan.Gamelist
		'XmlDom.documentElement.SelectNodes("masterselgames/game")
		Response.Write "<ul>"
		For Each Node In XmlDom.documentElement.SelectNodes("masterselgames/game")
		%>
		<li>
		<a href="plus_popwan.asp?view=playgame&gid=<%=Server.URlencode(Node.selectSingleNode("entergameurl").text)%>" target="_blank"><%=Node.selectSingleNode("gamename").text%></a><br/>
		<span class="img"><a href="plus_popwan.asp?view=playgame&gid=<%=Server.URlencode(Node.selectSingleNode("entergameurl").text)%>" target="_blank"><img src="<%=Node.selectSingleNode("bigpic").text%>" alt="" border="0"/></a></span>
		</li>
		<%
		Next
		Response.Write "</ul>"
%><div style="clear:both;"></div>
	</div>
</div>
<%
Set XmlDom = Nothing
End Sub

Sub GameList()
	Dim Node,i
	i = 0
	If Not (Plus_Popwan.Gamelist Is Nothing) Then
		If Plus_Popwan.Gamelist.length < 1 Then
			Exit Sub
		End If
	Else
		Exit Sub
	End If
%>
<div class="pw_tb0">
本站已开通的游戏列表：
	<div class="pw_par1">
	<%
		For Each Node In Plus_Popwan.Gamelist
		If (Node.selectSingleNode("gamename") Is Nothing) Then Exit For
	%>
		<div class="gamebox1">
			<div><b class="font14"><%=Node.selectSingleNode("gamename").text%></b></div>
			<div>
				<div class="p1">
				<a href="<%=Plus_Popwan.ConfigNode.getAttribute("gamesite")&"/"&Node.selectSingleNode("shortname").text%>/" target="_blank"><img src="<%=Node.selectSingleNode("smallpic").text%>" alt="" border="0"  />
				</a>
				</div>
				<div class="p2">
				<a href="plus_popwan.asp?view=playgame&gid=<%=Server.URlencode(Node.selectSingleNode("entergameurl").text)%>" target="_blank"><img src="<%=Plus_Popwan.Folder%>/images/gogame.gif" alt="" /></a> <a href="<%=Plus_Popwan.ConfigNode.getAttribute("gamesite")&"/"&Node.selectSingleNode("shortname").text%>/" target="_blank">官方网站</a>
				<br/>
				<%=Left(Node.selectSingleNode("gameintro").text,100)&"..."%>
				<%If Plus_Popwan.IsMaster Then%>
				<br/>
				<div><font class="green">进入游戏的链接：</font><input id="c_<%=i%>" name="gourl" value="<%=Plus_Popwan.ConfigNode.getAttribute("bbsurl")%>plus_popwan.asp?view=playgame&gid=<%=Node.selectSingleNode("entergameurl").text%>" size="90"/><button onclick="copyText(document.getElementById('c_<%=i%>'))">复制</button></div>
				<%End If%>
				</div>
				<div style="clear:both"></div>
			</div>
		</div>

	<%	i =  i + 1
		Next
	%>
	</div>
</div>
<%
End Sub

'详细联系
Sub Service()
%>
<iframe id="pw_frame" src="<%=Plus_Popwan.ConfigNode.getAttribute("unionurl")%>/CustomerService/" scrolling="yes" frameborder="0" allowtransparency="true"></iframe>
<%
End Sub

'修改绑定注册信息
Sub Editpopwan()
	If Not Plus_Popwan.IsMaster Then
		Response.Write "你没有该操作权限！"
		Exit Sub
	End If
	Dim BbsName,GameSite,BbsUrl,Userkey
	If LCase(Request("react"))="save" Then
		GameSite = Replace(LCase(Request.form("gamesite")),"'","")
		If Left(Request.form("gamesite"),7)<>"http://" Then
			GameSite = "http://"&GameSite
		End If
		Plus_Popwan.ConfigNode.setAttribute "key",Request.form("userkey")
		Plus_Popwan.ConfigNode.setAttribute "siteid",Request.form("siteid")
		Plus_Popwan.ConfigNode.setAttribute "gamesite",GameSite
		Plus_Popwan.ConfigNode.setAttribute "joined","1"
		Plus_Popwan.Update_Config()
		Response.Write "绑定操作成功！请重新点击获取游戏列表与相关更新。"
		Exit Sub
	End If
%>
<div class="pw_join2">
	<table width="100%" border="0" cellpadding="4" cellspacing="2" class="pw_tb1">
	<form action="?view=editpopwan&react=save" method="post">
	<input type="hidden" size="40" name="bbsname" value="<%=Plus_Popwan.ConfigNode.getAttribute("bbsname")%>" />
	<input type="hidden" size="40" name="domain" value="<%=Plus_Popwan.ConfigNode.getAttribute("bbsurl")%>" />
	<tr>
		<th colspan="3"><font class="green">*已开通</font>，修改绑定已注册的联盟资料（*详细资料请在联盟管理平台中修改。）</th>
	</tr>
	<tr>
		<td align="right">联盟站访问域名</td>
		<td><input type="text" size="40" name="gamesite" value="<%=Plus_Popwan.ConfigNode.getAttribute("gamesite")%>" /></td>
		<td rowspan="3"><input type="submit" name="submit" value="更新绑定联盟资料"/></td>
	</tr>
	<tr>
		<td align="right">联盟UserKEY</td>
		<td><input type="text" size="40" name="userkey" value="<%=Plus_Popwan.ConfigNode.getAttribute("key")%>" /></td>
		
	</tr>
	<tr>
		<td align="right">联盟SiteID</td>
		<td><input type="text" size="10" name="siteid" value="<%=Plus_Popwan.ConfigNode.getAttribute("siteid")%>" /></td>
	</tr>
	</form>
</table>
</div>

<%
End Sub

'注册开通表单
Sub JoinForm()
	If Not Plus_Popwan.IsMaster Then
		Response.Write "你没有该操作权限！"
		Exit Sub
	End If
	Dim BbsName,GameSite,BbsUrl,Userkey
%>
<div class="pw_join2">
	<table width="100%" border="0" cellpadding="4" cellspacing="2" class="pw_tb1">
	<form action="?view=regpopwan" method="post">
	<input type="hidden" size="40" name="bbsname" value="<%=Plus_Popwan.ConfigNode.getAttribute("bbsname")%>" />
	<input type="hidden" size="40" name="domain" value="<%=Plus_Popwan.ConfigNode.getAttribute("bbsurl")%>" />
	<tr>
		<th><font class="yellow">*未开通</font>，马上开通我的游戏联盟</th>
	</tr>
	<tr>
		<td>
		<input type="submit" name="submit" value="一键开通我的游戏联盟"/>
		</td>
	</tr>
	</form>
</table>
</div>
<%
Call Editpopwan()
%>

<div class="pw_join1"></div>
<div class="pw_join0">
	<div class="pw_readme">
		<ul>
		<li>国内最高的按销售提成模式，收入为独有的雪球式滚动，查看案例</li>
		<li>站长独有的游戏频道，无需维护即可拥有内容和可玩游戏的平台</li>
		<li>可绑定网站独立域名访问，流量和用户全部都是站长的</li>
		<li>多款游戏同时供用户选择，用户粘性更高，收入也更高</li>
		<li>可整合网站或社区用户，用户无需再注册即可玩游戏</li>
		<li>无注册限制，所有站长均可加入，小站点一个充值用户可比拟所有广告收入</li>
		<li>非系统故障下人工干预并造成站长收入减少，给予所涉及金额的10倍返还</li>
		</ul>
		
	</div>
</div>
<%
End Sub


Sub RegPopwan()
	Dim WebName,Domain,ValidCode,Sign,XmlDom,xmlhttp,DateTime,DataToSend,DataBack
	WebName=Server.Urlencode(Request.form ("bbsname"))
	Domain=Server.Urlencode(Replace(Request.form ("domain"),"'",""))
	ValidCode=Server.Urlencode(Request.form ("validcode"))
	DateTime=Server.Urlencode(CstrDateTime(Now()))
	DataToSend="domain=" & Domain & "&webname=" & WebName & "&time=" & DateTime & "&validcode=" & ValidCode &"&encode=gb2312"
	Sign=MD5(DataToSend,32)
	DataToSend=DataToSend & "&sign=" & Sign
	Set xmlhttp = Server.CreateObject("msxml2.ServerXMLHTTP")
	xmlhttp.setTimeouts 10000, 10000, 10000, 10000
'	xmlhttp.Open "POST","联盟注册页面地址",False
	xmlhttp.Open "POST",Plus_Popwan.ConfigNode.getAttribute("unionurl") & "?" & DataToSend,False
	xmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlhttp.send()
'Response.Write Plus_Popwan.ConfigNode.getAttribute("unionurl") & "?" & DataToSend
'	Response.Write Plus_Popwan.ConfigNode.getAttribute("unionurl") & "?" & DataToSend
		Set XmlDom = Server.CreateObject("Msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
		If XmlDom.Load(xmlhttp.responseXML) Then
			If Not (XmlDom.documentElement.selectSingleNode("success") Is Nothing) Then
				If XmlDom.documentElement.selectSingleNode("success").text="1" Then
					Plus_Popwan.ConfigNode.setAttribute "key",XmlDom.documentElement.selectSingleNode("responseresult/userkey").text
					Plus_Popwan.ConfigNode.setAttribute "siteid",XmlDom.documentElement.selectSingleNode("responseresult/siteid").text
					Plus_Popwan.ConfigNode.setAttribute "gamesite","http://u.popwan.com/"&XmlDom.documentElement.selectSingleNode("responseresult/domain").text
					Plus_Popwan.ConfigNode.setAttribute "joined","1"
					Plus_Popwan.ConfigNode.setAttribute "addtime","1"					
					Plus_Popwan.Update_Config()
					Response.Write XmlDom.documentElement.selectSingleNode("message").text
				Else
					Response.Write XmlDom.documentElement.selectSingleNode("message").text
				End If
			Else				
				Response.Write "错误提交，请重试!"
			End If
		Else
			'Response.Write PostUrl
			Response.Write "通信超时，请重新提交！"
			'Response.Write xmlhttp.responsetext
		End If
		Set XmlHttp = Nothing
		Set XmlDom = Nothing
End Sub


Sub UpdateGames()
	If Request("react") = "updategames" Then
		'更新游戏列表
		Plus_Popwan.UpdateGamesInfo()
	Else
		%>
		<div class="pw_tb0">
		当你在游戏平台更新了游戏列表，可以执行以下更新！
		<div class="pw_par1">
		<input type="submit" name="submit" value="获取最新开通游戏列表" onclick="window.location='plus_popwan.asp?view=updategames&react=updategames'"/>
		</div>
		</div>
		<%
	End If
End Sub

'申请开通POPWAN/管理
Sub PopManange()
	If Not Plus_Popwan.IsMaster Then
		Response.Write "你没有该操作权限！"
		Exit Sub
	End If
	Dim IsJoin
	IsJoin = Plus_Popwan.ConfigNode.getAttribute("joined")
	If IsJoin="0" Then
		JoinForm()
		Exit Sub
	End If

	PopMainTop()
	UpdateGames()
	PlusNav()
	GameList()

End Sub

Sub PlusNav()
%>
<div class="pw_tb0">
你可以直接点击，开通游戏导航链接！
<div class="pw_par1">
<input type="submit" name="submit" value="添加游戏导航链接" onclick="window.location='plus_popwan.asp?view=addplus&plus_id=POPWANID'"/>
</div>
</div>
<%
End Sub

Sub Addplus_main(iType,iName,iUrl,iPlus_id,iCopyright,isblank)
	Dim plus_setting
	plus_setting = isblank&"|0|0|||0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0|||设置字段1,设置字段2,设置字段3,设置字段4,设置字段5,设置字段6,设置字段7,设置字段8,设置字段9,设置字段10,设置字段11,设置字段12,设置字段13,设置字段14,设置字段15,设置字段16,设置字段17,设置字段18,设置字段19|||0,0|24,,,0,0,0,0,0,0,0,0,0,"

	Dvbbs.Execute("Insert into dv_plus (Plus_Type,Plus_Name,Isuse,Plus_Setting,Mainpage,IsShowMenu,plus_id,plus_Copyright) values ("&Dvbbs.Checkstr(iType)&",'"&Dvbbs.Checkstr(iName)&"',1,'"&Dvbbs.Checkstr(plus_setting)&"','"&Dvbbs.Checkstr(iUrl)&"',1,'"&Dvbbs.Checkstr(iPlus_id)&"','"&Dvbbs.Checkstr(iCopyright)&"')")
End Sub

Sub addplus()
	If Not Plus_Popwan.IsMaster Then
		Response.Write "你没有该操作权限！"
		Exit Sub
	End If
	If Plus_Popwan.ConfigNode.getAttribute("joined")="0" Then
		Response.Write "<font class=""yellow"">*开通或绑定了联盟站后才可以进行该操作！</font>"
		JoinForm()
		Exit Sub
	End If
	Dim SiteID,Plus_Name,Mainpage,i,iid
	Dim Node
		SiteID = "PopWanID"
		Plus_Name = "社区游戏中心"

	Dvbbs.Execute("delete from Dv_Plus where Plus_id='"& SiteID &"'")
	Addplus_main 0,Plus_Name,"plus_popwan.asp",SiteID,Plus_Name,0
	iid = Getid(SiteID)
	If Plus_Popwan.Gamelist.length>0 Then
		For Each Node In Plus_Popwan.Gamelist
			Addplus_main iid,Node.selectSingleNode("gamename").text,"plus_popwan.asp?view=playgame&gid="&Server.URlencode(Node.selectSingleNode("entergameurl").text),SiteID&"_"&Node.selectSingleNode("shortname").text,Node.selectSingleNode("gamename").text,1
		Next
	End If
		
		LoadForumPlusMenuCache
		%>
		<SCRIPT LANGUAGE="JavaScript">
		<!--
			alert("添加成功！");
			location.href='plus_popwan.asp?view=nav';
		//-->
		</SCRIPT>
		<%
End Sub

Function Getid(id)
	Dim iRs
	Set iRs = Dvbbs.Execute("Select Top 1 [id] From Dv_Plus Where Plus_Type='0' and Plus_id='"&Dvbbs.Checkstr(id)&"'")
	If Not iRs.Eof Then
		Getid = iRs(0)
	Else
		Getid = 0
	End If
	iRs.Close:Set iRs = Nothing
End Function

Sub LoadForumPlusMenuCache()
	Dvbbs.Name="Plus_Settingts"
	Dim Rs,SQL
	SQL = "select plus_ID,Plus_Setting,Plus_Name,plus_Copyright from [Dv_plus] Order By ID"
	Set Rs = Dvbbs.Execute(SQL)	
	If Not Rs.Eof Then
		Dvbbs.Name="Plus_Settingts"
		Dvbbs.value = Rs.GetRows(-1)
	End If
	Set Rs = Nothing
	Dvbbs.LoadPlusMenu()
End Sub


Sub PopMainTop()
%>
<div class="pw_tb0">
你已注册联盟，你的注册信息是：
<div class="pw_par1">
<span style="float:right;">[<a href="plus_popwan.asp?view=editpopwan">修改绑定信息</a>] | [<a href="<%=Plus_Popwan.p_configdb%>" target="_blank">进入管理平台</a>]</span>
论坛名称：<span class="bluefont"><%=Plus_Popwan.ConfigNode.getAttribute("bbsname")%></span><br/>
联盟域名：<a href="" target="_blank"><%=Plus_Popwan.ConfigNode.getAttribute("gamesite")%></a><br/>
联盟SiteID：<span class="green"><%=Plus_Popwan.ConfigNode.getAttribute("siteid")%></span><br/>
联盟UserKey：<span class="yellow"><%=Plus_Popwan.ConfigNode.getAttribute("key")%></span><br/>
	<%
		Dim XmlDom,Node
		Set XmlDom = Plus_Popwan.HttpPost(Plus_Popwan.ConfigNode.getAttribute("apiurl")&"/webinfo/?siteid="&Plus_Popwan.ConfigNode.getAttribute("siteid"))
		If XmlDom Is Nothing Then
			Exit Sub
		End If
		Set Node = XmlDom.documentElement
		If Not (Node Is Nothing) Then
			Response.Write "昨日注册<span  class=""bluefont"">"&Node.selectSingleNode("yestoday").text&"</span>"
			Response.Write "，今日注册<span  class=""yellow"">"&Node.selectSingleNode("today").text&"</span>"
		End If
		Set XmlDom = Nothing
	%>
</div>
</div>
<%
End Sub

'用户进入游戏跳转
Sub PlayGame()
	Dim GoGame,UniUrl,SiteID,UserKey,Sign,DateTime,UserEmail,Userid
	SiteID = Plus_Popwan.ConfigNode.getAttribute("siteid")
	UserKey = Plus_Popwan.ConfigNode.getAttribute("key")
	UniUrl = Plus_Popwan.ConfigNode.getAttribute("gamesite")
	GoGame = Request.QueryString ("gid")
	DateTime = CstrDateTime(Now()) 'FormatDateTime(Now(),0)
	
	UserEmail = ""
	If Dvbbs.Userid>0 Then
		Sign = MD5("userid="&Dvbbs.Userid&"&username=" & Dvbbs.MemberName & "&siteid=" & siteid & "&time=" & DateTime & "&userkey=" & UserKey,32)
		UserEmail = Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@useremail").text
		Response.Redirect UniUrl & "/webuserreg/?userid="&Dvbbs.Userid&"&username=" & Server.Urlencode(Dvbbs.MemberName) & "&email="&Server.Urlencode(UserEmail)&"&siteid=" & SiteID & "&time=" & Server.Urlencode(DateTime) & "&sign=" & Sign & "&encode=gb2312&go=" & Server.Urlencode(Plus_Popwan.ConfigNode.getAttribute("gamesite")&"/"&GoGame)
	Else
		Response.Redirect "login.asp?f="&Server.UrlEncode("plus_popwan.asp?gid="&GoGame)
	End If
End Sub

Function CstrDateTime(t)
	Dim y,m,d,h,mi,s
	y=CStr(Year(t))
	m=CStr(Month(t))
	d=CStr(Day(t))
	h=CStr(Hour(t))
	mi=CStr(Minute(t))
	s=CStr(Second(t))
	CstrDateTime =  y &"-" & m &"-" &d & " "& h &":"& mi &":" &s
End Function
%>