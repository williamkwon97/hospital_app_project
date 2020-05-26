//
//  HospitalViewController.swift
//  finalproject
//
//  Created by Landry Luker on 4/28/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit
import Alamofire

class HospitalViewController: UIViewController {
    
    var myAdministrator: Administrator?
    var patientRequestInfo: PatientRequest?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var customMessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameLabel.text = "\(patientRequestInfo!.userId!)"
        patientNameLabel.text = "\(patientRequestInfo!.patientFirstName!) \(patientRequestInfo!.patientLastName!)"
        roomNumberLabel.text = "\(patientRequestInfo!.patientRoomNumber!)"
        dobLabel.text = "\(patientRequestInfo!.patientDateOfBirth!)"
        phoneNumberLabel.text = "\(patientRequestInfo!.patientPhoneNumber!)"
        emailLabel.text = "\(patientRequestInfo!.patientEmailAddress!)"
    }
    
    private func changePatientRequestStatus(parameters: Parameters, completion: @escaping (Bool) -> Void) {
        AF.request("http://127.0.0.1:5000/changePatientRequest", method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print(error)
                    completion(false)
                }
        }
    }
    
    @IBAction func acceptPatientRequestButtonPressed(_ sender: UIButton) {
        let encoder = JSONEncoder()
        
        patientRequestInfo!.patientAccepetedStatus = "accepted"
        patientRequestInfo!.administratorId = self.myAdministrator!.id
        patientRequestInfo?.administratorMessage = customMessage!.text
        let encodedPatientRequest = try! encoder.encode(patientRequestInfo)
        let patientRequestDictonary = try! JSONSerialization.jsonObject(with:encodedPatientRequest, options: []) as! [String:String]
        
        self.changePatientRequestStatus(parameters: patientRequestDictonary) {bool in
            if bool == true {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print("Request Failed")
            }
        }
        
    }
    
    @IBAction func rejectPatientRequestButtonPressed(_ sender: UIButton) {
        let encoder = JSONEncoder()
        
        self.patientRequestInfo!.patientAccepetedStatus = "rejected"
        self.patientRequestInfo!.administratorId = self.myAdministrator!.id
        self.patientRequestInfo!.administratorMessage = customMessage!.text
        let encodedPatientRequest = try! encoder.encode(self.patientRequestInfo)
        let patientRequestDictonary = try! JSONSerialization.jsonObject(with:encodedPatientRequest, options: []) as! [String:String]
   
        self.changePatientRequestStatus(parameters: patientRequestDictonary) {bool in
            if bool == true {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print("Request Failed")
            }
        }
    }
}

