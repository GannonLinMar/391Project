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

Hi, <%= userid%><span style="float:right;"><a href="myinfo.jsp">My Info</a> <a href="logout.jsp">Logout</a> <a href="help.jsp">Help Page</a></span>
<hr>
<br>

<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%@include file="db_login/db_login.jsp" %>

<%
String groupName = "";

out.println("<a href=\"groups.jsp\">Back to Groups</a><br><br>");

if(request.getParameter("groupname") != null)
{
    groupName = (request.getParameter("groupname")).trim();

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
        String sqlsub = "(select group_id from groups where group_name = '" + groupName + "' and user_name = '" + userid + "')";    
    	String sql = "select friend_id from group_lists where group_id in " + sqlsub;
        out.println("Your query:<br>" + sql + ";<br><br>");
    	try{
        	stmt = conn.createStatement();
            rset = stmt.executeQuery(sql);
    	}

        catch(Exception ex){
            out.println("<hr>" + ex.getMessage() + "<hr>");
    	}

        ArrayList<String> memberNames = new ArrayList<String>();

    	while(rset != null && rset.next())
        	memberNames.add((rset.getString(1)).trim());

        out.println("<br><button type=\"button\" id=\"newmember\">Add a new member</button><br>");

        if(memberNames.size() < 1)
        {
            out.println("Currently no members");
        }
        else
            out.println("Group members:<br>");

        for(String name : memberNames)
        {
            if(!name.equals(userid))
            {
                out.println(name);
                out.println("<button onclick=\"DeleteMember('" + name + "')\">Delete</button>");
                out.println("<br>");
            }
        }

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
document.getElementById("newmember").onclick = function()
{
    var newName = prompt("New member's userid:", "");
    if(newName != null && newName != "") //not cancelled or blank
    {
        var notice = prompt("New member's notice (can be blank):", "");
        if(notice == null)
            notice = "";
        post("addGroupMember.jsp", {groupName: <%= "\"" + groupName + "\"" %>, newName: newName
            , notice: notice});
    }
}
</script>

<script>
function DeleteMember(memberName)
{
    post("deleteGroupMember.jsp", {groupName: <%= "\"" + groupName + "\"" %>, deletedMember: memberName});
}
</script>

</BODY>
</HTML>
