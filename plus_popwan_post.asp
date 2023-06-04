<!--#include file="conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="inc/dv_clsother.asp"-->
<!--#include file="inc/dv_ubbcode.asp"-->
<!--#include file="inc/code_encrypt.asp"-->
<!--#include file="Plus_popwan/cls_setup.asp"-->
<%
	Dim Action
	Dvbbs.LoadTemplates("")
	Dvbbs.Stats = "发表帖子"
	Dvbbs.Nav()
	Dvbbs.Head_var 0,0,Plus_Popwan.Program,"plus_popwan_post.asp"
	Dvbbs.ActiveOnline()
	action = Request("action")
	Page_main()

	If action<>"frameon" Then
		Dvbbs.Footer
	End If
	Dvbbs.PageEnd()

'页面右侧内容部分
Sub Page_Center()
	If Not (Dvbbs.master Or Dvbbs.GroupSetting(70)="1") Then
		Dvbbs.AddErrcode(28)
		Dvbbs.ShowErr()
	End If
%>

<!--post.asp##发帖、回帖、投票、编辑整体页面 更新时间2007-3月20日，注意要和post.asp一起更新-->
<center>
<script language = "JavaScript" src="inc/dv_setvote.js" type="text/javascript"></script>
<script language = "JavaScript" src="inc/ajaxpost.js" type="text/javascript"></script>
<script language="javascript">
<!--
var frmAD=null;
function CheckIsUpload(frm,e){
	frmAD=gid('ad')?((gid('ad')).contentWindow||window.frames['ad']):null;
	if (frmAD&&frmAD.DvFileInput&&frmAD.DvFileInput.realcount>0){
		gid('submit').disabled=true;
		try{if(e.preventDefault){e.preventDefault();}else{e.returnValue=false;}}catch(er){}
		frmAD.DvFileInput.send();
		WaitForSubmit(frm);
	}else{
		PostSubmit(frm,e);
	}
}
function WaitForSubmit(frm){
	if (0==frmAD.DvFileInput.realcount){
		gid('submit').disabled=false;
		setTimeout(function(){gid('submit').click();},0);
	}else{
		setTimeout(function(){
			WaitForSubmit(frm);
		},1000);
	}
}
function PostSubmit(frm,e){
	var Post=new DvSavePost(frm,e,'1'=='1'?'full':'fastre',<%=Dvbbs.Board_Setting(45)%>,<%=Dvbbs.Board_Setting(16)%>);
	gid('submit').disabled=true;
	if ('function'==typeof checkPay){Post.isok=checkPay()}
	gid('body').value=dvtextarea.save();
	Post.chk_topic(gid('topic'));
	Post.chk_flash();
	Post.chk_content(gid('body'));
	if (frm.topicmode&&frm.selecttmode){Post.chk_topicmode(frm.topicmode,frm.selecttmode);}
	if(!(Post.send())){gid('submit').disabled=false;}
}
//-->
</script>
<form action="SavePost.asp?Action=snew&boardid=<%=Dvbbs.Boardid%>" method="post" name="Dvform" id="Dvform" onsubmit="CheckIsUpload(this,event)">
<input name="upfilerename" type="hidden" value="" />
<input type="hidden" name="dvbbs" value="<%=GetFormID()%>" />
<input type="hidden" name="star" value="1" />
<input type="hidden" name="page" value="1" />
<input type="hidden" name="poststyle" value="" />
<input type="hidden" name="TotalUseTable" value="<%=Dvbbs.NowUseBBS%>" />


<table cellpadding="1" cellspacing="1" align="center" class="tableborder1" style="text-align:left;text-indent:10px;">
<tr><th align="left" colspan="2" style="padding-top:0px;">&nbsp;&nbsp;<%=Application(Dvbbs.CacheName&"_boardlist").documentElement.selectSingleNode("board[@boardid='"&Dvbbs.BoardID&"']/@boardtype").text%>&nbsp;&nbsp;发表帖子
</th></tr>
<tr><td width="20%" class="tablebody2"><b>用户名：</b></td>
<td width="80%" class="tablebody2" style="text-indent:0;" ><input name="username" value="<%=Dvbbs.MemberName%>" class="FormClass" readonly/>
&nbsp;&nbsp;点击 (<a title="填写表单" href="javascript:;" onclick="DvWnd.open('填写表单','plus_popwan_posttinput.asp?sh=520&amp;sw=500',800,520,1,{bgc:'black',opa:0.5});">填写表单</a>) 可快速填写表单
</td></tr>

