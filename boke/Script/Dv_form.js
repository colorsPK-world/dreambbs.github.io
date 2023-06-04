/*//////////////////////////////////////////////////////////////////
 * Script For Dvbbs Program -- 表单对象相关
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

var Lang = new Array() ;
var Dvbbs_bIsIE5=document.all;
var Dvbbs_Mode = 3;
var Dvbbs_bTextMode=1;
if (Dvbbs_bIsIE5){
}
else{
	var Dvbbs_bIsNC=true;
}
/*
* 定义提示信息
*/
Lang["Msg"]				= "提示：";
Lang["NEED_TEL_NUM"]	= "请正确填写电话号码！";
Lang["NEED_NUM"]		= "请正确填写数值!";
Lang["NOT_DATE"]		= "请正确填写或选取正确的日期!";
Lang["NO_Checked"]		= "未选择！";
Lang["NOT_MIN"]			= "该项数值不能小于："
Lang["NOT_MAX"]			= "该项数值不能大于："
Lang["NOT_MAXLen"]		= "字符限制不要超过："
Lang["NOT_MINLen"]		= "字符限制不要小于："
Lang["NEED_English"]	= "只能使用英文字母、数字或下划\"_\"填写。"

/*
* 添加字串对象方法
*/
String.prototype.remove=function(start,length){
	var s='';
	if (start>0) s=this.substring(0,start);
	if (start+length<this.length) s+=this.substring(start+length,this.length);
	return s;
};

String.prototype.trim=function(){
	return this.replace(/(^\s*)|(\s*$)/g,'');
};

String.prototype.ltrim=function(){
	return this.replace(/^\s*/g,'');
};

String.prototype.rtrim=function(){
	return this.replace(/\s*$/g,'');
};

String.prototype.replaceNewLineChars=function(replacement){
	return this.replace(/\n/g,replacement);
}

