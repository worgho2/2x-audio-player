//
//  TranscriptorProtocol.swift
//  2xSpeedAudio
//
//  Created by bruno pastre on 02/12/20.
//

import Foundation
import Speech

protocol Transcriptor {
    func transcribe(contentsOf url: URL, forLocale locale: Locale, completion: @escaping TranscriptorCompletion)
    var availableLocationCodes: [String] { get }
}

typealias TranscriptorCompletion = (String?, TranscriptorError?) -> ()

enum TranscriptorError: Error {
    case unauthorized
    case unavailable
    case fileError
}
