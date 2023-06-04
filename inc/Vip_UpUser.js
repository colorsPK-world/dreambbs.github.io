function sel_group(obj){
if (obj){
	var t="";
	obj.options[0] =  new Option("选择相应的VIP组",0);
	for (var i = 0,k = 1;i<vipconfig.UserGroupID.length;i++){
		t = vipconfig.Title[i]+"--"+vipconfig.Usertitle[i];
		t = t.replace(/<[^>]*>/g, "");
		obj.options[k++] = new Option(t,vipconfig.UserGroupID[i]);
	}
}
}
function GetGroupInfo(Sid){
	if (Sid>0){
		var configid= Sid-1;
		var MMoney=vipconfig.NMoney[configid]*vipconfig.Ldays[configid]/vipconfig.days[configid];
		var MTicket=vipconfig.NTicket[configid]*vipconfig.Ldays[configid]/vipconfig.days[configid];
		document.TheForm.vipmoney.value=vipconfig.NMoney[configid];
		document.TheForm.vipticket.value=vipconfig.NTicket[configid];
		document.getElementById("Days").innerHTML = vipconfig.days[configid];
		document.getElementById("VDays").innerHTML = vipconfig.days[configid];
		document.getElementById("GroupTitle").innerHTML = vipconfig.Title[configid]+"--"+vipconfig.Usertitle[configid];
		document.getElementById("VMondy").innerHTML = vipconfig.NMoney[configid];
		document.getElementById("VTicket").innerHTML = vipconfig.NTicket[configid];
		document.getElementById("LVMondy").innerHTML = MMoney.toFixed(0);
		document.getElementById("LVTicket").innerHTML = MTicket.toFixed(0);
		document.getElementById("LVDays").innerHTML = vipconfig.Ldays[configid];
		document.getElementById("viptips").style.display=""
		document.getElementById("GETVDays").innerHTML = vipconfig.days[configid];
	}
	else
	{
		document.TheForm.vipmoney.value=0;
		document.TheForm.vipticket.value=0;
		document.getElementById("Days").innerHTML = 0;
		document.getElementById("viptips").style.display="none"
		document.getElementById("GETVDays").innerHTML = 0;
	}
}
function countdays(){
	var sel = document.TheForm.vipgroupid.selectedIndex;
	var vipticket = document.TheForm.vipticket.value;
	var vipmoney = document.TheForm.vipmoney.value;
	if(isNaN(vipticket)){
		document.TheForm.vipticket.value = 0;
		alert('请填写正确的数值！');
		return false;
	}
	if(isNaN(vipmoney)){
		document.TheForm.vipmoney.value = 0;
		alert('请填写正确的数值！');
		return false;
	}
	if (sel>0){
	sel = sel-1;
	if (document.TheForm.Btype[1].checked){
		var GETVDays=parseFloat(vipticket)*vipconfig.days[sel]/vipconfig.NTicket[sel];
		document.getElementById("GETVDays").innerHTML = GETVDays.toFixed(0);
		
	}else{
		var GETVDays=parseFloat(vipmoney)*vipconfig.days[sel]/vipconfig.NMoney[sel];
		document.getElementById("GETVDays").innerHTML = GETVDays.toFixed(0);
	}
	if (GETVDays.toFixed(0)<vipconfig.Ldays[sel]){
		alert("请按支付要求填写。");
	}
	}
	return false;
}
/**
* 文本表单检验
* <input type="text" onkeyup="javascript:CheckNumer(this.value,this,0,10);" >...
*/

//验证表单数值 n:number 表单值 | v:value object 表单对象 | n_max 最大值 | n_min最小值
function CheckNumer(n,v,n_min,n_max)
{
	if (isNaN(n)){
		alert("请填写正确的数值！");
		v.value = 0;
	}
	else{
		n = parseFloat(n);
		if (!isNaN(n_min)){
			n_min = parseFloat(n_min);
			if (n<n_min){alert("该项数值不能小于："+n_min);v.value = n_min;}
		}
		if (!isNaN(n_max)){
			n_max = parseFloat(n_max);
			if (n>n_max){alert("该项数值不能高于："+n_max);v.value = n_max;}
		}
	}
}
var vipconfig = new VipGroupConfig();
sel_group(document.TheForm.vipgroupid);