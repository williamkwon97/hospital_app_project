//
//  ViewController.swift
//  finalproject
//
//  Created by William Kwon on 4/27/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit
import CoreData
import UIKit
import Alamofire
var myHospital: Hospital?

class DomainViewController: UIViewController {
    
    
    @IBOutlet weak var hospitalQuery: UITextField!
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"PreferredHospital")
        var fetchedResults:NSManagedObject? = nil
        do {
            try fetchedResults = managedContext.fetch(fetchRequest).first as? NSManagedObject
            hospitalQuery.text = fetchedResults?.value(forKey: "hospital") as? String
        } catch {
            let nserror = error as NSError
            NSLog("Unable to fetch \(nserror), \(nserror.userInfo)")
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func validateHospital(headers: HTTPHeaders, completion: @escaping (Hospital?) -> Void) {
        AF.request("http://127.0.0.1:5000/chooseHospital", method: .get, headers : headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    // the backend should always send back a dictionary if the request was received. if no user or administrator matched then the value of the dictionary will be null
                    guard let hospitalData = response.data
                        else {
                            return completion(nil)
                    }
                    let jsonDecoder = JSONDecoder()
                    let fetchedHospital = try! jsonDecoder.decode(Hospital.self, from: hospitalData)
                    completion(fetchedHospital)
                    
                case .failure(let error):
                    completion(nil)
                    print("error", error)
                    
                }
                
        }
    }
    
    @IBAction func Submit(_ sender: UIButton) {
        let hospitalInfo: HTTPHeaders = ["name": hospitalQuery.text!]
        validateHospital (headers: hospitalInfo) { fetchedHospital in
            
            // the entered credentials do not match an existing hospital thus the login failed and a nil value was returned
            guard fetchedHospital != nil else {
                
                myHospital = nil
                // TO DO: Make a pretty little error message that appears if your login was incorrect - base it off of Instagram or FB maybe?
                return self.alert(title: "Failure", message: "failed")
            }
            myHospital = fetchedHospital
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PreferredHospital")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try managedContext.execute(deleteRequest)
            } catch {
                print ("There was an error")
            }
            
            let entity = NSEntityDescription.entity(forEntityName: "PreferredHospital", in: managedContext)
            
            let aHospital = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            aHospital.setValue(self.hospitalQuery.text!, forKey: "hospital")
            
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unable to save \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            self.performSegue(withIdentifier: "Login", sender: UIButton.self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if a user was returned pass it to the Patient View Controller and perform the segue
        if segue.identifier == "Login" {
            let destinationVC = segue.destination as! LoginViewController
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





