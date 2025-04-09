//
//  MemorySample.swift
//  Frame
//
//  Created by Cole Roberts on 4/9/25.
//

import Foundation

/// The app memory footprint taken at a specific point in time.
///
/// `MemorySample` represents a snapshot of the app memory.
/// It can be used to analyze performance over time.
public typealias MemorySample = Sample<Int>
