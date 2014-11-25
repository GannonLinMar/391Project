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
<FORM name = "OLAPform" action = "OLAP.jsp" method = "post" enctype="multipart/form-data">
<table>
<tr>
<td align="right">Subject:</td><td align="left"><INPUT type = "text" name = "subject" maxlength=50></td>
</tr>
<tr>
<td align="right">Start Time: </td><td align="left"><INPUT type = "text" name = "rangeStart" maxlength=50 placeholder="YYYY MM DD"></td>
</tr>
<tr>
<td align="right">End Time: </td><td align="left"><INPUT type = "text" name = "rangeEnd" maxlength=50 placeholder="YYYY MM DD"></td>
</tr>
<tr>
<td align="right">Time Frame: </td><td align="left"><input type="radio" name="time_frame" value="weekly" checked="checked">Weekly
<input type="radio" name="time_frame" value="monthly">Monthly
<input type="radio" name="time_frame" value="yearly">Yearly
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
