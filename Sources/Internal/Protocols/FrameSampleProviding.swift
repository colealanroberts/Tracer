//
//  FrameSampleProviding.swift
//  FrameCore
//
//  Created by Cole Roberts on 4/7/25.
//

import Foundation

/// A protocol for types that provide frame rate samples over time.
///
/// Conforming types are responsible for starting the sampling process
/// and exposing a collection of recorded `FrameRateSample` values.
/// This protocol is useful for monitoring and analyzing rendering performance.
protocol FrameSampleProviding: Sampler where Value == FrameRateSample {}