<tr><td width="20%" class="tablebody2"><b>主题标题：</b>
<select name="font" onchange="DoTitle(this.options[this.selectedIndex].value)">
<option selected="selected" value="">选择话题</option>
<option value="[原创]">[原创]</option><option value="[转帖]">[转帖]</option><option value="[灌水]">[灌水]</option><option value="[讨论]">[讨论]</option><option value="[求助]">[求助]</option><option value="[推荐]">[推荐]</option><option value="[公告]">[公告]</option><option value="[注意]">[注意]</option><option value="[贴图]">[贴图]</option><option value="[建议]">[建议]</option><option value="[下载]">[下载]</option><option value="[分享]">[分享]</option>
</select></td>
<td width="80%" class="tablebody2" style="text-indent:0;">
<input name="topic" id="topic" size="45" class="FormClass" value="" />

<select name="topicximoo" onchange="titleColor(this.options[this.selectedIndex].value)"><option value="0">标题醒目</option><option value="1">HTML支持</option><option value="2">红色醒目</option><option value="3">蓝色醒目</option><option value="4">绿色醒目</option></select>
<span id="mode_chk"></span>
&nbsp;<font color="#FF0000"><b>*</b></font>不得超过 <%=Dvbbs.Board_Setting(45)%> 个汉字<span id="topic_chk"></span>
</td></tr>

<tr><td width="20%" valign="top" class="tablebody1"><b>当前心情</b><br />
  <ul><li>将放在帖子的前面</li><br /><li>部分图片由<a href="http://www.qq.com/" target="_blank">QQ授权提供</a></li></ul></td>
<td width="70%" class="tablebody1" style="text-indent:0;">
<table border="0" align="left" cellpadding="2" cellspacing="1">
<tr>
<td width="75%">
<table border="0" cellpadding="2" cellspacing="1" align="left">
<tr>
<td id="ShowBack" width="1" class="tablebody2" valign="middle">
<img style="cursor: pointer;" onclick="show_post_face(-1);" src="Images/post/Previous.gif" alt="上一页" id="ShowBack" />
</td>
<td class="tablebody1" width="100%" id="ShowFace">发帖表情</td>
<td id="ShowNext" width="1" class="tablebody2" align="right" valign="middle"><img style="cursor: pointer;" onclick="show_post_face(1);" src="Images/post/Next.gif" alt="下一页"></td>
</tr>
</table>
</td>

