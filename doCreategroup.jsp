<HTML>
<HEAD>
<TITLE>My Groups</TITLE>
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

<%@ page import="java.sql.*" %>

<%@include file="db_login/db_login.jsp" %>

<%
    if(request.getParameter("newname") != null)
    {
        String groupname = (request.getParameter("newname")).trim();

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

    	Statement stmt = null;
        ResultSet rset2 = null;

        int newGroupId = 0;

        String prequery = "select max(group_id) from groups";
        Boolean presuccess = true;
        try
        {
            stmt = conn.createStatement();
            rset2 = stmt.executeQuery(prequery);
        }
        catch(Exception ex)
        {
            out.println("<hr>" + "Error retrieving next id: " + ex.getMessage() + "<hr>");
            presuccess = false;
            conn.commit();
        }
        if(presuccess)
        {
            while(rset2 != null && rset2.next())
                newGroupId = rset2.getInt(1);

            ResultSet rset = null;

            newGroupId += 1;

            //insert the new group
        	String sql = "insert into groups values (" + Integer.toString(newGroupId) + ", '" + userid + "', '" + groupname + "', SYSDATE)";
            out.println("Your query:<br>" + sql + ";<br><br>");
            Boolean success = true;

            //insert the group creator himself into the group
            String firstValues = Integer.toString(newGroupId) + ", '" + userid + "', SYSDATE, 'This is me'";
            String firstInsert = "INSERT INTO group_lists values (" + firstValues + ")";

        	try
            {
            	//stmt = conn.createStatement();
                stmt.execute(sql);
                stmt.execute(firstInsert);
        	}
            catch(Exception ex)
            {
                out.println("<hr>" + ex.getMessage() + "<hr>");
                success = false;
                out.println("<br><a href=\"groups.jsp\">Back to groups</a>");
        	}
            if(success)
            {
                out.println("Succesfully added group!<br>");
                out.println("<a href=\"groups.jsp\">Back to groups</a>");
            }

            if(success)
                conn.commit();
            else
                conn.rollback();
            conn.close();            
        }
    }
    else //no submission so redirect back
    {
            out.println("<meta http-equiv=\"refresh\" content=\"0; url=groups.jsp\" />");
    }      
%>

</BODY>
</HTML>
