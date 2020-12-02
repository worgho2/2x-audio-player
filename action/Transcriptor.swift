import Speech

protocol TranscriptorDelegate: AnyObject {
    func onRecognitionCompleted(result: String?, error: Error?)
}

protocol Transcriptor {
    func requestAuthorization()
    func transcribe(from url: URL, completion: @escaping (String?, Error?) -> Void)
}


public class DefaultTranscriptor: Transcriptor {

    // MARK: - Inner types
    enum TranscriptorError: Error {
        case unauthorized
        case alreadyStarted
    }
    // MARK: - Properties
    private var request: SFSpeechURLRecognitionRequest?
    private let recognizer = SFSpeechRecognizer(locale: .init(identifier: "pt_BR"))
    private var isAuthorizedToTranscribe = false
    
    // MARK: - Initialization
    init() {
        requestAuthorization()
    }
    
    // MARK: - Transcriptor
    func requestAuthorization() {
        guard !isAuthorizedToTranscribe
        else { return }
        SFSpeechRecognizer.requestAuthorization { [weak self] (status) in
            self?.isAuthorizedToTranscribe = status == .authorized
        }
    }
    
    func transcribe(from url: URL, completion: @escaping (String?, Error?) -> Void) {
        txLog("TRANSCRIBING FROM", url)
        guard isAuthorizedToTranscribe else {
            completion(nil, TranscriptorError.unauthorized)
            return
        }
        
        guard request == nil else {
            completion(nil, TranscriptorError.alreadyStarted)
            return
        }
        
        request = SFSpeechURLRecognitionRequest(url: url)
        recognizer?.recognitionTask(with: request!) { [weak self] (result, error) in
            self?.request = nil
            guard let result = result
            else {
                completion(nil, error)
                return
            }
            txLog("AE BROW", result.transcriptions.map { $0.formattedString} )
            guard result.isFinal else { return }
            completion(result.bestTranscription.formattedString, nil)
        }
    }
    
}
