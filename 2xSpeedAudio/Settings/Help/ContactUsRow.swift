//
//  PrivacyPolicyRow.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation
import UIKit
import MessageUI

class ContactUsRow: SettingsTableViewRow {
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
        cell.setup(image: UIImage(systemName: "envelope.fill")!, title: "Contact Us")
        return cell
    }
    
    func didSelected() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            
            mail.mailComposeDelegate = (self.sender as! MFMailComposeViewControllerDelegate)
            mail.setToRecipients(["otavio.baziewicz.filho@gmail.com", "akiratsukamoto13@gmail.com"])
            mail.setSubject("Contact from 2x Speed Audio")
            mail.setMessageBody("<p>Hey! Feel free to write whatever you want :)</p>", isHTML: true)
            
            self.sender?.present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Can't Write Email", preferredStyle: .alert)
            self.sender?.present(alert, animated: true)
        }
    }
}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