var Dv_Form = new FormObject();
function FormObject(){
	// 修改 textarea 文本区域编辑栏高度
	this.set_Size = function(objname,num){
		if (objname=="[object]"){
			var obj = objname;
		}else{
			var obj = Dvbbs.Objects(objname);
		};
		if (obj)
		{
			if (parseInt(obj.rows)+num>=3) {obj.rows = parseInt(obj.rows) + num;	};
		};
	};

	//SELECT表单选取
	this.Set_Select = function(objname,Value){
		if (objname=="[object]"){
			var obj = objname;
		}else{
			var obj = Dvbbs.Objects(objname);
		};
		if (obj)
		{
			for (var i=0;i<obj.length;i++){
				if (obj.options[i].value==Value){obj.options[i].selected=true;break;};
			};
		};
	};

	//Weather SELECT表单选取
	this.Weather_Select = function(objname,Value,WeatherSrc,PicPath){
		if (objname=="[object]"){
			var obj = objname;
		}else{
			var obj = Dvbbs.Objects(objname);
		};
		var SrcFile = "";
		if (obj)
		{
			for (var i=0;i<obj.length;i++){

				if (obj.options[i].value.split("|")[1]==Value){
					SrcFile = obj.options[i].value.split("|")[0];
					obj.options[i].selected=true;break;
				};
			};
		};
		var ObjSrc = Dvbbs.Objects(WeatherSrc);
		if (ObjSrc)
		{
			ObjSrc.src = PicPath + SrcFile;
		}
	};

	//单选表单选取
	this.Set_Radio = function(objname,Value){
		if (objname=="[object]"){
			var obj = objname;
		}else{
			var obj = Dvbbs.Objects(objname);
		};
		if (obj)
		{
			for (var i=0;i<obj.length;i++){
				if (obj[i].value==Value){obj[i].checked=true;break;};
			};
		};
	};

	/**
	* 文本表单检验
	* <input type="text" onkeyup="javascript:Dv_Form.CheckNumer(this,0,10);" >...
	*/

	//验证表单数值 object 表单对象 | n_min最小值 | n_max 最大值
	this.CheckNumer = function (Object,n_min,n_max)
	{
		var Value = Object.value;
		if (isNaN(Value)){
			alert(Lang["NEED_NUM"]);
			Object.value = 0;
		}
		else{
			Value = parseFloat(Value);
			if (!isNaN(n_min)){
				n_min = parseFloat(n_min);
				if (Value<n_min){alert(getMsg(Lang["NOT_MIN"]+n_min));Object.value = n_min;}
			}
			if (!isNaN(n_max)){
				n_max = parseFloat(n_max);
				if (Value>n_max){alert(getMsg(Lang["NOT_MAX"]+n_max));Object.value = n_max;}
			};
		};
	};

	/**
	*文本输入限制 object 表单对象 | n_max 最大值 	//onkeydown or onkeyup
	* <input type="text" onkeyup="javascript:Dv_Form.CheckLength(this,255);" >...
	*/
	this.CheckLength = function(obj,n_max){
		if (obj){
			Val_Length = obj.value;
			if (!isNaN(n_max)){
				if (Val_Length.length > n_max){
					obj.value = Val_Length.substring(0,n_max);alert(getMsg(Lang["NOT_MAXLen"]+n_max));
				};
			};
		};
	};
	//输出指定文件表单字节数
	this.GetLength = function(_Getobj,Putobj){
		var _Putobj = Dvbbs.Objects(Putobj);
		if (!_Getobj||!_Putobj){alert("test");return false;}
		else{
			var oBjName = _Putobj.nodeName.toLowerCase();
			var TotalLen = _Getobj.value.length;
			if (oBjName=="input"||oBjName=="textarea"){_Putobj.value = TotalLen;}else{_Putobj.innerText = TotalLen;};
		};
	};

	/*
	* 颜色选取器 表单及图片底色可付上默认值
	* img_obj 图标对象 ,input_val 输出到表单名
	* <input type="text" name="setColor" value="#000000"/><img border="0" src="rect.gif" style="cursor:pointer;background-Color:#000000;" onclick="Dv_Form.Getcolor(this,'setColor');" alt="选取颜色!"/>
	*/
	var ColorImg;
	var ColorValue;
	this.Getcolor = function (img_obj,input_val){
		var obj = document.getElementById("Dv_colourPalette");
		if (!obj)
		{
			obj = document.createElement('iframe');
			obj.id = "Dv_colourPalette";
			obj.width = "260px";
			obj.height = "165px";
			obj.src = "selcolor.htm";
			obj.style.visibility = "hidden"
			obj.style.position = "absolute"
			obj.style.border = "1px gray solid"
			obj.frameborder="0";
			obj.scrolling="no";
			document.getElementsByTagName("body")[0].appendChild(obj);
		};
		ColorImg = img_obj;
		ColorValue = Dvbbs.Objects(input_val);
		if (obj){
			obj.style.left = Dvbbs.getOffsetLeft(ColorImg) + "px";
			obj.style.top = (Dvbbs.getOffsetTop(ColorImg) + ColorImg.offsetHeight) + "px";
			if (obj.style.visibility=="hidden"){obj.style.visibility="visible";}
			else {obj.style.visibility="hidden";};
		};
	};

	this.setColor = function(color){
		if (ColorValue){ColorValue.value = color;}
		if (ColorImg){ColorImg.style.backgroundColor = color;}
		document.getElementById("Dv_colourPalette").style.visibility="hidden";
	};

	/**
	*文本字符输入限制 object 表单对象 | n_max 最大值 	//onkeydown or onkeyup
	* <input type="text" onkeyup="javascript:Dv_Form.CheckEnglish(this);" >...
	*/
	this.CheckEnglish = function(obj){
		if (obj){
			if (CheckIfEnglish(obj.value)==false){
				obj.value = "";
				alert(getMsg(Lang["NEED_English"]));
			};
		};
	};

}

/*
* 获取提示信息
* @return String
*/
	function getMsg(pKey) {
			return Lang["Msg"] +"\n\n" + pKey ;
	}

