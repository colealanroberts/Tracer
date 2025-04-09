//
//  MemorySampleProviding.swift
//  Frame
//
//  Created by Cole Roberts on 4/9/25.
//

import Foundation
/// A protocol for types that provide memory usage samples over time.
///
/// Conforming types are responsible for starting the sampling process
/// and exposing a collection of recorded `MemorySample` values.
/// This protocol is useful for monitoring and analyzing memory performance.
protocol MemorySampleProviding: Sampler where Value == MemorySample {}
