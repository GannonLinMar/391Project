<HTML>
<HEAD>
<TITLE>Logout</TITLE>
<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
else
{
	session.invalidate();
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
}
%>
<HEAD>
<BODY>
</BODY>
</HTML>