document.charset = "gb2312";
function gid(id){return document.getElementById(id);};
var menuOffX=0	
var menuOffY=18	
var vBobjects = new Array();
var fo_shadows=new Array();
var linkset=new Array();
var boardid=0;
var ie4=document.all&&navigator.userAgent.indexOf("Opera")==-1
var ns6=document.getElementById&&!document.all
var ns4=document.layers
var xslDoc;
var cache={};
var xmlhttp = HttpObj();
var forumpath="./"
function HttpObj(){
	var xmlhttp = null;
	try{
		xmlhttp= new ActiveXObject('Msxml2.XMLHTTP');
	}catch(e){
		try{
			xmlhttp= new ActiveXObject('Microsoft.XMLHTTP');
		}catch(e){
			try{
				xmlhttp= new XMLHttpRequest();
			}catch(e){}
		}
	}
	if (xmlhttp) return xmlhttp;
}
//短信窗口
function openScript(url, width, height){
	var Win = window.open(url,"openScript",'width=' + width + ',height=' + height + ',resizable=1,scrollbars=yes,menubar=no,status=no' );
}
//插件窗口
function PlusOpen(url, width, height){
	window.open(url,"PlusOpen",'width=' + width + ',height=' + height + ',resizable=0,scrollbars=yes,menubar=no,status=yes' );
}
function MM_findObj(n, d) {
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	 
	if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  
		for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  
		if(!x && d.getElementById) x=d.getElementById(n); return x;

} 
function fetch_object(idname, forcefetch)
{
	if (typeof(vBobjects[idname]) == "undefined")
	{
		vBobjects[idname] = MM_findObj(idname);
	}
	return vBobjects[idname];
}
//showmenu vmenu:内容，允许为空,vmenuobj DIV数据ID，MOD 0=关闭浏览器自适应，用于版面导航菜单

var monuobj=new Array();
function showmenu1(vmenuobj,depth){
	var obj=document.getElementById(vmenuobj);
	if (obj){
		if (monuobj[depth] && monuobj[depth]!=''){
			monuobj[depth].style.display='none';
			monuobj[depth]='';
		}
		obj.style.display ='block';
		window.__topPopMenuHidden = false;
		monuobj[depth]=obj;
	}
}
function hidemenu1(){
	if(monuobj[0]!=null && monuobj[0]!=''){
		if (monuobj[0].style.display=='block'){
			monuobj[0].style.display='none';
			window.__topPopMenuHidden = true;
		}
		monuobj[0]='';
	}
}

function showmenu(e,vmenu,vmenuobj,mod){
	if (!document.all&&!document.getElementById&&!document.layers)
		return
	var which=vmenu;
	if (vmenuobj)
	{
		var MenuObj = fetch_object(vmenuobj);
		if (MenuObj)
		{
			which = MenuObj.innerHTML;
		}
	}
	if (!which)
	{
		return
	}
	clearhidemenu();
	ie_clearshadow();
	menuobj=ie4? document.all.popmenu : ns6? document.getElementById("popmenu") : ns4? document.popmenu : ""
	menuobj.thestyle=(ie4||ns6)? menuobj.style : menuobj
	if (ie4||ns6)
		menuobj.innerHTML=which
	else{
		menuobj.document.write('<layer name=gui bgcolor="#E6E6E6" width="165" onmouseover="clearhidemenu()" onmouseout="hidemenu()">'+which+'</layer>')
		menuobj.document.close()
	}
	menuobj.contentwidth=(ie4||ns6)? menuobj.offsetWidth : menuobj.document.gui.document.width
	menuobj.contentheight=(ie4||ns6)? menuobj.offsetHeight : menuobj.document.gui.document.height
	eventX=ie4? event.clientX : ns6? e.clientX : e.x
	eventY=ie4? event.clientY : ns6? e.clientY : e.y
	var rightedge=ie4? document.body.clientWidth-eventX : window.innerWidth-eventX
	var bottomedge=ie4? document.body.clientHeight-eventY : window.innerHeight-eventY
	var getlength
		if (rightedge<menuobj.contentwidth){
			getlength=ie4? document.body.scrollLeft+eventX-menuobj.contentwidth+menuOffX : ns6? window.pageXOffset+eventX-menuobj.contentwidth : eventX-menuobj.contentwidth
		}else{
			getlength=ie4? ie_x(event.srcElement)+menuOffX : ns6? window.pageXOffset+eventX : eventX
		}
		menuobj.thestyle.left=getlength+'px'
		if (bottomedge<menuobj.contentheight&&mod!=0){
			getlength=ie4? document.body.scrollTop+eventY-menuobj.contentheight-event.offsetY+menuOffY-23 : ns6? window.pageYOffset+eventY-menuobj.contentheight-10 : eventY-menuobj.contentheight
		}	else{
			getlength=ie4? ie_y(event.srcElement)+menuOffY : ns6? window.pageYOffset+eventY+10 : eventY
		}
	menuobj.thestyle.top=getlength+'px'
	menuobj.thestyle.visibility="visible"
	ie_dropshadow(menuobj,"#999999",3)
	return false
}

