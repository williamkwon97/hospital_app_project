//
//  PatientViewController.swift
//  finalproject
//
//  Created by Landry Luker on 4/28/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit
import Alamofire
import PusherSwift

class PatientViewController: UIViewController {
    var myUser: User?
    var patientRequest: PatientRequest?
    var pusher: Pusher!
    
    @IBOutlet weak var patientFirstName: UITextField!
    @IBOutlet weak var patientLastName: UITextField!
    @IBOutlet weak var patientRoomNumber: UITextField!
    @IBOutlet weak var patientDateOfBirth: UITextField!
    @IBOutlet weak var patientPhoneNumber: UITextField!
    @IBOutlet weak var patientEmailAddress: UITextField!
    @IBOutlet weak var patientInfoView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingWheel: UIImageView!
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingWheel.layer.cornerRadius = loadingWheel.frame.width/2.0
        loadingWheel.layer.masksToBounds = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listenForPatientRequestStatus()
    }
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let encoder = JSONEncoder()
        let patientRequestUUID = UUID().uuidString
        // need to add a keyboardDidFinishEditing function to check that all the form values have been completed
        let patientRequest = PatientRequest(Id: patientRequestUUID, UserId : myUser!.id, HospitalId : myHospital!.id,
                                            AdministratorId : "", PatientFirstName : patientFirstName!.text!, PatientLastName : patientLastName!.text!,
                                            PatientRoomNumber : patientRoomNumber!.text!,
                                            PatientDateOfBirth : patientDateOfBirth!.text!,
                                            PatientPhoneNumber : patientPhoneNumber!.text!,
                                            PatientEmailAddress : patientEmailAddress!.text!, PatientAcceptedStatus: "created", AdministratorMessage: "NA" )
        let encodedPatientRequest = try! encoder.encode(patientRequest)
        let patientRequestDictonary = try! JSONSerialization.jsonObject(with:encodedPatientRequest, options: []) as! [String:String]
        submitRequest(parameters: patientRequestDictonary)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = CFTimeInterval(3)
        rotateAnimation.repeatCount=Float.infinity
        loadingWheel.layer.add(rotateAnimation, forKey: nil)
        
        patientInfoView.isHidden = true
        loadingView.isHidden = false
    }
    
    private func submitRequest(parameters: Parameters) {
        AF.request("http://127.0.0.1:5000/addPatientRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    break
                case .failure(let error):
                    self.alert(title: "Failure", message: "\(error)")
                    
                }
        }
    }
    
    private func listenForPatientRequestStatus() {
        let options = PusherClientOptions(
            host: .cluster("us2")
        )
        
        pusher = Pusher(key: "1d4f9403bbf0dc92fed2", options: options)
        
        let channel = pusher.subscribe("patientRequests")
        channel.bind(eventName: "changed-request", callback: { (data: Any?) -> Void in
            if let data = data as? NSDictionary {
                let jsonDecoder = JSONDecoder()
                let encodedData = try! JSONSerialization.data(withJSONObject: data, options: []) as Data
                let newPatientRequest = try! jsonDecoder.decode(PatientRequest.self, from: encodedData)
                self.patientRequest = newPatientRequest
                if newPatientRequest.patientAccepetedStatus == "accepted" {
                self.performSegue(withIdentifier: "PatientPickupLandingPage", sender: PatientViewController.self)
                }
            }
        })
        pusher.connect()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "PatientPickupLandingPage" {
            let destinationVC = segue.destination as! PatientRequestLandingPageViewController
            destinationVC.myUser = self.myUser
            destinationVC.patientRequestInfo = self.patientRequest
        }
    }
    
    private func alert(title: String, message: String) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
            return
        })
        present(alertCtrl, animated: true, completion: nil)
    }
    
}
