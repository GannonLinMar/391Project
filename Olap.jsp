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
<%@ page import="java.lang.Object"%>


<%@include file="db_login/db_login.jsp" %>

<%    
if(request.getParameter("submitupload") != null) 
{
	String user = (request.getParameter("user")).trim() + "";
        String subject = (request.getParameter("subject")).trim() + "";
        String start = (request.getParameter("start")).trim();
        String end = (request.getParameter("end")).trim();
        String timeFrame = (request.getParameter("timeFrame")).trim();

	//establish the connection to the underlying database
	Connection conn = null;

	String driverName = "oracle.jdbc.driver.OracleDriver";
  	//load and register the driver
	try
	{
		Class drvClass = Class.forName(driverName); 
		DriverManager.registerDriver((Driver) drvClass.newInstance());
		conn = DriverManager.getConnection(dbstring, db_username, db_password);
		conn.setAutoCommit(false);
	}

	catch(Exception ex){
   
		out.println("<hr>" + ex.getMessage() + "<hr>");
	}
	
	if (conn != null){
	
		PreparedStatement stmt = null;
		stmt = conn.prepareStatement("select owner_name, subject, timing, count(owner_name) as count from images where timing between TO_DATE('"+start+"', 'YYYY MM DD') and TO_DATE('"+end+"', 'YYYY MM DD') group by owner_name order by count asc");

	ResultSet rset = null;

		try{
			rset = stmt.executeQuery();
		}
	
	
		catch(Exception ex){
			out.println("<hr>" + ex.getMessage() + "<hr>");
		}	

		while (rset != null && rset.next()) {
			out.println(rset.next());
		}
	}
	conn.close();

}

else{
	out.println("Empty");
}
		
	
%>

<FORM name = "Drill Down/Roll Up form" action = "Olap.jsp" method = "post" enctype="multipart/form-data">
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
