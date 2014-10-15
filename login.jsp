<HTML>
<HEAD>
<TITLE>Login Result</TITLE>
</HEAD>
<BODY>
<!--A simple example to demonstrate how to use JSP to 
    connect and query a database. 
    @author  Hong-Yu Zhang, University of Alberta
 -->
<%@ page import="java.sql.*" %>

<%@include file="db_login/db_login.jsp" %>

<% 

        if(request.getParameter("submitlogin") != null)
        {

	        //get the user input from the login page
        	String userName = (request.getParameter("username")).trim();
	        String passwd = (request.getParameter("password")).trim();
        	out.println("<p>Your input username: "+userName+"</p>");
        	out.println("<p>Your input password: "+passwd+"</p>");


	        //establish the connection to the underlying database
        	Connection conn = null;
	
	        String driverName = "oracle.jdbc.driver.OracleDriver";
            String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	
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
	

	        //select the user table from the underlying db and validate the user name and password
        	Statement stmt = null;
	        ResultSet rset = null;
        	String sql = "select password from users where user_name = '"+userName+"'";
	        out.println("Your login query:<br>" + sql);
        	try{
	        	stmt = conn.createStatement();
		        rset = stmt.executeQuery(sql);
        	}
	
	        catch(Exception ex){
		        out.println("<hr>" + ex.getMessage() + "<hr>");
        	}

	        String truepwd = "";
	
        	while(rset != null && rset.next())
	        	truepwd = (rset.getString(1)).trim();
	
        	//display the result
	        if(passwd.equals(truepwd))
		        out.println("<p><b>Successfully logged in.</b></p>");
        	else
	        	out.println("<p><b>Either the username or password is incorrect.</b></p>");

                try{
                        conn.close();
                }
                catch(Exception ex){
                        out.println("<hr>" + ex.getMessage() + "<hr>");
                }
        }
        else //no submission so redirect back to login page
        {
                out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.html\" />");
        }      
%>

</BODY>
</HTML>

