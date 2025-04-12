//
//  EncodableSample.swift
//  Tracer
//
//  Created by Cole Roberts on 4/12/25.
//

import Foundation

/// A `Sample` that's able to encoded.
/// - Note: This is useful when encoding and persisting to disk, etc.
public typealias EncodableSample = SampleRepresentable & Encodable
