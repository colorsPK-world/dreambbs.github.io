function DvSavePost(){
	var a=arguments;
	this.$=function(o){return document.getElementById(o);}
	this.frm=a[0]||document.forms[0];//发表表单对象
	this.evt=a[1]||window.event;//事件对象
	this.mode=a[2]||'fastre';//发表模式
	this.max_title_length=a[3]||100;//标题最大长度
	this.max_content_length=a[4]||16240;//标题最短长度
	this.isok=true;
	this.chk_topic=function(o){
		if('fastre'!=this.mode){
			if(!o.value){
			this.$(o.name+"_chk").innerHTML='<font color="#FF0000">←您忘记填写标题</font>';
			o.focus();
			this.isok=false;
			}
		};
		if(o.value.length>this.max_title_length){
			this.$(o.name+"_chk").innerHTML=' <font color="#FF0000">←标题长度不能大于'+this.max_title_length+'</font>';
			o.focus();
			this.isok=false;
		}
	};
	this.chk_content=function(o){
		//var len=o.value.replace(/<[^>]*>/gi,'').replace(/&\w{4};/gi,'').length;
		var len=o.value.length;
		if(0==len){
			this.$(o.name+"_chk").innerHTML='<font color="#FF0000">←在您的贴子中没有检测到文字内容。</font>';
			this.isok=false;
		};
		if(o.value.length>this.max_content_length){
			this.$(o.name+"_chk").innerHTML=' <font color="#FF0000">←帖子内容长度不能大于'+this.max_content_length+',您已经输入了'+o.value.length+'个字</font>';
			try{o.focus();}catch(e){}
			this.isok=false;
		}
	};
	this.chk_topicmode=function(modevalue,modelimit){
		if (modevalue.value==0&&modelimit.value==2){
			this.$("mode_chk").innerHTML=" <font color=\"#FF0000\">←您没有选择专题</font>"
			this.isok=false;
		}
	};
	this.chk_code=function(){
		if (document.Dvform.codestr)
		{
			document.getElementById("GetCode").innerHTML="";
			if (''==document.Dvform.codestr.value)
			{
				document.getElementById("GetCode").innerHTML=" <font color=\"#FF0000\">←请输入正确的验证码</font>"
				document.Dvform.codestr.focus();
				this.isok=false;
			}
		}
	};
	this.chk_flash=function(){
		if (document.getElementById("phidstatus"))	{
			if (document.getElementById("phidstatus").value!="0")	{
				alert("您使用了Flash组图功能，请保存后再提交！");
				this.isok=false;
			}
		}
	}
	this.prevent=function(){
		try{if(this.evt.preventDefault){this.evt.preventDefault();}else{this.evt.returnValue=false;}}catch(er){}
	};
	this.send=function(){		
		if (this.isok){
			try{
				if (typeof(ajaxpost)!="undefined"){
					if(!ajaxpost.postForm(this.frm)){
						this.prevent();
					}
				}
			}
			catch (e){}
		}else{
			this.prevent();
		}
		return this.isok;
	};
}

function ChkPostMoney(n)
{
	var DivInfo = document.getElementById('PostMoneyInfo');
	var DivBuy_Setting = document.getElementById('Buy_setting');
	document.Dvform.ToMoney.value = "";
	document.Dvform.ToMoney.disabled = false;
	if (n!="")
	{
		switch (n)
		{
			case '0':
				document.Dvform.ToMoney.value = 1;
			    showmoney.style.display="block";
				DivInfo.innerHTML="自定义悬赏金币数，发帖后暂时扣除该用户相应金币，用户可对不同回复用户在金币范围内分别悬赏，悬赏完毕可结帖，结帖后剩余金币(未送出)还入用户数据中";
				DivBuy_Setting.style.display="none";
				break;
			case '1':
				showmoney.style.display="none";
				DivInfo.innerHTML="回复用户可自定数量金币赠送给帖主。";
				DivBuy_Setting.style.display="none";
				break;
			case '2':
				document.Dvform.ToMoney.value = 1;
     			showmoney.style.display="block";
				DivInfo.innerHTML="发帖者可以定义帖子出售金币数量，浏览者需要支付金币购买才可以查看帖子全部内容。";
				if (DivBuy_Setting)
				{
					DivBuy_Setting.style.display="";
				}
				break;
		}
	}else{
		DivInfo.innerHTML="";
	}
}