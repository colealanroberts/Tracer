//
//  FrameRateSamplingView.swift
//  Frame
//
//  Created by Cole Roberts on 4/6/25.
//

import Charts
import SwiftUI

/// A SwiftUI view that relays frame rate samples via closure to the caller.
/// This `FrameRateSample` array can be used to populate a chart, etc.
public struct FrameRateSamplingView<Content: View>: View {

    // MARK: - Private Properties

    @State private var frameSamples = [FrameRateSample]()
    @State private var memorySamples = [MemorySample]()

    @ViewBuilder private let builder: (SampleBuffer) -> Content

    // MARK: - Init

    public init(
        @ViewBuilder _ builder: @escaping (SampleBuffer) -> Content
    ) {
        self.builder = builder
    }

    // MARK: - Body

    public var body: some View {
        builder(.init(
            frameSamples: frameSamples,
            memorySamples: memorySamples
        ))
        .onReceive(Frame.shared.frameRateSamplePublisher) { frameSamples = $0 }
        .onReceive(Frame.shared.memorySamplePublisher) { memorySamples = $0 }
    }
}
