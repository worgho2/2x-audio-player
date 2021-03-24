//
//  RepositoryManager.swift
//  2xSpeedAudio
//
//  Created by otavio on 10/02/21.
//

import Foundation

class Preferences {
    
    @Preference(key: "playback_speed", defaultValue: 1.0)
    static var playbackSpeed: Float
    
    @Preference(key: "locale_code", defaultValue: "en")
    static var localeCode: String
    
}
