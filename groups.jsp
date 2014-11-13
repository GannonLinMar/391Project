<HTML>
<HEAD>
<TITLE>My Groups</TITLE>
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
        //select the user table from the underlying db and validate the user name and password
    	Statement stmt = null;
        ResultSet rset = null;
    	String sql = "select group_name from groups where user_name = '" +userid +"'";
        out.println("Your query:<br>" + sql + ";<br><br>");
    	try{
        	stmt = conn.createStatement();
            rset = stmt.executeQuery(sql);
    	}

        catch(Exception ex){
            out.println("<hr>" + ex.getMessage() + "<hr>");
    	}

        ArrayList<String> groupNames = new ArrayList<String>();

    	while(rset != null && rset.next())
        	groupNames.add((rset.getString(1)).trim());

        out.println("<button type=\"button\" id=\"creategroup\" name=\"newgroup\">Create New Group</button><br>");

        if(groupNames.size() < 1)
        {
            out.println("You don't have any groups");
        }
        else
            out.println("Your groups:<br>");

        for(String groupName : groupNames)
        {
            out.println(groupName);
            out.println("<button onclick=\"EditGroup('" + groupName + "')\">View/Edit</button>");
            out.println("<br>");
        }

        conn.commit();
        conn.close();
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
document.getElementById("creategroup").onclick = function()
{
    var newname = prompt("New group name:", "");
    if(newname != null && newname != "") //not cancelled or blank
    {
        //window.location.href = "doCreategroup.jsp?newname=" + newname;
        post("doCreategroup.jsp", {newname: newname});
    }
}
</script>

<script>
function EditGroup(groupname)
{
    post("editgroup.jsp", {groupname: groupname});
}
</script>

</BODY>
</HTML>