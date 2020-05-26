//
//  PatientRequestLandingPageViewController.swift
//  finalproject
//
//  Created by Peter Vail Driscoll II on 5/15/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit

class PatientRequestLandingPageViewController: UIViewController {
    var myUser: User?
    var patientRequestInfo: PatientRequest?
    @IBOutlet weak var customMessage: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (patientRequestInfo!.administratorMessage != nil) {
            customMessage.text = patientRequestInfo?.administratorMessage
        }
        // Do any additional setup after loading the view.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
