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

Hi, <%= userid%><span style="float:right;"><a href="myinfo.jsp">My Info</a> <a href="logout.jsp">Logout</a> <a href="help.jsp">Help Page</a></span>
<hr>
<h1>Main Menu</h1>
<br>
<a href="upload.jsp">Upload One Image</a>
<br>
<a href="uploadFolder.jsp">Upload A Folder Of Images</a>
<br>
<a href="groups.jsp">Manage Your Groups</a>
<br>
<a href="viewImages.jsp">View Images</a>

<%
userid = (String)session.getAttribute("userid");
if(userid != null)
if(userid.equals("admin"))
	out.println("<br> <a href='adminModule.jsp'>Admin Module</a>");
%>

</BODY>
</HTML>
