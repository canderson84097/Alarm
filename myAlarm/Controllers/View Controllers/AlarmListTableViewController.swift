//
//  AlarmListTableViewController.swift
//  myAlarm
//
//  Created by Chris Anderson on 11/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedInstance.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmListCell") as? SwitchTableViewCell else { return UITableViewCell() }
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        cell.updateViews(with: alarm)
        cell.cellDelegate = self
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.deleteAlarm(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
            cancelUserNotifications(for: alarm)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "existingAlarmSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationVC = segue.destination as? AlarmDetailTableViewController {
                    let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
                    destinationVC.alarmLanding = alarm
                }
            }
        }
    }
}

extension AlarmListTableViewController: SwitchDelegate {
    func switchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        AlarmController.sharedInstance.toggledIsOn(for: alarm)
        cell.updateViews(with: alarm)
    }
}
extension AlarmListTableViewController: AlarmScheduler {
}
