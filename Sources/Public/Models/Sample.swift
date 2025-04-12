//
//  Sample.swift
//  Tracer
//
//  Created by Cole Roberts on 4/9/25.
//

import Foundation

/// A sample represents a unit that's able to be examined.
public struct Sample<Value: Equatable & Encodable>: EncodableSample {
    public let timestamp: Date
    public let value: Value
}

// MARK: - Sample+Hashable

extension Sample: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(timestamp)
    }
}

// MARK: - Sample+Equatable

extension Sample: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
}
