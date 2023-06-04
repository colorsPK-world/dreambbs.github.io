function astro(birth)
{
	if (birth!='')
	{	var tmpstr;
		var bstr;
		var mm;
		var yy;
		var dd;
		var birthmonth;
		tmpstr=birth.split(' ');
		bstr=tmpstr[0];
		tmpstr=bstr.split('-');
		yy=(tmpstr[0]*1);
		mm=parseInt(tmpstr[1]*1);
		dd=parseInt(tmpstr[2]*1);
		
		switch(mm){
		case 1 :
		if(dd>=21){return('<img src=Skins/Default/birth/z11.gif alt=Ë®Æ¿×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z10.gif alt=Ä§ôÉ×ù'+mm+'-'+dd+'>');}
		break;
		case 2 :
		if(dd>=20){return('<img src=Skins/Default/birth/z12.gif alt=Ë«Óã×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z11.gif alt=Ë®Æ¿×ù'+mm+'-'+dd+'>');}
		break;
		case 3 :
		if(dd>=21){return('<img src=Skins/Default/birth/z1.gif alt=°×Ñò×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z12.gif alt=Ë«Óã×ù'+mm+'-'+dd+'>');}
		break;
		case 4 :
		if(dd>=21){return('<img src=Skins/Default/birth/z2.gif alt=½ğÅ£×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z1.gif alt=°×Ñò×ù'+mm+'-'+dd+'>');}
		break;
		case 5 :
		if(dd>=22){return('<img src=Skins/Default/birth/z3.gif alt=Ë«×Ó×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z2.gif alt=½ğÅ£×ù'+mm+'-'+dd+'>');}
		break;
		case 6 :
		if(dd>=22){return('<img src=Skins/Default/birth/z4.gif alt=¾ŞĞ·×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z3.gif alt=Ë«×Ó×ù'+mm+'-'+dd+'>');}
		break;
		case 7 :
		if(dd>=23){return('<img src=Skins/Default/birth/z5.gif alt=Ê¨×Ó×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z4.gif alt=¾ŞĞ·×ù'+mm+'-'+dd+'>');}
		break;
		case 8 :
		if(dd>=24){return('<img src=Skins/Default/birth/z6.gif alt=´¦Å®×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z5.gif alt=Ê¨×Ó×ù'+mm+'-'+dd+'>');}
		break;
		case 9 :
		if(dd>=24){return('<img src=Skins/Default/birth/z7.gif alt=Ìì³Ó×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z6.gif alt=´¦Å®×ù'+mm+'-'+dd+'>');}
		break;
		case 10 :
		if(dd>=24){return('<img src=Skins/Default/birth/z8.gif alt=ÌìĞ«×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z7.gif alt=Ìì³Ó×ù'+mm+'-'+dd+'>');}
		break;
		case 11 :
		if(dd>=23){return('<img src=Skins/Default/birth/z9.gif alt=ÉäÊÖ×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z8.gif alt=ÌìĞ«×ù'+mm+'-'+dd+'>');}
		break;
		case 12 :
		if(dd>=22){return('<img src=Skins/Default/birth/z10.gif alt=Ä§ôÉ×ù'+mm+'-'+dd+'>');}
		else{return('<img src=Skins/Default/birth/z9.gif alt=ÉäÊÖ×ù'+mm+'-'+dd+'>');}
		break;
		default : return('');
}
	}else{return('');}
}
function MM_showHideLayers() { //v6.0

  var i,p,v,obj,args=MM_showHideLayers.arguments;
  obj=document.getElementById("MagicFace");
  for (i=0; i<(args.length-2); i+=3) if (obj) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
    obj.visibility=v; }
}

function DispMagicEmot(MagicID,H,W){
	MagicFaceUrl = "Dv_plus/tools/magicface/swf/" + MagicID + ".swf";
	document.getElementById("MagicFace").innerHTML = '<object codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="' + W + '" height="' + H + '"><PARAM NAME=movie VALUE="'+ MagicFaceUrl +'"><param name=menu value=false><PARAM NAME=quality VALUE=high><PARAM NAME=play VALUE=false><param name="wmode" value="transparent"><embed src="' + MagicFaceUrl +'" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="' + W + '" height="' + H + '"></embed>';
	document.getElementById("MagicFace").style.top = '250px';
	document.getElementById("MagicFace").style.left = '250px';
	document.getElementById("MagicFace").style.visibility = 'visible';
	MagicID += Math.random();
	setTimeout("MM_showHideLayers('MagicFace','','hidden')",5000);
	NowMeID = MagicID;
}
function LoadMagicEmot(MagicID,topicid){
var cookiesstr=readCookie('mofaface_'+ topicid);
if (cookiesstr ==null){
createCookie('mofaface_'+ topicid,MagicID,365)
DispMagicEmot(MagicID,350,500)
}
}
function fixheight(objname){
var obj=document.getElementById(objname);
	if (obj){
	if (obj.offsetHeight>300){
	obj.style.overflow='hidden';
	obj.style.height='300px';
	}
}
}