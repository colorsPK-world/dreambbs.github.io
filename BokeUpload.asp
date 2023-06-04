<!--#include FILE="conn.asp"-->
<!--#include file="inc/const.asp" -->
<!--#include file="boke/config.asp"-->
<!-- #include File="boke/Upload_Class.asp" -->
<%
DvBoke.Stats = "上传操作"
DvBoke.Head(0)
Dim m
m = Request.QueryString("mode")
Select Case Request.QueryString("mode")
Case "UploadForm" : UploadForm()
Case "SaveUpload" : SaveUpload()
End Select
Dvbbs.PageEnd()
Sub UploadForm()
	Dim PageHtml
	DvBoke.LoadPage("topic.xslt")
	PageHtml = DvBoke.Page_Strings(26).text
	PageHtml = Replace(PageHtml,"{$upset}",5)
	PageHtml = Replace(PageHtml,"{$bokename}",Dvboke.BokeName)
	Response.Write PageHtml
End Sub

Sub SaveUpload()
	Dim MaxSize
	Server.ScriptTimeOut=999999'要是你的论坛支持上传的文件比较大，就必须设置。
	'-----------------------------------------------------------------------------
	'提交验证
	'-----------------------------------------------------------------------------
	If Not Dvbbs.ChkPost Then
		Response.End
	End If
	If Dvboke.Userid=0 Then
		Response.write "你还未登陆！"
		Response.End
	End If
	

	If Dvboke.System_UpSetting(0)="1" Then
		If Cint(Dvbbs.GroupSetting(7))=0 then
			Response.write "您没有在本论坛上传文件的权限！"
			Response.End
		End If
	Else
		If Dvboke.System_UpSetting(1)="0" Then
			Response.write "您没有在本博客上传文件的权限！"
			Response.End
		End If
	End If
	MaxSize = Int(Dvboke.System_UpSetting(1))
	If MaxSize=0 Then
		MaxSize = Int(Dvbbs.GroupSetting(44))
	End If
	If Dvboke.BokeNode.getAttribute("spacesize")=0 Then
		Response.write "当前博客允许的上传空间已满，请与管理员联系。"
		Response.End
	ElseIf Dvboke.BokeNode.getAttribute("spacesize")>0 Then
		If Dvboke.BokeNode.getAttribute("spacesize")<MaxSize Then
			MaxSize = Dvboke.BokeNode.getAttribute("spacesize")
		End If
	End If

	'----------------------------------------------------------------------
	Dim FilePath,ChildFilePath,Previewpath,DrawInfo,AllFileName
	'上传目录
	FilePath = CreatePath(CheckFolder)
	'不带系统上传目录的下级目录路径
	ChildFilePath = Replace(FilePath,CheckFolder,"")
	'预览图片目录路径
	Previewpath = "Boke/PreviewImage/"
	Previewpath = CreatePath(Previewpath)

	If Dvboke.System_UpSetting(17)="1" Then
		DrawInfo = Dvboke.System_UpSetting(4)
	ElseIf Dvboke.System_UpSetting(17)="2" Then
		DrawInfo = Dvboke.System_UpSetting(9)
	Else
		DrawInfo = ""
	End If
	If DrawInfo = "0" Then
		DrawInfo = ""
		Dvboke.System_UpSetting(17) = 0
	End If
%>
	<script>parent.document.PostForm.submit.disabled=false;</script>
