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
String user = "";
String subject = "";
String start = "";
String end = "";
if(request.getParameter("timeFrame") != null) 
{
	user = (request.getParameter("user")).trim();
    subject = (request.getParameter("subject")).trim();
    start = (request.getParameter("start")).trim();
    end = (request.getParameter("end")).trim();
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

		if (timeFrame.equals("WEEK"))
		{
			prepare = " to_number(to_char(timing, 'ww')) as Week, count(*) as count from images where ";
		}
		else if (timeFrame.equals("MONTH"))
		{
			prepare = " to_number(to_char(timing, 'mm')) as Month, count(*) as count from images where ";
		}		
		else if (timeFrame.equals("YEAR"))
		{
			prepare = " to_number(to_char(timing, 'yy')) as Year, count(*) as count from images where ";
		}

		String timeString = null;
		if(start.equals("") || end.equals(""))
			timeString = "1 = 1 ";
		else
			timeString = "timing between to_date('"+start+"', 'YYYY MM DD') and to_date('"+end+"', 'YYYY MM DD') ";

		//check what is empty and what is filled in

		String timeGroup = "";
		if (timeFrame.equals("WEEK"))
		{
			timeGroup = "to_number(to_char(timing, 'ww'))";
		}
		else if (timeFrame.equals("MONTH"))
		{
			timeGroup = "to_number(to_char(timing, 'mm'))";
		}		
		else if (timeFrame.equals("YEAR"))
		{
			timeGroup = "to_number(to_char(timing, 'yy'))";
		}

		if (user.equals("") && subject.equals("")) //neither specified
		{
			first = "select owner_name, subject, ";

			append = "group by owner_name, subject, " + timeGroup + " order by count asc";
		}
		else if (user.equals("")) //subject specified
		{
			first = "select owner_name, '____', ";

			append = " and subject = '"+subject+"' group by owner_name, " + timeGroup + " order by count asc";
		}
		else if (subject.equals("")) //owner specified
		{
			first = "select '____', subject, ";

			append = " and owner_name = '"+user+"' group by subject, " + timeGroup + " order by count asc";
		}
		else
		{
			first = "select '____', '____', ";
			append = " and owner_name = '"+user+"' and subject = '"+subject+"' group by " + timeGroup + " order by count asc";
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
		out.println("<td>" + timeFrame + "</td>");
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

<script>
//http://stackoverflow.com/questions/133925/javascript-post-request-like-a-form-submit
function post(path, params) {
    var method = "post";
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);

    for(var key in params)
    {
        if(params.hasOwnProperty(key))
        {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
         }
    }

    document.body.appendChild(form);
    form.submit();
}
</script>

<script>
function Again()
{
    post("Olap.jsp", {
    user: <%= "\"" + user + "\"" %>
	, subject: <%= "\"" + subject + "\"" %>
	, start: <%= "\"" + start + "\"" %>
	, end: <%= "\"" + end + "\"" %>
	, timeFrame: document.getElementById("olapForm").elements["timeFrame"].value
	});
}
</script>


<br><br>
<h2>Drill Down/Roll Up</h2>
<FORM id = "olapForm" name = "Drill Down/Roll Up form" action = "Olap.jsp" method = "post"">
<table>
<tr>
<td align="right">Time frame: </td><td align="left"><input type="radio" name="timeFrame" value="WEEK" checked="checked">Weekly
<input type="radio" name="timeFrame" value="MONTH">Monthly
<input type="radio" name="timeFrame" value="YEAR">Yearly
</td>
</tr>
<tr>
<td align="right"><button type='button' onclick = 'Again()'>Submit</button></td>
</tr>
</table>
</FORM>
<br><br><a href="index.jsp">Back to Home</a>

</BODY>
</HTML>
