import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

/**
 *  This servlet sends one picture stored in the table below to the client 
 *  who requested the servlet.
 *
 *   picture( photo_id: integer, title: varchar, place: varchar, 
 *            sm_image: blob,   image: blob )
 *
 *  The request must come with a query string as follows:
 *    GetOnePic?12:        sends the picture in sm_image with photo_id = 12
 *    GetOnePic?big12: sends the picture in image  with photo_id = 12
 *
 *  Cannibalizing his code again -- EM
 *  @author  Li-Yan Yuan
 *
 */
public class GetOnePic extends HttpServlet 
    implements SingleThreadModel {

    /**
     *    This method first gets the query string indicating PHOTO_ID,
     *    and then executes the query 
     *          select image from yuan.photos where photo_id = PHOTO_ID   
     *    Finally, it sends the picture to the client
     */

    public void doGet(HttpServletRequest request,
		      HttpServletResponse response)
	throws ServletException, IOException {
	
	//  construct the query  from the client's QueryString
	String picid  = request.getQueryString();
	String query;
	String extQuery;

	// because we found all the photo ids for this username, can
	// just ask for those photo ids here to simplify query
	if ( picid.startsWith("big") )
	{
	    query = "select photo from images where photo_id=" + picid.substring(3);
	    extQuery = "select extension from photoExt where photo_id = " + picid.substring(3);
	}
	else
	{
	    query = "select thumbnail from images where photo_id=" + picid;
	    extQuery = "select extension from photoExt where photo_id = " + picid;
	}

	ServletOutputStream out = response.getOutputStream();

	/*
	 *   to execute the given query
	 */
	Connection conn = null;
	try
	{
	    conn = getConnected();

	    Statement stmt2 = conn.createStatement();
	    ResultSet rset2 = stmt2.executeQuery(extQuery);
	    String ext = "jpg";
	    if ( rset2.next() )
	    {
	    	ext = rset2.getString(1).trim();
	    }

	    Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);

	    if ( rset.next() )
	    {
			response.setContentType("image/" + ext);
			InputStream input = rset.getBinaryStream(1);	    
			int imageByte;
			while((imageByte = input.read()) != -1)
			{
			    out.write(imageByte);
			}
			input.close();
	    } 
	    else 
			out.println("Your query failed: " + query);
	}
	catch( Exception ex )
	{
	    out.println(ex.getMessage() );
	}
	// to close the connection
	finally {
	    try {
	    conn.commit();
		conn.close();
	    } catch ( SQLException ex) {
		out.println( ex.getMessage() );
	    }
	}
    }

    /*
     *   Connect to the specified database
     */
    private Connection getConnected() throws Exception {

	String username = "username";
	String password = "asdfg";
        /* one may replace the following for the specified database */
	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	String driverName = "oracle.jdbc.driver.OracleDriver";

	/*
	 *  to connect to the database
	 */
	Class drvClass = Class.forName(driverName); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	return( DriverManager.getConnection(dbstring,username,password) );
    }
}