/*
*	获取相应格式的日期
*	pVal为增加的天数，可为+/-，将返还距离当天天数的日期；
*	当 pDiv 为'/'时，返还 '2004/11/01'的格式.
*   getDate(0,"/")
*   @param pVal 距离天数.
*   @param pDiv 分隔符.
*	@return String
*/
	function getDate(pVal, pDiv) {
		var dtnum = Date.parse(new Date());
		dtnum = dtnum + (pVal * (3600000 * 24));
		dt = new Date(dtnum);
		var year = dt.getYear();
		var month = (dt.getMonth() + 1) + '';
		var day = dt.getDate() + '';
		if(month.length == 1)	month = "0" + month;
		if(day.length == 1) 	day = "0" + day;
		rtn = year + pDiv + month + pDiv + day;
		return rtn;
	}


/*
* 检测是否只有英文及数字及"_"
* @param pKey String
* @return boolean
*/
	function CheckIfEnglish(pKey)
	{
		var Letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_";
		 var i;
		 var c;
		 for( i = 0; i < pKey.length; i ++ )
		 {
			  c = pKey.charAt( i );
		  if (Letters.indexOf( c ) < 0)
			 return false;
		 };
		 return true;
	};



/*
* 检测是否含有中文
* @param pKey String
* @return boolean
*/
	function CheckIfChina(pKey){
	 var str=pKey;
	 var lst = /[u00-uFF]/; 
	 if (!lst.test(str))
			 return false;
	  return true;
	};

/*
* Email 检测
* @param str 检测字串
* @return boolean
*/
	function CheckEmail(str)
	{
		var filter=/^.+@.+\..{2,3}$/i;
		//var filter=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z])?)$/i
		if (filter.test(str)) { return true; }
		else { return false; };
	};

/*
*   isNumber('1234')
*   @param pVal  检测字串
*	@return boolean
*/
	function isPhone(pVal)
	{
		if((strTrim(pVal)).length == 0 ) {return false;};
		var str = "0123456789()-,*# ";
		for( i = 0; i < pVal.length; i++){
			if( str.indexOf( pVal.charAt( i ) ) < 0 ){
				alert(getMsg('NEED_TEL_NUM'));
				return false;
				break;
			};
		};
		return true;
	};

/*
*	验证是否身份证号码
*	@param strValue  检测字串
*	@return boolean
*/
	function isCertificateNum(strValue)
	{  
	  if(!(strValue.length==15||strValue.length==18)) return(false);	
		var str = "0123456789Xx";
		for( i = 0; i < strValue.length; i++){
			if( str.indexOf( strValue.charAt( i ) ) < 0 ) return false;    
		return true;
		};
	};

/*
* 查找替换函数
*  str原字串，a要换掉pattern，b换成字串，i是否区分大小写，Msg提示信息
*/
	function Replace(str,a,b,i,Msg){	
		a = a.replace("?","\\?");
		if (i==null){var r = new RegExp(a,"gi");}
		else if (i) {var r = new RegExp(a,"g");}
		else{var r = new RegExp(a,"gi");
		};
		if (r.test(str))
		{
			if (Msg){alert(getMsg(Msg));};
			return str.replace(r,b); 
		}else{return str;};
	};

/*
OchangeSel_Cat ObjName列表表单名，Stype所属分类，Val=CATID的值。
*/
function OchangeSel_Cat(ObjName,Stype,Val){
	var Obj = Dvbbs.Objects(ObjName);
	var k=0;var sel =0;
	if (Obj&&Stype!="")
	{

		if (Obj.length>0)
		{
			for(var i = 10; i >= 0; i--){
				Obj.options.remove(i);
			};
		}
		Stype = parseInt(Stype)
		if (Stype >=0&&BokeCat_ID[Stype].length>0)
		{
			for (var CatID in BokeCat_ID[Stype]){
				if (Val==BokeCat_ID[Stype][CatID])
				{
					sel = k;
				}
				Obj.options[k++] = new Option(BokeCat_Title[Stype][CatID], BokeCat_ID[Stype][CatID]);
			};
			if (sel>0)
			{
				Obj.options[sel].selected = true;
			};
		};
	};
}

