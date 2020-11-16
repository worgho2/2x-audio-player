import UIKit
import AVFoundation

protocol VideoPlayer: UIView {
    func playVideo(using player: AVPlayer)
}
final class TXTutorialView: UIView, VideoPlayer {
    
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
