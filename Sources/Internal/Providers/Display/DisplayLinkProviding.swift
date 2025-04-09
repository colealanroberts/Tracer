//
//  DisplayLinkProvider.swift
//  Frame
//
//  Created by Cole Roberts on 4/6/25.
//

import Combine
import Foundation

/// A protocol that defines an interface for monitoring the screen refresh rate using a display link.
protocol DisplayLinkProviding: Engine {
    /// The current frame rate.
    /// - Note: This is observable from SwiftUI.
    var frameRatePublisher: ValuePublisher<Double> { get }

    /// The maximum frame rate for the current device.
    var maximumFrameRate: Int { get }
}
