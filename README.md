391Project
==========

###Install###
- cd catalina/webapps
- git clone https://github.com/GannonLinMar/391Project.git

###Setup tables###
- cd SqlSetup
- sqlplus
- @allsetup

Note that removej.sql is a template for removing previously submitted jobs. Generally there's no need to run it.

###Setup Oracle credentials in the servlet###
- in WEB-INF/classes/GetOnePic.java, edit your credentials in at the end of the file
- then recompile (javac GetOnePic.java)

###Setup Oracle credentials for the JSP's###
- in the folder "db_login", place a file named "db_login.jsp" It's contents should be:

```
<% 
String db_username = "YOUR ORACLE USERNAME";
String db_password = "YOUR ORACLE PASSWORD";
String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
%>
```
