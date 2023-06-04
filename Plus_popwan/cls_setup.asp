<!--#include file="../inc/md5.asp"-->
<%
'游戏联盟插件主类
Dim Plus_Popwan

Class Cls_Popwan
	Public Version,Program
	Public ConfigFile,CachePath,Folder,IsMaster
	Public Config,ConfigNode,GameNode,Gamelist
	Public p_admin,p_advurl,p_serviceurl,p_configdb


	Private Sub Class_Initialize()
		Program = "社区游戏中心"
		Version = "ASP 1.1 For DVBBS 8.3"
		ConfigFile = "CacheFile/sn.config"
		Folder = "Plus_popwan/"
		CachePath = "CacheFile/"
		IsMaster = False
		If Dvbbs.master Or Dvbbs.GroupSetting(70)="1" Then
			IsMaster = True
		End If
		Set Config = Dvbbs.CreateXmlDoc("msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
		If Not Config.load(FilePath(ConfigFile)) Then
			CreatConfig()
		Else
			Set ConfigNode = Config.documentElement.selectSingleNode("popwan")
			Set GameNode = Config.documentElement.selectSingleNode("masterselgames")
			Set Gamelist = Config.documentElement.SelectNodes("masterselgames/game")
		End If

		p_admin = Server.UrlEncode("http://union.popwan.com/my/")
		p_advurl = Server.UrlEncode("http://union.popwan.com/my/IncomeStat/")
		p_serviceurl = Server.UrlEncode("http://union.popwan.com/CustomerService/")
		p_configdb = "http://union.popwan.com/login/?userkey="& ConfigNode.getAttribute("key") &"&go="
		
	End Sub

	Private Sub class_terminate()
		Set Config = Nothing
	End Sub

	Public Function FilePath(Str)
		FilePath = Server.MapPath(Folder & Str)
	End Function

	'测试地址：
	'http://union.popwan.com/SelectedGames/?siteid=1998&sign=53ffcef88dde8d42dccce668d0c2bf9c&encode=utf-8
	'参数说明：siteid:站点ID    sign:站长签名  encode:编码
	'Sign = MD5(siteid+userkey)

	Public Sub UpdateGamesInfo()	'webgames.xml
		Dim XmlDom,Node,PUrl,DataToSend,Sign

		Sign = MD5(ConfigNode.getAttribute("siteid")&ConfigNode.getAttribute("key"),32)
		PUrl = "http://union.popwan.com/SelectedGames/?"
		DataToSend = "siteid="&ConfigNode.getAttribute("siteid")&"&sign="&Sign&"&encode=gb2312"
		PUrl = PUrl&DataToSend

		Set XmlDom = HttpPost(PUrl)

		If XmlDom Is Nothing Then
			Response.Write "游戏列表不存在。"
			Exit Sub
		End If

		Set Node = XmlDom.selectSingleNode("//masterselgames")
		If Not (Node Is Nothing) Then
			Config.documentElement.replaceChild Node.cloneNode(true),GameNode
			Response.Write "本站游戏列表数据已成功更新！"
		Else
			Response.Write "游戏列表不存在。"
		End If
		Set XmlDom = Nothing
		Update_Config()
	End Sub 

	Public Function HttpPost(PostUrl)
		Dim XmlHttp,XmlDom
		Set xmlhttp = Server.CreateObject("msxml2.ServerXMLHTTP")
		xmlhttp.setTimeouts 10000, 10000, 10000, 10000
		xmlhttp.Open "POST",PostUrl,False
		xmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		xmlhttp.send()
		Set XmlDom = Server.CreateObject("Msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
		'If XmlDom.Load(xmlhttp.responsexml) Then
		If XmlDom.Loadxml(xmlhttp.responsetext) Then
			Set HttpPost = XmlDom
		Else
			'Response.Write PostUrl
			Response.Write xmlhttp.responsetext
			Set HttpPost = Nothing
		End If
		Set XmlHttp = Nothing
		Set XmlDom = Nothing
	End Function


	'创建配置文件
	Public Sub CreatConfig()
		Dim Node
		Config.LoadXml("<webgame_api/>")
		Set ConfigNode = Config.documentElement.appendChild(Config.createNode(1,"popwan",""))
		ConfigNode.setAttribute "unionurl","http://union.popwan.com/webmasterreg/"
		ConfigNode.setAttribute "apiurl","http://union.popwan.com"
		ConfigNode.setAttribute "bbsname",Dvbbs.Forum_info(0)
		ConfigNode.setAttribute "bbsurl",Dvbbs.Forum_info(1)
		ConfigNode.setAttribute "gamesite","http://u.popwan.com/yourname"
		ConfigNode.setAttribute "pluginversion",Version
		ConfigNode.setAttribute "addtime",""
		ConfigNode.setAttribute "joined",0
		ConfigNode.setAttribute "key",""
		ConfigNode.setAttribute "siteid",""
		Set Node = Config.documentElement.appendChild(Config.createNode(1,"masterselgames",""))
		Node.appendChild(Config.createNode(1,"game",""))
		Update_Config()
	End Sub

	'更新配置文件数据
	Public Sub Update_Config()
		Config.save FilePath(ConfigFile)
	End Sub
End Class

Set Plus_Popwan = New Cls_Popwan

'页面公共代码

Sub Page_main()
%>
	<link rel="stylesheet" type="text/css" href="<%=Plus_Popwan.Folder%>pop.css" />
	<script language="javascript" src="<%=Plus_Popwan.Folder%>fuc_script.js" type="text/javascript"></script>
	<div class="mainbox">
	<div id="pw_l">
		<!-- 功能菜单 -->
		<%
		Admin_Setting()
		User_Setting()
		Copyright()
		%>
	</div>
	<div id="pw_m">
		<!-- 内容 -->
		<%Page_Center()%>
	</div>
	<div style="clear:both;"></div>
	</div>

<%
Set Plus_Popwan = Nothing
End Sub

Sub Copyright()
%>
<div class="pw_a pw_c gray">

<span class="img"><img src="http://game.popwan.com/templates/%7BMainTemplates%7D/simple/client/skins/blue/images/travian.gif" border="0"/></span>
<span class="img"><img src="http://game.popwan.com/templates/%7BMainTemplates%7D/simple/client/skins/blue/images/gamebto2.gif" border="0"/></span>
<br/>

<%=Plus_Popwan.Program &" 版本："& Plus_Popwan.Version%>
</div>
<%
End Sub

Sub Admin_Setting()
If Not Plus_Popwan.IsMaster Then
	Exit Sub
End If
%>
<div class="pw_a">
	<span class="t bluefont">站长管理</span>
	<ul class="b">
	<%If Plus_Popwan.ConfigNode.getAttribute("joined")="1" Then%>
	<li><a href="plus_popwan.asp?view=popmng">联盟信息管理</a></li>
	<%Else%>
	<li><a href="plus_popwan.asp?view=popmng">申请游戏联盟</a></li>
	<%End If%>
	<li><a href="plus_popwan.asp?view=nav">论坛导航编辑</a></li>
	<li><a href="plus_popwan_forum.asp">游戏版面设置</a></li>
	<li><a href="plus_popwan_ads.asp">宣传信息发布</a></li>
	<li><a href="plus_popwan_Message.asp">发表用户短信</a></li>
	<li><a href="<%=Plus_Popwan.p_configdb & Plus_Popwan.p_advurl%>" target="_blank">查看推广收益</a></li>
	<li><a href="<%=Plus_Popwan.p_configdb & Plus_Popwan.p_serviceurl%>" target="_blank">客户服务联系</a></li>
	</ul>
</div>
<%
End Sub

Sub User_Setting()
If Dvbbs.Userid=0 Then Exit Sub
%>
<div class="pw_a">
	<span class="t bluefont">用户频道</span>
	<ul class="b">
	<li><a href="plus_popwan.asp?view=mygames">我的游戏</a></li>
	<li><a href="<%=Plus_Popwan.ConfigNode.getAttribute("gamesite")%>/MoneyIn/?username=<%=dvbbs.membername%>&siteid=<%=Plus_Popwan.ConfigNode.getAttribute("siteid")%>&encode=gb2312" target="_blank">用户充值</a></li>
	<!-- <li><a href="plus_popwan.asp?view=userchannel">玩家频道</a></li> -->
	<li><a href="<%=Plus_Popwan.ConfigNode.getAttribute("gamesite")%>/help/?username=<%=dvbbs.membername%>&siteid=<%=Plus_Popwan.ConfigNode.getAttribute("siteid")%>&encode=gb2312" target="_blank">游戏帮助</a></li>
	</ul>
</div>
<%
End Sub
%>