/*
编辑器相关功能
*/

function getContent(objname){
	var oEditor = FCKeditorAPI.GetInstance(objname) ;
	alert(oEditor.GetXHTML())

}

function put_ubb(objname,ubbcode,val){
	var oEditor = FCKeditorAPI.GetInstance(objname) ;
	var Ubb_str2= "[/"+ubbcode+"]";
	if (val){
		var Ubb_str1= "["+ubbcode+"="+val+"]";
	}else{
		var Ubb_str1= "["+ubbcode+"]";
	};
	if (oEditor.EditorDocument.selection.type=="Text"){
		var Selval = oEditor.EditorDocument.selection.createRange().text;
		oEditor.InsertHtml(Ubb_str1 + Selval +Ubb_str2);
	}else
	{
		oEditor.InsertHtml(Ubb_str1 + Ubb_str2);
	};
}

function put_html(objname,val){
	var oEditor = FCKeditorAPI.GetInstance(objname) ;
	if (oEditor){
		oEditor.InsertHtml(val);
	};
}

function GetNode(objname,toobj,Maxlen){
	var oEditor = FCKeditorAPI.GetInstance(objname);
	toobj = Dvbbs.Objects(toobj);
	if (oEditor&&toobj){
		if (oEditor.EditorDocument.selection.type=="Text"){
			var Selval = oEditor.EditorDocument.selection.createRange().text;
			if (Selval.length>Maxlen)
			{
				Selval = Selval.substring(0,Maxlen)
			}
			toobj.value = Selval;
		}else
		{
			alert("请选取作为摘要的内容！");
		};
	};
}

function PlayUbb(ObjName,code){
	var txt1 = "";
	var txt2 = "";
	var val1 = "";
	var val2 = "";
	switch (code)
	{
		case 'FLASH':
			txt1 = "Flash宽度，高度";
			val1 = "500,350";
			txt2 = "Flash 文件的地址";
			val2 = "http://"
			break;
		case 'RM':
			txt1 = "视频的宽度，高度，播放参数\r(播放参数：0＝手动播放，1＝自动播放)";
			val1 = "500,350,1";
			txt2 = "视频文件的地址";
			val2 = "http://"
			break;
		case 'MP':
			txt1 = "视频的宽度，高度，播放参数\r(播放参数：0＝手动播放，1＝自动播放)";
			val1 = "500,350,1";
			txt2 = "视频文件的地址";
			val2 = "http://"
			break;
		case 'QT':
			txt1 = "视频的宽度，高度";
			val1 = "500,350";
			txt2 = "视频文件的地址";
			val2 = "http://"
			break;
		default : return;
	};
	var addtxt1 = prompt(txt1,val1);
	if (addtxt1!=null) {
		var addtxt2=prompt(txt2,val2);
		if (addtxt2!=null) {
			if (addtxt1=="") {             
				var AddTxt="<br/>["+code+"=500,350]"+addtxt2+"[/"+code+"]<br/>";
				put_html(ObjName,AddTxt);
			} else {
				AddTxt="<br/>["+code+"="+addtxt1+"]"+addtxt2+"[/"+code+"]<br/>";
				put_html(ObjName,AddTxt);
			}
	    };
    };
}

function CheckPostForm(Obj){
	if (Obj.sCatID)
	{
		if (Obj.sCatID.value=="-1"||Obj.sCatID.value=="")
		{
			alert("请选取发表的话题！");
			return false;
		};
	};
	if (Obj.Catid)
	{
		if (Obj.Catid.value=="-1"||Obj.Catid.value=="")
		{
			alert("请选取相应的栏目或建立好栏目后再进行发表！");
			return false;
		};
	};
}

function Dvbbs_foralipay(obj)
{
	var arr = showModalDialog("boke/images/alipay/alipay.htm", window, "dialogWidth:20em; dialogHeight:34em; status:0; help:0");
	if (arr)
	{
		put_html(obj,arr);
		//IframeID.document.body.innerHTML+=arr;
	}
	//IframeID.focus();
}