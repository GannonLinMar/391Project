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
Hi, <%= userid%><span style="float:right;"><a href="myinfo.jsp">My Info</a> <a href="logout.jsp">Logout</a> <a href="help.jsp">Help Page</a></span>
<hr>
<br>
<p>Form for OLAP report generation.</p>
<FORM name = "OLAPform" action = "Olap.jsp" method = "post">
<table>
<tr>
<td align="right">User: </td><td align="left"><INPUT type = "text" name = "user" maxlength=50></td>
</tr>
<tr>
<td align="right">Subject:</td><td align="left"><INPUT type = "text" name = "subject" maxlength=50></td>
</tr>
<tr>
<td align="right">Start Date: </td><td align="left"><INPUT type = "text" name = "start" maxlength=50 placeholder="YYYY MM DD"></td>
</tr>
<tr>
<td align="right">End Date: </td><td align="left"><INPUT type = "text" name = "end" maxlength=50 placeholder="YYYY MM DD"></td>
</tr>
<tr>
<td align="right">Time frame: </td><td align="left"><input type="radio" name="timeFrame" value="WEEK" checked="checked">Weekly
<input type="radio" name="timeFrame" value="MONTH">Monthly
<input type="radio" name="timeFrame" value="YEAR">Yearly
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
