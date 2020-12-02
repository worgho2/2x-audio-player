//
//  PrivacyPolicyRow.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation
import UIKit

class PrivacyPolicyRow: SettingsTableViewRow {
    private let cellIdentifier: String = "BasicTableViewCell"
    private let cellNibName: String = "BasicTableViewCell"
    private var sender: UIViewController?
    
    func registerCell(on tableView: UITableView) {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func buildCell(for tableView: UITableView, sender: UIViewController) -> UITableViewCell {
        self.sender = sender
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! BasicTableViewCell
        cell.setup(image: UIImage(systemName: "info.circle.fill")!, title: "Privacy Policy")
        return cell
    }
    
    func didSelected() {
        guard let url = URL(string: "https://worgho2.github.io/2x-speed-audio/privacy_policy.html") else {
            return
        }
        
        UIApplication.shared.open(url)        
    }
}
