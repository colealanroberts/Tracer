//
//  DocumentExplorerView.swift
//  Tracer
//
//  Created by Cole Roberts on 4/12/25.
//

import Foundation
import MobileCoreServices
import QuickLook
import SwiftUI
import UIKit

struct DocumentExplorerView: UIViewControllerRepresentable {

    // MARK: - Typealias

    typealias UIViewControllerType = UIDocumentBrowserViewController

    // MARK: - Public Methods

    func makeUIViewController(
        context: Context
    ) -> UIViewControllerType {
        let browser = UIViewControllerType(
            forOpening: [.json]
        )

        browser.allowsDocumentCreation = false
        browser.delegate = context.coordinator

        return browser
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {}
}

// MARK: - DocumentExplorerView+Coordinator

extension DocumentExplorerView {
    final class Coordinator: NSObject, UIDocumentBrowserViewControllerDelegate {

        // MARK: - Public Methods

        func documentBrowser(
            _ controller: UIViewControllerType,
            didPickDocumentsAt documentURLs: [URL]
        ) {
            // We're only going to handle previewing a single item.
            // If we have several, we'll assume the user is trying to share rather than preview.
            guard documentURLs.count == 1, let url = documentURLs.first else { return }
            let previewController = DocumentPreviewViewController(url: url)
            controller.present(previewController, animated: true)
        }
    }
}
