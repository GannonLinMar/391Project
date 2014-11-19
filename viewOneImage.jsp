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

        //ArrayList<Integer> idList = new ArrayList<Integer>();

    	while(rset != null && rset.next())
        	; //idList.add((rset.getInt(1)));

        // TODO: display, and allow updating of all those attributes

        /*
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
        */

        out.println("<img src=\"GetOnePic?big" + Integer.toString(photoId) + "\">");

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