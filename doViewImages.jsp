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
        PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;

    	switch(viewType)
    	{
            // View Owned Images
    		case 1:
                stmt = conn.prepareStatement("select photo_id from images where owner_name = '" + userid + "'");
    			break;
            // View Popular Images
            case 2:
                String table1 = "images";
                stmt = conn.prepareStatement("select p.photo_id, i.permitted, count(*) from " + table1 + " i, popularity p where i.photo_id = p.photo_id " + " GROUP BY p.photo_id, i.permitted ORDER BY count(*) DESC");
                //tie-breaking in SQL would be hard
                //so just fetch everything, that way we can get the top 5 and tiebreak in JSP
		stmt2 = conn.prepareStatement("select group_id from group_lists where friend_id = '"+userid+"'");
                break;
            // Search Images
            case 3:
                String radio = (request.getParameter("rankBy")).trim();

		if (radio.equals("default")){

			stmt = conn.prepareStatement("select photo_id, permitted from (select (6*score(1) + 3*score(2) +1*score(3)) as Score, photo_id, permitted from images where contains(subject, ?, 1) >0 or contains(place, ?, 2)>0 or contains(description, ?, 3)>0) order by Score desc");

			stmt.setString(1, request.getParameter("keywords"));
			stmt.setString(2, request.getParameter("keywords"));
			stmt.setString(3, request.getParameter("keywords"));
		
			stmt2 = conn.prepareStatement("select group_id from group_lists where friend_id = '"+userid+"'");
		}

		else if (radio.equals("recentFirst")) {

			stmt = conn.prepareStatement("select photo_id, permitted from (select photo_id, permitted, timing from images where contains(subject, ?, 1) >0 or contains(place, ?, 2)>0 or contains(description, ?, 3)>0) order by timing desc");
			stmt.setString(1, request.getParameter("keywords"));
			stmt.setString(2, request.getParameter("keywords"));
			stmt.setString(3, request.getParameter("keywords"));
		
			stmt2 = conn.prepareStatement("select group_id from group_lists where friend_id = '"+userid+"'");

		}

		else if (radio.equals("recentLast")) {
			stmt = conn.prepareStatement("select photo_id, permitted from (select photo_id, permitted, timing from images where contains(subject, ?, 1) >0 or contains(place, ?, 2)>0 or contains(description, ?, 3)>0) order by timing asc");
			stmt.setString(1, request.getParameter("keywords"));
			stmt.setString(2, request.getParameter("keywords"));
			stmt.setString(3, request.getParameter("keywords"));
		
			stmt2 = conn.prepareStatement("select group_id from group_lists where friend_id = '"+userid+"'");

		}
		
		break;

    		default:
    			out.println("Something is terribly wrong");
    	}

    	//want to print a list of thumbnails, clicking them should take us to their display page via POST
    	//factoring considerations: make an arraylist of thumbnail data and corresponding ID's
    	//then a single section of code to output them generically

        ResultSet rset = null;
        
        out.println("Your query:<br>" + stmt + ";<br><br>");


    	try
        {
        	
            rset = stmt.executeQuery();
    	}
        catch(Exception ex)
        {
            out.println("<hr>" + ex.getMessage() + "<hr>");
    	}

       ArrayList<Integer> idList = new ArrayList<Integer>();

        ArrayList<Integer> popList = new ArrayList<Integer>();

	ArrayList<Integer> permitList = new ArrayList<Integer>();

	if (viewType == 1){
		while(rset != null && rset.next()){
        		idList.add((rset.getInt(1)));
        	}
	}

        if(viewType == 2 && idList.size() > 5) //popularity search only
        {
            //truncate the list size to best 5, but also tiebreak which allows over 5 results

	    while(rset != null && rset.next())
       	    {
        	idList.add((rset.getInt(1)));
                popList.add(rset.getInt(3));
            }

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

	if(viewType == 3 || viewType == 2) {
		//create a second list that user is permitted to access
		ResultSet rset2 = null;
	    	try{	
			
        		rset2 = stmt2.executeQuery();
    		}

	        catch(Exception ex){
           		out.println("<hr>" + ex.getMessage() + "<hr>");
    		}		


		while(rset2 != null && rset2.next()){
			permitList.add(rset2.getInt(1));
		}
		
		//out.println(permitList.get(1));
		//permitList.add(1);
		
		while(rset != null && rset.next()){
			if(permitList.contains(rset.getInt(2)))
				idList.add(rset.getInt(1));
			

     		}

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
