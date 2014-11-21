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
String imageId = null;

String attribute = null;
String newValue = null;

String permit = null;
String groupName = null;

if(request.getParameter("attribute") != null || request.getParameter("permit") != null)
{
    imageId = request.getParameter("imageId").trim();

    int mode = 1;

    try
    {
        attribute = request.getParameter("attribute").trim();
        newValue = request.getParameter("value").trim();
    }
    catch(Exception e)
    {
        permit = request.getParameter("permit").trim();
        groupName = request.getParameter("groupName").trim();
        mode = 2;
    }

    //out.println("Working in mode: " + Integer.toString(mode));

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

        Statement stmt = null;
        ResultSet rset = null;

        stmt = conn.createStatement();

        String setter = "";

        if(mode == 1)
        {
            if(!attribute.equals("timing"))
                setter = attribute + " = '" + newValue + "'";
            else
            {
                setter = "timing = " + "TO_DATE('" + newValue + "','YYYY MM DD')";
            }
        }
        else if(mode == 2)
        {
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
            setter = "permitted = " + permitted;
        }

        String sql = "UPDATE images SET " + setter + " WHERE photo_id = " + imageId;

        out.println("Your query:<br>" + sql + ";<br><br>");
     
        Boolean bSuccess = true;
        try
        {
            stmt.execute(sql);
        }

        catch(Exception ex){
            out.println("<hr>" + ex.getMessage() + "<hr>");
            bSuccess = false;
        }

        if(bSuccess)
        {
            out.println("Successfully updated");
        }
        else
        {
            out.println("Failed to update");
        }

        out.println("<br><button onclick=\"Back()\">Back</button>");

        conn.commit();
        conn.close();
    }
}
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
function Back(memberName)
{
    post("viewOneImage.jsp", {photoId: <%= "\"" + imageId + "\"" %>});
}
</script>

</BODY>
</HTML>