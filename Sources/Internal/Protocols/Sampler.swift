//
//  Sampler.swift
//  Tracer
//
//  Created by Cole Roberts on 4/9/25.
//

import Foundation

/// The `Sample` protocol defines the basic interface for sample collection.
protocol Sampler: Engine {
    /// The value associated with the sample.
    associatedtype Value

    /// A publisher yielding values.
    var samplePublisher: ValuePublisher<[Value]> { get }

    /// Whether the sampler is running.
    var isRunning: Bool { get }

    /// The number of samples to collect.
    var maximumSamples: Int { get set }

    /// Resets sample collection.
    func reset()

    /// Pauses sample collection.
    func pause()

    /// Resumes sample collection.
    func resume()
}

// MARK: - Sample+Util

extension Sampler {
    /// Switches between `pause` and `resume`, i.e. toggling between
    /// the two states.
    func toggle() {
        isRunning ? pause() : resume()
    }
}
