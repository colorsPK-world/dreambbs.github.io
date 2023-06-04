

//更改字体大小
var status0 = '';
function fontSize(type,objname){
	var currentfontsize,currentlineheight;
	currentfontsize=parseInt(document.getElementById(objname).style.fontSize);
	//currentlineheight=parseInt(document.getElementById(objname).style.lineHeight); 
	if (type=="b"){
		if(currentfontsize<64){			
			document.getElementById(objname).style.fontSize=(++currentfontsize)+"pt";
			//document.getElementById(objname).style.lineHeight=(++currentlineheight)+'pt';
		}
	}else{
		if(currentfontsize>8){
			document.getElementById(objname).style.fontSize=(--currentfontsize)+"pt";
			//document.getElementById(objname).style.lineHeight=(--currentlineheight)+'pt';
		}
	}
}