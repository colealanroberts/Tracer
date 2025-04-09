//
//  FrameWidget+GraphContainer.swift
//  Frame
//
//  Created by Cole Roberts on 4/9/25.
//

import SwiftUI

extension FrameWidget {
    struct GraphContainer: View {

        // MARK: - Properties

        let buffer: SampleBuffer
        let isCompact: Bool
        let isShowingOverflowMenu: Bool
        let style: FrameWidget.Style
        let onOverflowMenu: () -> Void

        // MARK: - Body

        var body: some View {
            VStack(spacing: 0) {
                MemoryContainer(
                    isCompact: isCompact,
                    style: style,
                    samples: buffer.memorySamples
                )

                FrameContainer(
                    isCompact: isCompact,
                    isShowingOverflowMenu: isShowingOverflowMenu,
                    style: style,
                    samples: buffer.frameSamples,
                    onOverflowMenu: onOverflowMenu
                )
            }
            .padding(.top, 12)
            .padding(.bottom, 12)
            .padding(.trailing, 12)
            .padding(.leading, 12)
            .frame(height: isCompact ? 64 : 176)
            .background(Material.thick)
        }
    }
}
