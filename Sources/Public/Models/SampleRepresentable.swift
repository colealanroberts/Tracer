//
//  SampleRepresentable.swift
//  Tracer
//
//  Created by Cole Roberts on 4/12/25.
//

import Foundation

// MARK: - TimestampRepresentable

/// A sample represents a unit that's able to be examined.
public protocol SampleRepresentable {
    associatedtype Value: Equatable & Encodable

    /// A unique identifier.
    var uuid: UUID { get }

    /// The timestamp when the sample was recorded.
    /// - Note: This is particularly useful when paired with the SwiftUI Charts library and `XMark` graphs.
    var timestamp: Date { get }

    /// The value of the sample.
    var value: Value { get }
}
