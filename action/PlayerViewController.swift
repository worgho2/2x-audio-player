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

class PlayerViewController: UIViewController, PlayerObserverProtocol {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var spacerView: UIView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var rateSegment: UISegmentedControl!
    
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var transcribeActivityMonitor: UIActivityIndicatorView!
    
    //MARK: - Transcription
    
    let transcriptor: Transcriptor = NativeTranscriptor()
    var urlToTranscribe: URL? // colocar para dentro do transcriptor
    
    //MARK: - Player
    
    var player = AudioPlayer.instance
    var sliderTimer: Timer?
    let speeds: [Float] = [1.0,1.25,1.5,2.0,2.25,2.5]
    
    //MARK: - Application Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewState(.initial)
        loadAudioFilesFromAttachments()
        rateSegment.selectedSegmentIndex = self.speeds.firstIndex(of: Preferences.playbackSpeed) ?? 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    //MARK: - Attachments Loading
    func loadAudioFilesFromAttachments() {
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeData as String
        
        for provider in attachments {
            
            guard provider.hasItemConformingToTypeIdentifier(contentType) else {
                continue
            }
            
            provider.loadItem(forTypeIdentifier: contentType, options: nil) { [weak self] (data, error) in
                
                guard let self = self, let url = data as? URL, error == nil else {
                    return
                }
                self.player.addListener(self)
                self.player.prepareToPlay(contentsOf: url)
                self.player.setRate(rate: 1.0)
                self.urlToTranscribe = url
                self.player.setRate(rate: Preferences.playbackSpeed)
            }
        }
    }
    
    //MARK: - PlayerObserverProtocol methods
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
                self.contentView.layer.cornerRadius = 0.07 * min(self.contentView.frame.width, self.contentView.frame.height)
                self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            
            setDurationLabelState(.initial)
            setCurrentTimeLabelState(.initial)
            setPlayButtonState(.play)
            setTranscribeComponentsState(.initial)
            break
        }
        
    }
    
    func setPlayButtonState(_ state: PlayButtonState) {
        DispatchQueue.main.async {
            self.playButton.setBackgroundImage(UIImage(systemName: state.rawValue), for: .normal)
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
    
    func setTranscribeComponentsState(_ state: TranscribeComponentsState) {
        DispatchQueue.main.async {
            switch (state) {
            case .initial:
                self.transcribeButton.isHidden = false
                self.transcribeActivityMonitor.stopAnimating()
                self.transcribeActivityMonitor.isHidden = true
                break
            case .transcribing:
                self.transcribeButton.isHidden = true
                self.transcribeActivityMonitor.startAnimating()
                self.transcribeActivityMonitor.isHidden = false
                break
            }
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
    
    @IBAction func onRateSegment(_ sender: UISegmentedControl) {
        guard let rate = Float(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "1.0") else {
            print("Erro no sender")
            return
        }
        
        Preferences.playbackSpeed = rate
        player.setRate(rate: rate)
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
    }
    
    @IBAction func onTranscribe(_ sender: Any) {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(transcriptor.availableLocationCodes.firstIndex(of: Preferences.localeCode) ?? 0, inComponent: 0, animated: false)
        
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        vc.preferredContentSize = CGSize(width: 250 , height: 200)
        vc.view.addSubview(pickerView)
        
        let alert = UIAlertController(title: "Select Audio Language", message: nil, preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Start", style: .default, handler: { [weak self] (_) in
            self?.setTranscribeComponentsState(.transcribing)
            
            self?.transcriptor.transcribe(contentsOf: self!.urlToTranscribe!, forLocale: Locale(identifier: Preferences.localeCode)) { (result, error) in
                if let error = error {
                    switch error {
                    case .fileError:
                        print("file error")
                    case .unauthorized:
                        print("Unauthorized")
                        break
                    case .unavailable:
                        print("Unavailable")
                        break
                    }
                    
                    let alert = UIAlertController(title: "Error", message: "Transcription is Unavailable", preferredStyle: .alert)
                    self?.present(alert, animated: true) {
                        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { (t) in
                            self?.dismiss(animated: true)
                            t.invalidate()
                        }
                    }
                    self?.setTranscribeComponentsState(.initial)
                    return
                }
                
                self?.setTranscribeComponentsState(.initial)
                
                let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
                textView.isEditable = false
                textView.backgroundColor = .clear
                textView.font = UIFont.systemFont(ofSize: 15)
                textView.text = result
                
                let vc = UIViewController()
                vc.view.backgroundColor = .clear
                vc.preferredContentSize = CGSize(width: 250 , height: 200)
                vc.view.addSubview(textView)
                
                
                let alert = UIAlertController(title: "Transcription Completed", message: nil, preferredStyle: .alert)
                alert.setValue(vc, forKey: "contentViewController")
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (_) in
                    UIPasteboard.general.string = result
                }))
                
                self?.present(alert, animated: true)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
}

extension PlayerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return transcriptor.availableLocationCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Locale.current.localizedString(forIdentifier: transcriptor.availableLocationCodes[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Preferences.localeCode = transcriptor.availableLocationCodes[row]
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

enum PlayButtonState: String {
    case play = "play.fill"
    case pause = "pause.fill"
}

enum TranscribeComponentsState {
    case initial
    case transcribing
}
