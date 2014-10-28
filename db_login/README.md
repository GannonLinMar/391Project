Put a file named "db_login.jsp" in this folder. It's contents should be:

```
<% 
String db_username = "YOUR ORACLE USERNAME";
String db_password = "YOUR ORACLE PASSWORD";
String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
%>
```