import Speech

protocol TranscriptorDelegate: AnyObject {
    func onAuthorizationStatusChanged(isAuthorized: Bool)
    func onRecognitionCompleted(result: String?, error: Error?)
}

protocol Transcriptor {
    func requestAuthorization()
    func transcribe(from url: URL)
}

class DefaultTranscriptor: Transcriptor {
    
    weak var delegate: TranscriptorDelegate?
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] (status) in
            self?.delegate?.onAuthorizationStatusChanged(isAuthorized: status == .authorized)
        }
    }
    
    func transcribe(from url: URL) {
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)
        
        recognizer?.recognitionTask(with: request) { [weak self] (result, error) in
            guard let result = result
            else {
                self?.delegate?.onRecognitionCompleted(result: nil, error: error)
                return
            }
            guard result.isFinal else { return }
            self?.delegate?.onRecognitionCompleted(result: result.bestTranscription.formattedString, error: nil)
        }
    }
}
