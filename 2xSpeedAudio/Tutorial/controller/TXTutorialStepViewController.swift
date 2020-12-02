import UIKit
import AVFoundation

final class TXTutorialStepViewController: UIViewController, VideoManagerDelegate {
    
    // MARK: - Dependencies
    private let tutorialView: TXTutorialView
    private var videoManager: VideoManager
    
    // MARK: - Initialization
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
    override func viewDidLoad() {
        videoManager.setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - VideoManagerDelegate
    func play(using player: AVPlayer) {
        tutorialView.playVideo(using: player)
    }
    
    // MARK: - Public API
    func forcePlay() { // TODO REMOVE THIS, it's a bug
//        print("FORCE PLAY")
//        if let manager = videoManager as? TXVideoManager {
//            manager.playVideo()
//        }
    }
    
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("This class should only be used programatically")
    }
}

