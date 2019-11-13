//
//  AlarmController.swift
//  myAlarm
//
//  Created by Chris Anderson on 11/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UserNotificationsUI

protocol AlarmScheduler: class {
}

extension AlarmScheduler {
    func scheduleUserNotifications(_ alarm: Alarm, _ date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm done!"
        content.body = "The alarm has finished!"
        content.badge = 1
        content.sound = .default()
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("failed to schedule notification")
                print(error, error.localizedDescription)
            } else {
                print("successfully scheduled notifications")
            }
        }
    }
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
class AlarmController: AlarmScheduler {
    
    var alarms: [Alarm] = []
    
    static let sharedInstance = AlarmController()
    
    // loadToPersistentStore works throughout the project here because all of the alarms are housed inside the controller.
    init() {
        loadToPersistentStore()
    }
    
    func addAlarm(fireDate: Date, name: String, isOn: Bool) {
        let newAlarm = Alarm(name: name, isOn: isOn, fireDate: fireDate)
        alarms.append(newAlarm)
        saveToPersistentStore()
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, isOn: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.isOn = isOn
        saveToPersistentStore()
    }
    
    func deleteAlarm(alarm: Alarm) {
        if let index = alarms.firstIndex(of: alarm) {
            alarms.remove(at: index)
            saveToPersistentStore()
        }
    }
    
    func toggledIsOn(for alarm: Alarm) {
        alarm.isOn = !alarm.isOn
        if alarm.isOn == true {
            scheduleUserNotifications(alarm, alarm.fireDate)
        } else {
            cancelUserNotifications(for: alarm)
        }
        saveToPersistentStore()
        
    }
    
//    func createAlert() {
//        let alert = UIAlertController(title: "WAKE UP!", message: "Time to wake up", preferredStyle: .alert)
//
//        alert.addTextField { (textField) in
//            textField.keyboardType = .numberPad
//            textField.placeholder = "How many minutes?"
//        }
//
//        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
//        alert.addAction(dismissAction)
//
//        let snoozeAction = UIAlertAction(title: "Snooze", style: .destructive) { (_) in
//            if let textField = alert.textFields?.first,
//                let timeAsString = textField.text,
//                let timeAsDouble = Double(timeAsString) {
//
//            }
//
//        }
//    }
    
    // MARK: - Persistence
    
    // Get the URL where we are saving our data.
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let filename = "alarms.json"
        let fullURL = documentDirectory.appendingPathComponent(filename)
        return fullURL
    }
    
    func saveToPersistentStore() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        } catch let error {
            print(error)
        }
    }
    
    func loadToPersistentStore() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            self.alarms = alarms
        } catch let error {
            print(error)
        }
    }
}
