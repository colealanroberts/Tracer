//
//  FrameConstants.swift
//  Frame
//
//  Created by Cole Roberts on 4/6/25.
//

import Combine
import Foundation

public final class Frame: FrameSDK {

    // MARK: - Singleton

    public static let shared = Frame()

    // MARK: - Public Properties

    public var frameRatePublisher: ValuePublisher<Double> {
        displayLinkProvider.frameRatePublisher
    }

    public var frameRateSamplePublisher: ValuePublisher<[FrameRateSample]> {
        frameSampleProvider.samplePublisher
    }

    public var memorySamplePublisher: ValuePublisher<[MemorySample]> {
        memorySampleProvider.samplePublisher
    }

    public var maximumFrameRate: Int {
        displayLinkProvider.maximumFrameRate
    }

    public private(set) var isObserving: Bool = false

    // MARK: - Private Properties

    private var configuration: FrameConfiguration
    private var displayLinkProvider: DisplayLinkProviding
    private var frameSampleProvider: any FrameSampleProviding
    private let memorySampleProvider: any MemorySampleProviding

    // MARK: - Init

    deinit {
        displayLinkProvider.stop()
    }

    public init(
        _ configure: (inout FrameConfiguration) -> Void = { _ in }
    ) {
        let displayLinkProvider: DisplayLinkProviding
        #if os(macOS)
        displayLinkProvider = macOSDisplayLinkProvider()
        #else
        displayLinkProvider = iOSDisplayLinkProvider()
        #endif

        var configuration = FrameConfiguration(maximumSamples: FrameConstants.maximumSamples)
        configure(&configuration)

        self.frameSampleProvider = FrameSampleProvider()
        self.memorySampleProvider = MemorySampleProvider()
        self.displayLinkProvider = displayLinkProvider
        self.configuration = configuration
    }

    // MARK: - Public Methods

    public func configure(
        _ configure: (inout FrameConfiguration) -> Void
    ) {
        configure(&configuration)
        frameSampleProvider.maximumSamples = configuration.maximumSamples
    }

    public func resetSampling() {
        frameSampleProvider.reset()
        memorySampleProvider.reset()
    }

    public func toggleSampling() {
        frameSampleProvider.toggle()
        memorySampleProvider.toggle()
    }

    public func startObservation() {
        isObserving = true

        displayLinkProvider.start()
        frameSampleProvider.start()
        memorySampleProvider.start()
    }

    public func endObservation() {
        isObserving = false

        displayLinkProvider.stop()
        frameSampleProvider.stop()
        memorySampleProvider.stop()
    }
}
