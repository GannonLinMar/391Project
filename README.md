391Project
==========

###Install###
- cd catalina/webapps
- git clone https://github.com/GannonLinMar/391Project.git

###Setup tables###
- cd SqlSetup
- sqlplus
- @setup.sql
- @extensions.sql
- @popular.sql
- @index.sql
- @drjobdml.sql
To use the drjobdml.sql file, you must run it 3 times. Each time, you must first specify the name of the index (see index.sql) and a refresh time (5 secs works).

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