</tr>
</table>
</td></tr>
<script language = "JavaScript" type="text/javascript">
<!--
var PostType=1;
var Forum_PostFace='Skins/default/topicface/|||face1.gif|||face2.gif|||face3.gif|||face4.gif|||face5.gif|||face6.gif|||face7.gif|||face8.gif|||face9.gif|||face10.gif|||face11.gif|||face12.gif|||face13.gif|||face14.gif|||face15.gif|||face16.gif|||face17.gif|||face18.gif|||';
var Forum_PostFace=Forum_PostFace.split("\|\|\|");
var retitle='';
var Forum_Emot='images/emot/<><><>em01.gif<><><>em02.gif<><><>em03.gif<><><>em04.gif<><><>em05.gif<><><>em06.gif<><><>em07.gif<><><>em08.gif<><><>em09.gif<><><>em10.gif<><><>em11.gif<><><>em12.gif<><><>em13.gif<><><>em14.gif<><><>em15.gif<><><>em16.gif<><><>em17.gif<><><>em18.gif<><><>em19.gif<><><>em20.gif<><><>em21.gif<><><>em22.gif<><><>em23.gif<><><>em24.gif<><><>em25.gif<><><>em26.gif<><><>em27.gif<><><>em28.gif<><><>em29.gif<><><>em30.gif<><><>em31.gif<><><>em32.gif<><><>em33.gif<><><>em34.gif<><><>em35.gif<><><>em36.gif<><><>em37.gif<><><>em38.gif<><><>em39.gif<><><>em40.gif<><><>em41.gif<><><>em42.gif<><><>em43.gif<><><>em44.gif<><><>em45.gif<><><>em46.gif<><><>em47.gif<><><>em48.gif<><><>em49.gif<><><>em50.gif<><><>em51.gif<><><>em52.gif<><><>em53.gif<><><>em54.gif<><><>em55.gif<><><>em56.gif<><><>em57.gif<><><>em58.gif<><><>em59.gif<><><>em60.gif<><><>em61.gif<><><>em62.gif<><><>em63.gif<><><>em64.gif<><><>em65.gif<><><>em66.gif<><><>em67.gif<><><>em68.gif<><><>em69.gif<><><>em70.gif<><><>em71.gif<><><>em72.gif<><><>em73.gif<><><>em74.gif<><><>em75.gif<><><>em76.gif<><><>em77.gif<><><>em78.gif<><><>em79.gif<><><>em80.gif<><><>em81.gif<><><>em82.gif<><><>em83.gif<><><>em84.gif<><><>em85.gif<><><>em86.gif<><><>em87.gif<><><>em88.gif<><><>em89.gif<><><>em90.gif<><><>em91.gif<><><>em92.gif<><><>em93.gif<><><>em94.gif<><><>em95.gif<><><>em96.gif<><><>em97.gif<><><>em98.gif<><><>em99.gif<><><>em100.gif<><><>em101.gif<><><>em102.gif<><><>em103.gif<><><>em104.gif<><><>em105.gif<><><>em106.gif<><><>em107.gif<><><>em108.gif<><><>em109.gif<><><>em110.gif<><><>em111.gif<><><>em112.gif<><><>em113.gif<><><>em114.gif<><><>em115.gif<><><>';
Forum_Emot=Forum_Emot.split("<><><>");
var Emot_PageSize=15; //心情一行个数
if (document.Dvform.topicximoo){
	document.Dvform.topicximoo.options[0].selected=true;
}
function DoTitle(addTitle) { 
	var revisedTitle; 
	var currentTitle = document.Dvform.topic.value; 
	revisedTitle = addTitle+currentTitle; 
	document.Dvform.topic.value=revisedTitle; 
	document.Dvform.topic.focus();
	return;
}
function titleColor(i) { 
	var color = new Array("#000000","#000000","red","blue","green");
	if (i<=color.length){		
		document.Dvform.topic.style.color = color[i];
	}
}
function showtitle(){
	if (document.Dvform.reishow.checked == true){
		if (document.Dvform.topic.value==''){
			document.Dvform.topic.value=retitle;
		}
		document.getElementById("advance").innerText="不采用";
	}
	else{
		if (document.Dvform.topic.value==retitle){
			document.Dvform.topic.value='';
		}
		document.getElementById("advance").innerText="采用";
	}
}
function lookmagic()
{
	var obj=document.getElementById("magicframe");
	var buttonElement = document.getElementById("magicfacepic");
	if (obj.style.visibility=="hidden")
	{
		obj.style.top = (getOffsetTop(buttonElement) + buttonElement.offsetHeight)+"px";
		obj.style.left = (getOffsetLeft(buttonElement)-410)+"px";
		obj.style.visibility="visible";
		document.getElementById("magic_frame").width="410px";
		document.getElementById("magic_frame").height= "268px";
		document.getElementById("magic_frame").src = "plus_tools_magiclist.asp?boardid="+boardid+"&s=0";
	}else {
		obj.style.visibility="hidden";
	}
}
function closemagic()
{
	var cm=document.getElementById("magicframe");
	if (cm.style.visibility=="visible")
	{
		cm.style.visibility = "hidden";
	}
}
//-->
</script>

<!--post.asp##上传文件部分-->
<tr><td width="20%" valign="top" class="tablebody2"><b>文件上传</b> <a onmouseover="showmenu(event,'<div class=menuitems><a href=#>gif</a></div><div class=menuitems><a href=#>jpg</a></div><div class=menuitems><a href=#>jpeg</a></div><div class=menuitems><a href=#>bmp</a></div><div class=menuitems><a href=#>png</a></div><div class=menuitems><a href=#>rar</a></div><div class=menuitems><a href=#>txt</a></div><div class=menuitems><a href=#>zip</a></div><div class=menuitems><a href=#>mid</a></div>')" style="cursor:pointer" title="查看可上传的文件类型" >类型</a>
</td><td width="80%" class="tablebody2" style="text-indent:0;">
<!--<iframe name="ad" frameborder="0" width="100%" height="25" scrolling="no" src="post_upload.asp?boardid=2"></iframe>-->
<iframe id="ad" name="ad" align="left" frameborder="0" width="100%" height="20" scrolling="no" src="savefile.asp?boardid=<%=Dvbbs.Boardid%>"></iframe>
</td></tr>

