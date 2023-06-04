function ajaCreateData(_form){
	var data="";
	if(_form){
		for(var i=0;i<_form.elements.length;i++){
			if(data==""){
				data=_form.elements[i].name+"="+escape(_form.elements[i].value);
			}else{
				data+="&"+_form.elements[i].name+"="+escape(_form.elements[i].value);
			}
		}
	}
	return data;
}

function ajaxSubmit(actionAddress,data){
	var xmlhttp;
	try{
		xmlhttp=new XMLHttpRequest();
	}catch(e){
		try{
			xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		}catch(e){
			try{
				xmlhttp=new ActiveXObject('Msxml2.XMLHTTP');
			}catch(e){
				alert('你使用的浏览器不支持ajax提交数据，请使用IE6.0或Mozilla Firefox 2.0以上浏览器浏览。');
			}
		}
	}
	xmlhttp.onreadystatechange=function(){
		if (4==xmlhttp.readyState){
			if (200==xmlhttp.status){
				eval(xmlhttp.responseText.substring(0));
				if (''==returnInfo.formName){
					alert(returnInfo.formValue);
				}else{
					document.getElementById(returnInfo.formName).style.display = 'block';
					document.getElementById(returnInfo.formName).innerHTML = returnInfo.formValue;
				}
			}else{
				alert(xmlhttp.status+'投票失败，网络中断或服务器忙，请稍后重试。')
				//这里可以告诉客户端，提交失败，请重试(状态号xmlhttp.status)
			}
		}
	}
	xmlhttp.open("POST", actionAddress, true);
	//xmlhttp.setRequestHeader("Method", "POST " + actionAddress + " HTTP/1.1");
	xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
	xmlhttp.send(data);
	return false;
}