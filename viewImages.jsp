<HTML>
<HEAD>
<TITLE>View Images</TITLE>
<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
%>
<HEAD>
<BODY>

Hi, <%= userid%><span style="float:right;"><a href="myinfo.jsp">My Info</a> <a href="logout.jsp">Logout</a> <a href="help.jsp">Help Page</a></span>
<hr>
<br>

<a href=".">Back to Home</a><br><br>

<FORM name = "ViewForm" action = "doViewImages.jsp" method = "post">
<input type="radio" name="imageType" value="owned" checked="checked">View My Images<br>
<input type="radio" name="imageType" value="popular">View Popular Images<br>
<div style="border: thin dotted gray; width: 500">
<input type="radio" name="imageType" value="search">Search Images<br>
Keywords: <INPUT type = "text" name = "keywords" maxlength=200> (seperate with spaces)<br>
Sort by: <input type="radio" name="rankBy" value="default" checked="checked">Most relevant
<input type="radio" name="rankBy" value="recentFirst">Newest
<input type="radio" name="rankBy" value="recentLast">Oldest <br>
<input type = "radio" name="imageType" value="date">Search by Date <br> 
From: <input type ="text" name ="lower_date" maxlength=10 placeholder="YYYY MM DD"<br>
To: <input type="text" name="upper_date" maxlength=10 placeholder="YYYY MM DD"<br>
</div>
<INPUT type = "submit" name = "submitViewImages" value = "Submit">
</FORM>

</BODY>
</HTML>
