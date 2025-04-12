//
//  EventWriter.swift
//  Tracer
//
//  Created by Cole Roberts on 4/11/25.
//

import Foundation

final class EventWriter: EventWriting {

    // MARK: - Public Properties

    var isRecording: Bool = false

    // MARK: - Private Properties

    private var events = [Event]()

    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        return encoder
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' h.mm.ss a"

        return formatter
    }()

    // MARK: - Public Methods

    func append(event: Event) {
        // Discard all events when not recording.
        guard isRecording else { return }
        events.append(event)
    }

    func start() {
        isRecording = true
    }

    func stop() {
        finalize()
    }

    // MARK: - Private Methods

    private func finalize() {
        assert(isRecording, "You must call `start()` prior to finalizing events.")

        Task {
            do {
                let data = try encoder.encode(events)
                let fileURL = URL.file(with: "Tracer-\(dateFormatter.string(from: .now))")
                try data.write(to: fileURL)
                events.removeAll()
                isRecording = false
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

// MARK: - URL+Util

private extension URL {
    static func file(with value: String) -> Self {
        URL.documentsURL.appendingPathComponent(value).appendingPathExtension("json")
    }
}
