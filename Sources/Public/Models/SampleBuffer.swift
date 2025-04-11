//
//  SampleBuffer.swift
//  Tracer
//
//  Created by Cole Roberts on 4/9/25.
//

import Foundation

/// A container for storing performance-related samples over time.
///
/// `SampleBuffer` holds two sets of time-series sample data:
/// - frame rate
/// - memory usage.
public struct SampleBuffer {
    /// A collection of frame rate samples, typically in frames-per-second (FPS).
    public let frameSamples: [FrameRateSample]

    /// A collection of memory usage samples, such as megabytes used over time.
    public let memorySamples: [MemorySample]
}