<script language = "JavaScript" type="text/javascript">
<!--
var ShowFacePage=0;
function show_post_face(n){
	var CountLength=Forum_PostFace.length-2;
	var j=1;
	var page_size=18;//每页个数
	var br=9;	//换行个数
	var post_face='';
	var SelectFace ='';
	var thispage=ShowFacePage + n;
	document.getElementById("ShowBack").style.display="";
	document.getElementById("ShowNext").style.display="";
	if (thispage==1){
	document.getElementById("ShowBack").style.display="none";
	}
	for (i=thispage*page_size-page_size+1;i<=thispage*page_size;i++)
	{
		post_face=post_face+'<input style="border:none;" type="radio" value="'+Forum_PostFace[i]+'" name="Expression" ';
		if (i==1&& SelectFace==''){post_face=post_face+'checked="checked"'; }
		if(Forum_PostFace[i]==SelectFace){post_face=post_face+'checked="checked"';}
		post_face=post_face+' /><img src="'+Forum_PostFace[0]+Forum_PostFace[i]+'" alt=""/>&nbsp;&nbsp;';
		if (j==br){
			j=1
			post_face=post_face+'<br />';
		}
		else{
			j++
		}
		if (i>=CountLength){
		document.getElementById("ShowNext").style.display="none";
		break;
		}
	}
	if (document.getElementById("ShowFace"))
	{
	document.getElementById("ShowFace").innerHTML=post_face;
	ShowFacePage=thispage;
	}
}
show_post_face(1);
function gopreview(){
	var frm=gid('preview');
	if (frm){
		frm.Dvtitle.value=document.Dvform.topic.value;
		frm.theBody.value=dvtextarea.get();
		frm.submit();
	}
}
//-->
</script>
<td colspan="2" width="80%" class="tablebody1" style="padding:0px;margin:0px;border:0px;" valign="top">
	<!--post.asp##Dvbbs多功能编辑器-->
