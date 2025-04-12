//
//  DocumentPreviewViewController.swift
//  Tracer
//
//  Created by Cole Roberts on 4/12/25.
//

import Foundation
import QuickLook

final class DocumentPreviewViewController: QLPreviewController, QLPreviewControllerDataSource {

    // MARK: - Private Properties

    private let url: URL

    // MARK: - Init

    init(
        url: URL
    ) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - QLPreviewControllerDataSource

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return url as QLPreviewItem
    }
}
