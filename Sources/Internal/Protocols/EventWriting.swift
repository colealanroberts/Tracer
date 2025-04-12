//
//  EventWriting.swift
//  Tracer
//
//  Created by Cole Roberts on 4/11/25.
//

import Foundation

protocol EventWriting: Engine {
    /// Whether events are being captured.
    var isRecording: Bool { get }

    /// Adds a new event to the current event list.
    func append(event: Event)
}
