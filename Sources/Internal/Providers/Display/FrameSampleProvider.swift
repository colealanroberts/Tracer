//
//  FrameSampleProvider.swift
//  Frame
//
//  Created by Cole Roberts on 4/6/25.
//

import Combine
import Foundation
import UIKit

final class FrameSampleProvider: SampleProvider<FrameRateSample> & FrameSampleProviding {

    // MARK: - Override

    override func startSampling() {
        cancellable = Frame.shared.frameRatePublisher
            .filter { [unowned self] _ in self.isRunning }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                guard let self else { return }

                let sample = FrameRateSample(
                    timestamp: .now,
                    value: rate
                )

                append(sample: sample)
            }
    }
}
