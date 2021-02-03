//
//  DemoRow.swift
//  2xSpeedAudio
//
//  Created by otavio on 02/02/21.
//

import Foundation
import UIKit
import AVKit

class DemoRow: SettingsTableViewRow {
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
        cell.setup(image: UIImage(systemName: "play.circle.fill")!, title: "Demo video")
        return cell
    }
    
    func didSelected() {
        guard let path = Bundle.main.path(forResource: "sample", ofType: "mp4") else {
            return
        }
        
        let videoURL = NSURL(fileURLWithPath: path)
        
        let player = AVPlayer(url: videoURL as URL)
        player.isMuted = true
        player.volume = 0
        
        let avvc = AVPlayerViewController()
        avvc.player = player
        
        sender?.present(avvc, animated: true, completion: {
            player.play()
        })
    }
}
