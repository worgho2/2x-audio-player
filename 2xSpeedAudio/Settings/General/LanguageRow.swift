//
//  LanguageRow.swift
//  2xSpeedAudio
//
//  Created by otavio on 02/02/21.
//

import Foundation
import UIKit

class LanguageRow: SettingsTableViewRow {
    private let cellIdentifier: String = "RightDetailTableViewCell"
    private let cellNibName: String = "RightDetailTableViewCell"
    private var sender: UIViewController?
    
    func registerCell(on tableView: UITableView) {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func buildCell(for tableView: UITableView, sender: UIViewController) -> UITableViewCell {
        self.sender = sender
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RightDetailTableViewCell
        cell.setup(image: UIImage(systemName: "character")!, title: "Language", detail: "English")
        return cell
    }
    
    func didSelected() {
        
        let alert = UIAlertController(title: "Cooming Soon", message: nil, preferredStyle: .alert)
        sender?.present(alert, animated: true, completion: {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (t) in
                self.sender?.dismiss(animated: true, completion: nil)
                t.invalidate()
            }
        })
    }
}
