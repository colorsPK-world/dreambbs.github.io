/*//////////////////////////////////////////////////////////////////
 * Script For Dvbbs Program -- 前台页面公共对象
 * Version: 8.3.0
 * Copyright (C) 2000 - 2005 bbs.dvbbs.net
 *
 * For further information visit:
 * 		http://bbs.dvbbs.net/
 * 		http://www.aspsky.net/
 *
 * Builder: Fssunwin
 * Created: 2005-04-23
*///////////////////////////////////////////////////////////////////
var DvMenu = new MenuObj();
//CSS读取
window.onload = function(e) {
	try{
		var cookieName = forum_sn+'_style_'+templateid+'_'+boardid;
		var cookie = Dvbbs.readCookie(cookieName);
		var title = (cookie ? cookie : getActiveStyleSheet());
		setActiveStyleSheet(title);
		if (Dvbbs.BrowserInfo.IsIE||Dvbbs.BrowserInfo.IsNC6){
			document.onclick=DvMenu.hidemenu;
		};
	}catch(e){};
};

window.onunload = function(e) {
  var filepath = getActiveStyleSheet();
  Dvbbs.createCookie("style", filepath, 365);
};

//转换CSS
function setActiveStyleSheet(filepath) {
	if (filepath.lastIndexOf('.css')==-1) return false;
	var cookieName = forum_sn+'_style_'+templateid+'_'+boardid;
	var i, a
	for(i=0; (a = document.getElementsByTagName("link")[i]); i++) {
		if (a.getAttribute("title") == "Dvbbs_BodyCss")
		{
			a.href=filepath;
			Dvbbs.createCookie(cookieName, filepath, 365);
			break;
		};
	};
};

function getActiveStyleSheet() {
  var i, a;
  for(i=0; (a = document.getElementsByTagName("link")[i]); i++) {
    if (a.getAttribute("title") == "Dvbbs_BodyCss") return a.getAttribute("href");
  }
  return null;
}

/*
菜单MENU
*/
function showmenu(e,vmenu,vmenuobj,mod){
	DvMenu.ShowMenu(e,vmenu,vmenuobj,mod);

};

