<HTML>
<HEAD>

</HEAD>

<%@ page import ="java.sql.*" %>
<%

	if(request.getParameter("Submit") != null)
	{

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

		//are all the fields filled out?

		

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
		catch{
			out.println("<hr>" + ex.getMessage() + "<hr>");
		}

		//check if the username already exists
		Statement statement = null;
		ResultSet resultset = null;
		String sql = "select count(id) from login where id = '"+username+"'";
		out.println(sql);

		try{
			statement.conn.createStatement();
			resultset = statement.executeQuery(sql);
		}

		catch{(Exception ex)
			out.println("<hr>" + ex.getMessage() + "<hr>");
		}

		//if there's one of the same username, reject and goto fail html

		//if there is zero of the given username, insert it, commit and goto success


		//close the connection
		try{
			conn.close();
		}

		catch{(Exception ex)
			out.println("<hr>" + ex.getMessage() + "<hr>");
		}


	}

%>
</BODY>
</HTML>

