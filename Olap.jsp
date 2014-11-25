<HTML>
<HEAD>
<TITLE>OLAP Cube Generator</TITLE>
<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
if(!userid.equals("admin"))
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=index.jsp\" />");
%>


<HEAD>
<BODY>

Hi, <%= userid%><span style="float:right;"><a href="logout.jsp">Logout</a></span>
<hr>
<br>

<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ page import="oracle.sql.*" %>
<%@ page import="oracle.jdbc.*" %>


<%@include file="db_login/db_login.jsp" %>

<%    
	if(request.getParameter("submit") != null)
        {
            String user = (request.getParameter("user")).trim();
            String subject = (request.getParameter("subject")).trim();
            String start = (request.getParameter("start")).trim();
            String end = (request.getParameter("end")).trim();
            String timeFrame = (request.getParameter("timeFrame")).trim();}


	//establish the connection to the underlying database
	Connection conn = null;

    String driverName = "oracle.jdbc.driver.OracleDriver";

    //load and register the driver
    try
    {
		Class drvClass = Class.forName(driverName); 
    	DriverManager.registerDriver((Driver) drvClass.newInstance());
	}
    catch(Exception ex)
    {
        out.println("<hr>" + ex.getMessage() + "<hr>");
    }

    //establish the connection
	try
    {
        conn = DriverManager.getConnection(dbstring, db_username, db_password);
		conn.setAutoCommit(false);
    }
	catch(Exception ex){
    
        out.println("<hr>" + ex.getMessage() + "<hr>");
	}

	String query="SELECT DATE, COUNT(photo_id) FROM IMAGES WHERE";
%>

<FORM name = "OLAPform" action = "Olap.jsp" method = "post" enctype="multipart/form-data">
<table>
<tr>
<td align="right">Time frame: </td><td align="left"><input type="radio" name="timeFrame" value="week" checked="user">Weekly
<input type="radio" name="timeFrame" value="month">Monthly
<input type="radio" name="timeFrame" value="year">Yearly
</td>
</tr>
<tr>
<td align="right"><INPUT type = "submit" name = "submitupload" value = "Submit"></td>
</tr>
</table>
</FORM>

<br><a href="index.jsp">Back to Home</a>
</BODY>
</HTML>
