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
String viewTypeString = "";
int viewType = 0;

out.println("<a href=\"viewImages.jsp\">Back to View Images</a><br><br>");

if(request.getParameter("submitViewImages") != null)
{
    viewTypeString = (request.getParameter("imageType")).trim();
    if(viewTypeString.equals("owned"))
    	viewType = 1;
    else if(viewTypeString.equals("popular"))
    	viewType = 2;
    else if(viewTypeString.equals("search"))
    	viewType = 3;

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
        PreparedStatement stmt = null;

    	switch(viewType)
    	{
    		case 1:
                stmt = conn.prepareStatement("select photo_id from images where owner_name = '" + userid + "'");
    			break;
            case 2:
                // selec
                break;
            case 3:
                String radio = (request.getParameter("rankBy")).trim();

		if (radio.equals("default")){

			stmt = conn.prepareStatement("select photo_id, permitted, thumbnail, photo from (select (6*score(1) + 3*score(2) +1*score(3)) as Score, photo_id, permitted, thumbnail, photo from images where contains(subject, ?, 1) >0 or contains(place, ?, 2)>0 or (description, ?, 3)>0) order by Score desc");

			stmt.setString(1, request.getParameter("keywords"));
			stmt.setString(2, request.getParameter("keywords"));
			stmt.setString(3, request.getParameter("keywords"));
		
		}

		else if (radio.equals("recentFirst")) {
			out.println("Not yet implemented");
		}

		else if (radio.equals("recentLast")) {
			out.println("Not yet implemented");
		}
		
	
    		default:
    			out.println("Not yet implemented");
    	}

    	//want to print a list of thumbnails, clicking them should take us to their display page via POST
    	//factoring considerations: make an arraylist of thumbnail data and corresponding ID's
    	//then a single section of code to output them generically

        ResultSet rset = null;
        
        out.println("Your query:<br>" + stmt + ";<br><br>");


    	try
        {
        	
            rset = stmt.executeQuery();
    	}
        catch(Exception ex)
        {
            out.println("<hr>" + ex.getMessage() + "<hr>");
    	}

       /* ArrayList<Integer> idList = new ArrayList<Integer>();

    	while(rset != null && rset.next())
        	idList.add((rset.getInt(1)));*/

        //out.println("<br><button type=\"button\" id=\"newmember\">Add a new member</button><br>");

        if(idList.size() < 1)
        {
            out.println("No results to display");
        }

        out.println("<div style=\"text-align: center\">");
        for(int photoId : idList)
        {
            out.println("<a href=\"#\" onclick=\"ViewOneImage(" + Integer.toString(photoId) + ")\">");
            out.println("<img src=\"GetOnePic?" + Integer.toString(photoId) + "\">");
            out.println("</a>");
            //out.println(name);
            //out.println("<button onclick=\"DeleteMember('" + name + "')\">Delete</button>");
            out.println("<br>");
        }
        out.println("</div>");

        conn.commit();
        conn.close();
    }
}
else
	out.println("Something went wrong");
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
function ViewOneImage(photoId)
{
    post("viewOneImage.jsp", {photoId: photoId});
}
</script>

</BODY>
</HTML>
