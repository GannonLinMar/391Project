<HTML>
<HEAD>
<TITLE>Upload Image</TITLE>
<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
%>
<HEAD>
<BODY>

<a href=".">Back to Home</a><br><br>

<FORM name = "UploadForm" action = "uploadOne.jsp" method = "post" enctype="multipart/form-data">
Image: <INPUT type = "file" name = "file"><br>
Subject: <INPUT type = "text" name = "subject" maxlength=50><br>
Location: <INPUT type = "text" name = "place" maxlength=50><br>
Time: <INPUT type = "text" name = "when" maxlength=50><br>
Description: <INPUT type = "text" name = "desc" maxlength=100><br>
Permissions: <input type="radio" name="permit" value="private" checked="checked">Private
<input type="radio" name="permit" value="public">Public
<input type="radio" name="permit" value="group">Only this group: 
<INPUT type = "text" name = "groupName" maxlength=50><br>
<INPUT type = "submit" name = "submitupload" value = "Upload">
</FORM>
<!-- <a href="index.jsp">Back to Home</a> -->
</BODY>
</HTML>
