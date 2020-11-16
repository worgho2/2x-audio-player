import UIKit
import AVFoundation

final class TXVideoView: UIView {
    
    // MARK: - Properties
    private var currentLayer: AVPlayerLayer?
    private var player: AVPlayer?
    
    // MARK: - Public API
    func play(_ player: AVPlayer) {
      
        self.player?.pause()
        self.currentLayer?.removeFromSuperlayer()
        self.currentLayer = nil
        self.player = nil
        
        let layer = AVPlayerLayer(player: player)

        layer.needsDisplayOnBoundsChange = true
        
        layer.bounds = bounds
        layer.frame = frame
        
        layer.repeatCount = 1
        layer.repeatDuration = 0
        
        layer.videoGravity = .resizeAspectFill

        player.actionAtItemEnd = .none
        player.externalPlaybackVideoGravity = .resizeAspectFill

        self.layer.addSublayer(layer)
        
        self.currentLayer = layer
        self.player = player
        
        self.player?.play()
    }
}
