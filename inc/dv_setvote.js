document.charset = "gb2312";
if (window.Event){ //  修正Event的DOM
    Event.prototype.__defineSetter__( " returnValue " , function (b){ //   
         if ( ! b) this .preventDefault();
         return  b;
        });
}

if (window.Node){
	Node.prototype.replaceNode = function (Node){ //  替换指定节点 
         this .parentNode.replaceChild(Node, this );
        }
    Node.prototype.removeNode = function (removeChildren){ //  删除指定节点 
         if (removeChildren)
             return   this .parentNode.removeChild( this );
         else {
             var  range = document.createRange();
            range.selectNodeContents( this );
             return   this .parentNode.replaceChild(range.extractContents(), this );
            }
        }
}

var getNameList = function(strName){return document.getElementsByName(strName);}

//投票设置事件
//opmax 限制数
var voten = 0;
function votetypeset(opobj,opmax){
	//vote_set
	//hidden Textea ID:vote
	var s = opobj.options[opobj.selectedIndex];
	var div_voteset = document.getElementById("voteset_div");
	if (!div_voteset){return ;}
	document.getElementById("voteset_legend").innerHTML = s.text;
	//voteset_function
	var voteset_add = document.getElementById("voteset_add");
	//添加投票项表单
	voteset_add.innerHTML = voteset_input(s.value,opmax);
	document.getElementById("votetitles").innerHTML = "";
	voteset_todata("vote","set_vote",s.value);
}

function voteset_input(s,opmax){

	var _inputHmtl = '<input type="text" name="set_votetitle" id="set_votetitle" value="" size="80"/>';
	_inputHmtl +=' <input type="button" name="put_vset" value="添加" onclick="voteadd_input('+s+',\'set_votetitle\','+opmax+');"/>';
	//_inputHmtl +=' <br/><ol id="votetitles"></ol>';
	return ("添加项目：" + _inputHmtl);
}

function voteadd_input(s,objid,opmax){
	var titleobj = document.getElementById(objid);
	var voteset_function = document.getElementById("votetitles");
	if (!titleobj){return ;}
	if (titleobj.value==''){alert("请填写相应的内容 ！");return ;}
	if (document.getElementsByName("set_vote")){
	if (document.getElementsByName("set_vote").length>=parseInt(opmax)){
		alert("投票数目超出限制！");
		return ;
	}
	}
	voten = voten + 1;
	var child_Html = "";
	child_Html = '<li id="set_vote_'+voten+'">投票项目：<input type="text" name="set_vote" id="set_vote" value="'+titleobj.value+'" onBlur="voteset_todata(\'vote\',\'set_vote\','+s+');" size="80"/>  <input type="button" name="del_vset" value="删除" onclick="votedel_input(\'set_vote_'+voten+'\','+s+');"/>';
	//问卷调查增加填写表单
	if (s=='2'){
		child_Html += ' <br/>子项数：<input maxlength="2" onkeyup="votechild_input('+voten+','+s+');" name="vote_childs_'+voten+'" id="vote_childs_'+voten+'" type="text" value="4" size="1"/>';
		child_Html += ' 类型：<select id="vote_childtype_'+voten+'" name="vote_childtype_'+voten+'" onchange="votechild_input('+voten+','+s+');"><option value="0">单选</option><option value="1">多选</option><option value="2">文本</option></select>';
		child_Html += '  <input type="hidden" name="voten" id="voten" value="'+voten+'"/><input type="button" name="add_vsetchild" value="添加子项" onclick="votechild_input('+voten+','+s+');"/>';
		child_Html += ' <ol type="A" id="vchild_ol_'+voten+'"></ol>'
	}
	child_Html += '</li>';
	voteset_function.innerHTML += child_Html;
	voteset_todata("vote","set_vote",s);
}

function votechild_input(objid,s){
	var child_ol = document.getElementById("vchild_ol_"+objid);
	var child_Html = "";
	var AddChilds = document.getElementById("vote_childs_"+objid);
	var ChildsType = document.getElementById("vote_childtype_"+objid);
	if (isNaN(AddChilds.value)){
		AddChilds.value = 4;
	}
	if (ChildsType.options[ChildsType.selectedIndex].value=='2'){AddChilds.value=1;}
	AddChilds.value = parseInt(AddChilds.value);
	var AddLength = parseInt(AddChilds.value);
	
	if (child_ol){
		for(var i=1; i<=AddLength; i++) {
			child_Html +='<li id="vchild_li_'+objid+'">';
			if (ChildsType.options[ChildsType.selectedIndex].value=='2'){
				child_Html +='答案：<textarea id="vchild_input_'+objid+'" name="vchild_input_'+objid+'" onBlur="if (this.value==\'\'){this.value=\'null\';};voteset_todata(\'vote\',\'set_vote\','+s+');" style="width:460px;height:50px;">null</textarea>';
			
			}else
			{
				switch (ChildsType.options[ChildsType.selectedIndex].value){
					case '0':
						child_Html +='<input type="radio" name="" class="radio"/>';
						break;
					case '1':
						child_Html +='<input type="checkbox" name="" class="chkbox"/>';
						break;
				}
				child_Html +='<input type="text" id="vchild_input_'+objid+'" name="vchild_input_'+objid+'" onblur="voteset_todata(\'vote\',\'set_vote\','+s+');" size="80"/> 得分：<input type="text" name="vchild_ep_'+objid+'" id="vchild_ep_'+objid+'" value="0" onBlur="voteset_todata(\'vote\',\'set_vote\','+s+');" size="3"/>';
			}
			child_Html +='</li>';
		}
		child_ol.innerHTML=child_Html;
	
	}
	voteset_todata("vote","set_vote",s);
}

