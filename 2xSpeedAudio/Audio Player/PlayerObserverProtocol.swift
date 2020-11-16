//
//  PlayerObserverProtocol.swift
//  2xSpeedAudio
//
//  Created by otavio on 05/11/20.
//

import Foundation

protocol PlayerObserverProtocol {
    func setup()
    func update()
    func didFinishPlaying()
}
