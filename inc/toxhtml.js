var DvWEBXHTML=new Object();
DvWEBXHTML.GetXHTML=function(node){
if (window.ActiveXObject){
	var prefix = ["MSXML3","MSXML2","MSXML","Microsoft"];
	for (var i=0;i<prefix.length;i++) {
		try {
		this.XML=new ActiveXObject(prefix[i] + ".DOMDocument");
		if (XML)
					{
						return XML;
					}		
			} catch (e) {}
	}
	}else{
	this.XML=document.implementation.createDocument('', '', null);
	Node.prototype.__defineGetter__('xml', DvWEBXHTML._Node_Getxml);
	};
	this.MainNode=this.XML.appendChild(this.XML.createElement( 'XHTML' ));
	this._AppendChildNodes(this.MainNode, node);
	var sXHTML=this.MainNode.xml;
	sXHTML=sXHTML.replace(/<embed><\/embed>/g,"") ;
	return sXHTML.substr(7, sXHTML.length - 15);
	};
DvWEBXHTML._Node_Getxml=function(){
	var oSerializer=new XMLSerializer();
	return oSerializer.serializeToString(this);
	};
DvWEBXHTML._AppendChildNodes=function(xmlNode, htmlNode){
	var oChildren=htmlNode.childNodes;
	var i=0;
	while (i < oChildren.length){
		i +=this._AppendNode(xmlNode, oChildren[i]);
	};
};
DvWEBXHTML._AppendNode=function(xmlNode, htmlNode){
	var iAddedNodes=1;
	switch (htmlNode.nodeType){
		case 1 : var sNodeName=fixtag(htmlNode.nodeName.toLowerCase());
		if(sNodeName=='') break;
		var oNode=xmlNode.appendChild(this.XML.createElement( sNodeName ));
		var oAttributes=htmlNode.attributes;
		for (var n=0 ; n < oAttributes.length ; n++){
			var oAttribute=oAttributes[n];
			if (oAttribute.specified && oAttribute.nodeName.toLowerCase()+''!='style') this._AppendAttribute(oNode, fixtag(oAttribute.nodeName.toLowerCase()+''), oAttribute.nodeValue+'');
			};
			var cssText=htmlNode.style.cssText;

			if (cssText!='') {
				if (navigator.appVersion.indexOf("MSIE")!=-1){
				cssText=cssText+';';
				}
				this._AppendAttribute(oNode, 'style', cssText);
			}
				if (htmlNode.childNodes.length == 0){
				switch (sNodeName){
					case "img" :case "input" :case "br" : case "hr" :case "param" :break;
					default : oNode.appendChild(this.XML.createTextNode( '' ));
					break;
					};
					};
			switch (sNodeName){
				
			//case "script" : case "style" : 	oNode.appendChild(this.XML.createTextNode( '\['+sNodeName+'\]'+ htmlNode.nodeValue +'\[\/'+ sNodeName+'\]' ));break;
			case "abbr" : if (document.all){var oNextNode=htmlNode.nextSibling;
				while (true){
					iAddedNodes++;
					if (oNextNode && oNextNode.nodeName !='/ABBR'){
						this._AppendNode(oNode, oNextNode);
						oNextNode=oNextNode.nextSibling;
					}else
						break;
				};
				break;
			};
			case "area" : if (document.all && ! oNode.attributes.getNamedItem( 'coords' )){var sCoords=htmlNode.getAttribute('coords', 2);if (sCoords && sCoords !='0,0,0') this._AppendAttribute(oNode, 'coords', sCoords);};
			case "img" : if (! oNode.attributes.getNamedItem( 'alt' )) this._AppendAttribute(oNode, 'alt', '');
			default :this._AppendChildNodes(oNode, htmlNode);
			break;
		};
			case 3 : if (htmlNode.nodeValue!=null) {
				xmlNode.appendChild(this.XML.createTextNode( htmlNode.nodeValue ));
			};
			break;
			default : xmlNode.appendChild(this.XML.createComment( "Element not supported - Type: " + htmlNode.nodeType + " Name: " + htmlNode.nodeName ));break;
		};
		return iAddedNodes;
	};
DvWEBXHTML._AppendAttribute=function(xmlNode, attributeName, attributeValue){
	if(checkattributeName(attributeName) && attributeName.indexOf('_moz') ==-1 && attributeName.substring(0,2)!='on' && attributeValue.indexOf('_moz') ==-1 && attributeName!=''){
		var oXmlAtt=this.XML.createAttribute(attributeName);
		if (typeof( attributeValue )=='boolean' && attributeValue == true ){
			oXmlAtt.nodeValue=attributeName;
			}else{
			oXmlAtt.nodeValue=attributeValue;
			};
			xmlNode.attributes.setNamedItem(oXmlAtt);
			};
			};
function fixtag(text)
{
	text = text.replace(/&|\/|<|>|\*|#|:|;|=|\?|\)|\(|%|\[|\]|\$| /g, "") ;
	return text ;
}
function checkattributeName(attributeName){
	var Re = new RegExp(/&|\/|<|>|\*|#|:|;|=|\?|\)|\(|%|\[|\]|\$| /gi);
	if(Re.test(attributeName)){
		return false
		}else{
		var Re = new RegExp(/[0-9]/gi);
		if(Re.test(attributeName.substring(0,1))){
			return false
			}else{
			return true;
			}
		}
	}
function fixtoxhtml(o,action){
	var div=document.getElementById("hiddenhtml");
	if(action==1){
	var htm=o.value;
	var html=htm.split('\n');
	div.innerHTML=html[0];
	htm=DvWEBXHTML.GetXHTML(div);
	for (i=1;i<html.length;i++){
		div.innerHTML=html[i];
		htm+='\n'+DvWEBXHTML.GetXHTML(div);
		}
		o.value=htm;
}else{
	div.innerHTML=o.value;
	o.value=DvWEBXHTML.GetXHTML(div);
	}
	}