import UIKit
import AVFoundation
protocol VideoManagerDelegate: AnyObject {
    func play(using player: AVPlayer)
}

protocol VideoPlayer: AnyObject {
    func playVideo()
}

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
protocol VideoManager {
    var delegate: VideoManagerDelegate? { get set }
    func setup()
}
class TXVideoManager: VideoManager {
    
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
    func playVideo() {
        
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

final class TXTutorialView: UIView {
    
    private lazy var videoView: TXVideoView = {
        let view = TXVideoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    init(
        title: String,
        description: String
    ) {
        super.init(frame: .zero)
        titleLabel.text = title
        descriptionLabel.text = description
        addSubviews()
        constraintSubviews()
    }
    
    // MARK: - UIView lifecycle
    private func addSubviews() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(videoView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(descriptionLabel)
    }
    private func constraintSubviews() {
        constraintContainerView()
    }

    // MARK: - Constraints subviews
    private func constraintContainerView(){
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            containerStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            containerStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            containerStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
        ])
    }
    
    // MARK: - Video player methods
    func playVideo(using player: AVPlayer) {
        videoView.play(player)
    }
    
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("This view should not be instantiated on storyboard")
    }
}

final class TXTutorialViewController: UIViewController, VideoManagerDelegate {
    
    private let tutorialView: TXTutorialView
    private var videoManager: VideoManager
    
    // MARK: -
    init(
        url: URL,
        title: String,
        description: String
    ) {
        videoManager = TXVideoManager(url: url)
        tutorialView = .init(
            title: title,
            description: description
        )
        super.init(nibName: nil, bundle: nil)
        
        videoManager.delegate = self
    }
    
    
    // MARK: - UIViewController lifecycle
    override func loadView() { view = tutorialView }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoManager.setup()
    }
    
    
    // MARK: - VideoManagerDelegate
    func play(using player: AVPlayer) {
        tutorialView.playVideo(using: player)
    }
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("This class should only be used programatically")
    }
    
}
