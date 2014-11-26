<HTML>
<HEAD>
<TITLE>Home</TITLE>
<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
%>

<HEAD>
<BODY>

Hi, <%= userid%><span style="float:right;"><a href="logout.jsp">Logout</a></span>
<hr>
<br>

<h1>Welcome to the Help Page!</h1>
<p>To be implemented!</p>
<!--Display user documentation, convert to html using: http://www.textfixer.com/html/convert-text-html.php-->



<br><a href="index.jsp">Back to Home</a>
</BODY>
</HTML>
