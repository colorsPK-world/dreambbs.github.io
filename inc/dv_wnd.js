/*
 模拟windows模态对话框。
 Author: HxyMan
 Thanks: Laomi,Fssunwin
 Update: 2008-1-20
*/
var DvWnd={
	$:function(d){return document.getElementById(d)},
	move:0,
	eventStartX:0,
	eventStartY:0,
	wndStartX:0,
	wndStartY:0,
	d:{a:'dvwnd',b:'dvwndtitle',c:'dvwndchild',d:'dvwndstatus',e:'dvwndiframe',g:'dvwndcanvas',w:'DvWnd'},
	e:null,
	x:function(){return DvWnd.e.clientX;},
	y:function(){return DvWnd.e.clientY;},
	drag_start:function(e){
		DvWnd.e=e;
		DvWnd.move=1;
		DvWnd.eventStartX=DvWnd.x();
		DvWnd.eventStartY=DvWnd.y();
		DvWnd.wndStartX=DvWnd.$(DvWnd.d.a).offsetLeft;
		DvWnd.wndStartY=DvWnd.$(DvWnd.d.a).offsetTop;
	},
	drag_stop:function(e){
		DvWnd.e=e;
		DvWnd.move=0;
	},
	drag:function(e){
		DvWnd.e=e;
		if(DvWnd.move){
			DvWnd.$(this.d.a).style.left=DvWnd.wndStartX+(DvWnd.x()-DvWnd.eventStartX)+'px';
			DvWnd.$(this.d.a).style.top=DvWnd.wndStartY+(DvWnd.y()-DvWnd.eventStartY)+'px';
			try{document.selection.empty();}catch(er){}
		}
	},
	close:function(){
		DvWnd.$(DvWnd.d.a).style.display='none';DvWnd.$(DvWnd.d.g).style.display='none';
		var a=document.body;a.removeChild(DvWnd.$(DvWnd.d.a));//a.removeChild(DvWnd.$(DvWnd.d.g));
	},
	onfocus:function(){
		DvWnd.flash(2);
	},
	flash:function(n){
		DvWnd.$(DvWnd.d.b).className='dvwndfocus';
		setTimeout(function(){DvWnd.$(DvWnd.d.b).className='dvwndtitle';},50);
		if(n>1){setTimeout(function(){DvWnd.flash(n-1);},100);}
	},
	open:function(){
		var de=document.documentElement;
		var w=window.innerWidth || self.innerWidth || (de&&de.clientWidth) || document.body.clientWidth;
		var ch=window.innerHeight || self.innerHeight || (de&&de.clientHeight) || document.body.clientHeight;
		if (self.pageYOffset) {
			var st=self.pageYOffset;
		} else if (de&&de.scrollTop){	 // Explorer 6 Strict
			var st=de.scrollTop;
		} else if (document.body) {// all other Explorers
			var st=document.body.scrollTop;
		}
		if (window.innerHeight && window.scrollMaxY) {	
			var sh=window.innerHeight + window.scrollMaxY;
		} else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
			var sh=document.body.scrollHeight;
		} else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
			var sh=document.body.offsetHeight;
		}
		var a=arguments;
		DvWnd.title=a[0]||'信息窗口';
		DvWnd.para=a[1];//网址或者要显示的内容
		DvWnd.width=a[2]||300;
		DvWnd.height=a[3]||200;
		DvWnd.type=null==a[4]?1:a[4];//1-框架,2-直接显示内容
		DvWnd.canvas=a[5]||{bgc:'#fff',opa:0.1};
		DvWnd.left=a[6]||(w-DvWnd.width)/2+'px';
		DvWnd.top=a[7]||(ch-(DvWnd.height||200))/2+st+'px';
		var dc=document,s='';
		var o=dc.createElement("div");
		o.id=DvWnd.d.a;
		o.className='dvwnd';
		o.style.width=DvWnd.width+'px';
		o.style.height=DvWnd.height+'px';
		o.style.left=DvWnd.left;
		o.style.top=DvWnd.top;
		s+='<div id="'+DvWnd.d.b+'" class="dvwndtitle" onmousedown="'+DvWnd.d.w+'.drag_start(event)" onmouseup="'+DvWnd.d.w+'.drag_stop(event)" onmousemove="'+DvWnd.d.w+'.drag(event)">';
		s+='<span style="float:right"><a href="javascript:'+DvWnd.d.w+'.close();" class="dvwndclose">×</a></span>'+DvWnd.title;
		s+='</div>';
		s+='<div id="'+DvWnd.d.c+'" class="dvwndchild">';
		s+=1==DvWnd.type?('<iframe id="'+DvWnd.d.e+'" name="'+DvWnd.d.e+'" src="about:blank"  style="width:100%;height:'+(DvWnd.height-40)+'px;" frameborder="0" hspace="0"></iframe>'):('<div style="padding:10px;">'+DvWnd.para+'</div>');
		s+='</div>';
		o.innerHTML=s;
		dc.body.appendChild(o);
		var f=0;
		o=DvWnd.$(DvWnd.d.g);
		if(!o){f=1;o=dc.createElement("div");}
		o.id=DvWnd.d.g;
		o.className='dvwndcanvas';
		o.style.height=(sh>ch?sh:ch)+'px';
		o.style.width=w+'px';
		s=DvWnd.canvas;
		o.style.backgroundColor=s.bgc;
		o.style.filter='alpha(opacity='+(s.opa*100)+')';
		o.style.display='block';
		if(f){o.onclick=function(){DvWnd.onfocus()};dc.body.appendChild(o)};
		if(1==DvWnd.type){DvWnd.$(DvWnd.d.e).src=DvWnd.para;}
	}
}