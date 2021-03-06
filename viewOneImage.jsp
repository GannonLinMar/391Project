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

Hi, <%= userid%><span style="float:right;"><a href="myinfo.jsp">My Info</a> <a href="logout.jsp">Logout</a> <a href="help.jsp">Help Page</a></span>
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
            String time = "";
            try
            {
                Format formatter = new SimpleDateFormat("yyyy-MM-dd");
                time = formatter.format(timing);
            }
            catch(IllegalArgumentException e)
            {
                time = "<i>not specified</i>";
            }
            String description = rset.getString("description");
        	
            Boolean allowed = false;
            if(permitted == 1) //public
                allowed = true;
            else if(permitted == 2) //private
            {   
                if(owner.equals(userid))
                    allowed = true;
            }
            else if(permitted > 2 || permitted == 0) //group
            { //permitted=0 shouldn't happen but just in case..
                allowed = true; //TODO

                String sqlgroup = "SELECT 1 from group_lists where group_id = " + permitted + " and friend_id = '"
                    + userid + "'";

                try
                {
                    ResultSet rset2 = stmt.executeQuery(sql);
                    if(!rset2.next())
                        allowed = false;
                }
                catch(Exception e)
                {
                    out.println("Error enumerating group members<br>");
                    allowed = false;
                }
            }

            if(userid.equals("admin"))
                allowed = true;

            out.println("<div style=\"text-align: center\">");
            if(allowed)
            {   
                //output the image
                out.println("<img src=\"GetOnePic?big" + Integer.toString(photoId) + "\">");
                out.println("<br><br><br>");
                out.println("Subject: " + subject);
                if(userid.equals(owner))
                    out.println("<button onclick=\"Edit('subject')\">Edit</button>");
                out.println("<br><br>Place: " + place);
                if(userid.equals(owner))
                    out.println("<button onclick=\"Edit('place')\">Edit</button>");
                out.println("<br><br>Time: " + time);
                if(userid.equals(owner))
                    out.println("<button onclick=\"Edit('timing')\">Edit</button>");
                out.println("<br><br>Description: " + description);
                if(userid.equals(owner))
                    out.println("<button onclick=\"Edit('description')\">Edit</button>");
                out.println("<br><br>");

                if(userid.equals(owner))
                {
                    String privateDef = (permitted == 2) ? "checked=\"checked\"" : "";
                    String publicDef = (permitted == 1) ? "checked=\"checked\"" : "";
                    String groupDef = (permitted > 2) ? "checked=\"checked\"" : "";
                    
                    String permForm = "<FORM name = \"PermissionForm\" action = \"updateImage.jsp\" method = \"post\">"
                    + "<input type=\"radio\" name=\"permit\" value=\"private\" "+ privateDef +">Private"
                    + "<input type=\"radio\" name=\"permit\" value=\"public\""+ publicDef +">Public"
                    + "<input type=\"radio\" name=\"permit\" value=\"group\""+ groupDef +">Only this group: "
                    + "<INPUT type = \"text\" name = \"groupName\" maxlength=50 placeholder=\"Group Name\">"
                    + "<input type=\"hidden\" name=\"imageId\" value=\"" + Integer.toString(photoId) + "\">"
                    + "<INPUT type = \"submit\" name = \"submitedit\" value = \"Change\">"
                    + "</FORM><br>";
                    out.println(permForm); //TODO: permission editing
                }

                //update the image's popularity
                String popValues = Integer.toString(photoId) + ", '" + userid + "'";
                String popSub = "SELECT * from popularity where photo_id = "
                    + Integer.toString(photoId) + " and username = '" + userid + "'";
                String sqlpop = "INSERT INTO popularity (photo_id, username) SELECT " + popValues
                    + " from dual where NOT EXISTS (" + popSub + ")";
                //out.println("popularity string: " + sqlpop + "<br>");

                try
                {
                    stmt.execute(sqlpop);
                }
                catch(Exception e)
                {
                    out.println("Error updating image popularity: " + e.getMessage() + "<br>");
                }
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

<script>
function Edit(attribName)
{
    var p =
    {subject: "New subject:"
    , place: "New location:"
    , timing: "New date (YYYY MM DD):"
    , description: "New Description"}[attribName];

    var newValue = prompt(p, "");

    if(newValue != null) //not cancelled
    {
        if(attribName != "timing" || newValue != "")
        {
            post("updateImage.jsp", {imageId: <%= "'" + Integer.toString(photoId) + "'" %>, attribute: attribName, value: newValue});
        }
        else
            alert("You must supply a date");
    }
}
</script>


</BODY>
</HTML>
