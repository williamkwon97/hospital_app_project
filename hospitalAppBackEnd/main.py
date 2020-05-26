from flask import Flask, jsonify, request
from pusher import Pusher
from models import app, db, User_Info, Administrator, Hospital
from repository import Patient_Request_Repository, Registration_Repository
import json
from base64 import b64encode
import sys

# configure pusher object
pusher = Pusher(app_id="993124",
                key="1d4f9403bbf0dc92fed2",
                secret="09c89b20e26a9114fefd",
                cluster="us2",
                ssl=True)


#this app.route defines the url endpoints that the backend will be expecting requests from the frontend to ome to
#the method for this URL is 'GET' which means that only requests to retrieve information (aka HTTP GET requests) will be accepted and processed
@app.route('/login', methods=['GET'])
def login():
    #grab the username and password values from a custom header that was sent as a part of the request from the frontend
    username = request.headers.get('user')
    password = request.headers.get('password')

    response = {}

    # check to see if the user exists in the database by querying the User_Info table for the giver username and password
    # if they don't exist this will throw an error which if caught by the except block on line 20
    try:
        user = db.session.query(User_Info).filter(
            User_Info.id == username,
            User_Info.password == password).first().serialize
        response['user'] = user
        return jsonify(response)

    except:
        # check to see if the user exists in the database by querying the Administrator table for the giver username and password
        # if they don't exist this will throw an error which if caught by the except block on line 28
        try:
            administrator = db.session.query(Administrator).filter(
                Administrator.id == username,
                Administrator.password == password).first().serialize
            response['administrator'] = administrator
            return jsonify(response)

        #return an empty dictionary and a 404 status code which will trigger an error message in the front end by causing AlamoFire to recognize that the HTTP GET request has failed
        # (404 means the requested resource was not found on the server)
        except:
            # print(sys.exc_info())
            return jsonify(response), 404


@app.route('/addPatientRequest', methods=['POST'])
def add_patient_request():
    response = {}
    patient_request_repository = Patient_Request_Repository()
    patient_request = json.loads(request.data)  # load JSON data from request
    patient_request_repository.add_patient_request(patient_request)
    pusher.trigger(
        'patientRequests', 'new-request', patient_request
    )  # trigger `new-request` event on `patientRequests` channel
    return jsonify(response), 200


@app.route('/patientRequests', methods=['GET'])
def get_patient_requests():
    administrator = request.headers.get('administrator')
    response = {'patient_requests': ''}
    patient_request_repository = Patient_Request_Repository()
    patient_requests = patient_request_repository.get_patient_requests(administrator)
    response['patient_requests'] = patient_requests
    return jsonify(response['patient_requests']), 200

@app.route('/changePatientRequest', methods=['PUT'])
def change_patient_request():
    response = {}
 
    patient_request_to_change = json.loads(request.data)
    patient_request_repository = Patient_Request_Repository()
    if patient_request_repository.change_patient_request_status(patient_request_to_change) == True:
        pusher.trigger(
        'patientRequests', 'changed-request', patient_request_to_change
    )  # trigger `new-request` event on `patientRequests` channel
        return jsonify(response), 200
    else:
        return jsonify(response), 404


@app.route('/addAdminstrator', methods=['POST'])
def add_administrator():
    response = {}
    approved_ids = {"baylor_scott_&_white":["00001", "00002", "00003", "00004", "00005", "00006", "00007"],
                    "dell_seton_at_the_university_of_texas":["aa", "bb", "cc"]}
    registration_repository = Registration_Repository()
    new_administrator = json.loads(request.data)  # load JSON data from request
    if new_administrator["employeeID"] not in approved_ids[new_administrator["hospital"]]:
        error_msg = "Employee ID not found"
        response['msg'] = error_msg
        return jsonify(response), 404
    else:
        if registration_repository.add_administrator(new_administrator) != False:
            approved_ids[new_administrator["hospital"]].remove(new_administrator['employeeID'])
            return jsonify(response), 200
        else:
            return jsonify(response), 400
        

@app.route('/addUser', methods=['POST'])
def add_user():
    response = {}
    registration_repository = Registration_Repository()
    new_user = json.loads(request.data)  # load JSON data from request
    if registration_repository.add_user(new_user) == True:
        return jsonify(response), 200
    else:
        return jsonify(response), 400

@app.route('/Registrations', methods=['GET'])
def get_registration():
    response = {'registrations': ''}
    registration_repository = Registration_Repository()
    registrations = registration_repository.get_registration()
    response['registrations'] = registrations
    return jsonify(response['registrations']), 200

@app.route('/chooseHospital', methods=['GET'])
def get_hospital():
    hospital_name = request.headers.get('name')
    response = {}
    
    try:
        hospital = db.session.query(Hospital).filter(Hospital.name == hospital_name).first().serialize
        response['hospital'] = hospital
        return jsonify(response['hospital']), 200
    except:
        return jsonify(response), 404

if __name__ == '__main__':
    app.debug = True
    app.run()
