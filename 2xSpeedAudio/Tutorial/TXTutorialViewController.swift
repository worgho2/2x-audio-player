import UIKit
import AVFoundation

final class TXTutorialViewController: UIViewController, VideoManagerDelegate {
    
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

