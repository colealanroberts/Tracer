//
//  Tracer.swift
//  Tracer
//
//  Created by Cole Roberts on 4/6/25.
//

import Combine
import Foundation

public final class Tracer: TracerSDK {

    // MARK: - Singleton

    public static let shared = Tracer()

    // MARK: - Public Properties

    public var maximumFrameRate: Int {
        displayLinkProvider.maximumFrameRate
    }

    public private(set) var isObserving: Bool = false

    // MARK: - Internal Properties

    var frameRatePublisher: ValuePublisher<Double> {
        displayLinkProvider.frameRatePublisher
    }

    var frameRateSamplePublisher: ValuePublisher<[FrameRateSample]> {
        frameSampleProvider.samplePublisher
    }

    var memorySamplePublisher: ValuePublisher<[MemorySample]> {
        memorySampleProvider.samplePublisher
    }

    // MARK: - Private Properties

    private var configuration: TracerConfiguration
    private let eventWriter: EventWriting
    private var displayLinkProvider: DisplayLinkProviding
    private var frameSampleProvider: any FrameSampleProviding
    private let memorySampleProvider: any MemorySampleProviding

    // MARK: - Init

    deinit {
        displayLinkProvider.stop()
    }

    public init(
        _ configure: (inout TracerConfiguration) -> Void = { _ in }
    ) {
        let displayLinkProvider: DisplayLinkProviding
        #if os(macOS)
        displayLinkProvider = macOSDisplayLinkProvider()
        #else
        displayLinkProvider = iOSDisplayLinkProvider()
        #endif

        var configuration = TracerConfiguration(maximumSamples: TracerConstants.maximumSamples)
        configure(&configuration)

        self.eventWriter = EventWriter()
        
        self.frameSampleProvider = FrameSampleProvider(
            eventWriter: eventWriter
        )

        self.memorySampleProvider = MemorySampleProvider(
            eventWriter: eventWriter
        )

        self.displayLinkProvider = displayLinkProvider
        self.configuration = configuration
    }

    // MARK: - Public Methods

    public func configure(
        _ configure: (inout TracerConfiguration) -> Void
    ) {
        configure(&configuration)
        frameSampleProvider.maximumSamples = configuration.maximumSamples
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

    public func event(
        message: String,
        metadata: [String: Any]?
    ) {
        eventWriter.append(event: .user(
            message: message,
            metadata: metadata
        ))
    }

    // MARK: - Internal Methods

    func resetSampling() {
        frameSampleProvider.reset()
        memorySampleProvider.reset()
    }

    func toggleSampling() {
        frameSampleProvider.toggle()
        memorySampleProvider.toggle()
    }

    func startRecording() {
        assert(
            isObserving,
            """
            You must call `Tracer.shared.startObservation()` prior to
            calling this method.
            """
        )

        eventWriter.start()
    }

    func stopRecording() {
        eventWriter.stop()
    }
}
