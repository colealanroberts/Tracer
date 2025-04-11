//
//  TracerSamplingViewController.swift
//  Tracer
//
//  Created by Cole Roberts on 4/7/25.
//

import SwiftUI

// MARK: - FrameRateSamplingUIViewController

final class TracerSamplingViewController<Content: View>: HostingController<TracerSamplingView<Content>> {

    // MARK: - Init

    init(
        @ViewBuilder _ builder: @escaping (SampleBuffer) -> Content
    ) {
        super.init(rootView: TracerSamplingView(builder))
    }
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
