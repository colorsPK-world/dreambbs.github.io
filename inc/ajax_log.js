var useAjaxPost=1;
var xcount=0;

var j$=function(id)
{
	var itm = null;
	if (document.getElementById) {itm = document.getElementById(id);}
	else if (document.all) {itm = document.all[id];}
	else if (document.layers) {itm = document.layers[id];}
	return itm;
}
var getByName=function(_name) {	return document.getElementsByName(_name);}

function AjaxPost(){
	var base=this;
	this.postForm=function(_form,winclosed){
		if (useAjaxPost != 1) return true;
		var data="";		
		if(_form){		
			//readyPost();
			postErr2(0,1);
			for(var i=0;i<_form.elements.length;i++)
			{
				if (!_form.elements[i]["name"]) continue;
				if ("username"==_form.elements[i]["name"].toLowerCase()){usernameIndex=i;continue;}
				if(data!=""&&"&"!=data.substr(data.length-1,1)){data += "&"}
					try{
						if (_form.elements[i].type.toLowerCase() == "radio" || _form.elements[i].type.toLowerCase() =="checkbox"){
							var n = getByName(_form.elements[i].name).length;
							for (var j=0; j<n ; j++ ){
								if (_form.elements[i+j].checked){
									data += _form.elements[i+j].name +"="+ base.replace(escape(String(_form.elements[i+j].value)));
									if (_form.elements[i].type.toLowerCase() == "radio"){break;}
								}
							}
							i = i + n-1;
						}
						else{
							data += _form.elements[i].name+"="+base.replace(escape(String(_form.elements[i].value)));
						}
					}
					catch(e) {data += _form.elements[i].name+"="+base.replace(escape(String(_form.elements[i].value)));}	
			
			}
			data+="&ajaxPost=1&username="+escape(escape(String(_form.elements[usernameIndex].value)));			
			var xmlhttp;
			try{
				xmlhttp= new ActiveXObject("Msxml2.XMLHTTP");
			}catch(e){
				try{
					xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
				}catch(e){
					try{
						xmlhttp= new XMLHttpRequest();
					}catch(e){}
				}
			}
			xmlhttp.onreadystatechange=function(){
				if(xmlhttp.readyState==4)
				{
					base.xmlhttp = xmlhttp;
					if(xmlhttp.status==200){
						//postErr(xmlhttp.responseText);
						base.onsuccess(winclosed);
					}else{
						base.onfailure();
					}
				}				
			}
			xmlhttp.open(_form.method, _form.action, true);
			xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
			xmlhttp.send(data.replace("&&","&"));
		}
		return false;
	}
	this.onsuccess=function(winclosed){};
	this.onfailure=function(){};
	this.replace=function(str){
		var con=str;
			con=con.replace(/%A0/gi,"%20");
			con=con.replace(/\+/gi,"%2B");
			return con;
	}
}
var ajaxpost=new AjaxPost()
ajaxpost.onsuccess=function(winclosed)
{
	var rt=this.xmlhttp.responseText;
	var rl=rt.split("@@@@");
	if (rl.length<0){postErr2(rt,0);return;}		
	if (parseInt(rl[1])==1)
	{
		delCookie("count");
		if(rl[0].indexOf("showerr")>0){
			parent.location.href="index.asp";
			return;
		}else{
			if (winclosed=='winclosed')
			{
			parent.location.href=rl[0];
			return;		
			}
			else 
			{
			parent.location.href=rl[0];
			return;			
			}

		}
	}
	else
	{
		/*if(document.getElementById("imgid")){
			document.getElementById("imgid").src='DV_getcode.asp?t='+Math.random();	
		}*/
        if (parseInt(rl[1])==2){get_Code_yuyin();}else {get_Code();}
		postErr2(rl[0],0);	
		xcount+=1;		
		//setTimeout('document.getElementById("dvlog").style.display="none"',300);	
		//setTimeout('document.getElementById("trh").style.display="none"',300);
        if (xcount>200) //200次登录失败后操作,因为有语音验证码此处做此更换
		{
			var cookieEnabled=(navigator.cookieEnabled)? true : false;
			if (cookieEnabled){		
				createCookie("count",4,1);
				parent.location.href="login.asp";
			}else{
				parent.location.href="login.asp?count=4";
			}		
		}
	}	
}
ajaxpost.onfailure=function()
{
	postErr2(this.xmlhttp.responseText,0);
}

