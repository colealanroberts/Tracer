//
//  FrameRateSample.swift
//  Tracer
//
//  Created by Cole Roberts on 4/6/25.
//

import Foundation

/// A single frame rate measurement taken at a specific point in time.
///
/// `FrameRateSample` represents a snapshot of the frames-per-second (FPS) value
/// at a given timestamp. It can be used to analyze rendering performance over time,
/// and identify dropped frames or performance trends.
public typealias FrameRateSample = Sample<Double>