function ie_y(e){  
	var t=e.offsetTop;  
	while(e=e.offsetParent){  
		t+=e.offsetTop;  
	}  
	return t;  
}  
function ie_x(e){  
	var l=e.offsetLeft;  
	while(e=e.offsetParent){  
		l+=e.offsetLeft;  
	}  
	return l;  
}  
function ie_dropshadow(el, color, size)
{
	var i;
	for (i=size; i>0; i--)
	{
		var rect = document.createElement('div');
		var rs = rect.style
		rs.position = 'absolute';
		rs.left = (el.style.posLeft + i) + 'px';
		rs.top = (el.style.posTop + i) + 'px';
		rs.width = el.offsetWidth + 'px';
		rs.height = el.offsetHeight + 'px';
		rs.zIndex = el.style.zIndex - i;
		rs.backgroundColor = color;
		var opacity = 1 - i / (i + 1);
		rs.filter = 'alpha(opacity=' + (100 * opacity) + ')';
		fo_shadows[fo_shadows.length] = rect;
	}
}
function ie_clearshadow()
{
	for(var i=0;i<fo_shadows.length;i++)
	{
		if (fo_shadows[i])
			fo_shadows[i].style.display="none"
	}
	fo_shadows=new Array();
}


function contains_ns6(a, b) {
	while (b.parentNode)
		if ((b = b.parentNode) == a)
			return true;
	return false;
}

function hidemenu(){
	if (window.menuobj)
		menuobj.thestyle.visibility=(ie4||ns6)? "hidden" : "hide"
	ie_clearshadow()
}

function dynamichide(e){
	e=fixE(e);

	if (ie4&&!menuobj.contains(e.toElement))
		hidemenu()
	else if (ns6&&e.currentTarget!= e.relatedTarget&& !contains_ns6(e.currentTarget, e.relatedTarget))
		hidemenu()
}

function delayhidemenu(){
	if (ie4||ns6||ns4)
		delayhide=setTimeout("hidemenu()",500)
}

function clearhidemenu(){
	if (window.delayhide)
		clearTimeout(delayhide)
}

function highlightmenu(e,state){
	if (document.all)
		source_el=event.srcElement
	else if (document.getElementById)
		source_el=e.target
	if (source_el.className=="menuitems"){
		source_el.id=(state=="on")? "mouseoverstyle" : ""
	}
	else{
		while(source_el.id!="popmenu"){
			source_el=document.getElementById? source_el.parentNode : source_el.parentElement
			if (source_el.className=="menuitems"){
				source_el.id=(state=="on")? "mouseoverstyle" : ""
			}
		}
	}
}

function fixE(e){var e;e=e?e:(window.event?window.event:null);return e}

