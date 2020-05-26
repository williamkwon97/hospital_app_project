from models import db, User_Info, Hospital, Administrator, app
import json
from datetime import date
import os
from sqlalchemy import exc
from base64 import b64encode, b64decode

def load_json(filename):

    with open(filename) as file:
        jsn = json.load(file)
        file.close()

    return jsn

def create_user_administrator():

    hospitals = db.session.query(Hospital)
    hospital = hospitals[0]
    test_user = load_json("test_user.json")
    test_administrator = load_json("test_administrator.json")

    for user in test_user:
        id = user['id']
        first_name = user['first_name']
        last_name = user['last_name']
        password = user["password"]

        # After I create the user, I can then add it to my session.
        new_user = User_Info(id=id, password=password, first_name=first_name, last_name=last_name)
        db.session.add(new_user)

    for administrator in test_administrator:
        id = administrator['id']
        first_name = administrator['first_name']
        last_name = administrator['last_name']
        password = administrator['password']
        image = b64decode(administrator['image'])
        employeeID = administrator["employeeID"]
        hospital = hospital.id
        
        # After I create the administrator, I can then add it to my session.
        new_administrator = Administrator(id=id, password=password, first_name=first_name, last_name=last_name, hospital=hospital, employeeID=employeeID, image=image)
        db.session.add(new_administrator)

    # commit the session to my DB.
    db.session.commit()



def create_hospital():

    test_hospital = load_json("test_hospital.json")

    for hospital in test_hospital:
        id = hospital['id']
        name = hospital['name']
        street = hospital['street']
        city = hospital['city']
        state = hospital['state']
        zipcode = hospital['zipcode']
        date_joined = date.today()

        new_hospital = Hospital(id=id, name=name, street=street, city=city,
                      state=state, zipcode=zipcode, date_joined=date_joined)

        # After I create the hospital, I can then add it to my session.
        db.session.add(new_hospital)

    # commit the session to my DB.
    db.session.commit()

db.drop_all()
db.create_all()
create_hospital()
create_user_administrator()
# try:
#     create_hospital()
# except exc.IntegrityError:
#      db.session.rollback()
# try:
#     create_user_administrator_patient()
# except exc.IntegrityError:
#      db.session.rollback()
