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
    	switch(viewType)
    	{
    		case 1:
    			out.println("WIP");
    			break;
    		default:
    			out.println("Not yet implemented");
    	}

    	//want to print a list of thumbnails, clicking them should take us to their display page via POST
    	//factoring considerations: make an arraylist of thumbnail data and corresponding ID's
    	//then a single section of code to output them generically

    	/*

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
            out.println(name);
            out.println("<button onclick=\"DeleteMember('" + name + "')\">Delete</button>");
            out.println("<br>");
        }

		*/

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

</BODY>
</HTML>