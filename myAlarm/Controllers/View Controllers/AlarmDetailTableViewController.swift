//
//  AlarmDetailTableViewController.swift
//  myAlarm
//
//  Created by Chris Anderson on 11/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var alarmOnButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var alarmLanding: Alarm? {
        didSet {
            loadViewIfNeeded()
            guard let alarm = alarmLanding else { return }
            updateViews(alarm: alarm)
        }
    }
    
    var alarmIsOn: Bool = true
    
    
    
    
    // MARK: - Actions
    @IBAction func alarmOnButtonPressed(_ sender: UIButton) {
        if alarmIsOn {
            alarmIsOn = false
            alarmOnButton.setTitle("Alarm off!", for: .normal)
            alarmOnButton.setTitleColor(.systemRed, for: .normal)
        } else {
            alarmIsOn = true
            alarmOnButton.setTitle("Alarm on!", for: .normal)
            alarmOnButton.setTitleColor(.systemGreen, for: .normal)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let dateOnPicker = datePicker.date
        guard let alarmTitle = detailTextField.text, title != "" else { return }
        // Update Alarm.
        if let alarm = alarmLanding {
            AlarmController.sharedInstance.updateAlarm(alarm: alarm, fireDate: dateOnPicker, name: alarmTitle, isOn: alarmIsOn)
        } else {
            AlarmController.sharedInstance.addAlarm(fireDate: dateOnPicker, name: alarmTitle, isOn: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews(alarm: Alarm) {
        datePicker.date = alarm.fireDate
        detailTextField.text = alarm.name
        
        
    }
    
}
