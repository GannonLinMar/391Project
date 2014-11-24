<HTML>
<HEAD>
<TITLE>Upload Folder</TITLE>
<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
%>
<HEAD>
<BODY>

Hi, <%= userid%><span style="float:right;"><a href="myinfo.jsp">My Info</a> <a href="logout.jsp">Logout</a></span>
<hr>
<br>

You can upload multiple images at once by ctrl+clicking or shift+clicking
<FORM name = "UploadForm" action = "uploadMultiple.jsp" method = "post" enctype="multipart/form-data">
<table>
<tr>
<td align="right">Image:</td><td align="left"> <INPUT type = "file" name = "file" multiple></td>
</tr>
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
