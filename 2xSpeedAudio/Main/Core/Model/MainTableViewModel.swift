//
//  MainTableViewModel.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation
import UIKit

class MainTableViewModel {
    let sections: [MainTableViewSection]
    
    init() {
        self.sections = [
//            TutorialSection(),
            HelpSection()
        ]
    }
    
    func registerCells(on tableView: UITableView) {
        sections.forEach({ section in
            section.rows.forEach({ row in
                row.registerCell(on: tableView)
            })
        })
    }
}
