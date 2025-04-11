//
//  TracerWidget.swift
//  Tracer
//
//  Created by Cole Roberts on 4/8/25.
//

import Charts
import SwiftUI

public struct TracerWidget: View {

    // MARK: - Private Properties

    @State private var position: CGSize = .zero
    @State private var isCompact: Bool = false
    @State private var isCollectingSamples: Bool = true
    @GestureState private var dragOffset: CGSize = .zero

    // MARK: - Internal Properties

    @State var isShowingOverflowMenu: Bool = false

    let buffer: SampleBuffer
    let style: Style
    let onClose: () -> Void
    
    // MARK: - Init

    public init(
        style: Style = .init(),
        buffer: SampleBuffer,
        onClose: @escaping () -> Void
    ) {
        self.style = style
        self.buffer = buffer
        self.onClose = onClose
    }

    public var body: some View {
        VStack(
            alignment: .center,
            spacing: 0
        ) {
            GraphContainer(
                buffer: buffer,
                isCompact: isCompact,
                isShowingOverflowMenu: isShowingOverflowMenu,
                style: style,
                onOverflowMenu: {
                    withAnimation {
                        isShowingOverflowMenu.toggle()
                    }
                }
            )

            if isShowingOverflowMenu {
                SettingsMenu(items: settingsMenuItems())
            }
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8.0)
        )
        .frame(
            width: 172
        )
        .animation(
            .snappy,
            value: isShowingOverflowMenu
        )
        .overlay(
            alignment: .topLeading
        ) {
            CloseButton(onClose: onClose)
        }
        .offset(
            x: position.width + dragOffset.width,
            y: position.height + dragOffset.height
        )
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded {
                    position.width += $0.translation.width
                    position.height += $0.translation.height
                }
        )
        .environment(
            \.colorScheme,
             .dark
        )
    }

    // MARK: - Private Methods

    private func settingsMenuItems() -> [SettingsItem] {
        [
            .init(
                symbolName: isCompact ? "arrow.up.left.and.arrow.down.right" : "arrow.down.right.and.arrow.up.left",
                name: isCompact ? "Show full" : "Show compact",
                onTap: {
                    withAnimation {
                        isCompact.toggle()
                    }
                }
            ),
            .init(
                symbolName: isCollectingSamples ? "pause" : "play",
                name: isCollectingSamples ? "Pause sampling" : "Resume sampling",
                onTap: {
                    isCollectingSamples.toggle()
                    Tracer.shared.toggleSampling()
                }
            ),
            .init(
                symbolName: "trash",
                name: "Discard samples",
                onTap: {
                    Tracer.shared.resetSampling()
                }
            ),
        ]
    }
}

// MARK: - TracerWidget+Style

extension TracerWidget {
    public struct Style {
        /// Defines a bar gradient for the frame graph.
        let frameGraphGradient: LinearGradient

        /// Defines a bar gradeint for the memory graph.
        let memoryGraphGradient: LinearGradient

        /// The `InterpolationMethod`.
        /// - Note: The default value is `monotone`.
        let interoplationMethod: InterpolationMethod

        public init(
            frameGraphGradient: LinearGradient = .fps,
            memoryGraphGradient: LinearGradient = .memory,
            interpolationMethod: InterpolationMethod = .monotone
        ) {
            self.frameGraphGradient = frameGraphGradient
            self.memoryGraphGradient = memoryGraphGradient
            self.interoplationMethod = interpolationMethod
        }
    }
}

// MARK: - LinearGradient+Util

extension LinearGradient {
    public static var fps: Self {
        .init(colors: [.indigo, .purple], startPoint: .top, endPoint: .bottom)
    }

    public static var memory: Self {
        .init(colors: [.teal, .blue], startPoint: .top, endPoint: .bottom)
    }
}

