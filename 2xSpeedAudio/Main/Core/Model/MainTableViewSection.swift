//
//  MainTableViewSection.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation
import UIKit

class MainTableViewSection {
    let headerTitle: String?
    let footerTitle: String?
    
    let rows: [MainTableViewRow]
    
    init(headerTitle: String?, footerTitle: String?, rows: [MainTableViewRow]) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.rows = rows
    }
}