function postErr(str,tp)
{
	var trh=document.getElementById("trh")?document.getElementById("trh"):self.document.getElementById("trh");
	trh.style.display="";
	//document.getElementById("trh").style.display="";
	var lg=document.getElementById("tdh")?document.getElementById("tdh"):self.document.getElementById("tdh");
	if(tp==0)
	{
		lg.innerHTML='<img src="images/note_error.gif" width="16" height="16" alt="Err" />&nbsp;&nbsp;<span style="color:#ff0000;">'+str+'</span>';	
	}
	else
	{
		lg.innerHTML='<img src="images/loading_small.gif" alt="登录中">登录中...';
	}
}
function postErr2(str,tp)
{
	var trh=document.getElementById("trh")?document.getElementById("trh"):self.document.getElementById("trh");
	trh.style.display="";
	//document.getElementById("trh").style.display="";
	var lg=document.getElementById("tdh_win")?document.getElementById("tdh_win"):self.document.getElementById("tdh_win");
	if(tp==0)
	{
		lg.innerHTML='<img src="images/note_error.gif" width="16" height="16" alt="Err" />&nbsp;&nbsp;<span style="color:#ff0000;">'+str+'</span>';	
	}
	else
	{
		lg.innerHTML='<img src="images/loading_small.gif" alt="登录中">登录中...';
	}
}

function checkLogin()
{
	var a=arguments;
	var theform=a[0]||document.forms[0];
	var winclosed=a[1]||'nowinclosed';//是否关闭窗口
	if (theform.username.value=="")
	{		
		postErr("请输入您的用户名",0);
		theform.username.focus();
		return false;
	}
	if (theform.password.value=="" || theform.password.value.length<6)
	{
		postErr("请输入您的密码",0);
		theform.password.focus();
		return false;
	}
	return ajaxpost.postForm(theform,winclosed);
	/*return true;*/
}
function PrEvent(evt){
try{if(evt.preventDefault){evt.preventDefault();}else{evt.returnValue=false;}}catch(er){}
}


function checkLogin_win()
{
	var a=arguments;
	var theform=a[0]||document.forms[0];
	var evt=a[1]||'event';//是否关闭窗口
	PrEvent(evt);
	var winclosed=a[2]||'nowinclosed';//是否关闭窗口
	if (theform.username.value=="")
	{		
		postErr2("请输入您的用户名",0);
		theform.username.focus();
		return false;
	}
	if (theform.password.value=="" || theform.password.value.length<6)
	{
		postErr2("请输入您的密码",0);
		theform.password.focus();
		return false;
	}
	return ajaxpost.postForm(theform,winclosed);
	/*return true;*/
}
/*create cookie*/
function createCookie(name,value,days)
{
	var expires = "";
	if (days)
	{
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	document.cookie = name+"="+value+expires+"; path=/";
}
/*read cookies*/
function readCookie(name)
{
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++)
	{
		var c =ca[i].replace( /^\s*/,"");
		if (c.indexOf(nameEQ) == 0)
		{
			return c.substring(nameEQ.length,c.length);
		}
	}
	return null;
}
/*delete cookies*/
function delCookie(name)
{
	var exp = new Date();
	exp.setTime(exp.getTime() - 1);
	var cval=readCookie(name);
	if(cval!=null) document.cookie= name + "="+cval+";expires="+exp.toGMTString();
}
/*
var cookieEnabled=(navigator.cookieEnabled)? true : false
//判断cookie是否开启
//如果浏览器不是ie4+或ns6+
if (typeof navigator.cookieEnabled=="undefined" && !cookieEnabled)
{ 
	document.cookie="testcookie"
	cookieEnabled=(document.cookie=="testcookie")? true : false
	document.cookie="" //erase dummy value
}
//if (cookieEnabled) //if cookies are enabled on client's browser
//do whatever
*/