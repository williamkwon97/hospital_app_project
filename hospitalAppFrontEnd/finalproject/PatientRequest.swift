//
//  PatientRequest.swift
//  finalproject
//
//  Created by Peter Vail Driscoll II on 5/1/20.
//  Copyright © 2020 groupproject. All rights reserved.
//
import UIKit

struct PatientRequest {
    let id: String
    let userId: String?
    let hospitalId : String?
    var administratorId : String?
    let patientFirstName: String?
    let patientLastName: String?
    let patientRoomNumber: String?
    let patientDateOfBirth: String?
    let patientPhoneNumber: String?
    let patientEmailAddress: String?
    var patientAccepetedStatus: String?
    var administratorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "designated_pickup"
        case hospitalId = "hospital"
        case administratorId = "administrator"
        case patientFirstName = "first_name"
        case patientLastName = "last_name"
        case patientRoomNumber = "room_number"
        case patientDateOfBirth = "birthday"
        case patientPhoneNumber = "phone_number"
        case patientEmailAddress = "email_address"
        case patientAccepetedStatus = "status"
        case administratorMessage = "administrator_message"
    }
}
extension PatientRequest {
    init(Id: String, UserId: String, HospitalId: String, AdministratorId: String, PatientFirstName: String, PatientLastName: String, PatientRoomNumber: String, PatientDateOfBirth: String, PatientPhoneNumber: String, PatientEmailAddress: String, PatientAcceptedStatus: String, AdministratorMessage: String?) {
        self.id = Id
        self.userId = UserId
        self.hospitalId = HospitalId
        self.administratorId = AdministratorId
        self.patientFirstName = PatientFirstName
        self.patientLastName = PatientLastName
        self.patientRoomNumber = PatientRoomNumber
        self.patientDateOfBirth = PatientDateOfBirth
        self.patientPhoneNumber = PatientPhoneNumber
        self.patientEmailAddress = PatientEmailAddress
        self.patientAccepetedStatus = PatientAcceptedStatus
        self.administratorMessage = AdministratorMessage
    }
}
extension PatientRequest: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.administratorId = try container.decode(String.self, forKey: .administratorId)
        self.hospitalId = try container.decode(String.self, forKey: .hospitalId)
        self.patientFirstName = try container.decode(String.self, forKey: .patientFirstName)
        self.patientLastName = try container.decode(String.self, forKey: .patientLastName)
        self.patientRoomNumber = try container.decode(String.self, forKey: .patientRoomNumber)
        self.patientDateOfBirth = try container.decode(String.self, forKey: .patientDateOfBirth)
        self.patientPhoneNumber = try container.decode(String.self, forKey: .patientPhoneNumber)
        self.patientEmailAddress = try container.decode(String.self, forKey: .patientEmailAddress)
        self.patientAccepetedStatus = try container.decode(String.self, forKey: .patientAccepetedStatus)
           self.administratorMessage = try container.decode(String.self, forKey: .administratorMessage)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.administratorId, forKey: .administratorId)
        try container.encode(self.hospitalId, forKey: .hospitalId)
        try container.encode(self.patientFirstName, forKey: .patientFirstName)
        try container.encode(self.patientLastName, forKey: .patientLastName)
        try container.encode(self.patientRoomNumber, forKey: .patientRoomNumber)
        try container.encode(self.patientDateOfBirth, forKey: .patientDateOfBirth)
        try container.encode(self.patientPhoneNumber, forKey: .patientPhoneNumber)
        try container.encode(self.patientEmailAddress, forKey: .patientEmailAddress)
        try container.encode(self.patientAccepetedStatus, forKey: .patientAccepetedStatus)
        try container.encode(self.administratorMessage, forKey: .administratorMessage)
    }
}
