//
//  PrivacyPolicyRow.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation
import UIKit

class LicensesRow: MainTableViewRow {
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
        cell.setup(image: UIImage(systemName: "checkmark.seal.fill")!, title: "Licenses")
        return cell
    }
    
    func didSelected() {
        self.sender?.performSegue(withIdentifier: "LicensesSegue", sender: self.sender)
    }
}
