391Project
==========

###To install###
- cd catalina/webapps
- git clone https://github.com/GannonLinMar/391Project.git

###To setup Oracle credentials###
- in the folder "db_login", place a file named "db_login.jsp" It's contents should be:

```
<% 
String db_username = "YOUR ORACLE USERNAME";
String db_password = "YOUR ORACLE PASSWORD";
String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
%>
```