if (ie4||ns6)
document.onclick=hidemenu
function doSClick() {
	var targetId, srcElement, targetElement, imageId, imageElement;
	srcElement = window.event.srcElement;
	targetId = srcElement.id + "content";
	targetElement = document.all(targetId);
	imageId = srcElement.id;
	imageId = imageId.charAt(0);
	imageElement = document.all(imageId);
	if (targetElement.style.display == "none") {
		imageElement.src = "Skins/Default/minus.gif"
		targetElement.style.display = "";
	} else {
		imageElement.src = "Skins/Default/plus.gif"
		targetElement.style.display = "none";
	}
}
function doClick() {
	var targetId, srcElement, targetElement;
	srcElement = window.event.srcElement;
	targetId = srcElement.id + "_content";
	targetElement = document.all(targetId);
	if (targetElement.style.display == "none") {
		srcElement.src = "Skins/Default/minus.gif"
		targetElement.style.display = "";
	} else {
		srcElement.src = "Skins/Default/plus.gif"
		targetElement.style.display = "none";
	}
}
function bbimg(o){
	var zoom=parseInt(o.style.zoom, 10)||100;zoom+=event.wheelDelta/12;if (zoom>0) o.style.zoom=zoom+'%';
	return false;
}
function imgzoom(img,maxsize){
	var a=new Image();
	a.src=img.src
	if(a.width > maxsize * 4)
	{
		img.style.width=maxsize;
	}
	else if(a.width >= maxsize)
	{
		img.style.width=Math.round(a.width * Math.floor(4 * maxsize / a.width) / 4);
	}
	return false;
}
function Dvbbs_ViewCode(replyid)
{
	var bodyTag="<html><head><style type=text/css>.quote{margin:5px 20px;border:1px solid #CCCCCC;padding:5px; background:#F3F3F3 }\nbody{boder:0px}.HtmlCode{margin:5px 20px;border:1px solid #CCCCCC;padding:5px;background:#FDFDDF;font-size:14px;font-family:Tahoma;font-style : oblique;line-height : normal ;font-weight:bold;}\nbody{boder:0px}</style></head><BODY bgcolor=\"#FFFFFF\" >";
	bodyTag+=document.getElementById('scode'+replyid).CodeText.value
	bodyTag+="</body></html>"
	preWin=window.open('preview','','left=0,top=0,width=550,height=400,resizable=1,scrollbars=1, status=1, toolbar=1, menubar=0');
	preWin.document.open();
	preWin.document.write(bodyTag);
	preWin.document.close();
	preWin.document.title="查看贴子内容";
	preWin.document.charset="UTF-8";
}
function BoardJumpList(boardid,act)
{
	var MenuStr="";
	if(typeof(cache["boardlist"])=="undefined")
	{
		var xmlhttp;
			try{
				xmlhttp= new ActiveXObject('Msxml2.XMLHTTP');
			}catch(e){
				try{
					xmlhttp= new ActiveXObject('Microsoft.XMLHTTP');
				}catch(e){
					try{
						xmlhttp= new XMLHttpRequest();
					}catch(e){}
				}
			}
			xmlhttp.onreadystatechange=function(){
			if(xmlhttp.readyState==4){
				if(xmlhttp.status==200){
					cache["boardlist"]=xmlhttp.responseText;
					BoardJumpList(boardid,act)
				}else{
				
				}
			}
	    }
	    xmlhttp.open("post",forumpath+"GetBoardlist.asp",true);	
	    xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
			xmlhttp.send("");
	}
	else
	{
		eval("var boardlist="+cache["boardlist"]+".data");
		MenuStr+="<div class=\"menuitems\">";
		MenuStr+=getboardmenu(boardlist,boardid);
		MenuStr+="</div>";
	}
	return MenuStr;
}
function getboardmenu(boardlist,boardid)
{
	var html="";
	for(var i=0;i<boardlist.length;i++)
	{		
		if(parseInt(boardlist[i].parentid)==boardid)
		{
			var LoadBoard =parseInt(boardlist[i].boardid);
			var depth = parseInt(boardlist[i].depth);
			var	boardtype = boardlist[i].boardtype;			
			if (depth==0)
			{
				var outtext="╋";
				/*start_o*/						
				//html+='<div id="'+LoadBoard+'" style="cursor:pointer" onmouseover="showdiv(child_'+LoadBoard+');">'+boardtype+"</div>";						
				//html+='<div id="child_'+LoadBoard+'" style="cursor:pointer;display:none;">'+getboardmenu(boardlist,LoadBoard)+'</div>';
				/*end_o*/
			}
			else
			{
				var outtext="";
				for (var j=0;j<(depth);j++)
				{
					if (j>0)
					{
						outtext+=" |"
					}
					outtext+="&nbsp;&nbsp;"
				}
				outtext+="├"
				/*o_star*/
				//html+='<div id="'+LoadBoard+'" style="cursor:pointer">'+boardtype+'</div>';
				/*o_end*/
			}
			if (ISAPI_ReWrite==1)
				html+="<a href=\"index_"+LoadBoard+".html\">"+ outtext + "&nbsp;" + boardtype +"</a><br />" + getboardmenu(boardlist,LoadBoard);			
			else
				html+="<a href=\"index.asp?boardid="+LoadBoard+"\">"+ outtext + "&nbsp;" + boardtype +"</a><br />" + getboardmenu(boardlist,LoadBoard);			
		}
	}
	return html;
}
/*o_start
function showdiv(sid)
{
	if(document.getElementById(sid))
		document.getElementById(sid).style.display='';
}
o_end*/
//selected下拉列表选取表单()
function BoardJumpListSelect(boardid,selectname,fristoption,fristvalue,checknopost)
{	
	if(typeof(cache["boardlist"])=="undefined")
	{
		var xmlhttp;
			try{
				xmlhttp= new ActiveXObject('Msxml2.XMLHTTP');
			}catch(e){
				try{
					xmlhttp= new ActiveXObject('Microsoft.XMLHTTP');
				}catch(e){
					try{
						xmlhttp= new XMLHttpRequest();
					}catch(e){}
				}
			}
			xmlhttp.onreadystatechange=function(){
			if(xmlhttp.readyState==4){
				if(xmlhttp.status==200){
					cache["boardlist"]=xmlhttp.responseText;
					BoardJumpListSelect(boardid,selectname,fristoption,fristvalue,checknopost);
				}else{
				
				}
			}
	    }
	    xmlhttp.open("post",forumpath+"GetBoardlist.asp",true);	
	    xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
			xmlhttp.send("");
	}
	else
	{
		var sObj = document.getElementById(selectname);
		if (sObj)
		{
			sObj.options[0] =  new Option(fristoption, fristvalue);
			eval("var boardlist="+cache["boardlist"]+".data");
			appOption(boardlist,sObj,boardid,checknopost,0)
		}
	}
}
function appOption(boardlist,Obj,boardid,checknopost,pid)
{
	for(var i=0;i<boardlist.length;i++)
	{
		if(parseInt(boardlist[i].parentid)==pid)
		{
			var LoadBoard =parseInt(boardlist[i].boardid);
			var depth = parseInt(boardlist[i].depth);
			var	boardtype = boardlist[i].boardtype;
			if (depth ==0)
			{
				var outtext="╋";
			}
			else
			{
					var outtext="";
					for (var j=0;j<depth ;j++)
					{
						if (j>0){outtext+=" |"}
						outtext+="  "
					}
					outtext+="├"
			}
			boardtype = boardtype.replace(/<[^>]*>/g, "")
			boardtype = boardtype.replace(/&[^&]*;/g, "")
			if(checknopost==1 && boardlist[i].nopost=="1")
			{
					boardtype+="(不许转移)"
			}
			var index=Obj.length;
			Obj.options[index] = new Option(outtext+boardtype, LoadBoard);
			if(LoadBoard==boardid) Obj.options[index].selected = true;
			appOption(boardlist,Obj,boardid,checknopost,LoadBoard)
		}
	}
}

