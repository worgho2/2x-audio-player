//
//  PrivacyPolicyRow.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation
import UIKit

class HowItWorksRow: MainTableViewRow {
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
        cell.setup(image: UIImage(systemName: "hare.fill")!, title: "How It Works")
        return cell
    }
    
    func didSelected() {
        let alert = UIAlertController(title: "How It Works", message: "Whenever the option to share an audio is available in any application, just select the 'listen with 2x Speed Audio' option. To easily access it, add the extension to your favorites", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        sender?.present(alert, animated: true)
    }
}
