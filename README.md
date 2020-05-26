This is how you setup this project for the first time:

Front End:
1. make sure if you open up the front end by clicking the project file that you specifically click the workspace file. this file is mostly white with a little bit of blue. otherwise you can just open up the project by opening the hospital app front end folder in xcode.
2. install cocoa pods - $ sudo gem install cocoapods
3. open up your terminal and navigate to the hospitalAppFrontEnd folder and enter "pod install" - not sure if this is necessary but it might be causing the bugs
4. the only hospital in the database is "Baylor Scott & White". enter this value into the domain name field to proceed
5. one user that exists has the following login credentials- username:"a" password: "a" . use these credentials at the login page to go to the patient request page.
6. one administrator that exists has the following login credentials- username:"b" password: "b" . use these credentials at the login page to go to the table view of current patient requests

Back End: 
1. Download Postgres from the internet (it is an open source database software kit). as a part of this step you should create a postgres username and password. https://www.postgresql.org/download/
2. add postgres to your path variable. https://www.postgresql.org/docs/9.1/install-post.html
3. connect to the postgres in the terminal by opening up your terminal and typing in "psql"
4. Create a database called "hospitaldb". https://www.postgresql.org/docs/9.0/sql-createdatabase.html
5. make sure you have pip installed for python.
6. open the terminal and navigate to the hospitalAppBackend folder and then type this in "pip install -r requirements.txt"
8. run models.py
9. run create_database.py
10. run main.py
11. after completing these steps for initial setup you only need to run main.py to start the backend
12. to stop the backend from running you need to go in your terminal where main.py was executed and press control c
13. everytime you change something in the backend and save the changed file the backend will automatically restart so you shouldn't have to stop the backend with conrol c unless you are completing your work