//SELECT表单选取 Obj 表单名，VAL所选的值
function ChkSelected(Obj,Val)
{
	Val = Val.replace(/\s*/g,"");
	if (Obj)
	{
	for (i=0;i<Obj.length;i++){
		if (Obj.options[i].value==Val||(","+Val+",").indexOf(","+Obj.options[i].value+",")!=-1){
			Obj.options[i].selected=true;
		}
	}
	}
}

//单选表单选取 Obj 表单名，VAL所选的值
function chkradio(Obj,Val){
	if (Obj){
		Val = Val.replace(/\s*/g,"");
		for (i=0;i<Obj.length;i++){
			if (Obj[i].value==Val){
				Obj[i].checked=true;
				break;
			}
		}
	}
}

//多选表单选取 Obj 表单名，VAL所选的值
function chkcheckbox(Obj,Val){
	if (Obj){
		Val = Val.replace(/\s*/g,"");
		Val = ","+Val+",";
		if (Obj.length==null){
			if(Val.indexOf(","+Obj.value+",")!=-1){
				Obj.checked=true;
			}
		}
		for (i=0;i<Obj.length;i++){
			if(Val.indexOf(","+Obj[i].value+",")!=-1){
				Obj[i].checked=true;
			}
		}
	}
}

//复选表单全选事件
function boxCheckAll(obj,chkobj)  {
	if (!obj){return false;}

	for (var i=0;i<obj.length;i++)
	{
		var e = obj[i];
		if (e.type=="checkbox")
		{
			e.checked = chkobj.checked;
		}
	}
}
// 修改编辑栏高度
function textarea_size(num,objname){
	var obj=document.getElementById(objname)
	if (obj){
		if (parseInt(obj.style.height)+num>20){
		obj.style.height = parseInt(obj.style.height)+num+"px";
		}
	}
}


