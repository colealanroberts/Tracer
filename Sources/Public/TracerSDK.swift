//
//  TracerSDK.swift
//  Tracer
//
//  Created by Cole Roberts on 4/7/25.
//

import Combine
import Foundation

/// A protocol defining the core interface for frame rate observation.
///
/// Conforming types are expected to be `Observable` and provide real-time frame rate data,
/// along with lifecycle hooks to begin and end frame monitoring.
public protocol TracerSDK {
    var frameRatePublisher: ValuePublisher<Double> { get }

    /// An array of `FrameRateSample` objects.
    var frameRateSamplePublisher: ValuePublisher<[FrameRateSample]> { get }

    /// An array of `MemorySample` objects.
    var memorySamplePublisher: ValuePublisher<[MemorySample]> { get }

    /// Whether the frame rate is being observed.
    var isObserving: Bool { get }

    /// The maximum possible frame rate that can be reported.
    var maximumFrameRate: Int { get }

    /// Enables configuration of the FrameSDK.
    func configure(_ configure: (inout TracerConfiguration) -> Void)

    /// Resets all sampling.
    func resetSampling()

    /// Toggles sample collection.
    func toggleSampling()
    
    /// Begins observing the frame rate.
    func startObservation()

    /// Ends observation of the frame rate.
    func endObservation()
}
