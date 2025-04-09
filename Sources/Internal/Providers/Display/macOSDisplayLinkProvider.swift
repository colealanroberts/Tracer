//
//  macOSDisplayLinkProvider.swift
//  Frame
//
//  Created by Cole Roberts on 4/6/25.
//

#if os(macOS)
import AppKit
import Foundation

final class macOSDisplayLinkProvider: DisplayLinkProvider {
    // MARK: - Public Methods

    override func start() {
        displayLink = NSScreen().displayLink(
            target: self,
            selector: #selector(update)
        )

        super.start()
    }
}

#endif
