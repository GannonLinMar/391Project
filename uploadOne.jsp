<HTML>
<HEAD>
<TITLE>Upload Result</TITLE>
<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
%>
</HEAD>
<BODY>

Hi, <%= userid%><span style="float:right;"><a href="myinfo.jsp">My Info</a> <a href="logout.jsp">Logout</a> <a href="help.jsp">Help Page</a></span>
<hr>
<br>
<% /***
*This code references the UploadImage.java sample program provided on eClass, written by Fan Deng
*  Licensed under the Apache License, Version 2.0 (the "License");         
*  you may not use this file except in compliance with the License.        
*  You may obtain a copy of the License at                                 
*      http://www.apache.org/licenses/LICENSE-2.0                          
*  Unless required by applicable law or agreed to in writing, software
*  distributed under the License is distributed on an "AS IS" BASIS,
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*  See the License for the specific language governing permissions and
*  limitations under the License. ***/
%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ page import="oracle.sql.*" %>
<%@ page import="oracle.jdbc.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.io.*" %>
<%@ page import= "javax.imageio.*" %>
<%@ page import= "java.awt.image.BufferedImage"%>

<%@include file="db_login/db_login.jsp" %>

<%!
public static BufferedImage shrink(BufferedImage image, int n) {

        int w = image.getWidth() / n;
        int h = image.getHeight() / n;

        BufferedImage shrunkImage =
            new BufferedImage(w, h, image.getType());

        for (int y=0; y < h; ++y)
            for (int x=0; x < w; ++x)
                shrunkImage.setRGB(x, y, image.getRGB(x*n, y*n));

        return shrunkImage;
    }

%>

<% 
	String response_message = "??";


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
        try
        {
		    //Parse the HTTP request to get the image stream
		    DiskFileUpload fu = new DiskFileUpload();
		    List FileItems = fu.parseRequest(request);
		    
		    // Process the uploaded items, assuming only 1 image file uploaded
		    Iterator i = FileItems.iterator();
		    FileItem image = (FileItem) i.next();
		    FileItem item = (FileItem) i.next();
		    String  subject = item.getString();
		    item = (FileItem) i.next();
		    String place = item.getString();
		    item = (FileItem) i.next();
		    String when = item.getString();
		    item = (FileItem) i.next();
		    String desc = item.getString();

		    item = (FileItem) i.next();
		    String permit = item.getString(); //public, private, group
		    item = (FileItem) i.next();
		    String groupName = item.getString();

		    if(image.getSize() < 1)
		    {
		    	throw new Exception("No image specified");
			}

		    //Get the image stream
		    InputStream instream = image.getInputStream();
		    InputStream thumbstream  = image.getInputStream();

		    BufferedImage img = ImageIO.read(thumbstream);
	    	BufferedImage thumbNail = shrink(img, 3);

		    Statement stmt = conn.createStatement();

		    /*
		     *  First, to generate a unique pic_id using an SQL sequence
		     */
		    //we don't have a sequence and I have no idea how to make one
			    //ResultSet rset1 = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
			    //rset1.next();
		    int pic_id = 0;

		    //////////////
		    //////////////

		    String prequery = "select max(photo_id) from images";
	        Boolean presuccess = true;
	        ResultSet rset2;
	        Statement stmt2 = conn.createStatement();
	        try
	        {
	            stmt2 = conn.createStatement();
	            rset2 = stmt2.executeQuery(prequery);

	            while(rset2 != null && rset2.next())
	                pic_id = rset2.getInt(1) + 1;
	        }
	        catch(Exception ex)
	        {
	            response_message = "<hr>" + "Error retrieving next image id: " + ex.getMessage() + "<hr>";
	            presuccess = false;
	            conn.commit();
	            conn.close();
	        }

		    //////////////
		    //////////////

		    if(presuccess)
		    {
		    //Insert an empty blob into the table first. Note that you have to 
		    //use the Oracle specific function empty_blob() to create an empty blob
		    String permitted = "2"; //private by default
		    if(permit.equals("public"))
		    	permitted = "1";
		    else if(permit.equals("group"))
		    {
		    	String sqlpre = "SELECT group_id from groups where group_name = '" + groupName + "' and "
		    		+ "user_name = '" + userid + "'";
		    	out.println("Pre-query: " + sqlpre + "<br>");
		    	ResultSet rset3 = stmt.executeQuery(sqlpre);
		    	rset3.next();
		    	int groupid = rset3.getInt(1);
		    	permitted = Integer.toString(groupid);
			}
		    String values = Integer.toString(pic_id) + ", '" + userid + "', " + permitted + ", '"
		    	+ subject + "', '" + place + "', TO_DATE('" + when + "','YYYY MM DD'), '" + desc + "', " + " empty_blob(), "
		    	+ "empty_blob() ";
		    String sqlInsert = "INSERT INTO images VALUES(" + values + ")";

		    out.println("Your query is: " + sqlInsert + "<br><br>");

		    stmt.execute(sqlInsert);


		    //store the file extension
		    String fullpath = image.getName();
		    out.println(fullpath);
		    String ext = FilenameUtils.getExtension(fullpath);
		    String extvalues = "(" + Integer.toString(pic_id) + ", '" + ext +  "')";
		    String extension = "INSERT INTO photoExt values " + extvalues + "";
		    out.println("Extension query: " + extension + "<br><br>");
		    stmt.execute(extension);


		    // to retrieve the lob_locator 
		    // Note that you must use "FOR UPDATE" in the select statement
		    String cmd = "SELECT * FROM images WHERE photo_id = "+ pic_id + " FOR UPDATE";

		    out.println("Attempting to insert BLOB...<br><br>");

		    ResultSet rset = stmt.executeQuery(cmd);
		    rset.next();
		    BLOB myblob = ((OracleResultSet)rset).getBLOB("PHOTO");
		    BLOB mythumb = ((OracleResultSet)rset).getBLOB("THUMBNAIL");


		    //Write the image to the blob object
		    OutputStream outstream = myblob.getBinaryOutputStream();
		    OutputStream outthumb = mythumb.getBinaryOutputStream();
		    
		    ImageIO.write(thumbNail, (String)ext, outthumb);

		    int size = myblob.getBufferSize();
		    byte[] buffer = new byte[size];
		    int length = -1;

		    while ((length = instream.read(buffer)) != -1)
			outstream.write(buffer, 0, length);

		    instream.close();
		    thumbstream.close();
		    outstream.close();
		    outthumb.close();

		    response_message = "Upload OK";
		    stmt.executeUpdate("commit");
		    conn.commit();
	        conn.close();
	    	}
    	}
    	catch( Exception ex )
		{
		    response_message = "ERROR: " + ex.getMessage();
		}
	}
	else
		response_message = "Failed to connect to DB";

	out.println(response_message);

	out.println("<br><br><a href=\"upload.jsp\">Back to Upload</a>");
%>
<br><a href="index.jsp">Back to Home</a>
</BODY>
</HTML>
