import UIKit
import AVFoundation

final class TXVideoView: UIView {
    
    // MARK: - Properties
    private var currentLayer: AVPlayerLayer?
    private var player: AVPlayer?
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 8
    }
    
    // MARK: - Public API
    func play(_ player: AVPlayer) { // TODO: Rethink this, the view should not need to know the player
      
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
    
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("This component can only be used programatically")
    }
}
