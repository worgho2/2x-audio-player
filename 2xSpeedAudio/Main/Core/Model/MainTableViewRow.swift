//
//  MainTableViewRow.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation
import UIKit

protocol MainTableViewRow {
    func registerCell(on tableView: UITableView)
    func buildCell(for tableView: UITableView, sender: UIViewController) -> UITableViewCell
    func didSelected()
}
