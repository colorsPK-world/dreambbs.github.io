//'-------------------------------------------------------------------------------------------------------------------------
//'例如：PageList(1,3,10,123,"acton=12",1)
//'页次：1/13页　每页：10篇 共：123篇 [1][2][3]...[13] 
//'页次：当前第currentpag页，n 分隔数量；每页显示记录数:MaxRows,总记录数：CountNum,v为显示类型
//'-------------------------------------------------------------------------------------------------------------------------
function PageList(CurrentPage,n,MaxRows,CountNum,PageSearch,v,getdata)
{
	var PageStr="";
	if (PageSearch!=''){
		PageSearch+="&";
		PageSearch = PageSearch.replace(/&amp;/gi,"&");
	}
	CountNum=parseInt(CountNum);
	CurrentPage=parseInt(CurrentPage);
	if (CountNum%MaxRows==0){var Pagecount= parseInt(CountNum / MaxRows);}else{var Pagecount = parseInt(CountNum / MaxRows)+1}
	if (Pagecount>CurrentPage+n){var Endpage=CurrentPage+n;}else{var Endpage=Pagecount;}
	if (isNaN(Pagecount)||CountNum==0){Pagecount=0;n=0}
	var ShowPage;
	if (n>0){
		switch (v)
		{
			case 0:
				PageStr = SeachPage(CurrentPage,n,MaxRows,Endpage,Pagecount,PageSearch,0)
				ShowPage="<div>";
				ShowPage+="<form action=\"?"+PageSearch+"\" method=POST name=\"PageForm\">";
				ShowPage+="共：<b>"+CountNum+"<\/b>，页次：<b>"+CurrentPage+"<\/b>/<b>"+Pagecount+"</b>页";
				ShowPage+=PageStr;
				ShowPage+="<input type=\"text\" name=\"page\" size=\"4\" value=\""+CurrentPage+"\"><input type=button class=button onclick=\"submit(this)\" value=\"GO\" title=\"填写翻转的分页，然后点击查看！\">";
				ShowPage+="</form>";
				ShowPage+="</div>";
				break;
			case 1:
				ShowPage="<table border=\"0\"  align=\"right\" cellpadding=\"0\" cellspacing=\"2\"><FORM action=\"?"+PageSearch+"\" method=POST name=\"PageForm\">";
				PageStr = SeachPage(CurrentPage,n,MaxRows,Endpage,Pagecount,PageSearch,1)
				ShowPage+="<tr><td nowrap>";
				ShowPage+="页次：<b><font color=\"Red\">"+CurrentPage+"<\/font><\/b>/<b>"+Pagecount+"</b>页";
				ShowPage+="．每页：显示<b>"+MaxRows+"<\/b>条 共：<b>"+CountNum+"<\/b>条记录</td>";
				ShowPage+="<td valign=middle nowrap align=right>";
				ShowPage+=PageStr;
				ShowPage+="&nbsp;<\/td><td noWrap align=right><input type=\"text\" name=\"page\" size=\"4\" value=\""+CurrentPage+"\"><input type=button class=button onclick=\"submit(this)\" value=\">>\" title=\"填写翻转的分页，然后点击查看！\"><\/td><\/tr>";
				ShowPage+="<\/FORM><\/table>";
				break;
			case 2:
				ShowPage="<table border=\"0\" Style=\"width:100%;width:auto;\" align=center cellpadding=0 cellspacing=2><form action=\"?"+PageSearch+"\" method=POST name=\"PageForm\">";
				PageStr = SeachPage(CurrentPage,n,MaxRows,Endpage,Pagecount,PageSearch,2)
				ShowPage+="<tr><td nowrap>";
				ShowPage+="符合您条件的共有<font color=\"Red\">"+CountNum+"<\/font>条 ，第：<font color=\"Red\">"+CurrentPage+"<\/font> 页/共 <font color=\"Red\">"+Pagecount+"<\/font> 页";
				ShowPage+="</td><td valign=middle nowrap align=right>";
				ShowPage+=PageStr;
				ShowPage+="<\/td><td noWrap align=right><input type=\"text\" name=\"page\" size=\"4\" value=\""+CurrentPage+"\"><input type=button class=button onclick=\"submit(this)\" value=\"GO\" title=\"填写翻转的分页，然后点击查看！\"><\/td><\/tr>";
				ShowPage+="<\/FORM><\/table>";
				break;
			case 3:
				PageStr = SeachPage(CurrentPage,n,MaxRows,Endpage,Pagecount,PageSearch,3)
				ShowPage="<table cellpadding=1 cellspacing=4 class=\"tableborder5\" style=\"margin:0px;width:auto;\">";
				ShowPage=ShowPage+"<form action=\"?"+PageSearch+"\" method=POST name=\"PageForm\" onsubmit='return chkpagestr(this);'><tr align='center'>";
				ShowPage=ShowPage+"";
				ShowPage=ShowPage+PageStr
				ShowPage=ShowPage+"<td class=\"page\"><input type=\"text\" name=\"star\" size=\"2\" value=\""+CurrentPage+"\" Class=PageInput style=\"border:0px;\"></td>";
				ShowPage=ShowPage+"<td class=\"page\"><input type=submit class=button value=GO name=submit Class=PageInput style=\"border:0px; height:16px;\">&nbsp;</td>";
				ShowPage=ShowPage+"<td class=\"page\">&nbsp;"+CountNum+"&nbsp;|&nbsp;"+MaxRows+"&nbsp;</td>";
				ShowPage=ShowPage+"<td class=\"tabletitle1\" title=\"分页\">&nbsp;"+CurrentPage+"/"+Pagecount+"&nbsp;页</td>";
				ShowPage=ShowPage+"</tr></form></table>";
				break;
			case 4:
				PageStr = SeachPage(CurrentPage,n,MaxRows,Endpage,Pagecount,PageSearch,4)

				ShowPage="<table cellpadding=1 cellspacing=4 class=\"tableborder5\" style=\"margin:0px;width:auto;\">";
				ShowPage=ShowPage+"<form action=\"?"+PageSearch+"\" method=POST name=\"PageForm\" onsubmit='return chkpagestr(this);'><tr align='center'>";
				ShowPage=ShowPage+"";
				ShowPage=ShowPage+PageStr
				ShowPage=ShowPage+"<td class=\"page\"><input type=\"text\" name=\"star\" size=\"2\" value=\""+CurrentPage+"\" Class=PageInput style=\"border:0px;\"></td>";
				ShowPage=ShowPage+"<td class=\"page\"><input type=submit class=button value=GO name=submit Class=PageInput style=\"border:0px; height:16px;\">&nbsp;</td>";
				ShowPage=ShowPage+"<td class=\"page\">&nbsp;"+CountNum+"&nbsp;|&nbsp;"+MaxRows+"&nbsp;</td>";
				ShowPage=ShowPage+"<td class=\"tabletitle1\" title=\"分页\">&nbsp;"+CurrentPage+"/"+Pagecount+"&nbsp;页</td>";
				ShowPage=ShowPage+"</tr></form></table>";
				break;
			case 5:
				PageStr = SeachPage(CurrentPage,n,MaxRows,Endpage,Pagecount,PageSearch,5)
				ShowPage="<span>";
				ShowPage+="共<b>"+Pagecount+"<\/b>页：";
				ShowPage+=PageStr;
				ShowPage+="</span>";
				break;
			
			case 6:
				PageStr = SeachPage(CurrentPage,n,MaxRows,Endpage,Pagecount,PageSearch,6)
				ShowPage="<table cellpadding=1 cellspacing=4 class=\"tableborder5\" style=\"width:auto;margin:4px 20px;padding:0px;\">";
				ShowPage=ShowPage+"<form action=\"?"+PageSearch+"\" method=post name=\"PageForm\" target=\"hiddenframe\"><tr align=center>";
				ShowPage=ShowPage+"";
				ShowPage=ShowPage+PageStr
				ShowPage=ShowPage+"<td class=\"page\"><input type=\"text\" name=\"star\" size=\"2\" value=\""+CurrentPage+"\" style=\"border:0px;\"></td>";
				ShowPage=ShowPage+"<td class=\"page\"><input type=submit class=button value=GO name=submit style=\"width:auto;border:0px; height:16px;\"></td>";
				ShowPage=ShowPage+"<td class=\"tabletitle1\" title=\"总数\">&nbsp;"+CountNum+"条&nbsp;&nbsp;"+CurrentPage+"/"+Pagecount+"&nbsp;页&nbsp;</td>";
				ShowPage=ShowPage+"</tr></form></table>";
				break;
			
		}
	}else{
		ShowPage='';
	}
	if (getdata)
	{
		return ShowPage;
	}
	else{
		document.write (urlrewrite(ShowPage));
	}
}

