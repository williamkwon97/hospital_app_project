//
//  User.swift
//  finalproject
//
//  Created by Peter Vail Driscoll II on 4/30/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit

struct User {
    let id: String
    let first_name: String
    let last_name: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case first_name = "first_name"
        case last_name = "last_name"
        case password = "password"
        

    }
  /*
    init(data: [String: String]) {
        self.id = data["id"]!
        self.first_name = ["first_name"]!
        self.last_name = data["last_name"]!
        self.password = data["password"]!
    }
 */
    

}
extension User {
    init(data: [String: String]) {
        self.id = data["id"]!
        self.first_name = data["first_name"]!
        self.last_name = data["last_name"]!
        self.password = data["password"]!
    }
    
}
extension User: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.first_name = try container.decode(String.self, forKey: .first_name)
        self.last_name = try container.decode(String.self, forKey: .last_name)
        self.password = try container.decode(String.self, forKey: .password)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.first_name, forKey: .first_name)
        try container.encode(self.last_name, forKey: .last_name)
        try container.encode(self.password, forKey: .password)
    }
}