<script language="javascript" src="images/emot/config.js"></script>
<script language="javascript" src="dv_edit/main.js"></script>
<script language="javascript" src="inc/dv_savepost.js"></script>
<span><textarea id="body" name="body" style="display:none;width:100%;height:330px;margin:0;padding:0;border:none;"></textarea></span>
<div style="margin:0;"><script>
var dvtextarea=null;
var Dvbbs_Mode=parseInt('3');
var edit_mode_,toolbar_;
var plus_cc="";
if(3==Dvbbs_Mode){Dvbbs_Mode=1;}
switch(Dvbbs_Mode){
	case 1:edit_mode_='design';toolbar_=[];break;
//	case 2:edit_mode_='design';toolbar_=['tenpay','<div style="float:left;padding-top:5px;position:relative;color:red" onclick="specialform(this)">[插入特殊内容]</div>',plus_cc];break;
	default:edit_mode_='text';
}
var dveditconfig={
	textarea_id:'body',
	edit_height:'302px',
	edit_mode:edit_mode_,
	toolbar:toolbar_,
	use_ubb:2==Dvbbs_Mode,
	is_show_status:Dvbbs_Mode>0
};
function dvloadarea(){
	if ('function'==typeof DvEdit){
		dvtextarea=new DvEdit(dveditconfig);
	}else{setTimeout('dvloadarea()',0)}
}
dvloadarea();
var dv_signal_click=null;
function Dv_Signal_Do(token,param,value){
	var s='';
	if (param)
	{
		s='['+token+'='+param+']'+value+'[\/'+token+']';
	}else{
		s = "["+token+']'+value+'[\/'+token+']';
	}
	dvtextarea.insert(s);
}
function Dv_Signal(token,param_title,value_title){
	var pn='',s='';
	if(param_title){s+='<div style="width:200px;">'+param_title+'<br/><input type="text" name="dv_signal_param" style="width:200px;" id="dv_signal_param" /></div>'}
	if(value_title){s+='<div style="width:200px;height:100px;">'+value_title+'<br/><textarea name="dv_signal_value" id="dv_signal_value" style="width:200px;height:100px;"></textarea></div>'};
	s+='<div><input type="button" value=" 插入 " onclick="Dv_Signal_Do(\''+token+'\',gid(\'dv_signal_param\')?gid(\'dv_signal_param\').value:null,document.getElementById(\'dv_signal_value\').value)"></div>';
	dvtextarea.t.close();
	dvtextarea.t.open(dv_signal_click,s);
}
function specialform(o){
	dv_signal_click=o;
	specialformcontent='<div style="width:150px">'+specialformcontent+'</div>'
	dvtextarea.t.open(o,specialformcontent);
}
</script></div>
</td>
</tr>
<tr  class="tablebody1" style="border:0">
	<td><b>高级设置：</b></td>
	<td>
	签名：<input type="radio" id="signflag_1" name="signflag" value="0"   class="radio"/><label for="signflag_1">不显示</label>
	<input type="radio" id="signflag_2" name="signflag" value="1" checked="checked" class="radio"/><label for="signflag_2">显示</label>
	<input type="radio" id="signflag_3" name="signflag" value="2" disabled="disabled" class="radio"/><label for="signflag_3">匿名&nbsp;&nbsp;</label>
	回帖通知：<input type="radio" id="emailflag_1" name="emailflag" value="0" checked="checked" class="radio"/><label for="emailflag_1" style=" cursor:hand">不通知</label>
	 <input type="radio" id="emailflag_2" name="emailflag" value="1"  class="radio"/><label for="emailflag_2" style=" cursor:hand">邮件通知</label>
	 <input type="radio" id="emailflag_3" name="emailflag" value="2"  class="radio"/><label for="emailflag_3" style=" cursor:hand">短信通知</label>
	 <input type="radio" id="emailflag_4" name="emailflag" value="3"  class="radio"/><label for="emailflag_4" style=" cursor:hand">邮件和短信通知</label>
	
<br />&nbsp;&nbsp;选项：<input type="checkbox" name="locktopic" value="yes" class="checkbox"/>帖子锁定&nbsp;&nbsp;<input type="checkbox" name="istop" value="yes" class="checkbox" checked/><font color="red">帖子固顶</font>&nbsp;&nbsp;<input type="checkbox" name="istopall" value="yes" class="checkbox"/><font color="red">帖子总固顶</font>

	<br/><span id="body_chk"></span><span id="ajaxMsg_1" class="ajaxMsg" style="display:none;"></span>
	</td>
</tr>
<tr>
  <td valign="middle" colspan="2" class="tablebody2" style="text-align : center; ">
<input class="input0" type="submit" value="       发 表 （编辑框内按CTRL+ENTER快捷发帖）       " id="submit" name="submit" />&nbsp;<input class="input0" type="button" value="预 览" name="Button" onclick="gopreview()" />
</td>
</tr>
</table></form>
<form action="preview.asp?boardid=<%=Dvbbs.Boardid%>" method="post" name="preview" target="preview_page" id="preview">
<input type="hidden" name="Dvtitle" value="" /><input type="hidden" name="theBody" value="" />
</form>

<!--Z-INDEX：999999，Modify By Dv_Xiaoxian，Date:2008.0.14-->
<div id="MagicFace" style="POSITION:absolute;Z-INDEX: 999999;visibility:hidden;"></div>
<div id="magicframe" style="visibility:hidden; position: absolute;">
<iframe id="magic_frame" class="magicframe" src="" frameborder="0" scrolling="no" width="0px" height="0px"></iframe>
</div>

</center><script language="javascript" type="text/javascript">
Maxtitlelength=200;
ispostnew=1;
MaxConlength=16240;
</script>

<%
End Sub
Function GetFormID()
	Dim i,sessionid
	sessionid = Session.SessionID
	For i=1 to Len(sessionid)
		GetFormID=GetFormID&Chr(Mid(sessionid,i,1)+97)
	Next
End Function

%>