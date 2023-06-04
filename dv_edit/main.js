/*
Dvbbs.HtmlEdit
Author: HxyMan
Thanks: Laomi,Fssunwin,Liancao
Update: 2008-1-10
*/
function DvEdit(){
	this_=this;
	this.$=function(o,d){return (d||document).getElementById(o)};
	this.$f=function(f){return this.$(f)?((this.$(f)).contentWindow||window.frames[f]):null};
	this.$t=function(t,d){return (d||document).getElementsByTagName(t)};
	this.ae=function(o,t,h){if (o.addEventListener){o.addEventListener(t,h,false);}else if(o.attachEvent){o.attachEvent('on'+t,h);}else{try{o['on'+t]=h;}catch(e){;}}};
	this.de=function(o,t,h){if (o.removeEventListener){o.removeEventListener(t,h,false);}else if(o.detachEvent){o.detachEvent('on'+t,h);}else{try{o['on'+t]=null;}catch(e){;}}};
	this.setC=function(n, v){var c=n+"="+encodeURIComponent(v);document.cookie=c;};
	this.readC=function(n){var re=eval("/(?:;)?"+n+"=([^;]*);?/g");return re.test(document.cookie)?decodeURIComponent(RegExp.$1):null;};
	this.getPath=function(){var a=this.$t('script');for (var i=a.length-1;i>=0;--i){if (-1!=a[i].src.toLowerCase().indexOf('dv_edit/main.js'))return a[i].src.replace('main.js','');}};
	var a=navigator.userAgent;
	this.isIE=a.search('MSIE')>0;
	this.isIE8=a.search('MSIE 8.0')>0;
	this.isFF=a.indexOf('Gecko')!=-1&&!(a.indexOf('KHTML')>-1||a.indexOf('Konqueror')>-1||a.indexOf('AppleWebKit')>-1);
	this.isFF=this.isFF;
	this.loadJs=function(p){
		var a=this.$t('script');
		if(a){for (var i=a.length-1;i>=0;--i){
			if (-1!=a[i].src.indexOf(p)) 
				return;
			}
		};
		var o=document.createElement('script');
		o.language='javascript';
		o.src=p;
		if (this.isFF||this.isIE8){
			a=this.$t('head')[0];
			if(a){a.appendChild(o);}
		}else{
			o.onload=o.onreadystatechange=function(){if(o.readyState&&o.readyState=="loading")return;a=this_.$t('head')[0];if(a){a.appendChild(o);}}
		}
	};
	this.insert=function(s){if('design'==this.m){this.t.insert(s)}else{this.$(this.c).value+=s;}};
	this.clear=function(){this.$(this.c).value=' ';if('design'==this.m){this.syc('t->d');}};
	this.loadCss=function(p,re){var a=this.$t('link'),o=null;if (a){for (var i=a.length-1;i>=0;--i){if (-1!=a[i].href.indexOf('dv_edit')){if (re){o=a[i];}else{return;}}}};if (!o){o=document.createElement('link');o.rel='stylesheet';o.type='text/css';};o.href=p;try{this.$t('head')[0].appendChild(o);}catch(e){;}};
	this.fcs=function(o){try{setTimeout(function(){o.focus();},0);}catch(e){;}};
	a=arguments[0];if(!a){return;}
	this.c=a['textarea_id']||'content';//textarea的id
	this.h=a['edit_height']||'300px';//编辑框的高度
	this.m=(this.isIE||this.isFF)?(a['edit_mode']||'design'):'text';//编辑模式
	this.l=a['toolbar']||['bold','italic','underline','fontsize','fontfamily','fontcolor','fontbgcolor','separator','emot','link','image','media','separator','justifyleft','justifycenter','justifyright','separator','insertorderedlist','insertunorderedlist','outdent','indent','separator','tenpay'];
	this.u=(this.isIE||this.isFF)?(null==a['is_show_status']?true:a['is_show_status']):false;//是否显示状态栏
	this.v=null==a['is_open_temp_save']?false:a['is_open_temp_save'];//是否开启cookies保存内容
	this.em=a['emot'];//表情系列
	this.e=null==a['quick_send']?1:a['quick_send'];//0-不捕获快捷键发贴 1-ctrl+enter发贴 2-enter发贴
	this.s=a['style_folder']||'default';//风格
	this.um=null==a['use_ubb']?0:a['use_ubb'];//限制只能使用ubb
	this.tox=null==a['to_xhml']?1:a['to_xhml'];//是否强制转换到xhtml格式
	this.lm=null;//上一次的编辑模式
	this.p=this.getPath();
	a=window;a.dv___=a.dv___||new Array();a.dv___.push(this);
	this.i=a.dv___.length-1;
	var b='dvedit_'+this.i+'_';
	this.x={t:b+'_toolbar',w:b+'_miniwnd',f:b+'_htmlarea',c:b+'_canvas',d:b+'_div',s:b+'_status',g:b+'_design'};
	this.d='window.dv___['+this.i+']';
	this.f=null;
	this.t=null;
	this.bld=0;
	this.loadToolBar=function(){if('function'==typeof DvEditToolBar){this.bld=1;this.upDes();}else{setTimeout(this.d+'.loadToolBar()',0);}};
	this.setEditable=function(){
		if (!this.$(this.x.f)){return setTimeout(this.d+'.setEditable()',0);}
		var d=null,db=null,s='';
		try{
			this.f=this.$f(this.x.f);
			d=this.isIE?this.f.document.body:this.f.document;
			this.$(this.x.g).style.display='';
			s=d.designMode;
		}catch(e){return setTimeout(this.d+'.setEditable()',0);}
		if(!(s&&'on'==s.toLowerCase()&&d.contentEditable)){try{d.designMode='on';d.contentEditable=true;}catch(e){};return setTimeout(this.d+'.setEditable()',0);}
		try
		{			
			var sl = [{a:"body",b:"{background-color:#fff;font-size:14px;font-family:verdana;margin:5px;}"}, 
				{a:"p",b:"{font-family:Verdana, Arial, Helvetica, sans-serif;  font-size:14px; margin:0px;padding:0px;}"},
				{a:"div.quote",b:"{margin :5px; border : 1px solid #cccccc; padding : 5px;background : #f9f9f9; line-height : normal;}"},
				{a:"div.htmlcode",b:"{margin : 5px 20px; border : 1px solid #cccccc;padding : 5px;background : #fdfddf;font-size : 14px;font-family : tahoma, 宋体, fantasy;font-style : oblique;line-height : normal;}"}];
			d=this.f.document;
			if (d.createStyleSheet)
			{
				var css = d.createStyleSheet();
				for (var i=0;i<sl.length;++i)
					css.addRule(sl[i].a, sl[i].b);
			}
			else
			{
				var css = d.createElement("style");
				s='';
				for (var i=0;i<sl.length;++i)
					s+=sl[i].a+sl[i].b;
				css.appendChild(d.createTextNode(s)); 
				d.getElementsByTagName("head")[0].appendChild(css);
			}
		}
		catch (e){}
		try{d.execCommand('useCSS',false,false);}catch(e){}
		this.setEditStyle();
	};
	this.xhtml=function(s){
		if(!this.tox){return s;}
		s=s.replace(/<\/?\w+[^>]*/gi,function(w){w=w.replace(/ (\w+=)(?=[^\"])(\'?)([^\2> ]+)\2/gi,' $1"$3"');return w;});//<font color=red or <font color='red' -> <font color="red"
		s=s.replace(/<\/?\w+[^>]*/gi,function(w){w=w.replace(/<\/?\w+/gi,function(t){return t.toLowerCase();});w=w.replace(/ \w+=/gi,function(t){return t.toLowerCase();});return w;});//<FONT Color -> <font color
		s=s.replace(/<(br|input|meta|link|img|hr)([^>]*?)\/?>/gi,'<$1$2/>');//<img ...> -> <img .../>
		s=s.replace(/<\w+[^>]*>/gi,function(w){w=w.replace(/ (\w+)(?=[ \/>]){1}/gi,' $1="$1" ');return w;});//<input checked -> <input checked="checked"
		return s;
	};
	this.tripOnScript=function(w){
		w=w.replace(/\\"/gi,'-:special:1:-').replace(/\\'/gi,'-:special:2:-');
		w=w.replace(/on\w+\s*=\s*(['"])[^\1]+?\1/gi, '');
		w=w.replace(/-:special:1:-/gi,'\\"').replace(/-:special:2:-/gi,'\\\'');
		return w;
	};
	this.get=function(){
		var a='';try{if('design'==this.m){a=this.f.document.body.innerHTML;}else{a=this.$(this.c).value;}}catch(e){}
		a=a.replace(/http:\/\/.+?dv_edit\//gi,'');
		if(this.um){a=a.replace(/<\p>/gi,'[BR]');a=a.replace(/<[^>]*?>/gi,'');}
		a=this.tripOnScript(a);
		return this.xhtml(a);
	};
	this.save=function(){
		var a=this.get();a=a.replace(/<img.src=[^>]*(em[0-9]{1,})\.[^>]*>/gi, '[$1]');
		this.setC(this.f+'_conent_saved','1');return a;
	};
	this.syc=function(m){
		var d=null;
		if (!this.f||!(d=this.f.document.body)){return;}
		var t=this.$(this.c);
		if ('d->t'==m){
			t.value=this.xhtml(d.innerHTML);
		}else{
			d.innerHTML=this.xhtml(t.value.length>0?t.value:(this.isFF?'&nbsp;':''));
		}
	};
	this.setEditStyle=function(){
		try{
		var b=this.f.document.body;
		b.style.font='normal 14px Verdana';
		b.style.padding='0px';
		this.syc('t->d');
		setTimeout(this.d+'.t=new DvEditToolBar('+this.d+');',0);
		}catch(e){setTimeout(this.d+'.setEditStyle()',0);}
	};
	this.des='<div id="'+this.x.t+'" class="dvedittoolbar" style="display:none;" onmousedown="'+this.d+'.fcs('+this.d+'.$f(\''+this.x.f+'\'));"></div><div class="dveditwnd" style="'+(this.isFF?'position:fixed;':'_position:absolute;')+'display:none;" id="'+this.x.w+'">loading...</div><div id="'+this.x.d+'" /*onmouseover="'+this.d+'.fcs('+this.d+'.$f(\''+this.x.f+'\'));"*/ style="99%;padding:0px;margin:0px;"><iframe id="'+this.x.f+'" src="" class="dvedithtmlarea" frameborder="0" marginheight="0" marginwidth="0" style="width:100%;height:'+this.h+';overflow:visible;margin-bottom:0;margin-right:0;"></iframe></div>';
	this.mode=function(m){
		if (this.lm==m){return;}
		this.m=m;
		var a=this.$(this.c);
		if('design'==m){
			a.style.display='none';
			if (!this.bld){this.loadJs(this.p+'toolbar.js');this.loadToolBar();}
			else{if('text'==this.lm){this.syc('t->d');};this.$(this.x.g).style.display='';}
		}else{
			a.style.font='normal 14px Verdana';
			if('design'==this.lm){this.syc('d->t');}
			a.style.display='';
			this.$(this.x.g).style.display='none';
		};this.lm=m;
	};
	this.upDes=function(){
        if (this.x.g==null){this.x.g='dvedit_0__design';}
		var a=this.$(this.x.g);a.innerHTML=this.des;
		setTimeout(this.d+'.setEditable();',0);
	}
	this.cleancode=function(){
		var s=this.get();
		s=s.replace(/<\/p>/gi, '<br/>');
		s=s.replace(/<[^>]*>/gi, function(w){
			return ('<br/>'==w||-1!=w.indexOf('<img')?w:'');
		});
		this.$(this.c).value=s;
		this.syc('t->d');
	}
	this.sta='<div id="'+this.x.s+'" class="dveditstatusbar"><a href="javascript:;" onclick="'+this.d+'.mode(\'design\')" title="在此模式下编辑可以实现一些加粗、更改字体、更改文字颜色等效果。">[设计模式]</a> <a href="javascript:;" onclick="'+this.d+'.mode(\'text\')" title="纯文本模式，如果开启了HTML可以直接使用HTML代码。">[代码模式]</a></div>';
	this.init=function(){
		this.p=this.getPath();
		this.loadCss(this.p+'skins/'+this.s+'/main.css',false);
		if(this.v){this.chkC();}
		document.writeln('<div id="'+this.x.g+'" style="text-align:left;text-indent:0;"></div>');
		if (this.u){document.writeln(this.sta);}
		this.mode(this.m);
	};
	this.saveT=function(){
		var a=this_.get();var b=this_.readC(this_.x.f+'_conent_temp');if (!b||(a&&a.length>b.length)){this_.setC(this_.x.f+'_conent_temp',a)};
		setTimeout(function(){this_.saveT()},0); //保存内容到cookies
	};
	this.chkC=function(){
		var a=this.readC(this.x.f+'_conent_temp');
		if ('0'==this.readC(this.x.f+'_conent_saved')&&a&&a.replace(/<.[^.]*>/gi,'').length>10&&confirm("检测到有未保存的内容，是否立即恢复？")){
			setTimeout(function(){this_.$(this_.c).value=a;},0);
		}
		this.setC(this.x.f+'_conent_temp','');
		this.setC(this.x.f+'_conent_saved','0');
		this.saveT();
	};
	this.init();
};