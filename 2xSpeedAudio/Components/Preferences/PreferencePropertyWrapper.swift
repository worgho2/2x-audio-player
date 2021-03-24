//
//  PreferencePropertyWrapper.swift
//  2xSpeedAudio
//
//  Created by otavio on 10/02/21.
//

import Foundation

@propertyWrapper
struct Preference<T> {
    let key: String
    let defaultValue: T
    var container: UserDefaults = .standard
    
    var wrappedValue: T {
        get {
            guard let output = container.object(forKey: key) as? T else {
                container.set(defaultValue, forKey: key)
                return defaultValue
            }
            
            Logger.log(origin: Self.self, "get \(key) : \(output)")
            return output
        }
        set {
            Logger.log(origin: Self.self, "set \(key) : \(newValue)")
            container.set(newValue, forKey: key)
        }
    }
}
