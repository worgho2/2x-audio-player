//
//  TranscriptorProtocol.swift
//  2xSpeedAudio
//
//  Created by bruno pastre on 02/12/20.
//

import Foundation

protocol Transcriptor {
    func transcribe(contentsOf url: URL, completion: @escaping (String?, TranscriptorError?) -> Void)
}

enum TranscriptorError: Error {
    case unauthorized
    case unavailable
    case fileError
}
