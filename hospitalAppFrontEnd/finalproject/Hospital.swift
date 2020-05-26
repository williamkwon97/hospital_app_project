//
//  Hospital.swift
//  finalproject
//
//  Created by Peter Vail Driscoll II on 5/5/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

struct Hospital {
    let id: String
    let name: String
    let city: String
    let state: String
    let zipcode: String
    let street: String
    let dateJoined: String
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case city = "city"
        case state = "state"
        case zipcode = "zipcode"
        case street = "street"
        case dateJoined = "date_joined"
    }
}

extension Hospital : Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.zipcode = try container.decode(String.self, forKey: .zipcode)
        self.street = try container.decode(String.self, forKey: .street)
        self.dateJoined = try container.decode(String.self, forKey: .dateJoined)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.city, forKey: .name)
        try container.encode(self.state, forKey: .city)
        try container.encode(self.zipcode, forKey: .state)
        try container.encode(self.street, forKey: .zipcode)
        try container.encode(self.zipcode, forKey: .street)
        try container.encode(self.street, forKey: .dateJoined)
        try container.encode(self.dateJoined, forKey: .dateJoined)
    }
}

