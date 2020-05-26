//
//  LoginViewController.swift
//  finalproject
//
//  Created by Landry Luker on 4/28/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit
import Alamofire
class LoginViewController: UIViewController {
    
    var myUser : User?
    var myAdministrator : Administrator?
    var dataValue : NSDictionary?
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func validateUser(headers: HTTPHeaders, completion: @escaping (NSDictionary?) -> Void) {
        AF.request("http://127.0.0.1:5000/login", method: .get, headers : headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    
                    // the backend should always send back a dictionary if the request was received. if no user or administrator matched then the value of the dictionary will be null
                    guard let data = response.value as? NSDictionary
                        
                        else {
                            self.alertError()
                            return completion(nil)
                    }
                    self.dataValue = data
                    
                case .failure(let error):
                    completion(nil)
                    print("error", error)
                    
                }
                completion(self.dataValue)
        }
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let userCredentials: HTTPHeaders = ["user": username.text!, "password" : password.text!]
        validateUser (headers: userCredentials) { data in
            
            // the entered credentials do not match an existing administrator nor user thus the login failed and a nil value was returned
            guard data != nil else {
                
                self.myUser = nil
                self.myAdministrator = nil
                
                // TO DO: Make a pretty little error message that appears if your login was incorrect - base it off of Instagram or FB maybe?
                return self.alertError()
            }
            // if the backend sent a JSON value back with a key called "user" then the login was for a user and we create an instance of the Swift User class
            if let fetchedUser = data!["user"] as? [String : String]{
                self.myUser = User(data: fetchedUser)
                self.performSegue(withIdentifier: "PatientVC", sender: UIButton.self)
            }
                
                // if the backend sent a JSON value back with a key called "administrator" then the login was for a user and we create an instance of the Swift Administrator class
            else if let adminstrator = data!["administrator"] as? [String: String]{
                self.myAdministrator = Administrator(data: adminstrator)
                self.performSegue(withIdentifier: "AdminVC", sender: UIButton.self)
            }
        }
    }
    
    // change this to make a nice little error message rather than an alert
    private func alertError() {
        return self.alert(
            title: "Failure",
            message: "Username or password is incorrect."
        )
    }
    
    // change this to make a nice little error message rather than an alert
    private func alert(title: String, message: String) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(alertCtrl, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if a user was returned pass it to the Patient View Controller and perform the segue
        if segue.identifier == "PatientVC" {
            let destinationVC = segue.destination as! PatientViewController
            destinationVC.myUser = self.myUser!
        }
            
            // if an administrator was returned pass it to the Administrator View Controller and perform the segue
        else if segue.identifier == "AdminVC" {
            let destinationVC = segue.destination as! HospitalTableViewController
            destinationVC.myAdministrator = self.myAdministrator!
        }
        
    }
}
