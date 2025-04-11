//
//  SampleProvider.swift
//  Tracer
//
//  Created by Cole Roberts on 4/9/25.
//

import Combine
import Foundation

/// A generic class that yields Sample<T> values.
class SampleProvider<Value>: Sampler {

    // MARK: - Public Properties

    var cancellable: AnyCancellable?
    var isRunning: Bool = false
    var maximumSamples: Int = TracerConstants.maximumSamples

    var samplePublisher: ValuePublisher<[Value]> {
        $samples.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    @Published var samples: [Value]

    // MARK: - Init

    deinit {
        stop()
    }

    init() {
        self.samples = []
        self.samples.reserveCapacity(maximumSamples)
    }

    // MARK: - Public Methods


    func reset() {
        samples.removeAll(keepingCapacity: true)
    }

    func pause() {
        isRunning = false
    }

    func resume() {
        isRunning = true
    }

    func start() {
        isRunning = true
        startSampling()
    }

    func stop() {
        isRunning = false
        cancellable = nil
    }

    func append(sample: Value) {
       samples.append(sample)

       if samples.count >= maximumSamples {
           samples.removeFirst()
       }
   }

    // MARK: - Overridable

    func startSampling() {
        // To be implemented in subclasses
        fatalError("Subclasses must override startSampling()")
    }
}
