<HTML>
<HEAD>

</HEAD>
<BODY>
<%@ page import ="java.sql.*, java.util.*, java.lang.Object" %>
<%



	//set the username and password for the underlying sqlplus user HERE
	String m_username = "emar";
	String m_password = "Rogue_81";
	


	//get everything from form first
	String firstName = (request.getParameter("firstname")).trim();
	String lastName = (request.getParameter("lastname")).trim();
	String address = (request.getParameter("address")).trim();
	String phoneNumber = (request.getParameter("phoneNumber")).trim();
	String username = (request.getParameter("username")).trim();
	String password = (request.getParameter("password")).trim();	

	Connection conn = null;

	String drivername = "oracle.jdbc.driver.OracleDriver";
	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

	try{
		Class drvClass = Class.forName(drivername);
		DriverManager.registerDriver((Driver) drvClass.newInstance());
	}

	catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
	}

	try{
		conn = DriverManager.getConnection(dbstring, m_username, m_password);
		conn.setAutoCommit(false);
	}

	catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
	}

	//check if the username already exists
	Statement statement = null;
	ResultSet resultset = null;
	String sql = "select count(*) from registration where username = '"+username+"'";
	System.out.print(sql);

	try{
		statement = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
        ResultSet.CONCUR_READ_ONLY);
		resultset = statement.executeQuery(sql);
	}

	catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
	}

	//find the count
	resultset.next();
	int count = resultset.getInt(1);
	
	//if there's one of the same username, reject and goto fail html
	if (count > 0){
		String redirect = "registration_failed.html";
		response.sendRedirect(redirect);	
	
	}
	
	//if there is zero of the given username, insert it, commit and goto success
	if (count == 0) {
		try{
			statement = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
        	ResultSet.CONCUR_UPDATABLE);
		String updateString = "insert into registration values ('"+username+"', '"+password+"', '"+firstName+"', '"+lastName+"', '"+address+"', '"+phoneNumber+"')";
		statement.executeUpdate(updateString);
		}

		catch(Exception ex) {
			out.println("<hr>" + ex.getMessage() + "<hr>");
		}
	}


	

	//close the connection
	try{
		conn.close();
	}

	catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
	}


	String redirect = "registration_success.html";
	response.sendRedirect(redirect);

%>

</BODY>
</HTML>

