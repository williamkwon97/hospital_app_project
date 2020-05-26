//
//  RegisterUserViewController.swift
//  finalproject
//
//  Created by Peter Vail Driscoll II on 5/4/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit
import Alamofire

class RegisterUserViewController: UIViewController {
    
    var registeredUser : User?
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    @IBOutlet weak var ConfirmPasswordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional set
        
    }
    
    
    @IBAction func Submit(_ sender: Any)  {
        let encoder = JSONEncoder()
        let newUser = User(id : usernameTextfield.text!, first_name: firstNameTextfield.text!,last_name: lastNameTextfield.text!,password: PasswordTextfield.text! )
        
        // preemtively set the registeredAdministrator to be the requested administrator. if this administrator already exists then it will be changed back to void
        
        self.registeredUser = newUser
        let encodedRegisteration = try! encoder.encode( newUser)
        let RegisterationDictonary = try! JSONSerialization.jsonObject(with:encodedRegisteration, options: []) as! [String:String]
        submitRequest(parameters: RegisterationDictonary)
        
    }
    private func submitRequest(parameters: Parameters)  {
        AF.request("http://127.0.0.1:5000/addUser", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    self.performSegue(withIdentifier: "successUser" , sender: UIButton.self)
                    
                case .failure(let error):
                    // if the request failed, changed the registeredUser back to void
                    self.registeredUser = nil
                    self.alert(title: "alert", message: "\(error)")
                    
                }
        }
    }
    
    // change this to make a nice little error message rather than an alert
    private func alert(title: String, message: String) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(alertCtrl, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if an administrator was registered successfully then perform the segue
        if segue.identifier == "successUser" {
            let destinationVC = segue.destination as! PatientViewController
            destinationVC.myUser = self.registeredUser
        }
        
    }
    
}