<%
	Dim Upload,FormName,File,F_FileName,F_Viewname
	'========================================================================
	Set Upload = New UpFile_Cls
	Upload.UploadType			= Cint(Dvboke.System_UpSetting(2))	'设置上传组件类型
	Upload.UploadPath			= FilePath								'设置上传路径
	Upload.InceptFileType		= Replace(DvBoke.System_Setting(16),"|",",")		'设置上传文件限制
	Upload.MaxSize				= MaxSize							'单位 KB
	Upload.InceptMaxFile		= 5									'每次上传文件个数上限
	'Upload.ChkSessionName		= "UploadCode"							'防止重复提交，SESSION名与提交的表单要一致。
	'预览图片设置
	Upload.PreviewType			= Cint(Dvboke.System_UpSetting(3))	'设置预览图片组件类型
	Upload.PreviewImageWidth	= Dvboke.System_UpSetting(14)			'设置预览图片宽度
	Upload.PreviewImageHeight	= Dvboke.System_UpSetting(15)			'设置预览图片高度
	Upload.DrawImageWidth		= Dvboke.System_UpSetting(11)			'设置水印图片或文字区域宽度
	Upload.DrawImageHeight		= Dvboke.System_UpSetting(12)			'设置水印图片或文字区域高度
	Upload.DrawGraph			= Dvboke.System_UpSetting(10)			'设置水印透明度
	Upload.DrawFontColor		= Dvboke.System_UpSetting(6)			'设置水印文字颜色
	Upload.DrawFontFamily		= Dvboke.System_UpSetting(7)			'设置水印文字字体格式
	Upload.DrawFontSize			= Dvboke.System_UpSetting(5)			'设置水印文字字体大小
	Upload.DrawFontBold			= Dvboke.System_UpSetting(8)			'设置水印文字是否粗体
	Upload.DrawInfo				= DrawInfo								'设置水印文字信息或图片信息
	Upload.DrawType				= Dvboke.System_UpSetting(17)			'0=不加载水印 ，1=加载水印文字，2=加载水印图片
	Upload.DrawXYType			= Dvboke.System_UpSetting(13)			'"0" =左上，"1"=左下,"2"=居中,"3"=右上,"4"=右下
	Upload.DrawSizeType			= Dvboke.System_UpSetting(16)			'"0"=固定缩小，"1"=等比例缩小
	If Dvboke.System_UpSetting(18)<>"" or Dvboke.System_UpSetting(18)<>"0" Then
		Upload.TransitionColor	= Dvboke.System_UpSetting(18)			'透明度颜色设置
	End If
	
	'执行上传
	Upload.SaveUpFile
	
	If Upload.ErrCodes<>0 Then
		Response.write "错误："& Upload.Description & "[ <a href=""?mode=UploadForm"">重新上传</a> ]"
		Exit Sub
	End If
	If Upload.Count > 0 Then
		For Each FormName In Upload.UploadFiles
			Set File = Upload.UploadFiles(FormName)
				F_FileName = FilePath & File.FileName
				'Response.Write File.sFileName
				'REsponse.End
				'创建预览及水印图片
				If Upload.PreviewType<>999 and File.FileType=1 then
						F_Viewname = Previewpath & "pre" & Replace(File.FileName,File.FileExt,"") & "jpg"
						'创建预览图片:Call CreateView(原始文件的路径,预览文件名及路径,原文件后缀)
						Upload.CreateView F_FileName,F_Viewname,File.FileExt
				End If
				UploadSave F_FileName,ChildFilePath&File.FileName,File.sFileName,File.FileExt,F_Viewname,File.FileSize,File.FileType
				AllFileName = AllFileName & "<br>" & Dvbbs.Get_ScriptNameUrl() & DvBoke.System_UpSetting(19) & ChildFilePath&File.FileName
			Set File = Nothing
		Next
	Else
		Response.write "请正确选择要上传的文件。[ <a href=""?mode=UploadForm"">重新上传</a> ]"
		Exit Sub
	End If

	Call Suc_upload(Upload.Count,Upload.CountSize,AllFileName)
	Set Upload = Nothing
End Sub

Sub Suc_upload(UpCount,upCountSize,AllFileName)
	Dim SucMsg
	Dim RemainSize
	upCountSize = Formatnumber((upCountSize/1024)/1024,2)
	IF Dvboke.BokeNode.getAttribute("spacesize")<>-1 Then
		RemainSize = cCur(Dvboke.BokeNode.getAttribute("spacesize")) - upCountSize
		If RemainSize<0 Then
			RemainSize = 0
		End If
	Else
		RemainSize = -1
	End If
	SucMsg = UpCount & "个附件上传成功,共"&upCountSize&"MB ;"
	If RemainSize = 0 Then
		SucMsg = SucMsg & "[ 当前博客的空间已满,请与管理员联系。]"
	Else
		SucMsg = SucMsg & "[ <a href=""?mode=UploadForm"">继续上传</a> ]"
	End If
	Dvboke.Execute("UPDATE [Dv_Boke_User] SET SpaceSize = '" & RemainSize &"' WHERE UserID = " & DvBoke.BokeUserID)
	Dim PageHtml
	DvBoke.LoadPage("topic.xslt")
	PageHtml = DvBoke.Page_Strings(27).text
	If m="1" Then SucMsg = SucMsg & "<br>文件地址：" & AllFileName
	PageHtml = Replace(PageHtml,"{$SucMsg}",SucMsg)
	Response.Write PageHtml