function readCookie(name){
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		for(var i=0;i < ca.length;i++) {
			var c = ca[i];
			while (c.charAt(0)==' ') c = c.substring(1,c.length);
			if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
		};
		return null;
	};
function createCookie(name,value,days){
		var expires = "";
		if (days) {
			var date = new Date();
			date.setTime(date.getTime()+(days*24*60*60*1000));
			expires = "; expires="+date.toGMTString();
		};
		document.cookie = name+"="+value+expires+"; path=/";
	};
//图片自动调整的模式，1为按比例调整 ，2 按大小调整。
var resizemode=2;
function imgresize(o){
	if (resizemode==2 || o.onmousewheel){
		if(o.width > 500 ){
			o.style.width='500px';
		}
		if(o.height > 800){
			o.style.height='800px';
		}
	}
	else{
		var parentNode=o.parentNode.parentNode
		if (parentNode){
			if (o.offsetWidth>=parentNode.offsetWidth) o.style.width='98%';
		}
		else{
			var parentNode=o.parentNode
			if (parentNode){
				if (o.offsetWidth>=parentNode.offsetWidth) o.style.width='98%';
			}
		}
	}
}
function bbimg(o){
	var zoom=parseInt(o.style.zoom, 10)||100;zoom+=event.wheelDelta/12;if (zoom>0) o.style.zoom=zoom+'%';
	return false;
}
function boardbarover(obj)
{
	obj.className = obj.className.indexOf("mainbarhover")>0? "mainbar":"mainbar mainbarhover";
}
function getOffsetTop(elm) {
	var mOffsetTop = elm.offsetTop;
	var mOffsetParent = elm.offsetParent;
	while(mOffsetParent){
		mOffsetTop += mOffsetParent.offsetTop;
		mOffsetParent = mOffsetParent.offsetParent;
	}
	return mOffsetTop;
}

