//
//  TracerConfiguration.swift
//  Tracer
//
//  Created by Cole Roberts on 4/8/25.
//

import Foundation

public struct TracerConfiguration {
    /// The maximum number of samples to collect when
    /// sampling is enabled.
    /// - Note: The default is `30`.
    public var maximumSamples: Int

    public init(
        maximumSamples: Int
    ) {
        self.maximumSamples = maximumSamples
    }
}
