<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="xml" omit-xml-declaration = "yes" indent="yes" version="4.0"/>
<xsl:variable name="pagesize" select="50"/>
<xsl:template match="/">
<script language="Javascript" src="images/post/reply.js" type="text/javascript"></script>
<iframe style="border:0px;width:0px;height:0px;"  src="" name="hid1"></iframe>
<div class="mainbar0">
<fieldset style="border : 1px dotted #ccc;text-align : left;line-height:22px;">
<legend>
<b>操作说明</b>
</legend>
<ol style="margin-top:0px;margin-bottom:0px;list-style-position : inside;">
<li style="padding:0px 5px;">本操作可以帮助您把老贴转换成规范的XHTML格式，减少论坛消耗。</li>
<li style="padding:0px 5px;">请选择需要转换的表，填写开始转换的贴子序号，再提交。</li>
<li style="padding:0px 5px;">注意：本操需要较长的时间，并且占用大量内存，建议在本地执行。执行过程中不能刷新页面或关闭窗口，请耐心等待。</li>
<li style="padding:0px 5px;">本操作有机会造成老贴子格式错误，为避免因程序错误造成损失，强烈建议您先备份好您的数据库。如果您使用的是Access数据库，建议你执行本操作之前和之后，都要执行数据库的修复和压缩。</li>
</ol>
</fieldset>
</div>
<div class="th" style="text-indent:10px;">操作设置</div>
<form id="Dvform1" name="Dvform1" action="Admin_transformxhml.asp?action=transform" method="post" target="hid1">
<div class="mainbar3" style="text-align : left;line-height:25px;height:25px;text-indent:10px;">
请选择修复的数据表：
<select name="tableid" id="tableid">
<xsl:for-each select="xml/posttable">
<option value="{@id}"><xsl:if test="@id= 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if><xsl:value-of select="@tabletype" />[记录：<xsl:value-of select="@count" />]</option>
</xsl:for-each>
</select>
开始编号：<input type="text" name="sid" value="1" />
每次修复数：<input type="text" name="transcount" value="1000" />
<input type="submit" value="开 始" name="submit"/>
</div>
</form>
<div class="mainbar0">
<fieldset style="border : 1px dotted #ccc;text-align : left;line-height:22px;">
<legend>
<b>转换情况</b>
</legend>
<div style="text-indent:24px;" id="title1">尚未开始</div>
<div style="text-indent:24px;" id="title2"></div>
</fieldset>
<hr />
<iframe class="Dvbbs_Reply" id="Dvbbs_Composition" marginheight="5" marginwidth="5" width="0" height="0" ></iframe>
</div>
<form id="Dvform" name="Dvform" action="?action=dotransform" method="post" target="hid1">
<input type="hidden" id="Body" name="Body" value="" />
<input type="hidden" id="id" name="id" value="1" />
<input type="hidden" id="tableid" name="tableid" value="1" />
</form>
<script language="Javascript" type="text/javascript">
var Dvbbs_bIsIE5=document.all;
var Dvbbs_Mode = 3;
if (Dvbbs_bIsIE5)
{var IframeID=frames["Dvbbs_Composition"];}
else
{
var IframeID=document.getElementById("Dvbbs_Composition").contentWindow;
}
Dvbbs_InitDocument('Body','gb2312');
function copyto(text){
IframeID.document.body.innerHTML=text;
Dvbbs_CopyData('Body');
document.Dvform.submit()
}
</script>
</xsl:template>

</xsl:stylesheet>
