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

Hi, <%= userid%><span style="float:right;"><a href="logout.jsp">Logout</a></span>
<hr>
<br>

<FORM name = "ViewForm" action = "doViewImages.jsp" method = "post">
<input type="radio" name="imageType" value="owned" checked="checked">View My Images<br>
<input type="radio" name="imageType" value="popular">View Popular Images<br>
<div style="border: thin dotted gray; width: 450">
<input type="radio" name="imageType" value="search">Search Images<br>
Keywords: <INPUT type = "text" name = "keywords" maxlength=200> (seperate with spaces)<br>
Time: TODO - specify time somehow <br>
Rank by: <input type="radio" name="rankBy" value="default" checked="checked">Default
<input type="radio" name="rankBy" value="recentFirst">Most to least recent
<input type="radio" name="rankBy" value="recentLast">Least to most recent
</div>
<INPUT type = "submit" name = "submitViewImages" value = "Submit">
</FORM>

</BODY>
</HTML>