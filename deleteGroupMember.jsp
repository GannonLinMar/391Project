<HTML>
<HEAD>
<TITLE>Edit Group</TITLE>
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

<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%@include file="db_login/db_login.jsp" %>

<%
String groupName = null;
String deletedMember = null;

if(request.getParameter("groupName") != null && request.getParameter("deletedMember") != null)
{
    groupName = request.getParameter("groupName").trim();
    deletedMember = request.getParameter("deletedMember").trim();

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

    if(conn != null)
    {
        //select the user table from the underlying db and validate the user name and password
    	Statement stmt = null;
        ResultSet rset = null;
        String sqlsub = "(select group_id from groups where group_name = '" + groupName + "' and user_name = '" + userid + "')";    
        String sql2 = " and friend_id = '" + deletedMember + "'";
    	String sql = "delete from group_lists where group_id in " + sqlsub + sql2;
        out.println("Your query:<br>" + sql + ";<br><br>");
        Boolean bSuccess = true;
    	try{
        	stmt = conn.createStatement();
            rset = stmt.executeQuery(sql);
    	}

        catch(Exception ex){
            out.println("<hr>" + ex.getMessage() + "<hr>");
            bSuccess = false;
    	}

        if(bSuccess)
        {
            out.println("Successfully deleted group member");
        }
        else
        {
            out.println("Failed to delete group member");
        }

        conn.commit();
    }
}
%>

</BODY>
</HTML>