<html><head><title>File Upload Applet</title></head>
<script>
<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
%>
</script>
<BODY>
Hi, <%= userid%><span style="float:right;"><a href="logout.jsp">Logout</a></span>
<hr>
<br>


	
	<table border="0" cellpadding="7" cellspacing="0" width="640">
		<tbody><tr><td colspan="2" align="center"><font color="red" face="arial" size="+1"><b><u>JUpload - File Upload Applet</u></b></font></td></tr>
		<tr height="20"></tr>
		<tr><td colspan="2" bgcolor="#3f7c98"><center><font color="#ffffff">FileUpload Applet</font></center></td></tr>
		<tr><td colspan="2" align="center">

<applet code="applet-basic_files/wjhk.JUploadApplet" name="JUpload" archive="applet-basic_files/wjhk.jar" mayscript="" height="300" width="640">
    <param name="CODE" value="wjhk.jupload2.JUploadApplet">
    <param name="ARCHIVE" value="wjhk.jupload.jar">
    <param name="type" value="application/x-java-applet;version=1.4">
    <param name="scriptable" value="false">    
    <param name="postURL"
    value="http://luscar.cs.ualberta.ca:8080/yuan/parseRequest.jsp?URLParam=URL+Parameter+Value">
    <param name="nbFilesPerRequest" value="2">    
Java 1.4 or higher plugin required.
</applet>

			</td>
		</tr>
        </tbody></table>

<FORM name = "UploadForm" action = "uploadOne.jsp" method = "post" enctype="multipart/form-data">
<table>
<tr>
<td align="right">Subject:</td><td align="left"><INPUT type = "text" name = "subject" maxlength=50></td>
</tr>
<tr>
<td align="right">Location: </td><td align="left"><INPUT type = "text" name = "place" maxlength=50></td>
</tr>
<tr>
<td align="right">Time: </td><td align="left"><INPUT type = "text" name = "when" maxlength=50 placeholder="YYYY MM DD"></td>
</tr>
<tr>
<td align="right">Permissions: </td><td align="left"><input type="radio" name="permit" value="private" checked="checked">Private
<input type="radio" name="permit" value="public">Public
<input type="radio" name="permit" value="group">Only this group: 
<INPUT type = "text" name = "groupName" maxlength=50 placeholder="Group Name"></td>
</tr>
<tr>
<td align="right"><INPUT type = "submit" name = "submitupload" value = "Upload"></td>
</tr>
</table>
</FORM>
<a href=".">Back to Home</a>
</BODY>
</HTML>
