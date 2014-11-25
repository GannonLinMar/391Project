###[Homepage]

index.jsp
- Provides links to all our other modules
- Redirects to the login page if user is not yet logged in

###[User Management Module]

login.jsp ==> doLogin.jsp
- users are automatically redirected from any page to this one if they have not yet logged in
- allows the user to login by providing their username and password
- the user's credentials are submitted to doLogin.jsp via regular form submission
- checks the user's credentials before instantiating a session and setting the session variable "userid" to their username
- SQL query for password checking: "select password from users where user_name = '"+userName+"'"

logout.jsp
- can be accessed from any page via our top bar
- logs out the user's current session
- uses session.invalidate() to clear the current session
- sends the user back to the login page (login.jsp) once they have been logged out

new_user_registration.html ==> new_user_registration.jsp
- can be accessed from the login.jsp page
- allows a user to register an account
- inserts the user's provided information into the database
- the user's information is submitted to new_user_registration.jsp via regular form submission
- SQL query for inserting username and password: "insert into users values ('"+username+"', '"+password+"', SYSDATE)"
- SQL query for inserting optional info: "insert into persons values('"+username+"', '"+firstName+"', '"+lastName+"', '"+address+"', '"+email+"', '"+phoneNumber+"')"
- sends the user back to the homepage after successfully registering

myinfo.jsp
- can be accessed from most pages via our top bar
- allows the user to view their own information
- SQL query for retrieving info: "SELECT first_name, last_name, address, email, phone FROM persons WHERE user_name = '"+userid +"'"
- displays each piece of retrieved information in a text box

###[Uploading Module]

upload.jsp ==> uploadOne.jsp
- Can be accessed from the homepage (index.jsp)
- Allows the user to upload a single image (.jpg or .gif file)
- Allows user to select one file and optionally provide information about the image's subject, location, time taken, and description
- Allows user to additionally specify if the image should be set to private, public, or restricted to one group (allows the user to input a group name for the last option)
- Submits the image and associated information to uploadOne.jsp via form submission with enctype="multipart/form-data"

uploadOne.jsp
- Uses Apache's FileUpload java package to extract the image file and information strings out of the encoded parameters
- Inserts the image and associated information into the database using this SQL query: "INSERT INTO images VALUES(" + Integer.toString(pic_id) + ", '" + userid + "', " + permitted + ", '" + subject + "', '" + place + "', TO_DATE('" + when + "','YYYY MM DD'), '" + desc + "', " + " empty_blob(), " + "empty_blob() " + ")"
- uploadOne.jsp then fills in the two empty blobs with the image file's data and the same data but shrunk for the thumbnail
- Uses the BufferedImage class to shrink the image data in order to produce thumbnails
- If the group-only permission was specified along with a group name, we retrieve the id of the specified group using this SQL query: "SELECT group_id from groups where group_name = '" + groupName + "' and " + "user_name = '" + userid + "'"
- SQL query for retrieving the current highest image ID (we add one to this number to get the next unused image ID): "select max(photo_id) from images"
- Also stores the extension of the image using this SQL query: "INSERT INTO photoExt values " + "(" + Integer.toString(pic_id) + ", '" + FilenameUtils.getExtension(fullpath) +  "')"

uploadFolder.jsp ==> uploadMultiple.jsp
- Can be accessed from the homepage (index.jsp)
- Allows the user to multiple images at a time (any combination of .jpg and/or .gif files that are in the same folder)
- Allows user to select one or more files, and optionally provide information about the images' subject, location, and time taken (but not description, which will always be initialized to a blank value)
- Allows user to additionally specify if the images should be set to private, public, or restricted to one group (allows the user to input a group name for the last option)
- Submits the images and associated information to uploadMultiple.jsp via form submission with enctype="multipart/form-data"

uploadMultiple.jsp
- Uses Apache's FileUpload java package to extract the image files and information strings out of the encoded parameters
- Inserts each image and the common associated information into the database using this SQL query: "INSERT INTO images VALUES(" + Integer.toString(pic_id) + ", '" + userid + "', " + permitted + ", '" + subject + "', '" + place + "', TO_DATE('" + when + "','YYYY MM DD'), '" + desc + "', " + " empty_blob(), " + "empty_blob() " + ")"
- uploadMultiple.jsp then fills in the two empty blobs with each image file's data and the same data but shrunk for the thumbnail
- Uses the BufferedImage class to shrink the image data in order to produce thumbnails
- If the group-only permission was specified along with a group name, we retrieve the id of the specified group using this SQL query: "SELECT group_id from groups where group_name = '" + groupName + "' and " + "user_name = '" + userid + "'"
- SQL query for retrieving the current highest image ID (we add one to this number to get the next unused image ID's): "select max(photo_id) from images"
- Also stores the extension of each image using this SQL query: "INSERT INTO photoExt values " + "(" + Integer.toString(pic_id) + ", '" + FilenameUtils.getExtension(fullpath) +  "')"

###[Security Module]

groups.jsp ==> editGroup.jsp
- 

editGroup.jsp ==> addGroupMember.jsp, deleteGroupMember.jsp

###[Display And Search Module]

viewImages.jsp

doViewImages.jsp ==> viewOneImage.jsp

viewOneImage => updateImage.jsp