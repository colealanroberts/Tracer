//
//  TracerWidget+GraphContainer.swift
//  Tracer
//
//  Created by Cole Roberts on 4/9/25.
//

import Combine
import SwiftUI

extension TracerWidget {
    struct GraphContainer: View {

        // MARK: - Properties

        let buffer: SampleBuffer
        let isCompact: Bool
        let isRecording: Bool
        let isShowingOverflowMenu: Bool
        let style: Style
        let tickBinding: Binding<Int>
        let onRecord: () -> Void
        let onOverflowMenu: () -> Void

        // MARK: - Body

        var body: some View {
            VStack(spacing: 4) {
                MemoryContainer(
                    isCompact: isCompact,
                    isRecording: isRecording,
                    style: style,
                    samples: buffer.memorySamples,
                    tickBinding: tickBinding
                )

                FrameContainer(
                    isCompact: isCompact,
                    isRecording: isRecording,
                    isShowingOverflowMenu: isShowingOverflowMenu,
                    style: style,
                    samples: buffer.frameSamples,
                    onRecord: onRecord,
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
