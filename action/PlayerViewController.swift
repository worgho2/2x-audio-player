//
//  PlayerViewController.swift
//  extension
//
//  Created by otavio on 30/10/20.
//

import UIKit
import Social
import MobileCoreServices
import AVFoundation

public func txLog(_ message: Any...) {
    NSLog("[asdqwe] \(message)")
}

class PlayerViewController: UIViewController, PlayerObserverProtocol, TranscriptorDelegate {
    // MARK: - TranscriptorDelegate methods
    func onRecognitionCompleted(result: String?, error: Error?) {
       txLog("RECOGNITION COMPLETED!", result, error)
    }
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var spacerView: UIView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var transcriptionTextView: UITextView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var player = AudioPlayer.instance
    
    var currentRateState: RateButtonState = .fast
    
    var sliderTimer: Timer?
    
    private var transcriptor: Transcriptor = DefaultTranscriptor()
    
    //MARK: - Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewState(.initial)
        loadAudioFilesFromAttachments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transcriptor.requestAuthorization()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.extensionContext?.cancelRequest(withError: Error.self as! Error)
    }
    
    //MARK: - Loading
    func loadAudioFilesFromAttachments() {
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeData as String
        
        for provider in attachments {
            guard provider.hasItemConformingToTypeIdentifier(contentType)
            else { continue }
            provider.loadItem(
                forTypeIdentifier: contentType,
                options: nil
            ) { [weak self] (data, error) in
                guard let self = self,
                      let url = data as? URL,
                      error == nil
                else { return }
                self.transcribe(from: url)
                self.player.addListener(self)
                self.player.prepareToPlay(contentsOf: url)
                self.player.setRate(rate: self.currentRateState.rawValue)
            }
        }
    }
    
    //MARK: - PlayerObserverProtocol
    func setup() {
        setTimerSliderRange(min: 0, max: player.duration)
        setDurationLabelState(player.duration.asFormatedString())
    }
    
    func update() {
        setCurrentTimeLabelState(player.currentTime.asFormatedString())
        setTimerSliderState(player.currentTime)
    }

    func didFinishPlaying() {
        setPlayButtonState(.play)
    }
    
    // MARK: - Transcription
    private func transcribe(from url: URL) {
        startLoadingTranscription()
        transcriptor.transcribe(from: url) { [weak self] result, error in
            self?.stopLoadingTranscription()
            txLog("got a result!", result)
            guard let result = result else {
                return // TODO present error
            }
            self?.transcriptionTextView.text = result
        }
    }
    
    func startLoadingTranscription() {
        loadingView.isHidden = false
        loadingActivityIndicator.startAnimating()
    }
    
    func stopLoadingTranscription() {
        loadingView.isHidden = true
        loadingActivityIndicator.stopAnimating()
    }
    
    //MARK: - View Components State
    func setViewState(_ state: ViewState) {
        switch state {
        case .initial:
            DispatchQueue.main.async {
                
                self.view.backgroundColor = .clear
                self.view.isOpaque = false
                
                self.spacerView.clipsToBounds = true
                self.spacerView.layer.cornerRadius = 0.45 * min(self.spacerView.frame.width, self.spacerView.frame.height)
                
                self.contentView.clipsToBounds = true
                self.contentView.layer.cornerRadius = 0.188 * min(self.contentView.frame.width, self.contentView.frame.height)
                self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            
            setDurationLabelState(.initial)
            setCurrentTimeLabelState(.initial)
            setPlayButtonState(.play)
            setRateButtonState(.fast)
            
            break
        }
        
    }
    
    func setPlayButtonState(_ state: PlayButtonState) {
        DispatchQueue.main.async {
            self.playButton.setBackgroundImage(UIImage(systemName: state.rawValue), for: .normal)
        }
    }
    
    func setRateButtonState(_ state: RateButtonState) {
        DispatchQueue.main.async {
            self.rateButton.setTitle("\(state.rawValue)x", for: .normal)
        }
    }
    
    func setGoBackwardButtonState(_ state: GoBackwardButtonState) {
        DispatchQueue.main.async {
            self.goBackButton.setBackgroundImage(UIImage(systemName: state.rawValue), for: .normal)
        }
    }
    
    func setGoForwardButtonState(_ state: GoForwardButtonState) {
        DispatchQueue.main.async {
            self.goBackButton.setBackgroundImage(UIImage(systemName: state.rawValue), for: .normal)
        }
    }
    
    func setDurationLabelState(_ state: DurationLabelState) {
        DispatchQueue.main.async {
            self.durationLabel.text = state.rawValue
        }
    }
    
    func setDurationLabelState(_ text: String) {
        DispatchQueue.main.async {
            self.durationLabel.text = text
        }
    }
    
    func setCurrentTimeLabelState(_ state: DurationLabelState) {
        DispatchQueue.main.async {
            self.currentTimeLabel.text = state.rawValue
        }
    }
    
    func setCurrentTimeLabelState(_ text: String) {
        DispatchQueue.main.async {
            self.currentTimeLabel.text = text
        }
    }
    
    func setTimerSliderState(_ value: Float) {
        DispatchQueue.main.async {
            self.timeSlider.value = value
        }
    }
    
    func setTimerSliderRange(min: Float, max: Float) {
        DispatchQueue.main.async {
            self.timeSlider.minimumValue = min
            self.timeSlider.maximumValue = max
        }
    }
    
    //MARK: - View Components Action
    
    @IBAction func onPlayButton(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            setPlayButtonState(.play)
        } else {
            player.play()
            setPlayButtonState(.pause)
        }
    }
    
    @IBAction func onGoBackButton(_ sender: Any) {
        player.goBackward(15)
    }
    
    @IBAction func onGoForwardButton(_ sender: Any) {
        player.goForward(15)
    }
    
    @IBAction func onRateButton(_ sender: Any) {
        currentRateState = currentRateState.next()
        player.setRate(rate: currentRateState.rawValue)
        setRateButtonState(currentRateState)
    }
    
    
    @IBAction func onTimeSlider(_ sender: Any) {
        sliderTimer?.invalidate()
        
        player.pause()
        player.currentTime = timeSlider.value
        setCurrentTimeLabelState(timeSlider.value.asFormatedString())
        
        sliderTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (t) in
            self.player.play()
            self.setPlayButtonState(.pause)
        })
        //MARK: - TODO
    }
}

enum ViewState {
    case initial
}

enum DurationLabelState: String {
    case initial = "--:--"
    case zero = "00:00"
}

enum CurrentTimeLabelState: String {
    case initial = "--:--"
    case zero = "00:00"
}

enum GoBackwardButtonState: String {
    case initial = "gobackward.15"
}

enum GoForwardButtonState: String {
    case initial = "goforward.15"
}

enum RateButtonState: Float {
    case normal = 1
    case nice = 1.4
    case fast = 1.8
    case faster = 2.2
    
    func next() -> RateButtonState {
        switch self {
        case .normal: return .nice
        case .nice: return .fast
        case .fast: return .faster
        case .faster: return .normal
        }
    }
}


enum PlayButtonState: String {
    case play = "play.fill"
    case pause = "pause.fill"
}
