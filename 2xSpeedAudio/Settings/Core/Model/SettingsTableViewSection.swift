//
//  SettingsTableViewSection.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation
import UIKit

class SettingsTableViewSection {
    let headerTitle: String?
    let footerTitle: String?
    
    let rows: [SettingsTableViewRow]
    
    init(headerTitle: String?, footerTitle: String?, rows: [SettingsTableViewRow]) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.rows = rows
    }
}
