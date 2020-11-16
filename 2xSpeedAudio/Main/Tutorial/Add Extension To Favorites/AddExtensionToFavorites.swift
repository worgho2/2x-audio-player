//
//  PrivacyPolicyRow.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation
import UIKit

class AddExtensionToFavoritesRow: MainTableViewRow {
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
        cell.setup(image: UIImage(systemName: "pin.circle.fill")!, title: "Add Extension To Favorites")
        return cell
    }
    
    func didSelected() {
        let alert = UIAlertController(title: "Steps", message: "1. Tap 'Next'\n2. Scroll Down\n3. Tap 'Edit Actions...'\n4. Add 'Listen with 2x Speed Audio' to Favorites", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (a) in
            let activityItem = URL.init(fileURLWithPath: Bundle.main.path(forResource: "demo-track", ofType: "mp3")!)
            let activityVC = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
            self.sender?.present(activityVC, animated: true)
        }))
        sender?.present(alert, animated: true)
    }
}
