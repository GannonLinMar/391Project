<HTML>
<HEAD>
<TITLE>Home</TITLE>
<!--Display user documentation, converted to html using: http://www.textfixer.com/html/convert-text-html.php and a few small formatting changes done by hand-->
<%
String userid = (String)session.getAttribute("userid");
if(userid == null)
	out.println("<meta http-equiv=\"refresh\" content=\"0; url=login.jsp\" />");
%>

</HEAD>
<BODY>

Hi, <%= userid%><span style="float:right;"><a href="myinfo.jsp">My Info</a> <a href="logout.jsp">Logout</a> <a href="help.jsp">Help Page</a></span>
<hr>
<br>
<br><a href="index.jsp">Back to Home</a>
<h1>Welcome to the Help Page!</h1>
<br />
<p>Welcome to the user documentation page! You can use this as a guide on how to install and use our photosharing system. This guide covers installation of the system and how to use the following modules:</p>

<p>-Signing up and logging in/out<br />
-Upload one photo<br />
-Upload multiple photos at one time<br />
-Creating and editing groups<br />
-Viewing your images<br />
-Searching for images</p>

<!--Installation stuff here-->
<h2>0. Installation</h2><br />
Installation of the system is simple, with only a few credentials that need changing to connect to the database. The instructions given use the catalina server. <br />
Here's step by step instructions to install the site into your system:</p>

<h3>0.1 Install</h3>
- cd catalina/webapps <i>(or the webapps folder of whichever server you are using)</i><br />
- git clone https://github.com/GannonLinMar/391Project.git</p>

<h3>0.2 Setup tables</h3>
- cd SqlSetup<br />
- sqlplus<br />
- @allsetup</p>

<p><i>Note that removej.sql is a template for removing previously submitted jobs. Generally there's no need to run it.</i></p>

<h3>0.3 Setup Oracle credentials in the servlet</h3>
- in WEB-INF/classes/GetOnePic.java, edit your credentials (username, password, and dbstring) in at the end of the file<br />
- then recompile (javac GetOnePic.java)</p>

<h3>0.4 Setup Oracle credentials for the JSP's</h3>
<p>
- in the folder "db_login", place a file named "db_login.jsp". It's contents should look like the following, except enclosed in jsp tags:</p>

<p>String db_username = "YOUR ORACLE USERNAME";</p>
<p>String db_password = "YOUR ORACLE PASSWORD";</p>
<p>String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS"; <i>or the addresss of whichever oracle database you're connecting to</i></p>

<p><b>Make sure to enclose these contents in jsp tags!</b></p>


<!-- Signing up, login and logout info starts here-->
<h2>1. Starting and Ending your Sessions</h2><br />
<h3>1.1 Sign up:</h3>
 You can access the sign up page either directly or from the log in page in the event that you don't have an account. Signing up is as simple as filling in all of the fields on the sign up page and clicking a button! <br />
Once you've signed in, you'll be greeted with a message indicating that you've been successfully signed in, and then you'll be redirected to the home page.</p>

<h3>1.2 Login</h3>
For future sessions all you'll need is to fill out your username and password at the log in page. Just as with signing in, you'll be greeted with a message indicating if your login was successful and then redirected to the home page.</p>

<h3>1.3 Logout</h3>
To end your session and log out, you simply must click the logout button. It's that easy to keep your photos secure with out system!</p>

<!--Information on the home page layout starts here-->
<h2>
The Home Page & Navigation</h2></br>

<p>Once you've logged in, you'll be directed to the home page which acts as a hub for connecting you to the features of our site. In the upper right hand corner you'll see options to view the information that you used to sign up, a logout button, and a link to access this very help page! This greeting header is available at the top of each page, with the "Back to Home" link at the top or bottom lefthand side of each page.</p>


<p><b>The main menu allows access to the following features:</b><br />
</p>

<!--Uploading images (One or Multiple) starts here-->
<h2>2. Uploading One or More Photos</h2><br />

