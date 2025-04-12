//
//  Event.swift
//  Tracer
//
//  Created by Cole Roberts on 4/11/25.
//

import Foundation

/// An event captured by the system.
struct Event {
    /// An associated message, if any.
    private let message: String?

    /// The type of event, i.e. `system` or `user`
    private let kind: Kind

    /// The associated sample.
    private let sample: (any EncodableSample)?

    /// The timestamp of the event.
    private let timestamp: Date

    /// Associated metadata, if any.
    private let metadata: [String: AnyEncodable]?

    // MARK: - Utility

    public static func user(
        message: String,
        metadata: [String: Any]? = nil
    ) -> Self {
        .init(
            message: message,
            kind: .user,
            sample: nil,
            timestamp: .now,
            metadata: metadata?.asEncodable ?? [:]
        )
    }

    public static func system<Value: Encodable>(
        sample: Sample<Value>
    ) -> Self {
        let category: Event.Kind.Category = switch sample {
        case is FrameRateSample: .frame
        case is MemorySample: .memory
        default: preconditionFailure("Unknown sample type: \(type(of: sample))")
        }

        return .init(
            message: nil,
            kind: .system(category),
            sample: sample,
            timestamp: sample.timestamp,
            metadata: [:]
        )
    }
}

// MARK: - Event+Kind

extension Event {
    enum Kind: Encodable {
        /// A system generated event.
        case system(Category)

        /// A user generated event.
        case user

        // MARK: - Event.Kind+Category
        enum Category: String, Encodable {
            /// A memory sample.
            case memory

            /// A frame sample.
            case frame
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .system(let category):
                try container.encode(category.rawValue)
            case .user:
                try container.encode("user")
            }
        }
    }
}

// MARK: - Event+Encodable

extension Event: Encodable {
    enum CodingKeys: String, CodingKey {
        case message, kind, sample, timestamp, metadata
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encode(kind, forKey: .kind)

        if let metadata, !metadata.isEmpty {
            try container.encodeIfPresent(metadata, forKey: .metadata)
        }

        // Always use `timestamp` from `sample`, if available, otherwise fallback to event timestamp
        if let sample, let unboxed = sample.value as? any EncodableSample {
            try container.encode(unboxed.timestamp, forKey: .timestamp)
            try container.encode(unboxed.value, forKey: .sample)
        } else {
            try container.encode(timestamp, forKey: .timestamp)
        }
    }
}
