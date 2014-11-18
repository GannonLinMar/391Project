<HTML>
<HEAD>
<TITLE>Upload Result</TITLE>
</HEAD>
<BODY>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ page import="oracle.sql.*" %>
<%@ page import="oracle.jdbc.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>

<%@include file="db_login/db_login.jsp" %>

<% 
	String response_message = "";

    if(request.getParameter("submitupload") != null)
    {

        //get the user input from the login page
    	String subject = (request.getParameter("subject")).trim();
        String place = (request.getParameter("place")).trim();
        String when = (request.getParameter("when")).trim();
        String desc = (request.getParameter("desc")).trim();
    	//out.println("<p>Your input username: "+userName+"</p>");

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

        try
        {

		    //Parse the HTTP request to get the image stream
		    DiskFileUpload fu = new DiskFileUpload();
		    List FileItems = fu.parseRequest(request);
		    
		    // Process the uploaded items, assuming only 1 image file uploaded
		    Iterator i = FileItems.iterator();
		    FileItem item = (FileItem) i.next();
		    while (i.hasNext() && item.isFormField()) {
			    item = (FileItem) i.next();
		    }

		    //Get the image stream
		    InputStream instream = item.getInputStream();
		    
	 
		    Statement stmt = conn.createStatement();

		    /*
		     *  First, to generate a unique pic_id using an SQL sequence
		     */
		    ResultSet rset1 = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
		    rset1.next();
		    int pic_id = rset1.getInt(1);

		    //Insert an empty blob into the table first. Note that you have to 
		    //use the Oracle specific function empty_blob() to create an empty blob
		    stmt.execute("INSERT INTO images VALUES(" + Integer.toString(pic_id) + ",userName,\"private\",subject,place,timing,description, empty_blob(),empty_blob())");
	 
		    // to retrieve the lob_locator 
		    // Note that you must use "FOR UPDATE" in the select statement
		    String cmd = "SELECT * FROM pictures WHERE pic_id = "+pic_id+" FOR UPDATE";
		    ResultSet rset = stmt.executeQuery(cmd);
		    rset.next();
		    BLOB myblob = ((OracleResultSet)rset).getBLOB(3);


		    //Write the image to the blob object
		    OutputStream outstream = myblob.getBinaryOutputStream();
		    int size = myblob.getBufferSize();
		    byte[] buffer = new byte[size];
		    int length = -1;
		    while ((length = instream.read(buffer)) != -1)
			outstream.write(buffer, 0, length);
		    instream.close();
		    outstream.close();

	        stmt.executeUpdate("commit");
		    response_message = " Upload OK!  ";
	        conn.close();
	    	}
	    	catch( Exception ex )
			{
			    //System.out.println( ex.getMessage());
			    response_message = ex.getMessage();
			}
	}

	out.println(response_message);    
%>

</BODY>
</HTML>