function getOffsetLeft(elm) {
	var mOffsetLeft = elm.offsetLeft;
	var mOffsetParent = elm.offsetParent;
	while(mOffsetParent) {
		mOffsetLeft += mOffsetParent.offsetLeft;
		mOffsetParent = mOffsetParent.offsetParent;
	}
	return mOffsetLeft;
}
function postUrl(poststyle,act,bid,stype){
	var thisUrl ="post.asp?poststyle="+poststyle+"&action="+act+"&boardid="+bid+"&stype="+stype;
	return thisUrl; 
}

function close_postform(){
			var obj=document.getElementById("post_div");
			if (obj.style.display!="none"){
			obj.style.display="none";
			document.getElementById("post_iframe").src="";
			}
}

function post_topic(buttonElement,pstyle,act,bid,stype){
	var obj=document.getElementById("post_div");
	var buttonElement = document.getElementById("postbutton");
	if (pstyle!="1"){
		return this.location = postUrl(pstyle,act,bid,stype);
	}
	if (obj.style.display=="none")
		{
			obj.style.display="block";
			document.getElementById("post_iframe").style.height="760px";
			document.getElementById("post_iframe").src=postUrl(pstyle,act,bid,stype);
	}else {
			obj.style.display="none";
			document.getElementById("post_iframe").src="";
	}
};


function ActiveOnline(boardid)
{
	xmlhttp.onreadystatechange=function(){
		if(xmlhttp.readyState==4){
			try{
			if(xmlhttp.status==200){
				updateonline(xmlhttp.responseText);		
			}else{}}catch(e){}
		}
	}
	var param="state="+escape(document.title.toString())+"&boardid="+boardid;
	xmlhttp.open("post","activeonline.asp",true);	
	xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlhttp.setRequestHeader("Content-Length",param.length); 
	xmlhttp.send(param);
}

function updateonline(XMLstr)
{
	eval(XMLstr);
	var AllOnlie=document.getElementById("allonline");
	var UserOnlie=document.getElementById("useronline");
	var GuestOnlie=document.getElementById("guestonline");
	if(AllOnlie) AllOnlie.innerHTML=allonline.toString();
	if(UserOnlie) UserOnlie.innerHTML=useronline.toString();
	if(GuestOnlie) GuestOnlie.innerHTML=guestonline.toString();

}

var cacheobj=function(){};

function frameon(url,img){
	if (window == top){
		top.location.href = "index.asp?action=frameon&url="+escape(url);
	}else{
		top.location.href = url;
	}
}

function changeframeicon(img){
	if (!img){return false;}
	if (window == top){
		img.src = 'images/others/isleft.gif';
	}else{
		img.src = 'images/others/noleft.gif';

	}
}

function ajaxMsg(t){
	tb_remove();
	var msg;
	switch(t){
		case 5:msg="状态信息：发表新主题成功！";break;
		case 6:msg="状态信息：回复帖子成功！";break;
		case 7:msg="状态信息：发表新投票成功！";break;
		case 8:msg="状态信息：保存编辑帖子成功！";break;
		default:msg="状态信息：发表成功！";
	}

	document.getElementById("ajaxMsg_1").style.display = "";
	document.getElementById("ajaxMsg_1").innerHTML = '<img src="Css/cndw/images/ok.gif" width="19" height="16" alt="Ok" /><font color="#33CC00">'+msg+'</font>';
	window.setTimeout("document.getElementById('ajaxMsg_1').style.display = 'none'",3000);
}

//页面完成后加载事件列表
function page_init(){
	
}

//url参数分割
function parseQuery ( query ) {
   var Params = {};
   if ( ! query ) {return Params;}// return empty object
   var Pairs = query.split(/[;&]/);
   for ( var i = 0; i < Pairs.length; i++ ) {
      var KeyVal = Pairs[i].split('=');
      if ( ! KeyVal || KeyVal.length != 2 ) {continue;}
      var key = unescape( KeyVal[0] );
      var val = unescape( KeyVal[1] );
      val = val.replace(/\+/g, ' ');
      Params[key] = val;
   }
   return Params;
}

