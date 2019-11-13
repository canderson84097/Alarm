//
//  SwitchTableViewCell.swift
//  myAlarm
//
//  Created by Chris Anderson on 11/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

protocol SwitchDelegate: class {
    func switchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var cellDelegate: SwitchDelegate?
    
    // MARK: - Actions
    @IBAction func switchTurnedOn(_ sender: UISwitch) {
        cellDelegate?.switchValueChanged(cell: self)
    }
    
    func updateViews(with alarm: Alarm) {
        nameLabel.text = alarm.name
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.isOn
        self.backgroundColor = alarm.isOn ? .cyan : .red
        if alarm.isOn != true {
            nameLabel.textColor = .black
            timeLabel.textColor = .black
        }
    }

}
