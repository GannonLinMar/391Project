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
if(request.getParameter("timeFrame") != null) 
{
	String user = (request.getParameter("user")).trim();
    String subject = (request.getParameter("subject")).trim();
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
	
	if (conn != null)
	{
	
		PreparedStatement stmt = null;
		String append = null;
		String prepare = null;
		String first = null;

		if (timeFrame.equals("week"))
		{
			prepare = " to_number(to_char(timing, 'ww')) as Week, count(*) as count from images where ";
		}
		else if (timeFrame.equals("month"))
		{
			prepare = " to_number(to_char(timing, 'mm')) as Month, count(*) as count from images where ";
		}		
		else if (timeFrame.equals("year"))
		{
			prepare = " to_number(to_char(timing, 'yy')) as Year, count(*) as count from images where ";
		}

		String timeString = null;
		if(start.equals("") || end.equals(""))
			timeString = "1 = 1 ";
		else
			timeString = "timing between to_date('"+start+"', 'YYYY MM DD') and to_date('"+end+"', 'YYYY MM DD') ";

		//check what is empty and what is filled in

		if (user.equals("") && subject.equals("")) //neither specified
		{
			first = "select owner_name, subject, ";

			append = "group by owner_name, subject, timing order by count asc";
		}
		else if (user.equals("")) //subject specified
		{
			first = "select owner_name, '____', ";

			append = " and subject = '"+subject+"' group by owner_name, timing order by count asc";
		}
		else if (subject.equals("")) //owner specified
		{
			first = "select '____', subject, ";

			append = " and owner_name = '"+user+"' group by subject, timing order by count asc";
		}
		else
		{
			first = "select '____', '____', ";
			append = " and owner_name = '"+user+"' and subject = '"+subject+"' group by timing order by count asc";
		}

		out.println("Your query: <br>" + first + prepare + timeString + append + "<br><br>");

		stmt = conn.prepareStatement(first + prepare + timeString + append);

		ResultSet rset = null;

		try
		{
			rset = stmt.executeQuery();
		}
		catch(Exception ex)
		{
			out.println("<hr>" + ex.getMessage() + "<hr>");
		}	

		ArrayList<String> resOwners = new ArrayList<String>();
		ArrayList<String> resSubjects = new ArrayList<String>();
		ArrayList<Integer> resTimings = new ArrayList<Integer>();
		ArrayList<Integer> resCounts = new ArrayList<Integer>();

		int totalRes = 0;

		while (rset != null && rset.next())
		{
			resOwners.add(rset.getString(1)); //owner
			resSubjects.add(rset.getString(2)); //subject
			resTimings.add(rset.getInt(3)); //timing info
			resCounts.add(rset.getInt(4)); //count
			totalRes++;
		}

		out.println("<table>");
		out.println("<tr>");
		out.println("<td>Owner</td>");
		out.println("<td>Subject</td>");
		out.println("<td>Timing</td>");
		out.println("<td>Count</td>");
		out.println("</tr>");

		int countTotal = 0;

		for(int q = 0; q < totalRes; q++)
		{
			String resOwner = resOwners.get(q);
			String resSubject = resSubjects.get(q);
			Integer resTiming = resTimings.get(q);
			Integer resCount = resCounts.get(q);

			if(resOwner.equals("____"))
				resOwner = "";
			if(resSubject.equals("____"))
				resSubject = "";				

			out.println("<tr>");
			out.println("<td>" + resOwner + "</td>");
			out.println("<td>" + resSubject + "</td>");
			out.println("<td>" + Integer.toString(resTiming) + "</td>");
			out.println("<td>" + Integer.toString(resCount) + "</td>");
			out.println("</tr>");

			countTotal += resCount;
		}
		out.println("<table>");

		out.println("<br>Total Count: " + Integer.toString(countTotal) + "<br>");


	conn.commit();
	conn.close();
	}
	
}
else
{
	out.println("No form was submitted<br>");
}
		
%>

<!--
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
-->