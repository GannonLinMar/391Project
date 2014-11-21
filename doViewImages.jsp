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
        String sql = "";

    	switch(viewType)
    	{
            // View Owned Images
    		case 1:
                sql = "select photo_id from images where owner_name = '" + userid + "'";
    			break;
            // View Popular Images
            case 2:
                String table1 = "images";
                sql = "select p.photo_id, count(*) from " + table1 + " i, popularity p where i.photo_id = p.photo_id "
                    + " GROUP BY p.photo_id ORDER BY count(*) DESC";
                //tie-breaking in SQL would be hard
                //so just fetch everything, that way we can get the top 5 and tiebreak in JSP
                break;
            // Search Images
            case 3:
                String table2 = "images";
                sql = "select photo_id from " + table2 + " where ... ";

                sql = "";            
                break;
    		default:
    			out.println("Something is terribly wrong");
    	}

    	//want to print a list of thumbnails, clicking them should take us to their display page via POST
    	//factoring considerations: make an arraylist of thumbnail data and corresponding ID's
    	//then a single section of code to output them generically

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

        ArrayList<Integer> idList = new ArrayList<Integer>();

        ArrayList<Integer> popList = new ArrayList<Integer>();

    	while(rset != null && rset.next())
        {
        	idList.add((rset.getInt(1)));
            if(viewType == 2)
                popList.add(rset.getInt(2));
        }

        if(viewType == 2 && idList.size() > 5) //popularity search only
        {
            //truncate the list size to best 5, but also tiebreak which allows over 5 results

            int worstIncludedPop = popList.get(4);
            int worstIncludedIndex = idList.size() - 1;

            for(int q = 5; q < idList.size(); q++)
            {
                if(popList.get(q) < worstIncludedPop)
                {
                    worstIncludedIndex = q - 1;
                }
            }

            idList = new ArrayList<Integer>(idList.subList(0, worstIncludedIndex + 1));
        }

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