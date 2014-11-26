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

Hi, <%= userid%><span style="float:right;"><a href="myinfo.jsp">My Info</a> <a href="logout.jsp">Logout</a> <a href="help.jsp">Help Page</a></span>
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
		String append = null;
		String prepare = null;

		if (timeFrame.equals("week")){
			prepare = "select owner_name, to_number(to_char(timing 'ww')) as Week, count(owner_name) as count from images where timing between to_date('"+start+"', 'YYYY MM DD') and to_date('"+end+"', 'YYYY MM DD') ";

		}

		else if (timeFrame.equals("month")){
			prepare = "select owner_name, to_number(to_char(timing 'mm')) as Month, count(owner_name) as count from images where timing between to_date('"+start+"', 'YYYY MM DD') and to_date('"+end+"', 'YYYY MM DD') ";

		}		

		else if (timeFrame.equals("year")){
			prepare = "select owner_name, to_number(to_char(timing 'yy')) as Year, count(owner_name) as count from images where timing between to_date('"+start+"', 'YYYY MM DD') and to_date('"+end+"', 'YYYY MM DD') ";

		}

		//check what is empty and what is filled in

		if (user.equals("") && subject.equals("")){
			append = "group by owner_name order by count asc";

		}
	
		else if (user.equals("")){
			append = "and subject = '"+subject+"' group by owner_name order by count asc";

		}

		else if (subject.equals("")){
			append = "and owner_name = '"+user+"' group by owner_name order by count asc";

		}

		else{
			append = "and owner_name = '"+user+"' and subject = '"+subject+"' group by owner_name order by count asc";

		}
		out.println(prepare + append);

		stmt = conn.prepareStatement(prepare+append);

	ResultSet rset = null;

		try{
			rset = stmt.executeQuery();
		}
	
	
		catch(Exception ex){
			out.println("<hr>" + ex.getMessage() + "<hr>");
		}	

		while (rset != null && rset.next()) {
			out.println(rset.getString(1));
			out.println(rset.getInt(2));
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
