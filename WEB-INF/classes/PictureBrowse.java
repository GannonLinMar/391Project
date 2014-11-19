import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import oracle.jdbc.driver.*;
import java.text.*;
import java.net.*;

/**
 *  As it stands right now, I'm basically canabalizing the prof's code --EM
 *  @author  Li-Yan Yuan
 *
 */
public class PictureBrowse extends HttpServlet implements SingleThreadModel {
    

    public void doGet(HttpServletRequest request,
		      HttpServletResponse res)
	throws ServletException, IOException {

	res.setContentType("text/html");
	PrintWriter out = res.getWriter ();

	out.println("<html>");
	out.println("<head>");
	out.println("<title> Photo List </title>");
	out.println("</head>");
	out.println("<body bgcolor=\"#000000\" text=\"#cccccc\" >");
	out.println("<center>");
	out.println("<h3>The List of Images </h3>");


	try {
		/*
		*	
		*Need to change this query to 
		* "select id from images where user_name = '"+user_name+"'", 
		* but catch is importing the data from doViewImages; maybe
		* get session attribs
		*/
	    String query = "select id from photos";

	    Connection conn = getConnected();
	    Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);
	    String p_id = "";

	    while (rset.next() ) {

		/* This p_id variable returns the first attrib in this table:
		*   picture( photo_id: integer, title: varchar, place: varchar, 
 		*   sm_image: blob,   image: blob ), so we need to change it to 
		* the correct value for our image table
		*/
		p_id = (rset.getObject(1)).toString();

	       // specify the servlet for the image
               out.println("<a href=\"/GetOnePic?big"+p_id+"\">");
	       // specify the servlet for the thumbnail
	       out.println("<img src=\"/GetOnePic?"+p_id +
	                   "\"></a>");
	    }
	    stmt.close();
	    conn.close();
	} catch ( Exception ex ){ out.println( ex.toString() );}
    
	//out.println("<P><a href=\"/yuan/servlets/logicsql.html\"> Return </a>");
	out.println("</body>");
	out.println("</html>");
    }
    
    /*
     *   Connect to the specified database
     */

	/* 
	* Again, need to find some way to NOT hardcode this next bit
	*/
    private Connection getConnected() throws Exception {

	String username = "emar";
	String password = "Rogue_81";
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




