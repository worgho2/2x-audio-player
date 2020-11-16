//
//  TutorialSection.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import Foundation

class TutorialSection: MainTableViewSection {
    init() {
        super.init(
            headerTitle: "Tutorial",
            footerTitle: nil,
            rows: [
                BasicRow(),
                HowItWorksRow(),
                AddExtensionToFavoritesRow(),
            ]
        )
    }
}