function inputStyle(fEvent,oInput){
	if (!oInput.style) return;
	var put=oInput.getAttribute("type").toLowerCase();

	switch (fEvent){
		case "focus" :
			oInput.isfocus = true;
		case "mouseover" :			
			if(put=="submit" || put=="button" || put=="reset")			
				oInput.className="input_on";
			else
				oInput.className = "TextBoxFocus";	
			break;
		case "blur" :
			oInput.isfocus = false;
		case "mouseout" :
			if(put=="submit" || put=="button" || put=="reset")
				oInput.className = "input0";
		    else if(!oInput.isfocus)
				oInput.className = "TextBox";
			break;
		//case else :
			//if(oInput.getAttribute(fEvent+"_2"))
				//eval(oInput.getAttribute(fEvent+"_2"));
	}	
}

window.onload = function(){
	var oInput = document.getElementsByTagName("input");
	var onfocusStr = [];
	var onblurStr = [];
	//alert(oInput.length);
	try
	{
		for (var i=0; i<oInput.length; i++)
		{
			if (!oInput[i]||!oInput[i].getAttribute("type")) continue;
			var put=oInput[i].getAttribute("type").toLowerCase();
			if(put=="submit" || put=="button" || put=="reset")
			{
				oInput[i].className="input0";
			}
			if (put=="text" || put=="password" || put=="submit" || put=="button" || put=="reset")
			{
				if (document.all)
				{
					oInput[i].attachEvent("onmouseover",oInput[i].onmouseover=function(){inputStyle("mouseover",this);});
					oInput[i].attachEvent("onmouseout",oInput[i].onmouseout=function(){inputStyle("mouseout",this);});

				}
				else{
					oInput[i].addEventListener("onmouseover",oInput[i].onmouseover=function(){inputStyle("mouseover",this);},false);
					oInput[i].addEventListener("onmouseout",oInput[i].onmouseout=function(){inputStyle("mouseout",this);},false);				
					//获取焦点
					if(oInput[i].getAttribute("onfocus")){
						oInput[i].addEventListener("onfocus",oInput[i].onblur=function(){eval(this.getAttribute("onfocus"));inputStyle("focus",this);},false);
					}else{
						oInput[i].addEventListener("onfocus",oInput[i].onfocus=function(){inputStyle("focus",this);},false);
					}
					//失去焦点
					if(oInput[i].getAttribute("onblur")){
						oInput[i].addEventListener("onblur",oInput[i].onblur=function(){eval(this.getAttribute("onblur"));inputStyle("blur",this);},false);
					}else{
						oInput[i].addEventListener("onblur",oInput[i].onblur=function(){inputStyle("blur",this);},false);
					}
				}			
			}
		}
	}catch(e){}
	for(i=1;i<=8;i++)//控制面板
	{
		if(document.getElementById('con_two_'+i))
		{	
			document.getElementById('two'+i).className="hover";			
			break;
		}
	}
}


function disp(id){
	if (!document.getElementById(id)) return;
	var disp=document.getElementById(id).style.display;
	if (disp=="")
		document.getElementById(id).style.display="none";
	else
		document.getElementById(id).style.display="";
}

/*显示认证码 o start1*/
function get_Code() {
	var Dv_CodeFile = "Dv_GetCode.asp";
	if(document.getElementById("imgid"))
		document.getElementById("imgid").innerHTML = '<img src="'+Dv_CodeFile+'?t='+Math.random()+'" alt="点击刷新验证码" style="cursor:pointer;border:0;vertical-align:middle;" onclick="this.src=\''+Dv_CodeFile+'?t=\'+Math.random()" />'
}
function get_Code_win() {
	var Dv_CodeFile = "Dv_GetCode.asp";
	if(document.getElementById("imgidwin"))
		document.getElementById("imgidwin").innerHTML = '<img src="'+Dv_CodeFile+'?t='+Math.random()+'" alt="点击刷新验证码" style="cursor:pointer;border:0;vertical-align:middle;" onclick="this.src=\''+Dv_CodeFile+'?t=\'+Math.random()" />'
}
/*o end*/

