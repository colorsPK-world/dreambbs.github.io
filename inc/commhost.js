function windows_open() {
	if(document.getElementById("openwindow_login")) {
		var down_open = document.getElementById("openwindow_login");
		var links = down_open.getElementsByTagName("a");
		for(var i=0; i<links.length; i++) {
			if(links[i].rel && links[i].href != "#") {
				links[i].rel = links[i].href;
				links[i].href = "javascript:void(0);";
				links[i].onclick = createopenwindow;
			}
		}
	}
}

//addLoadEvent(downOpen);

function createopenwindow() {
	//alert(!document.getElementById("openwindow_block"));
	if(!document.getElementById("openwindow_block")) {
		var openwindow_block = document.createElement("openwindow_block");
		openwindow_block.id = "openwindow_block";
		var bodys = document.body;
		bodys.appendChild(openwindow_block);
	} else {
		openwindow_block = document.getElementById("openwindow_block");
	}
	openwindow_block.innerHTML="<img src='images/loading.gif' /> 数据正在加载中...";
    //获取登录数据
	openwindow_block.style.top = document.documentElement.scrollTop + 150 + "px"; 
	var url = "login_win.asp";
　  var postStr = url+"?winaction=winlogin";
    var ajax1 = InitAjax();
　  ajax1.open("POST", postStr, true);
    //ajax1.setrequestheader("content-length",postStr.length); 
　  ajax1.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
　  ajax1.send(postStr);
    ajax1.onreadystatechange = function() { 
　　if (ajax1.readyState == 4 && ajax1.status == 200) { 
	var xmlhttpstrmy=ajax1.responseText;
	xmlhttpstrmy=xmlhttpstrmy.replace(/(^\s*)|(\s*$)/g,'');
	if(xmlhttpstrmy=="success"){
		openwindow_block.innerHTML="登录成功,开始跳转!";
	}
	else{
	openwindow_block.innerHTML = ajax1.responseText;
	var closeLink = document.createElement("a");
	closeLink.href = "#";
	closeLink.title = "关闭";
	closeLink.innerText = "关闭"
	closeLink.className = "down_pop_close";
	closeLink.onclick = closeDownBlock;
	openwindow_block.appendChild(closeLink);
	return false;
	}
　　} 
　  }
	
}

function closeDownBlock() {
	var bodys = document.body;
	bodys.removeChild(this.parentNode);
	return false;
}
function InitAjax()
{
　var ajax1=false; 
　try { 
　　ajax1 = new ActiveXObject("Msxml2.XMLHTTP"); 
　} catch (e) { 
　　try { 
　　　ajax1 = new ActiveXObject("Microsoft.XMLHTTP"); 
　　} catch (E) { 
　　　ajax1 = false; 
　　} 
　}
　if (!ajax1 && typeof XMLHttpRequest!='undefined') { 
　　ajax1 = new XMLHttpRequest(); 
　} 
　return ajax1;
}