<HTML>
<HEAD>
<TITLE>View Image</TITLE>
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
<%@ page import="java.text.*" %>

<%@include file="db_login/db_login.jsp" %>

<%
int photoId = 0;

out.println("<a href=\"viewImages.jsp\">Back to View Images</a><br><br>");

if(request.getParameter("photoId") != null)
{
    photoId = Integer.parseInt(request.getParameter("photoId"));

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
        String sqlAttribs = " owner_name, permitted, subject, place, timing, description ";
        String sql = "select" + sqlAttribs + "from images where photo_id = " + Integer.toString(photoId);

    	Statement stmt = null;
        ResultSet rset = null;
        
        out.println("Your query:<br>" + sql + ";<br><br>");

    	try
        {
        	stmt = conn.createStatement();
            rset = stmt.executeQuery(sql);
    	}
        catch(Exception ex)
        {
            out.println("<hr>" + ex.getMessage() + "<hr>");
    	}

    	while(rset != null && rset.next())
        {
            String owner = rset.getString("owner_name");
            int permitted = rset.getInt("permitted");
            String subject = rset.getString("subject");
            String place = rset.getString("place");
            java.util.Date timing = rset.getDate("timing");
            Format formatter = new SimpleDateFormat("yyyy-MM-dd");
            String time = formatter.format(timing);
            String description = rset.getString("description");
        	
            Boolean allowed = false;
            if(permitted == 3) //public
                allowed = true;
            else if(permitted == 2) //group
            {
                allowed = true; //TODO
            }
            else if(permitted == 1 && owner.equals(userid))
                allowed = true;

            out.println("<div style=\"text-align: center\">");
            if(allowed)
            {
                out.println("<img src=\"GetOnePic?big" + Integer.toString(photoId) + "\">");
                out.println("<br><br><br>");
                out.println("Subject: " + subject + "<br><br>");
                out.println("Place: " + place + "<br><br>");
                out.println("Time: " + time + "<br><br>");
                out.println("Description: " + description + "<br>");
            }
            else
            {
                out.println("You do not have permission to view this image");
            }
            out.println("</div>");
        }

        // TODO: display, and allow updating of all those attributes

        conn.commit();
        conn.close();
    }
}
else
	out.println("No image ID specified");
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