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

    // MARK: - Properties

    let url: URL

    // MARK: - Typealias

    typealias UIViewControllerType = DocumentPreviewViewController

    // MARK: - Methods

    func makeUIViewController(
        context: Context
    ) -> UIViewControllerType {
        DocumentPreviewViewController(url: url)
    }

    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {}
}
