//
//  SettingsTableViewController.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var model = SettingsTableViewModel()
    
    //MARK: - Application Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.registerCells(on: self.tableView)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return model.sections[indexPath.section].rows[indexPath.row].buildCell(for: tableView, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.sections[indexPath.section].rows[indexPath.row].didSelected()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.sections[section].headerTitle
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return model.sections[section].footerTitle
    }
    
}
