from models import Patient_Request, User_Info, Administrator, Hospital
# set up a scoped_session
from sqlalchemy.orm import scoped_session
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from datetime import date
import os
from base64 import b64encode, b64decode


class Patient_Request_Repository(object):
    def __init__(self):
        username = os.environ.get("USER", "")
        password = os.environ.get("PASSWORD", "")
        db_string_beginning = "postgres://"
        db_string_end = "@localhost:5432/hospitaldb"
        db_string = db_string_beginning + username + ":" + password + db_string_end
        patient_request_engine = create_engine(db_string)
        session_factory = sessionmaker(bind=patient_request_engine)
        self.Session = scoped_session(session_factory)

    def add_patient_request(self, patient_request):
        post_patient_request_session = self.Session()
        new_patient_request = Patient_Request( id = patient_request["id"],
            designated_pickup=patient_request["designated_pickup"],
            hospital="baylor_scott_&_white",
            administrator="b",
            first_name=patient_request["first_name"],
            last_name=patient_request["last_name"],
            room_number=patient_request["room_number"],
            birthday=patient_request["birthday"],
            phone_number=patient_request["phone_number"],
            email_address=patient_request["email_address"],
            date=date.today(), status=patient_request["status"], administrator_message= patient_request['administrator_message'] )
        post_patient_request_session.add(new_patient_request)
        post_patient_request_session.commit()
        self.Session.remove()

    def get_patient_requests(self, administrator_hospital):
        patient_request_session = self.Session()
        patient_requests = patient_request_session.query(Patient_Request).filter(Patient_Request.hospital == administrator_hospital)
        serialized_patient_requests = [x.serialize for x in patient_requests]
        return serialized_patient_requests

    def change_patient_request_status(self, patient_request):
        patient_request_session = self.Session()
        try:
            patient_request_to_change = patient_request_session.query(Patient_Request).get(patient_request['id'])
            patient_request_to_change.status = patient_request['status']
            patient_request_to_change.administrator_message = patient_request['administrator_message']
            patient_request_session.commit()
            self.Session.remove()
            return True
        except:
            return False


class Registration_Repository(object):
    def __init__(self):
        username = os.environ.get("USER", "")
        password = os.environ.get("PASSWORD", "")
        db_string_beginning = "postgres://"
        db_string_end = "@localhost:5432/hospitaldb"
        db_string = db_string_beginning + username + ":" + password + db_string_end
        registration_engine = create_engine(db_string)
        session_factory = sessionmaker(bind=registration_engine)
        self.Session = scoped_session(session_factory)

    def add_administrator(self, administrator):
        add_administrator_session = self.Session()
        test_administrator = add_administrator_session.query(
            Administrator).filter(
                Administrator.id == administrator["id"]).first()

        if test_administrator == None:
            new_administrator = Administrator(
            id=administrator["id"],
            password=administrator["password"],
            first_name=administrator["first_name"],
            last_name=administrator["last_name"],
            image=b64decode(administrator["image"]),
            employeeID=administrator["employeeID"],
            hospital=administrator["hospital"])

            add_administrator_session.add(new_administrator)
            add_administrator_session.commit()
            self.Session.remove()
            return True
        
        else:
            return False

    def add_user(self, user):
        add_user_session = self.Session()
        test_user = add_user_session.query(
            User_Info).filter(
                User_Info.id == user["id"]).first()
        if test_user == None:
            new_user = User_Info(
            id=user["id"],
            password=user["password"],
            first_name=user["first_name"],
            last_name=user["last_name"])

            add_user_session.add(new_user)
            add_user_session.commit()
            self.Session.remove()
            return True
        
        else:
            return False


    def get_registration(self):
        registration_session = self.Session()
        registrations = registration_session.query(Administrator)
        serialized_registrations = [x.serialize for x in registrations]
        return serialized_registrations
