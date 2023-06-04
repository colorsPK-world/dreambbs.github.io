var dv_ajax_debug_mode = false;
		
function dvajax_debug(text) {
	if (dv_ajax_debug_mode)
	alert("RSD: " + text);
}

function dvajax_init_object() {
	dvajax_debug("dvajax_init_object() called..");	
	var RetValue;
	try {
			RetValue = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
		try {
		RetValue = new ActiveXObject("Microsoft.XMLHTTP");
		} catch (oc) {
		RetValue = null;
		}
	}
	if(!RetValue && typeof XMLHttpRequest != "undefined")
		RetValue = new XMLHttpRequest();
		if (!RetValue)
			dvajax_debug("Could not create connection object.");
		return RetValue;
}

function dvajax_run(func_name,func_obj, args) {
	var i, x, n;
	var uri;
	var post_data;
	uri = "ajax_check.asp";
	if (dvajax_request_type == "GET") {
		if (uri.indexOf("?") == -1) 
			uri = uri + "?rs=" + func_name;
		else
			uri = uri + "&rs=" + func_name;
			for (i = 0; i < args.length-1; i++) 
				uri = uri + "&rsargs[]=" + args[i];
				uri = uri + "&rsrnd=" + new Date().getTime();
				post_data = null;
	} else {
				post_data = "rs=" + func_name;
				for (i = 0; i < args.length-1; i++) 
					post_data = post_data + "&rsargs[]=" + urlencode(args[i]);
	}
			
			x = dvajax_init_object();
			x.open(dvajax_request_type, uri, true);
			if (dvajax_request_type == "POST") {
				x.setRequestHeader("Method", "POST " + uri + " HTTP/1.1");
				x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			}
			x.onreadystatechange = function() {
				if (x.readyState != 4) 
					return;
				dvajax_debug("received " + x.responseText);				
				var status;
				var data;
				status = x.responseText.charAt(0);
				datacache = x.responseText.substring(0);
				data = unescape(datacache);
				if (status == "-") 
					alert("Error: " + data);
				else
					args[args.length-1](func_obj,data);
			}
	x.send(post_data);//alert(uri+"***"+post_data);
	dvajax_debug(func_name + " uri = " + uri + "/post = " + post_data);
	dvajax_debug(func_name + " waiting..");
	delete x;
}

function obj_getbyid(id) {
	itm = null;
	if (document.getElementById) {
		itm = document.getElementById(id);
	} else if (document.all)	{
		itm = document.all[id];
	} else if (document.layers) {
		itm = document.layers[id];
	}
	return itm;
}

function dv_ajaxcheck(seltype,objid){
    var objname = obj_getbyid(objid).value;
		if (objname){
			x_checkdata(seltype,objid,objname,checkuser_cb);
		}
}

function checkuser_cb(c_type,data){
	var isok_username = obj_getbyid("isok_"+c_type);
	if (isok_username)
	{
		isok_username.innerHTML = "&nbsp;"+data;
		if (data.indexOf("error")>0 && obj_getbyid("checkreg"))
		{
			obj_getbyid("checkreg").value = "0";
		}
	}
}

function x_checkdata(x_seltype,x_obj) {
	dvajax_run(x_seltype,x_obj,x_checkdata.arguments);
}

function urlencode(text){
	text = text.toString();
	var matches = text.match(/[\x90-\xFF]/g);
	if (matches)
	{
		for (var matchid = 0; matchid < matches.length; matchid++)
		{
			var char_code = matches[matchid].charCodeAt(0);
			text = text.replace(matches[matchid], '%u00' + (char_code & 0xFF).toString(16).toUpperCase());
		}
	}
	return escape(text).replace(/\+/g, "%2B");
}


