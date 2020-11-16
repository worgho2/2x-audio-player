import AVFoundation

protocol VideoManagerDelegate: AnyObject {
    func play(using player: AVPlayer)
}
protocol VideoManager {
    var delegate: VideoManagerDelegate? { get set }
    func setup()
}
final class TXVideoManager: VideoManager {
    
    // MARK: - Properties
    private var currentPlayer: AVPlayer?
    private var url: URL
    weak var delegate: VideoManagerDelegate?
    
    // MARK: - Control flags
    private var isIdle: Bool = true
    private var canPlay: Bool = true
    private var hasConfigured: Bool = false
    
    // MARK: - Initialization
    init(url: URL) {
        self.url = url
    }
    
    // MARK: - Playing functions
    func setup() {
        if self.hasConfigured { return }
        self.hasConfigured = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fileComplete),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        
        self.playVideo()
    }
   
    // MARK: - Helper methods
    private func playVideo() {
        
        guard canPlay
        else { return }
        
        let player = AVPlayer(url: url)
        player.isMuted = true
        canPlay = false
        currentPlayer = player
        isIdle = !isIdle
        delegate?.play(using: player)
    }
    
    // MARK: - Callbacks
    @objc func fileComplete(_ notification: NSNotification) {
        
        self.currentPlayer?.pause()
        self.currentPlayer = nil
        self.canPlay = true
        self.playVideo()
    }
    
}
