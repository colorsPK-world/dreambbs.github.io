query|||3600|||file|||select top 3  F_ID,F_AnnounceID,F_BoardID,F_Username,F_Filename,F_Readme,F_Type,F_FileType,F_AddTime,F_Viewname,F_ViewNum,F_DownNum,F_FileSize FROM [DV_Upfile] WHERE F_Flag<>4 and F_Type=1 order by F_ID desc|||<script type="text/javascript">
var swf_width=300;
var swf_height=250;
var files='';
var texts='';
var links='';|||files+='|{$Filename}'; texts+='|{$Readme}'; links+='|dv_plus/bcastr3/go.html?boardid={$Boardid}^id={$RootID}';|||files=files.substr(1,files.length-1); texts=texts.substr(1,texts.length-1);links=links.substr(1,links.length-1);
document.write('<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width="'+ swf_width +'" height="'+ swf_height +'">');
document.write('<param name="movie" value="dv_plus/bcastr3/bcastr31.swf"><param name="quality" value="high">');
document.write('<param name="menu" value="false"><param name=wmode value="opaque">');
document.write('<param name="FlashVars" value="bcastr_file='+files+'&bcastr_link='+links+'&bcastr_title='+texts+'&TitleBgColor=6699FF">');
document.write('<embed src="dv_plus/bcastr3/bcastr31.swf" wmode="opaque" FlashVars="bcastr_file='+files+'&bcastr_link='+links+'&bcastr_title='+texts+'&TitleBgColor=6699FF& menu="false" quality="high" width="'+ swf_width +'" height="'+ swf_height +'" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />'); document.write('</object>'); </script>|||3$1$1$$0$1|||20|||2