//
//  AnyEncodable.swift
//  Tracer
//
//  Created by Cole Roberts on 4/12/25.
//

import Foundation

// MARK: - AnyEncodable

/// Provides `Encodable` support through type-erasure.
struct AnyEncodable: Encodable {

    // MARK: - Private Properties

    private let encoded: (Encoder) throws -> Void

    // MARK: - Init

    public init<T: Encodable>(
        _ value: T
    ) {
        self.encoded = value.encode(to:)
    }

    public func encode(to encoder: Encoder) throws {
        try encoded(encoder)
    }
}

// MARK: - Dictionary+Util

extension [String: Any] {
    var asEncodable: [String: AnyEncodable] {
        compactMapValues { value in
            guard let value = value as? Encodable else {
                return AnyEncodable(String(describing: value))
            }
            return AnyEncodable(value)
        }
    }
}
