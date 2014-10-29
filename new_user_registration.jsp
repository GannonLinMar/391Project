<HTML>
<HEAD>

</HEAD>

<%@ page import ="java.sql.*" %>
<%

	if(request.getParameter("Submit") != null)
	{
		String firstName = (request.getParameter("firstname")).trim();
		String lastName = (request.getParameter("lastname)).trim();
		String address = (request.getParameter("address")).trim();
		String phoneNumber = (request.getParameter("phone")).trim();
		String userName = (request.getParameter("username")).trim();
		String password = (request.getParameter("password")).trim();	

	}


</HTML>

