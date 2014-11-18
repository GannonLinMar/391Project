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
String groupName = null;
String newName = null;

if(request.getParameter("groupName") != null && request.getParameter("newName") != null)
{
    groupName = request.getParameter("groupName").trim();
    newName = request.getParameter("newName").trim();

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

        String values = "select group_id, " + "'" + newName + "', SYSDATE, 'hi' from groups where group_name = '" + groupName + "' and user_name = '" + userid + "'";
        String sql = "insert into group_lists " + values;

        out.println("Your query:<br>" + sql + ";<br><br>");
        Boolean bSuccess = true;
    	try{
        	stmt = conn.createStatement();
            rset = stmt.executeQuery(sql);
    	}

        catch(Exception ex){
            out.println("<hr>" + ex.getMessage() + "<hr>");
            bSuccess = false;
    	}

        if(bSuccess)
        {
            out.println("Successfully added group member");
        }
        else
        {
            out.println("Failed to add group member");
        }

        conn.commit();
        conn.close();

        out.println("<br><button onclick=\"Back()\">Back</button>");
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
    post("editgroup.jsp", {groupname: <%= "\"" + groupName + "\"" %>});
}
</script>

</BODY>
</HTML>