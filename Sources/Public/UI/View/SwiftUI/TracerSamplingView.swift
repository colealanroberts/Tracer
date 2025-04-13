//
//  TracerSamplingView.swift
//  Tracer
//
//  Created by Cole Roberts on 4/6/25.
//

import Charts
import SwiftUI

/// A SwiftUI view that relays frame rate samples via closure to the caller.
/// This `FrameRateSample` array can be used to populate a chart, etc.
public struct TracerSamplingView<Content: View>: View {

    // MARK: - Private Properties

    @State private var frameSamples = [FrameRateSample]()
    @State private var memorySamples = [MemorySample]()

    @ViewBuilder private let content: (SampleBuffer) -> Content

    // MARK: - Init

    public init(
        @ViewBuilder _ content: @escaping (SampleBuffer) -> Content
    ) {
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        content(.init(
            frameSamples: frameSamples,
            memorySamples: memorySamples
        ))
        .onReceive(Tracer.shared.frameRateSamplePublisher) { frameSamples = $0 }
        .onReceive(Tracer.shared.memorySamplePublisher) { memorySamples = $0 }
    }
}
