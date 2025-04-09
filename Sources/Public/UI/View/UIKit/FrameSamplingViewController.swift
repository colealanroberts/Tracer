//
//  FrameSamplingViewController.swift
//  Frame
//
//  Created by Cole Roberts on 4/7/25.
//

import SwiftUI

// MARK: - FrameRateSamplingUIViewController

final class FrameSamplingViewController<Content: View>: HostingController<FrameRateSamplingView<Content>> {

    // MARK: - Init

    init(
        @ViewBuilder _ builder: @escaping (SampleBuffer) -> Content
    ) {
        super.init(rootView: FrameRateSamplingView(builder))
    }
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
