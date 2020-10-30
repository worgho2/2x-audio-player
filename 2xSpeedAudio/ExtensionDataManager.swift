//
//  ExtensionDataManager.swift
//  2xSpeedAudio
//
//  Created by otavio on 30/10/20.
//

import Foundation

protocol ExtensionDataLoader {
    func update()
}

class ExtensionDataManager {
    static let instance = ExtensionDataManager()
    
    var subscribers = [ExtensionDataLoader]()
    
    private init() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (_) in
            self.subscribers.forEach({$0.update()})
        }
    }
    
    func subcribe(_ subscriber: ExtensionDataLoader) {
        self.subscribers.append(subscriber)
    }
}
