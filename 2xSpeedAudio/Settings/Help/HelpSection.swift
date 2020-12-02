//
//  HelpSection.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation

class HelpSection: SettingsTableViewSection {
    init() {
        super.init(
            headerTitle: "Help",
            footerTitle: nil,
            rows: [
                PrivacyPolicyRow(),
                ContactUsRow(),
                LicensesRow(),
            ]
        )
    }
}
