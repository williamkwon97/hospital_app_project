//
//  Administrator.swift
//  finalproject
//
//  Created by Peter Vail Driscoll II on 5/4/20.
//  Copyright © 2020 groupproject. All rights reserved.
//
import UIKit

struct Administrator {
    let id: String
    let password: String
    let first_name: String
    let last_name: String
    let hospital: String
    let imageString: String
    let imageID: UIImage
    let employeeID: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case password = "password"
        case first_name = "first_name"
        case last_name = "last_name"
        case hospital = "hospital"
        case image = "image"
        case employeeID = "employeeID"
    }
    
  
}
extension Administrator {
    init(data: [String: String]) {
          self.id = data["id"]!
          self.password = data["password"]!
          self.first_name = data["first_name"]!
          self.last_name = data["last_name"]!
          self.hospital = data["hospital"]!
          self.imageString = data["image"]!
          self.employeeID = data["employeeID"]!
        if UIImage(data: Data(base64Encoded: self.imageString)!) == nil {
            self.imageID = UIImage(named: "portrait")!
        } else {
            self.imageID = UIImage(data: Data(base64Encoded: self.imageString)!)!
        }
      }
}

extension Administrator : Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.password = try container.decode(String.self, forKey: .password)
        self.first_name = try container.decode(String.self, forKey: .first_name)
        self.last_name = try container.decode(String.self, forKey: .last_name)
        self.hospital = try container.decode(String.self, forKey: .hospital)
        self.imageString = try container.decode(String.self, forKey: .image)
        self.employeeID = try container.decode(String.self, forKey: .employeeID)
        if UIImage(data: Data(base64Encoded: self.imageString)!) == nil {
            self.imageID = UIImage(named: "portrait")!
        } else {
            self.imageID = UIImage(data: Data(base64Encoded: self.imageString)!)!
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.password, forKey: .password)
        try container.encode(self.first_name, forKey: .first_name)
        try container.encode(self.last_name, forKey: .last_name)
        try container.encode(self.hospital, forKey: .hospital)
        try container.encode(self.imageString, forKey: .image)
        try container.encode(self.employeeID, forKey: .employeeID)
    }
}


