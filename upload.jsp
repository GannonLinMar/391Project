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

<FORM name = "UploadForm" action = "uploadOne.jsp" method = "post">
Image: <INPUT type = "file" name = "file"><br>
Subject: <INPUT type = "text" name = "subject" maxlength=50><br>
Location: <INPUT type = "text" name = "place" maxlength=50><br>
Time: <INPUT type = "text" name = "when" maxlength=50><br>
Description: <INPUT type = "text" name = "desc" maxlength=100><br>
<INPUT type = "submit" name = "submitupload" value = "Upload">
</FORM>

</BODY>
</HTML>