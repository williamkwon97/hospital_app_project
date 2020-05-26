//
//  RegistrationViewController.swift
//  finalproject
//
//  Created by Landry Luker on 4/28/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    var registeredAdministrator: Administrator?
    
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var CameraImageView: UIImageView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    @IBOutlet weak var employeeIDTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        
   
        

        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle:.actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style:.default, handler: {(action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
            else{
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in self.imagePickerController.sourceType = .photoLibrary;
            self.present(self.imagePickerController, animated: true, completion:nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title:" Cancel", style:.cancel, handler:nil))
        self.present(actionSheet,animated: true, completion:nil)
        
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
       
        imageView.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:true,completion:  nil)
    }
    
    //Sign up function
    @IBAction func Submit(_ sender: UIButton)  {
        let encoder = JSONEncoder()
        let requestedAdministrator = Administrator(id : usernameTextfield.text!, password: PasswordTextfield.text! ,first_name: firstNameTextfield.text!, last_name: lastNameTextfield.text!,hospital: myHospital!.id, imageString: imageView.image?.pngData()?.base64EncodedString() ?? portraitString, imageID: (imageView.image ?? UIImage(named: "portrait"))!, employeeID: employeeIDTextField.text!)
        
        // preemtively set the registeredAdministrator to be the requested administrator. if this administrator already exists then it will be changed back to void
        self.registeredAdministrator = requestedAdministrator
        let encodedAdministrator = try! encoder.encode( requestedAdministrator)
        let administratorDictonary = try! JSONSerialization.jsonObject(with:encodedAdministrator, options: []) as! [String: String]
        
        submitRequest(parameters: administratorDictonary)
        }
        
    
    private func submitRequest(parameters: Parameters)  {
        AF.request("http://127.0.0.1:5000/addAdminstrator", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                      self.performSegue(withIdentifier: "successAdmin" , sender: UIButton.self)
                    
                case .failure(let error):
                    // if the request failed, changed the registeredAdministrator back to void
                    self.registeredAdministrator = nil
                    self.alert(title: "alert", message: "\(error)")
                    
                }
        }
    }
    
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
        
        // if an administrator was registered successfully then perform the segue
        if segue.identifier == "successAdmin" {
            let destinationVC = segue.destination as! HospitalTableViewController
            destinationVC.myAdministrator = self.registeredAdministrator
        }
        
    }

    
}