var RegCheck = {
	passValue : new Array(),
	pass : function(v,Objid,t){
		var isok_pass = obj_getbyid("isok_"+Objid);
		RegCheck.passValue[t] = v;
		if (v.length<6||v.length>10){
			isok_pass.innerHTML = err_msg("密码不能少于6位或多于10位");
			return false;
		}else{
			isok_pass.innerHTML = suc_msg("符合要求");
		}
		if (t==0){
			SetPwdStrengthEx(v);
		}
		else{
			if (RegCheck.passValue.length==2){
				if (RegCheck.passValue[0]==RegCheck.passValue[1]){
					isok_pass.innerHTML = suc_msg("密码确认,符合要求");
				}else{
					isok_pass.innerHTML = err_msg("重复输入密码不符");
					return false;
				}
				
			}else
			{
				isok_pass.innerHTML = err_msg("重复输入密码不符");
				return false;
			}

		}
		return true;
	},

	Value : function(v,Objid){
		var isok_pass = obj_getbyid("isok_"+Objid);
		if (v==''){
			isok_pass.innerHTML = err_msg("必填内容，不能为空");
			return false;
		}else{
			isok_pass.innerHTML = "";
			obj_getbyid("checkreg").value = "1";
			return true;
		}
	}
}

//错误提示信息
function err_msg(msg){
	obj_getbyid("checkreg").value = "0";
	return "&nbsp;<img src='"+forum_picurl+"/note_error.gif' border='0'/> <span class='redfont'>"+msg+"</span>";
}
//成功提示信息
function suc_msg(msg){
	obj_getbyid("checkreg").value = "1";
	return "&nbsp;<img src='"+forum_picurl+"/note_ok.gif' border='0'/> <span class='bluefont'>"+msg+"</span>";
}
//检查密码强弱
function pse_a1(j,b){
	this.j=j;this.b=b;
};
function pse_a7(c,j){
	var b=false;
	switch(j){
	case 0:
		if((c>='A')&&(c<='Z')){
			b=true;
		};
		break;
	case 1:
		if((c>='a')&&(c<='z')){
		b=true;
		};
		break;
	case 2:
		if((c>='0')&&(c<='9')){
		b=true;
		};
		break;
	case 3:
		if("!@#$%^&*()_+-='\";:[{]}\|.>,</?`~".indexOf(c)>=0){
		b=true;
		};
		break;
	case 4:
		if(pse_a7(c,0)||pse_a7(c,1)){
		b=true;
		};
		break;
	default:break;
	};
	return b;
};

function pse_a8(e,g){
	if((e==null)||isNaN(g)){
		return false;
	}else if(e.length<g){
		return false;
	};
	return true;
};

function pse_a10(e,f){
	var i=0;
	var jj=new Array(new pse_a1(0,false),new pse_a1(1,false),new pse_a1(2,false),new pse_a1(3,false));
	if((e==null)||isNaN(f)){
		return false;
	};
	for(var k=0;k<e.length;k++){
		for(var d=0;d<jj.length;d++){
			if(!jj[d].b&&pse_a7(e.charAt(k),jj[d].j)){
				jj[d].b=true;break;
			};
		};
	};
	for(var d=0;d<jj.length;d++){if(jj[d].b){i++;};};if(i<f){return false;};return true;};function pse_a3(h){return(pse_a8(h,"7")&&pse_a10(h,"3"));};function pse_a2(h){return(pse_a8(h,"7")&&pse_a10(h,"2"));};function pse_a4(h){return(pse_a8(h,"5")||(!pse_a8(h,"0")));};function pse_a6(q){return document.getElementById(q);};

function SetPwdStrengthEx(o){
	if(pse_a3(o)){
		pse_a5(3,'pse04');
	}
	else if(pse_a2(o)){
		pse_a5(2,'pse03');
	}else if(pse_a4(o)){pse_a5(1,'pse02');
	}else{
		pse_a5(0,'pse01');
		};
	};

function pse_a5(m,p){if(m>3){m=3;};for(var n=0;n<4;n++){var l="pse01";if(n<=m){l=p;};if(n>0){pse_a6("idSM"+n).className=l;};pse_a6("idSMT"+n).style.display=((n==m)?"inline":"none");};};
