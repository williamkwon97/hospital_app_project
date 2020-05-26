//
//  HospitalTableViewController.swift
//  finalproject
//
//  Created by Landry Luker on 4/28/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit
import PusherSwift
import Alamofire

class HospitalTableViewController: UITableViewController{
    var pusher: Pusher!
    var myAdministrator: Administrator?
    var patientRequests: [PatientRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listenForNewMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let adminCredentials: HTTPHeaders = ["administrator":myAdministrator!.hospital]
        fetchPatientRequests(administratorID:adminCredentials) {fetchedPatientRequests in
            guard fetchedPatientRequests != nil else {
                return
            }
            self.patientRequests = fetchedPatientRequests!
            self.tableView.reloadData()
            
        }
    }
    private func fetchPatientRequests(administratorID:HTTPHeaders, completion: @escaping ([PatientRequest]?) -> Void) {
        AF.request("http://127.0.0.1:5000/patientRequests", method: .get, headers: administratorID)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    
                    guard let rawPatientRequests = response.data
                        else {
                            return completion(nil)
                    }
                    
                    let jsonDecoder = JSONDecoder()
                    
                    let patientRequests = try! jsonDecoder.decode([PatientRequest].self, from: rawPatientRequests)
                    var createdPatientRequests = [PatientRequest]()
                    for patientRequest in patientRequests {
                        if patientRequest.patientAccepetedStatus == "created" {
                            createdPatientRequests.append(patientRequest)
                        }
                    }
                    
                    
                    completion(createdPatientRequests)
                case .failure(let error):
                    completion(nil)
                    print(error)
                }
        }
    }
    
    private func listenForNewMessages() {
        let options = PusherClientOptions(
            host: .cluster("us2")
        )
        
        pusher = Pusher(key: "1d4f9403bbf0dc92fed2", options: options)
        
        let channel = pusher.subscribe("patientRequests")
        channel.bind(eventName: "new-request", callback: { (data: Any?) -> Void in
            if let data = data as? NSDictionary {
                let jsonDecoder = JSONDecoder()
                let encodedData = try! JSONSerialization.data(withJSONObject: data, options: []) as Data
                let newPatientRequest = try! jsonDecoder.decode(PatientRequest.self, from: encodedData)
                self.patientRequests.append(newPatientRequest)
                self.tableView.reloadData()
            }
        })
        pusher.connect()
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientRequests.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let accept = UITableViewRowAction(style: .normal, title: "Accept") { (action, indexPath) in
            
            let encoder = JSONEncoder()
            var selectedPatientRequest = self.patientRequests[indexPath.row]
            
            selectedPatientRequest.patientAccepetedStatus = "accepted"
            selectedPatientRequest.administratorId = self.myAdministrator!.id
            
            let encodedPatientRequest = try! encoder.encode(selectedPatientRequest)
            let patientRequestDictonary = try! JSONSerialization.jsonObject(with:encodedPatientRequest, options: []) as! [String:String]
            
            self.changePatientRequestStatus(parameters: patientRequestDictonary) {bool in
                if bool == true {
                    self.patientRequests.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData() 
               
                    
                }
                else {
                    print("Request Failed")
                }
            }
        }
        
        let info = UITableViewRowAction(style: .normal, title: "Info") { (action, indexPath) in
                  let patientRequestTableViewCell = tableView.cellForRow(at: indexPath) as! PatientRequestTableViewCell
            self.performSegue(withIdentifier: "PatientRequestInformation", sender: patientRequestTableViewCell.self)
        }
        
        accept.backgroundColor = UIColor.green
        info.backgroundColor = UIColor.blue
        
        return [accept, info]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PatientRequestTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PatientRequestTableViewCell
           
        // Fetches the appropriate patientReuest for the data source layout.
        let patientRequest = patientRequests[indexPath.row]
        
        cell.patientNameLabel.text = "\(patientRequest.patientFirstName!) \(String(describing: patientRequest.patientLastName!))"
        cell.designatedPickupLabel.text = "\(String(describing: patientRequest.userId!))"
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "PatientRequestInformation" {
            guard let hospitalViewController = segue.destination as?
                HospitalViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPatientRequestCell = sender as? PatientRequestTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPatientRequestCell) else {
                fatalError("The selected cell is not being displated by the table")
            }
            
            let selectedPatientRequest = patientRequests[indexPath.row]
            hospitalViewController.myAdministrator = self.myAdministrator!
            hospitalViewController.patientRequestInfo = selectedPatientRequest
            
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
