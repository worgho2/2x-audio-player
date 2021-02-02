//
//  Player.swift
//  2xSpeedAudio
//
//  Created by otavio on 05/11/20.
//

import Foundation
import AVFoundation
import UIKit

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    static let instance = AudioPlayer()
    
    private var playerObserverListeners = [PlayerObserverProtocol]()
    private var player: AVAudioPlayer?
    
    private override init() {
        super.init()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { (t) in
            self.playerObserverListeners.forEach({ $0.update() })
        })
        
        Logger.log(origin: Self.self, "Audio player initialized")
    }
    
    var isPlaying: Bool {
        get {
            return player?.isPlaying ?? false
        }
    }
    
    var currentTime: Float {
        set {
            player?.currentTime = TimeInterval(newValue)
        }
        get {
            return Float(player?.currentTime ?? 0)
        }
    }
    
    var duration: Float {
        get {
            return Float(player?.duration ?? 0)
        }
    }
    
    func addListener(_ listener: PlayerObserverProtocol) {
        self.playerObserverListeners.append(listener)
    }
    
    func prepareToPlay(contentsOf url: URL) {
        self.player = try! AVAudioPlayer(contentsOf: url)
        self.player?.delegate = self
        self.player?.enableRate = true
        self.player?.prepareToPlay()
        self.playerObserverListeners.forEach({$0.setup()})
    }
    
    func setRate(rate: Float) {
        self.player?.rate = rate
    }
    
    func play() {
        self.player?.play()
    }
    
    func pause() {
        self.player?.stop()
    }
    
    func goBackward(_ time: TimeInterval) {
        self.player?.currentTime -= time
    }
    
    func goForward(_ time: TimeInterval) {
        self.player?.currentTime += time
    }
    
    func stop() {
        self.pause()
        self.player?.currentTime = 0
        self.player?.prepareToPlay()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playerObserverListeners.forEach({$0.didFinishPlaying()})
    }
}
