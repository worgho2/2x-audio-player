//
//  GeneralSection.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation

class GeneralSection: SettingsTableViewSection {
    init() {
        super.init(
            headerTitle: "General",
            footerTitle: nil,
            rows: [
                LanguageRow()
            ]
        )
    }
}
