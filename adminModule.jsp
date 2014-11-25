<HTML>
<HEAD>
<TITLE>Admin Form</TITLE>
<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
if(!userid.equals("admin"))
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=index.jsp\" />");
%>
<HEAD>
<BODY>
Hi, <%= userid%><span style="float:right;"><a href="myinfo.jsp">My Info</a> <a href="logout.jsp">Logout</a></span>
<hr>
<br>
<p>Form for OLAP report generation.</p>
<FORM name = "OLAPform" action = "Olap.jsp" method = "post" enctype="multipart/form-data">
<table>
<tr>
<td align="right">First parameter to query on: </td><td align="left"><input type="radio" name="Xvalue" value="weekly" checked="user">User
<input type="radio" name="Xvalue" value="subject">Subject
<input type="radio" name="Xvalue" value="time">Time
</td>
</tr>
<tr>
<td align="right">  Second parameter to query on: </td><td align="left"><input type="radio" name="Yvalue" value="weekly" checked="user">User
<input type="radio" name="Yvalue" value="subject">Subject
<input type="radio" name="Yvalue" value="time">Time
</td>
</tr>
<tr>
<td align="right"><INPUT type = "submit" name = "submitupload" value = "Submit"></td>
</tr>
</table>
</FORM>
<a href=".">Back to Home</a>



</BODY>
</HTML>