function chkpagestr(theform){
	if (ISAPI_ReWrite==0){return true;}
	var url;
	if (theform.page){
		var inpValue = theform.page.value;
		var inpName = theform.page.name;
	}
	else if (theform.star){
		var inpValue = theform.star.value;
		var inpName = theform.star.name;
	}
	url = theform.action +inpName+"="+inpValue;
	theform.action = urlrewrite(url);
	return true;
}


function urlrewrite(str){
	if (ISAPI_ReWrite==0){return str;}
	var regExp = /\?boardid=(\d+)(&|&amp;)action=(.[^&]*)(&|&amp;)topicmode=(\d+)(&|&amp;)page=(\d+)/gi;
	str = str.replace(regExp,"index_$1_$3_$5_$7.html")
	regExp = /\?boardid=(\d+)(&|&amp;)action=&topicmode=(\d+)(&|&amp;)page=(\d+)/gi;
	str = str.replace(regExp,"index_$1__$3_$5.html")
	regExp = /\?boardid=(\d+)(&|&amp;)replyid=(\d+)(&|&amp;)id=(\d+)(&|&amp;)skin=(\d+)(&|&amp;)page=(\d+)(&|&amp;)star=(\d+)/gi;
	str = str.replace(regExp,"dispbbs_$1_$3_$5_skin$7_$9_$11.html")
	return str
}

