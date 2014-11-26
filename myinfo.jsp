<HTML>
<HEAD>
<TITLE>My Info</TITLE>
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

<script>
function validateForm() {
    var x = document.forms["editInfo"]["firstname", "lastname", "address", "phoneNumber"].value;
    if (x==null || x=="") {
        alert("One or more fields are empty!");
        return false;
    }
}
</script>

<%
    out.println("<a href=\".\">Back to Home</a><br><br>");

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
    	String sql = "SELECT first_name, last_name, address, email, phone FROM persons WHERE user_name = '"+userid +"'";
        out.println("Your query:<br>" + sql + ";<br><br>");
        Boolean success = true;
    	try
        {
        	stmt = conn.createStatement();
            rset = stmt.executeQuery(sql);
    	}
        catch(Exception ex)
        {
            out.println("<hr>" + ex.getMessage() + "<hr>");
            success = false;
    	}

        if(success)
        {
            rset.next();
            String first = rset.getString("first_name").trim();
            String last = rset.getString("last_name").trim();
            String addr = rset.getString("address").trim();
            String email = rset.getString("email").trim();
            String phone = rset.getString("phone").trim();

            String form = 
            "<form name = \"editInfo\" action=\"editInfo.jsp\" onsubmit=\"return validateForm()\" method=\"post\">"
            +"<table>"
            +"<tr>"
            +"<td align=\"right\">First Name:</td>"
            +"<td align=\"left\"><input type=\"text\" name=\"firstname\" value=\""+first+"\" /></td>"
            +"</tr>"
            +"<tr>"
            +"<td align=\"right\">Last Name:</td>"
            +"<td align=\"left\"><input type=\"text\" name=\"lastname\" value=\""+last+"\" /></td>"
            +"</tr>"
            +"<tr>"
            +"<td align=\"right\">Address:</td>"
            +"<td align=\"left\"><input type=\"text\" name=\"address\" value=\""+addr+"\" /></td>"
            +"</tr>"
            +"<tr>"
            +"<td align=\"right\">Email:</td>"
            +"<td align=\"left\"><input type=\"text\" name=\"email\" value=\""+email+"\" /></td>"
            +"</tr>"
            +"<tr>"
            +"<td align=\"right\">Phone Number:</td>"
            +"<td align=\"left\"><input type=\"text\" name=\"phoneNumber\" value=\""+phone+"\" /></td>"
            +"</tr>"
            +"</table>"
            +"</form>";

            out.println(form);
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

</BODY>
</HTML>