function MenuObj(){
	this.ShowMenu = function (e,vmenu,vmenuobj,mod){
		if (!Dvbbs.BrowserInfo.IsIE&&!Dvbbs.BrowserInfo.IsNC6&&!Dvbbs.BrowserInfo.IsNC4){return false;};
		var which=vmenu;
		if (vmenuobj)
		{
			var getMenuObj = Dvbbs.Objects(vmenuobj);
			if (getMenuObj){which = getMenuObj.innerHTML;};
		};
		if (!which){return};
		this.clearhidemenu();
		menuobj =  Dvbbs.Objects("popmenu");
		if (!menuobj){return false;};
		menuobj.thestyle=((Dvbbs.BrowserInfo.IsIE||Dvbbs.BrowserInfo.IsNC6)? menuobj.style : menuobj);
		
		if (Dvbbs.BrowserInfo.IsIE||Dvbbs.BrowserInfo.IsNC6){menuobj.innerHTML=which;}
		else{
			menuobj.document.write('<layer name="pop_menu" bgcolor="#E6E6E6" width="165" onmouseover="DvMenu.clearhidemenu();" onmouseout="DvMenu.hidemenu();">'+which+'</layer>');
			menuobj.document.close();
		};

		menuobj.contentwidth = ((Dvbbs.BrowserInfo.IsIE||Dvbbs.BrowserInfo.IsNC6)? menuobj.offsetWidth : menuobj.document.gui.document.width);
		menuobj.contentheight = ((Dvbbs.BrowserInfo.IsIE||Dvbbs.BrowserInfo.IsNC6)? menuobj.offsetHeight : menuobj.document.gui.document.height);
		eventX = (Dvbbs.BrowserInfo.IsIE? event.clientX : Dvbbs.BrowserInfo.IsNC6? e.clientX : e.x);
		eventY = (Dvbbs.BrowserInfo.IsIE? event.clientY : Dvbbs.BrowserInfo.IsNC6? e.clientY : e.y);
		var rightedge = (Dvbbs.BrowserInfo.IsIE? document.body.clientWidth-eventX : window.innerWidth-eventX);
		var bottomedge = (Dvbbs.BrowserInfo.IsIE? document.body.clientHeight-eventY : window.innerHeight-eventY);
		var getlength;
			if (rightedge<menuobj.contentwidth){
				getlength = (Dvbbs.BrowserInfo.IsIE? document.body.scrollLeft+eventX-menuobj.contentwidth+Dvbbs.menuOffX : Dvbbs.BrowserInfo.IsNC6? window.pageXOffset+eventX-menuobj.contentwidth : eventX-menuobj.contentwidth);
			}else{
				getlength = (Dvbbs.BrowserInfo.IsIE? Dvbbs.getOffsetLeft(event.srcElement)+Dvbbs.menuOffX : Dvbbs.BrowserInfo.IsNC6? window.pageXOffset+eventX : eventX);
			};
			menuobj.thestyle.left=getlength+'px';
			if (bottomedge<menuobj.contentheight&&mod!=0){
				getlength = (Dvbbs.BrowserInfo.IsIE? document.body.scrollTop+eventY-menuobj.contentheight-event.offsetY+Dvbbs.menuOffY-23 : Dvbbs.BrowserInfo.IsNC6? window.pageYOffset+eventY-menuobj.contentheight-10 : eventY-menuobj.contentheight);
			}else{
				getlength = (Dvbbs.BrowserInfo.IsIE? Dvbbs.getOffsetTop(event.srcElement)+Dvbbs.menuOffY : Dvbbs.BrowserInfo.IsNC6? window.pageYOffset+eventY+10 : eventY);
			};
		menuobj.thestyle.top=getlength+'px';
		menuobj.thestyle.visibility="visible";
		return false;
	}

	this.contains_ns6 = function (a, b) {
		while (b.parentNode){
			if ((b = b.parentNode) == a) {return true;};
		};
		return false;
	};

	this.hidemenu = function(){
		if (window.menuobj){
			menuobj.thestyle.visibility=((Dvbbs.BrowserInfo.IsIE||Dvbbs.BrowserInfo.IsNC6)? "hidden" : "hide");
		};
	};

	this.dynamichide = function (e){
		if (Dvbbs.BrowserInfo.IsIE && !menuobj.contains(e.toElement)){this.hidemenu();}
		else if (Dvbbs.BrowserInfo.IsNC6 && e.currentTarget!= e.relatedTarget && !this.contains_ns6(e.currentTarget, e.relatedTarget)){this.hidemenu();}
	};

	this.delayhidemenu = function (){
		if (Dvbbs.BrowserInfo.IsIE||Dvbbs.BrowserInfo.IsNC6||Dvbbs.BrowserInfo.IsNC4){delayhide=setTimeout("DvMenu.hidemenu();",500);}
	};

	this.clearhidemenu = function (){
		if (window.delayhide){clearTimeout(delayhide);}
	};
};

//OTHER FUNCTION
function InnerData(name,value){
	for (var objid in name) {
		var obj = Dvbbs.Objects(name[objid]);
		if (obj){
			obj.innerHTML = value[objid];
		}
	};
}

function mybook(){
  h = 300;
  w = 300;
  t = ( screen.availHeight - h ) / 2;
  l = ( screen.availWidth - w ) / 2;
  //window.open("http://forumAd.to5198.com/common/login.jsp?sCheckUrl=/out/login.jsp&sDesUrl=/out/mybook.jsp", "我的服务","left=" + l + ",top=" + t + ",height=" + h + ",width=" + w + ",toolbar=no,status=no,scrollbars=no,resizable=yes");
  return;
}