function SeachPage(CurrentPage,n,MaxRows,Endpage,Pagecount,PageSearch,v) {
var PageStr="";
switch (v)
{
	case 0:
		if (CurrentPage!=1)
		{
			PageStr += " <a href=\"?"+PageSearch+"page=1\" title=\"首页\">[首页]<\/a>";
		}
		if (CurrentPage>1)
			{
			PageStr += " <a href=\"?"+PageSearch+"page="+(CurrentPage-1)+"\" title=\"上一页\">[上一页]<\/a>";

		}
		if (CurrentPage<Pagecount)
			{
			PageStr += " <a href=\"?"+PageSearch+"page="+(CurrentPage+1)+"\" title=\"下一页\">[下一页]<\/a>";

		}

		if (CurrentPage!=Pagecount)
		{
			PageStr += " <a href=\"?"+PageSearch+"page="+Pagecount+"\" title=\"尾页\">[尾页]<\/a>";
		}
		break
	case 1:
		if (CurrentPage>n+1){PageStr="<a href=\"?"+PageSearch+"page=1\">[1]<\/a> ...";}
		for (var i=CurrentPage-n;i<=Endpage;i++)
		{
			if (i>=1)
			{
				if (i==CurrentPage)
				{
					PageStr+="["+i+"]";
				}else{
					PageStr+="<a href=\"?"+PageSearch+"page="+i+"\">["+i+"]<\/a>";
				}
			}
		}
		if (Pagecount>CurrentPage+n){PageStr+="...<a href=\"?"+PageSearch+"page="+Pagecount+"\" class=path>["+Pagecount+"]<\/a>";}
		break;
	case 2:
		var p;
		if ((CurrentPage-1)%n==0) 
		{
			p=(CurrentPage-1) /n
		}
		else
		{
			p=(((CurrentPage-1)-(CurrentPage-1)%n)/n)
		}
		if (CurrentPage!=1)
		{
			PageStr += "<a href=\"?"+PageSearch+"page=1\" title=\"首页\"><img src=\"images/pagelist/First.gif\" border=\"0\" alt=\"第一页\"><\/a>";
		}

		if (p*n > 0)
		{
			PageStr += "<a href=\"?"+PageSearch+"page="+p*n+"\" title=\"上十页\"><img src=\"images/pagelist/Previous.gif\" border=\"0\"><\/a>";
		}
		//PageStr += "<b>";
		for (var i=p*n+1;i<p*n+n+1;i++)
		{
			if (i==CurrentPage)
			{
				PageStr += " ["+i+"] ";
			}
			else
			{
				PageStr += " <a href=\"?"+PageSearch+"page="+i+"\">"+i+"<\/a> ";
			}
			if (i==Pagecount) break;
		}
		//PageStr += "</b>";
		if (i<Pagecount)
		{
			PageStr += "<a href=\"?"+PageSearch+"page="+i+"\" title=\"下十页\"><img src=\"images/pagelist/Next.gif\" border=\"0\"><\/a>";
		}
		if (CurrentPage!=Pagecount)
		{
			PageStr += "<a href=\"?"+PageSearch+"page="+Pagecount+"\" title=\"尾页\"><img src=\"images/pagelist/Last.gif\" border=\"0\"><\/a>";
		}
	break;
	case 3:
		var p;
		if ((CurrentPage-1)%n==0) 
		{
			p=(CurrentPage-1) /n
		}
		else
		{
			p=(((CurrentPage-1)-(CurrentPage-1)%n)/n)
		}
		if (CurrentPage!=1)
		{			
			PageStr+="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"star=1\" title=\"第一页\"><img src=\"images/pagelist/First.gif\" border=\"0\" alt=\"第一页\"><\/a>&nbsp;<\/td>";
		}
		//else{
			//PageStr+="<td class=\"page\"><font style=\"font-family:webdings\">9<\/font><\/td>";
		//}
		if (p*n > 0)
		{
			PageStr +="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"star="+p*n+"\" title=\"上十页\"><img src=\"images/pagelist/Previous.gif\" border=\"0\"><\/a>&nbsp;<\/td>";
		}
		for (var i=p*n+1;i<p*n+n+1;i++)
		{
			if (i==CurrentPage)
			{
				PageStr+="<td class=\"page2\">&nbsp;<B>"+i+"<\/B><\/td>";
			}
			else
			{
				PageStr+="<td class=\"page\" ><a href=\"?"+PageSearch+"star="+i+"\"><span>"+i+"</span><\/a><\/td>";
			}
			if (i==Pagecount) break;
		}
		if (i<Pagecount)
		{
			PageStr+="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"star="+i+"\" title=\"下十页\"><img src=\"images/pagelist/Next.gif\" border=\"0\"><\/a>&nbsp;<\/td>";
		}
		if (CurrentPage<Pagecount)
		{
			PageStr+="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"star="+Pagecount+"\" title=\"尾页\"><img src=\"images/pagelist/Last.gif\" border=\"0\"><\/a>&nbsp;";
			PageStr+="<\/td>";
		}
	break;

	case 4:
		var p;
		if ((CurrentPage-1)%n==0) 
		{
			p=(CurrentPage-1) /n
		}
		else
		{
			p=(((CurrentPage-1)-(CurrentPage-1)%n)/n)
		}
		if (CurrentPage!=1)
		{			
			PageStr+="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"page=1\" title=\"第一页\"><img src=\"images/pagelist/First.gif\" border=\"0\" alt=\"第一页\"><\/a>&nbsp;<\/td>";
		}
		if (p*n > 0)
		{
			PageStr +="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"page="+p*n+"\" title=\"上十页\"><img src=\"images/pagelist/Previous.gif\" border=\"0\"><\/a>&nbsp;<\/td>";
		}
		for (var i=p*n+1;i<p*n+n+1;i++)
		{
			if (i==CurrentPage)
			{
				PageStr+="<td class=\"page2\">&nbsp;<B>"+i+"<\/B><\/td>";
			}
			else
			{
				PageStr+="<td class=\"page\" ><a href=\"?"+PageSearch+"page="+i+"\"><span>"+i+"</span><\/a><\/td>";
			}
			if (i==Pagecount) break;
		}
		if (i<Pagecount)
		{
			PageStr+="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"page="+i+"\" title=\"下十页\"><img src=\"images/pagelist/Next.gif\" border=\"0\"><\/a>&nbsp;<\/td>";
		}
		if (CurrentPage<Pagecount)
		{
			PageStr+="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"page="+Pagecount+"\" title=\"尾页\"><img src=\"images/pagelist/Last.gif\" border=\"0\"><\/a>&nbsp;";
			PageStr+="<\/td>";
		}
	break;

	case 5:
		if (CurrentPage>n+1){PageStr="<a href=\"?"+PageSearch+"page=1\" target=\"TempIframe\">[1]<\/a> ...";}
		for (var i=CurrentPage-n;i<=Endpage;i++)
		{
			if (i>=1)
			{
				if (i==CurrentPage)
				{
					PageStr+="["+i+"]";
				}else{
					PageStr+="<a href=\"?"+PageSearch+"page="+i+"\"  target=\"TempIframe\">["+i+"]<\/a>";
				}
			}
		}
		if (Pagecount>CurrentPage+n){PageStr+="...<a href=\"?"+PageSearch+"page="+Pagecount+"\" class=\"path\"  target=\"TempIframe\">["+Pagecount+"]<\/a>";}
		break;
	
	case 6:
		var p;
		if ((CurrentPage-1)%n==0) 
		{
			p=(CurrentPage-1) /n
		}
		else
		{
			p=(((CurrentPage-1)-(CurrentPage-1)%n)/n)
		}
		if (CurrentPage!=1)
		{			
			PageStr+="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"star=1\" target=\"hiddenframe\" title=\"第一页\"><img src=\"images/pagelist/First.gif\" border=\"0\" alt=\"第一页\"><\/a>&nbsp;<\/td>";
		}
		//else{
			//PageStr+="<td class=\"page\"><font style=\"font-family:webdings\">9<\/font><\/td>";
		//}
		if (p*n > 0)
		{
			PageStr +="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"star="+p*n+"\" target=\"hiddenframe\" title=\"上十页\"><img src=\"images/pagelist/Previous.gif\" border=\"0\"><\/a>&nbsp;<\/td>";
		}
		for (var i=p*n+1;i<p*n+n+1;i++)
		{
			if (i==CurrentPage)
			{
				PageStr+="<td class=\"page2\">&nbsp;<B>"+i+"<\/B><\/td>";
			}
			else
			{
				PageStr+="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"star="+i+"\" target=\"hiddenframe\">"+i+"<\/a>&nbsp;<\/td>";
			}
			if (i==Pagecount) break;
		}
		if (i<Pagecount)
		{
			PageStr+="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"star="+i+"\" target=\"hiddenframe\" title=\"下十页\"><img src=\"images/pagelist/Next.gif\" border=\"0\"><\/a>&nbsp;<\/td>";
		}
		if (CurrentPage<Pagecount)
		{
			PageStr+="<td class=\"page\" >&nbsp;<a href=\"?"+PageSearch+"star="+Pagecount+"\" target=\"hiddenframe\" title=\"尾页\"><img src=\"images/pagelist/Last.gif\" border=\"0\"><\/a>&nbsp;";
			PageStr+="<\/td>";
		}
	break;
}
	return PageStr;
}