End Sub


'保存上传数据并返回附件ID
Sub UploadSave(FileName,ChildFileName,sFileName,FileExt,ViewName,FileSize,F_Type)
'所有字段 ID,UserID,UserName,CatID,sType,TopicID,PostID,IsTopic,Title,FileName,FileType,FileSize,FileNote,DownNum,ViewNum,DateAndTime,PreviewImage 
'字段排序 ID=0 ,UserID=1 ,UserName=2 ,CatID=3 ,sType=4 ,TopicID=5 ,PostID=6 ,IsTopic=7 ,Title=8 ,FileName=9 ,FileType=10 ,FileSize=11 ,FileNote=12 ,DownNum=13 ,ViewNum=14 ,DateAndTime=15 ,PreviewImage=16 

'CatID,sType,TopicID,PostID,IsTopic,Title,FileNote,IsLock
	Dim ShwoFileName
	ShwoFileName = Dvbbs.Checkstr(Replace(FileName,CheckFolder,"UploadFile/"))
	ChildFileName = Dvbbs.Checkstr(ChildFileName)

	DvBoke.Execute("Insert into Dv_Boke_Upfile (BokeUserID,UserID,UserName,FileName,sFileName,FileType,FileSize,PreviewImage,IsLock,IsTopic) values ("& DvBoke.BokeUserID &","& DvBoke.UserID &",'"& DvBoke.BokeUserName &"','"& ChildFileName &"','"& Dvbbs.Checkstr(sFileName) &"',"& F_Type &","& FileSize &",'"& Dvbbs.Checkstr(ViewName) &"',4,-1)")

	Dim Rs,UpFileID,DownloadID
	Set Rs=DvBoke.Execute("Select top 1 ID From Dv_Boke_Upfile order by ID desc")
		DownloadID=rs(0)
		UpFileID = DownloadID & ","
	Rs.Close
	Set Rs=nothing
	'0=其它,1=图片,2=FLASH,3=音乐,4=电影
	If F_Type=1 or F_Type=2 then
		Response.write "<script>parent.put_html('PostContent','[upload="&FileExt&"]"&ChildFileName&"[/upload]<br/>');</script>"
	Else
		Response.write "<script>parent.put_html('PostContent','[upload="&FileExt&"]BokeviewFile.asp?ID="&DownloadID&"[/upload]<br/>');</script>"
	End If
	Response.write "<script>parent.document.PostForm.upfilerename.value+='"&UpFileID&"'</script>"
End Sub


'读取上传目录
Function CheckFolder()
	If DvBoke.System_UpSetting(19)="" Or DvBoke.System_UpSetting(19)="0" Then DvBoke.System_UpSetting(19)="Boke/UploadFile/"
	CheckFolder = Replace(Replace(DvBoke.System_UpSetting(19),Chr(0),""),".","")
	'在目录后加(/)
	If Right(CheckFolder,1)<>"/" Then CheckFolder=CheckFolder&"/"
End Function

'按月份自动明名上传文件夹,需要ＦＳＯ组件支持。
Private Function CreatePath(PathValue)
	Dim objFSO,Fsofolder,uploadpath
	'以年月创建上传文件夹，格式：2003－8
	uploadpath = year(now) & "-" & month(now)
	If Right(PathValue,1)<>"/" Then PathValue = PathValue&"/"
	On Error Resume Next
	Set objFSO = Dvbbs.iCreateObject("Scripting.FileSystemObject")
		If objFSO.FolderExists(Server.MapPath(PathValue & DvBoke.BokeUserID ))=False Then
			objFSO.CreateFolder Server.MapPath(PathValue & DvBoke.BokeUserID)
		End If
		If objFSO.FolderExists(Server.MapPath(PathValue & DvBoke.BokeUserID &"/"& uploadpath))=False Then
			objFSO.CreateFolder Server.MapPath(PathValue & DvBoke.BokeUserID &"/"& uploadpath)
		End If
		If Err.Number = 0 Then
			CreatePath = PathValue & DvBoke.BokeUserID &"/"& uploadpath &"/"
		Else
			CreatePath = PathValue
		End If
	Set objFSO = Nothing
End Function

%>