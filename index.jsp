<HTML>
<HEAD>
<TITLE>Home</TITLE>

<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
%>

</HEAD>
<BODY>

Hi! You appear to be logged in as <%= userid%>.
<br><br>
<a href="upload.jsp">Upload One Image</a>
<br>
<a href="groups.jsp">Manage Your Groups</a>

</BODY>
</HTML>