function voteset_todata(objid,valobjid,s){
	var votedb_Obj = document.getElementById(objid);	//隐藏表单
	//var voteval_Obj = document.getElementsByName(valobjid);
	//var voten = document.getElementsByName("voten");
	var voteval_Obj = getNameList(valobjid);
	var voten = getNameList("voten");
	votedb_Obj.value = "";
		for(var i=0; i<voteval_Obj.length; i++) {
			voteval_Obj[i].value = voteval_Obj[i].value.replace(/@@|\$\$|\|/g,'');
			if(voteval_Obj[i].value!='') {
				votedb_Obj.value += voteval_Obj[i].value.replace(/\r/g,'');
				if (s=='2'){
					if (voten[i]){
						votedb_Obj.value += "@@";
						var ChildsType = document.getElementById("vote_childtype_"+voten[i].value);
						//var ChildsValue = document.getElementsByName("vchild_input_"+voten[i].value);
						//var ChildsEP = document.getElementsByName("vchild_ep_"+voten[i].value);
						var ChildsValue =  getNameList("vchild_input_"+voten[i].value);
						var ChildsEP =  getNameList("vchild_ep_"+voten[i].value);

						votedb_Obj.value += ChildsType.options[ChildsType.selectedIndex].value;
						votedb_Obj.value += "@@";
						for(var j=0; j<ChildsValue.length; j++) {
							ChildsValue[j].value = ChildsValue[j].value.replace(/@@|\$\$|\|/g,'');
							if (ChildsValue[j].value!=''){
								votedb_Obj.value += ChildsValue[j].value.replace(/\r|\n/g,'<br/>');
								votedb_Obj.value += "$$";
							}
						}
						votedb_Obj.value += "@@";
						if (ChildsEP.length>0){
						for(var j=0; j<ChildsValue.length; j++) {
							ChildsValue[j].value = ChildsValue[j].value.replace(/@@|\$\$|\|/g,'');
							if (ChildsValue[j].value!=''){
								if (isNaN(ChildsEP[j].value)){
									ChildsEP[j].value = 0;
								}
								ChildsEP[j].value = parseInt(ChildsEP[j].value);
								votedb_Obj.value += ChildsEP[j].value.replace(/@@|\$\$|\||\r/g,'');
								votedb_Obj.value += "$$";
							}
						}
						}

					}
				}
				votedb_Obj.value += '\r';
			}
		}
}

function votedel_input(objid,s){
	var del_Obj = document.getElementById(objid);	//删除表单
	if (del_Obj){
		del_Obj.removeNode(true);
		voteset_todata("vote","set_vote",s);
	}
}
//保存数据到临时复制板
function SaveDBtoText(objid){
	var voteset_function = document.getElementById("voteset_function");
	if (voteset_function){
		//event.returnValue = false;
		if (setClipboard(voteset_function.innerHTML)){
		var sobj = document.getElementById("votetype");
		var s = sobj.options[sobj.selectedIndex];
			alert("当前投票内容保存成功，还原时选确认投票类型为："+s.text+"！")
		}else{
			alert("系统不支持您的浏览器进行复制保存！")
		}
	}
}

function PutDBFromText(objid){
	var voteset_function = document.getElementById("voteset_function");
	if (voteset_function){
		//event.returnValue = false;   
		var SaveDB = window.clipboardData.getData("Text");
		if (SaveDB!="SaveDB"){
		voteset_function.innerHTML = SaveDB;
		var sobj = document.getElementById("votetype");
		var s = sobj.options[sobj.selectedIndex].value;
		voteset_todata("vote","set_vote",s);
		}
	}
}

//将字符串maintext复制到剪贴板 
function setClipboard(maintext) { 
   if (window.clipboardData) {
		window.clipboardData.setData("Text", maintext)
      return true; 
   } 
   else if (window.netscape) { 
      netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect'); 
      var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard); 
      if (!clip) return false; 
      var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable); 
      if (!trans) return false; 
      trans.addDataFlavor('text/unicode'); 
      var str = new Object(); 
      var len = new Object(); 
      var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString); 
      var copytext=maintext; 
      str.data=copytext; 
      trans.setTransferData("text/unicode",str,copytext.length*2); 
      var clipid=Components.interfaces.nsIClipboard; 
      if (!clip) return false; 
      clip.setData(trans,null,clipid.kGlobalClipboard); 
      return true; 
   } 
   return false; 
} 

//返回剪贴板的内容 
function getClipboard() { 
   if (window.clipboardData) { 
      return(window.clipboardData.getData('Text')); 
   } 
   else if (window.netscape) { 
      netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect'); 
      var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard); 
      if (!clip) return; 
      var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable); 
      if (!trans) return; 
      trans.addDataFlavor('text/unicode'); 
      clip.getData(trans,clip.kGlobalClipboard); 
      var str = new Object(); 
      var len = new Object(); 
      try { 
         trans.getTransferData('text/unicode',str,len); 
      } 
      catch(error) { 
         return null; 
      } 
      if (str) { 
         if (Components.interfaces.nsISupportsWString) str=str.value.QueryInterface(Components.interfaces.nsISupportsWString); 
         else if (Components.interfaces.nsISupportsString) str=str.value.QueryInterface(Components.interfaces.nsISupportsString); 
         else str = null; 
      } 
      if (str) { 
         return(str.data.substring(0,len.value / 2)); 
      } 
   } 
   return null; 
} 
