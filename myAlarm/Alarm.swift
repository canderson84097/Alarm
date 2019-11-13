//
//  Alarm.swift
//  myAlarm
//
//  Created by Chris Anderson on 11/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

class Alarm: Codable {
    var name: String
    var isOn: Bool
    var uuid: String
    var fireDate: Date
    
    
    var fireTimeAsString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: fireDate)
    }
    
    init(name: String, isOn: Bool, fireDate: Date, uuid: String = UUID().uuidString) {
        self.name = name
        self.isOn = isOn
        self.fireDate = fireDate
        self.uuid = uuid
    }
}
extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return (lhs.name == rhs.name) && (lhs.fireDate == rhs.fireDate) && (lhs.isOn == rhs.isOn)
    }
}

