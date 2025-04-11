//
//  iOSDisplayLinkProvider.swift
//  Tracer
//
//  Created by Cole Roberts on 4/6/25.
//

#if os(iOS) || os(tvOS) || os(visionOS)
import Combine
import Foundation
import UIKit
import QuartzCore

final class iOSDisplayLinkProvider: DisplayLinkProvider {

    // MARK: - Properties

    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Public Methods

    override func start() {
        displayLink = CADisplayLink(
            target: self,
            selector: #selector(update)
        )

        super.start()
        observeLifecycleEvents()
    }

    override func stop() {
        cancellables.removeAll()
        super.stop()
    }

    // MARK: - Private Methods

    private func observeLifecycleEvents() {
        NotificationCenter.default
            .publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.stop()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.start()
            }
            .store(in: &cancellables)
    }
}

#endif
