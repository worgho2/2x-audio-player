//
//  Logger.swift
//  2xSpeedAudio
//
//  Created by otavio on 02/12/20.
//

import Foundation

class Logger {
    
    static func log(origin: Any, _ message: Any ...) {
        NSLog("""
        {
            [\(String(describing: origin))] - \(message)
        }
        """)
    }
    
}
