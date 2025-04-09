//
//  iOSDisplayLinkProvider.swift
//  Frame
//
//  Created by Cole Roberts on 4/6/25.
//

import Foundation
import Combine
import QuartzCore

class DisplayLinkProvider: DisplayLinkProviding & Engine {

    // MARK: - Properties

    var frameRatePublisher: ValuePublisher<Double> { frameRateSubject.eraseToAnyPublisher() }
    var displayLink: CADisplayLink?
    var maximumFrameRate: Int { 120 }

    // MARK: - Private Properties

    private var frameCount: Int = 0
    private var frameRateSubject: CurrentValueSubject<Double, Never> = .init(0.0)
    private var lastTickTimestamp: CFTimeInterval = 0

    // MARK: - Init

    deinit {
        destroy()
    }

    // MARK: - Methods

    func start() {
        displayLink?.add(to: .main, forMode: .common)
    }

    func stop() {
        destroy()
    }

    @objc
    func update(
        displayLink: CADisplayLink
    ) {
        guard lastTickTimestamp > 0 else {
            lastTickTimestamp = displayLink.timestamp
            return
        }

        frameCount += 1
        let delta = displayLink.timestamp - lastTickTimestamp

        if delta >= 1.0 {
            let rate = Double(frameCount) / delta
            frameRateSubject.send(rate)
            frameCount = 0
            lastTickTimestamp = displayLink.timestamp
        }
    }

    // MARK: - Private Methods

    private func destroy() {
        displayLink?.invalidate()
        displayLink = nil
    }
}
