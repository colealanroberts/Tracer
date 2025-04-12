//
//  Event.swift
//  Tracer
//
//  Created by Cole Roberts on 4/11/25.
//

import Foundation

/// An event captured by the system.
struct Event: Encodable {
    /// An associated message, if any.
    let message: String?

    /// The type of event, i.e. `system` or `user`
    let kind: Kind

    /// The associated sample.
    let sample: AnyEncodable?

    /// Associated metadata, if any.
    let metadata: [String: AnyEncodable]

    // MARK: - Utility

    public static func user(
        message: String,
        metadata: [String: Any] = [:]
    ) -> Self {
        .init(
            message: message,
            kind: .user,
            sample: nil,
            metadata: metadata.asEncodable
        )
    }

    public static func system<Value: Encodable>(
        sample: Sample<Value>
    ) -> Self {
        let category: Event.Kind.Category = switch sample {
        case is FrameRateSample: .frame
        case is MemorySample: .memory
        default: preconditionFailure("Unknown sample type!")
        }

        return .init(
            message: nil,
            kind: .system(category),
            sample: .init(sample),
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
    }
}

// MARK: - AnyEncodable

public struct AnyEncodable: Encodable {
    private let encode: (Encoder) throws -> Void

    public init<T: Encodable>(
        _ value: T
    ) {
        self.encode = value.encode(to:)
    }

    public func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}

// MARK: - Dictionary+Util

private extension [String: Any] {
    var asEncodable: [String: AnyEncodable] {
        compactMapValues { value in
            guard let value = value as? Encodable else {
                return AnyEncodable(String(describing: value))
            }
            return AnyEncodable(value)
        }
    }
}
