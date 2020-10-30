//
//  ShareViewController.swift
//  extension
//
//  Created by otavio on 30/10/20.
//

import UIKit
import Social
import MobileCoreServices
import AVFoundation

class ShareViewController: UIViewController, ExtensionDataLoader {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var spacerView: UIView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    var audioPlayer: AVAudioPlayer?
    
    var rate: Float = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExtensionDataManager.instance.subcribe(self)
        setupView()
        loadFileFomAttachments()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
    
    func setupView() {
        view.backgroundColor = .clear
        view.isOpaque = false
        
        spacerView.clipsToBounds = true
        spacerView.layer.cornerRadius = 0.45 * min(spacerView.frame.width, spacerView.frame.height)
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 0.188 * min(contentView.frame.width, contentView.frame.height)
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        

        rateButton.setTitle("1x", for: .normal)
        
        durationLabel.text = "00:00"
        
        currentTimeLabel.text = "00:00"
    }
    
    func loadFileFomAttachments() {
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeData as String
        
        for provider in attachments {
            if provider.hasItemConformingToTypeIdentifier(contentType) {
                provider.loadItem(forTypeIdentifier: contentType, options: nil) { [unowned self] (data, error) in
                    guard error == nil else { return }
                    setupAudioPlayer(trackURL: data as! URL)
                }
            }
        }
    }
    
    func setupAudioPlayer(trackURL: URL) {
        audioPlayer = try! AVAudioPlayer(contentsOf: trackURL)
        audioPlayer?.delegate = self
        audioPlayer?.enableRate = true
        audioPlayer?.prepareToPlay()
    }
    
    func update() {
        self.timeSlider.minimumValue = 0
        self.timeSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
        self.timeSlider.value = Float(audioPlayer?.currentTime ?? 0)
        self.durationLabel.text = audioPlayer?.duration.toReadable()
        self.currentTimeLabel.text = audioPlayer?.currentTime.toReadable()
    }
    
    @IBAction func onPlayButton(_ sender: Any) {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            audioPlayer?.play()
            playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func onGoBackButton(_ sender: Any) {
        audioPlayer?.currentTime -= 15
    }
    
    @IBAction func onGoForwardButton(_ sender: Any) {
        audioPlayer?.currentTime += 15
    }
    
    @IBAction func onRateButton(_ sender: Any) {
        if rate == 1 {
            rate = 1.5
            rateButton.setTitle("1.5x", for: .normal)
        } else if rate == 1.5 {
            rate = 2.0
            rateButton.setTitle("2x", for: .normal)
        } else if rate == 2.0 {
            rate = 1.0
            rateButton.setTitle("1x", for: .normal)
        }
        audioPlayer?.rate = rate
    }
    
    @IBAction func onTimeSlider(_ sender: Any) {
    }
    
    
    
}

extension ShareViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
    }
}

extension TimeInterval {
    func toReadable() -> String {
        var x = Int(self)
        let seconds = x % 60
        x /= 60
        let minutes = x % 60
        return (minutes < 10 ? "0\(minutes)" : "\(minutes)") + ":" + (seconds < 10 ? "0\(seconds)" : "\(seconds)")
    }
}
