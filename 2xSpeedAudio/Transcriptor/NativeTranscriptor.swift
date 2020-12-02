//
//  NativeTranscriptor.swift
//  2xSpeedAudio
//
//  Created by bruno pastre on 02/12/20.
//

import Foundation
import Speech

public class NativeTranscriptor: Transcriptor {
    
    private var request: SFSpeechURLRecognitionRequest?
    
    func transcribe(contentsOf url: URL, completion: @escaping (String?, Error?) -> Void) {
        
        SFSpeechRecognizer.requestAuthorization { [weak self] (status) in
            switch status {
            case .authorized:
                Logger.log(origin: Self.self, "Authorized with success")
                Logger.log(origin: Self.self, "Transcription started from \(url)")
                
                guard let recognizer = SFSpeechRecognizer() else {
                    Logger.log(origin: Self.self, "Speech recognition not available for specified locale")
                    completion(nil, TranscriptorError.unavailable)
                    return
                }
                
                if !recognizer.isAvailable {
                    Logger.log(origin: Self.self, "Speech recognition not currently available")
                    completion(nil, TranscriptorError.unavailable)
                    return
                }
                
                self?.request = SFSpeechURLRecognitionRequest(url: url)
                
                recognizer.recognitionTask(with: self!.request!) { (result, error) in
                    guard let result = result else {
                        self?.request = nil
                        Logger.log(origin: Self.self, "There was an error transcribing that file")
                        completion(nil, TranscriptorError.fileError)
                        return
                    }
                    
                    if result.isFinal {
                        self?.request = nil
                        Logger.log(origin: Self.self, "Transcription completed","Result: \(result.bestTranscription.formattedString)")
                        completion(result.bestTranscription.formattedString, nil)
                    }
                }
                
                
            case .denied:
                Logger.log(origin: Self.self, "Authorization denied")
                completion(nil, TranscriptorError.unauthorized)
                break
            case .notDetermined:
                Logger.log(origin: Self.self, "Authorization not determined")
                completion(nil, TranscriptorError.unavailable)
                break
            case .restricted:
                Logger.log(origin: Self.self, "Authorization restricted")
                completion(nil, TranscriptorError.unavailable)
                break
            default:
                Logger.log(origin: Self.self, "Unknown authorization status")
                completion(nil, TranscriptorError.unavailable)
                break
            }
        }
    }
    
}
