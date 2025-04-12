//
//  FrameSampleProvider.swift
//  Tracer
//
//  Created by Cole Roberts on 4/6/25.
//

import Combine
import Foundation

final class FrameSampleProvider: SampleProvider<FrameRateSample> & FrameSampleProviding {

    // MARK: - Privat Properties

    private let eventWriter: EventWriting

    // MARK: - Init

    init(
        eventWriter: EventWriting
    ) {
        self.eventWriter = eventWriter
    }

    // MARK: - Override

    override func startSampling() {
        cancellable = Tracer.shared.frameRatePublisher
            .filter { [unowned self] _ in self.isRunning }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                guard let self else { return }

                let sample = FrameRateSample(
                    timestamp: .now,
                    value: rate
                )

                append(sample: sample)

                if eventWriter.isRecording {
                    eventWriter.append(
                        event: .system(sample: sample)
                    )
                }
            }
    }
}