<h3>2.1 Uploading One Image</h3>
Uploading one photo is a very intuitive process. It's as simple as clicking the &quot;Upload One Image&quot; link to the upload page, selecting the photo file of your choice from your disk, and filling out the fields to add information to your upload. Note that if you don't set the privacy of your photos, they will default to being private. Once uploaded, you will be presented with a message describing if the upload was successful or not (OK indicates it was successful) and to view the uploaded images you'll have to return to the main menu and click on the &quot;view images&quot; option (section 4 describes the usage of this module.)</p>

<h3>2.2 Uploading Multiple Photos at Once</h3>
Uploading a batch of photos at once is very similar to uploading one photo, although you must select a different option on the main menu. Click the &quot;Upload A Folder Of Images&quot; link to upload multiple files. To select more than one photo file from your disk, you simply need to click on the images you want to upload while holding the shift or control key. Then fill out the fields and click on the upload button.</p>

<!-- Group management starts here-->
<h2>3. Manage Your Groups</h2><br />
Groups are a way to share certain photos with certain members of the site, as opposed to setting your photos to private (so that only you can see them) or public (so that everyone can see them). An important note about how groups work is that when you add a user to your group, you are able to share images with them but they cannot share images with you using the group. Instead, they must create their own group with you in it in order to share their photos with you.<br />
The &quot;Manage Your Groups&quot; page displays the existing groups that you've created, and has a &quot;Create New Group&quot; button to create a new group.</p>

<h3>3.1 Creating a Group. </h3>
The groups page presents a view of any existing groups you have as well as a button to add a new group by specifying a group name for. Group creation is as simple as the click of a button! <br />
Click and name your new group. The next page will be a success dialogue if the group was created successfully. To add members you'll have to go back to the previous page and click the "View/Edit" button which will be next to the name of your new group. </p>

<h3>3.2 Editing an Existing Group</h3>
For all existing groups that you own, you can edit them by adding or removing members. To access this, click the "View/Edit" button. You'll be brought to an overview of that group with a list of the members. To add a member click the button above the list of group members, type in their username and choose if you'd like to send them a notification that they've been added to your group. You can specify your own message in the dialogue box to let them know!
</br>
Deleting members is as simple as clicking the delete button next to the username you'd like to remove from the group. After both adding and deleting you'll recieve a message indicating that your edit was successful.</p>

<!-- Viewing images starts here-->
<h2>4. Viewing & Editing Images</h2><br />

<h3>4.1 Viewing your own Images</h3>
To see images you have uploaded, simply select the &quot;View My Images&quot; radio button from the list and click the &quot;Submit&quot; button. This will populate the screen with a gallery of thumbnails of images that you've uploaded. Here you can view the images and their information.</p>

<h3>4.2 Viewing Popular Images</h3>
This function works similarly to viewing your own images, except that you select the &quot;View Popular Images&quot; radio button and then click the &quot;Submit&quot; button. This populates the screen with a gallery of the top 5 most viewed images on the site.</p>

<h3>4.3 Searching for Images</h3>
The third radio button option allows you to search through all of the images that you can view on the site either according to one or more keywords, and/or a date range. You can also choose how to sort the resulting thumbnails; they can be sorted according to &quot;Most Relevant&quot;, &quot;Newest&quot;, &quot;Oldest&quot; which you select using the radio button. </p>

<h3>4.4 Editing Images</h3>
To edit any of the fields that you had assigned your image when you uploaded it, from the view my images gallery simply click on the image you'd like to edit. Underneath the view of the image you'll find all of the fields with edit buttons next to them so that you can update them at any time.</p>

<!--OLAP module info starts here-->
<h2>5. Admin Only: &quot;Admin Module&quot;</h2><br/>

<p>This module will only appear on the home page if the user is logged in to the &quot;admin&quot; account. It is used to generate an OLAP data cube to provide usage statistics of the system.</p>

<p>This feature has yet to be fully implemented.</p>





</BODY>
</HTML>
