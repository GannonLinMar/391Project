<HTML>
<HEAD>
<TITLE>Home</TITLE>

<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.html\" />");
%>

</HEAD>
<BODY>

Hi! You appear to be logged in as <%= userid%>.

</BODY>
</HTML>