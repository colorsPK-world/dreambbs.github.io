//浮动广告
var brOK=false;
var mie=false;
var vmin=2;
var vmax=5;
var vr=3;
var timer1;
var jobads;

function movechip(chipname)
{
	var obj = document.getElementById(chipname);
		eval("chip="+chipname);
		if(!mie)
		{
			pageX=window.pageXOffset;
			pageW=window.innerWidth;
			pageY=window.pageYOffset;
			pageH=window.innerHeight;
		} 
		else
		{
			pageX=parseInt(window.document.body.scrollLeft?window.document.body.scrollLeft:window.document.documentElement.scrollLeft);
			pageY=parseInt(window.document.body.scrollTop?window.document.body.scrollTop:window.document.documentElement.scrollTop);
			pageW=parseInt(window.document.body.offsetWidth-8);
			pageH=parseInt(window.document.body.offsetHeight);			
		}
		
		//window.status="y:"+pageW+";x:"+pageX;
		chip.xx=chip.xx+chip.vx;
		chip.yy=chip.yy+chip.vy;
		chip.vx+=vr*(Math.random()-0.5);
		chip.vy+=vr*(Math.random()-0.5);
		if(chip.vx>(vmax+vmin))  chip.vx=(vmax+vmin)*2-chip.vx;
		if(chip.vx<(-vmax-vmin)) chip.vx=(-vmax-vmin)*2-chip.vx;
		if(chip.vy>(vmax+vmin))  chip.vy=(vmax+vmin)*2-chip.vy;
		if(chip.vy<(-vmax-vmin)) chip.vy=(-vmax-vmin)*2-chip.vy;
		if(chip.xx<=pageX)
		{
			chip.xx=pageX;
			chip.vx=vmin+vmax*Math.random();
		}
		if(chip.xx>=pageW-chip.w)
		{
			chip.xx=pageW-chip.w;
			chip.vx=-vmin-vmax*Math.random();
		}
		//if(chip.xx>=680)
		//{
		//	chip.xx=chip.xx-20;
		//	chip.vx=-vmin-vmax*Math.random();
		//}
		if(chip.yy<=pageY)
		{
			chip.yy=pageY;
			chip.vy=vmin+vmax*Math.random();
		}
		if(chip.yy>=pageH-chip.h)
		{
			chip.yy=pageH-chip.h;
			chip.vy=-vmin-vmax*Math.random();
		}
		
		obj.style.top = chip.yy+'px';
		obj.style.left = chip.xx+'px';
		chip.timer1=setTimeout("movechip('"+chip.named+"')",80);

}

function stopme(chipname)
{
	//if(brOK)
	//{
		eval("chip="+chipname);
		if(chip.timer1!=null)
		{
			clearTimeout(chip.timer1)
		}
	//}
}

function jobads()
{
	if(navigator.appName.indexOf("Internet Explorer")!=-1||navigator.userAgent.indexOf("Firefox") >= 0)
	{
		//if(parseInt(navigator.appVersion.substring(0,1))>=4) brOK=navigator.javaEnabled();
		mie=true;
	}
	if(navigator.appName.indexOf("Netscape")!=-1)
	{
		if(parseInt(navigator.appVersion.substring(0,1))>=4) brOK=navigator.javaEnabled();
	}
	jobads.named="jobads";
	jobads.vx=vmin+vmax*Math.random();
	jobads.vy=vmin+vmax*Math.random();
	jobads.w=1;
	jobads.h=1;
	jobads.xx=0;
	jobads.yy=0;
	jobads.timer1=null;
	movechip("jobads");
}


function move_ad(Forum_ads_3,Forum_ads_4,Forum_ads_5,Forum_ads_6)
{
	document.write('<div id="jobads" style="height:49px;left:178px;position:absolute;top:1237px;width:70px; z-index:1000">');
	document.write('<a href="' + Forum_ads_4 + '" target="_blank" onmouseover=stopme("jobads"); onmouseout=movechip("jobads");>');
	document.write('<img src="' + Forum_ads_3 + '" border="0" width="' + Forum_ads_5 + '" height="' + Forum_ads_6 + '"></a></div>');
	jobads();
}

//右边固定广告
function StayCorner(){
	var DivObj = document.getElementById("Corner");
	if (DivObj){
	_divTop = parseInt(DivObj.style.top,10)
	_divLeft = parseInt(DivObj.style.left,10)
	_divHeight = parseInt(DivObj.offsetHeight,10)
	_divWidth = parseInt(DivObj.offsetWidth,10)
	if (navigator.userAgent.indexOf("Firefox") >= 0 || navigator.userAgent.indexOf("Opera") >= 0) {
		var _docWidth = parseInt((document.body.clientWidth > document.documentElement.clientWidth)?document.body.clientWidth:document.documentElement.clientWidth);//document.body.clientWidth;
		var _docHeight = parseInt((document.body.clientHeight > document.documentElement.clientHeight)?document.documentElement.clientHeight:document.body.clientHeight);
	}else{
		var _docWidth = parseInt((document.documentElement.clientWidth == 0)?document.body.clientWidth:document.documentElement.clientWidth);
		var _docHeight = parseInt((document.documentElement.clientHeight == 0)?document.body.clientHeight:document.documentElement.clientHeight);
	}

	DivObj.style.top = parseInt((document.body.scrollTop?document.body.scrollTop:document.documentElement.scrollTop),10) + _docHeight - _divHeight-20 +"px";;
	DivObj.style.left = _docWidth - _divWidth-20 +"px";
	}
//window.status="y:"+DivObj.style.top+";x:"+DivObj.style.left;
setTimeout('StayCorner()', 50)
}

function fix_up_ad(sgImg,sgWidth,sgHeight,sgLink){
var sgDump=null;
document.write('<DIV ID="Corner" STYLE="position:absolute; width:'+sgWidth+'; height:'+sgHeight+'; z-index:9; filter: Alpha(Opacity=70)"><A href="'+sgLink+'" target=_blank><IMG src="'+sgImg+'" BORDER=0 WIDTH="'+sgWidth+'" HEIGHT="'+sgHeight+'"></A></DIV>');

sgDump = StayCorner()
}