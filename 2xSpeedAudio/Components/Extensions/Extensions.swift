//
//  TimeIntervalExtension.swift
//  2xSpeedAudio
//
//  Created by otavio on 05/11/20.
//

import Foundation
import UIKit

extension TimeInterval {
    func asFormatedString() -> String {
        var x = Int(self)
        let seconds = x % 60
        x /= 60
        let minutes = x % 60
        return (minutes < 10 ? "0\(minutes)" : "\(minutes)") + ":" + (seconds < 10 ? "0\(seconds)" : "\(seconds)")
    }
}

extension Float {
    func asFormatedString() -> String {
        var x = Int(self)
        let seconds = x % 60
        x /= 60
        let minutes = x % 60
        return (minutes < 10 ? "0\(minutes)" : "\(minutes)") + ":" + (seconds < 10 ? "0\(seconds)" : "\(seconds)")
    }
}
