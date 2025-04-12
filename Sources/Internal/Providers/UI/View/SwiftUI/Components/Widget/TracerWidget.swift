//
//  TracerWidget.swift
//  Tracer
//
//  Created by Cole Roberts on 4/8/25.
//

import Charts
import Combine
import SwiftUI

public struct TracerWidget: View {

    // MARK: - Public Properties

    let onClose: () -> Void

    // MARK: - Private Properties

    @StateObject private var viewModel = ViewModel()
    @GestureState private var dragOffset: CGSize = .zero

    private let buffer: SampleBuffer
    private let style: Style

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
                isCompact: viewModel.isCompact,
                isRecording: viewModel.isRecording,
                isShowingOverflowMenu: viewModel.isShowingOverflowMenu,
                style: style,
                tickBinding: $viewModel.tick,
                onRecord: {
                    withAnimation {
                        viewModel.record()
                    }
                },
                onOverflowMenu: {
                    withAnimation {
                        viewModel.isShowingOverflowMenu.toggle()
                    }
                }
            )

            if viewModel.isShowingOverflowMenu {
                SettingsMenu(items: settingsMenuItems())
            }
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8.0)
        )
        .frame(
            width: 192
        )
        .animation(
            .snappy,
            value: viewModel.isShowingOverflowMenu
        )
        .overlay(
            alignment: .topLeading
        ) {
            CircularButton(
                background: .ultraThick,
                onTap: onClose, {
                    Image(systemName: "xmark")
                        .font(.system(size: 8))
                        .foregroundStyle(.white)
                }
            )
            .offset(
                x: -8,
                y: -8
            )
            .shadow(radius: 4)
        }
        .offset(
            x: viewModel.position.width + dragOffset.width,
            y: viewModel.position.height + dragOffset.height
        )
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded {
                    viewModel.position.width += $0.translation.width
                    viewModel.position.height += $0.translation.height
                }
        )
        .environment(
            \.colorScheme,
             .dark
        )
        .sheet(
            isPresented: $viewModel.isShowingDocumentExplorer
        ) {
            NavigationView {
                DocumentExplorerView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                viewModel.isShowingDocumentExplorer = false
                            }
                            .bold()
                        }
                    }
            }
        }
    }

    // MARK: - Private Methods

    private func settingsMenuItems() -> [SettingsItem] {
        [
            .init(
                symbolName: viewModel.isCompact ? "arrow.up.left.and.arrow.down.right" : "arrow.down.right.and.arrow.up.left",
                name: viewModel.isCompact ? "Show full" : "Show compact",
                onTap: {
                    withAnimation {
                        viewModel.isCompact.toggle()
                    }
                }
            ),
            .init(
                symbolName: "text.word.spacing",
                name: "View logs",
                onTap: {
                    withAnimation {
                        viewModel.isShowingDocumentExplorer.toggle()
                    }
                }
            ),
            .init(
                symbolName: viewModel.isCollectingSamples ? "pause" : "play",
                name: viewModel.isCollectingSamples ? "Pause sampling" : "Resume sampling",
                onTap: {
                    viewModel.isCollectingSamples.toggle()
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

// MARK: - TracerWidget

private extension TracerWidget {
    final class ViewModel: ObservableObject {

        // MARK: - Public Properties

        @Published var position: CGSize = .zero
        @Published var isCompact: Bool = false
        @Published var isCollectingSamples: Bool = true
        @Published var isShowingDocumentExplorer: Bool = false
        @Published var isRecording: Bool = false
        @Published var isShowingOverflowMenu: Bool = false
        @Published var tick: Int = 0

        // MARK: - Private Methods

        private var timer: AnyCancellable?

        // MARK: - Public Methods

        func record() {
            isShowingOverflowMenu = false
            isCompact = true
            isRecording.toggle()

            if isRecording {
                Tracer.shared.startRecording()

                timer = Timer.publish(
                    every: 1.0,
                    on: .main,
                    in: .common
                )
                .autoconnect()
                .sink { [weak self] _ in
                    self?.tick += 1
                }
            } else {
                Tracer.shared.stopRecording()

                tick = 0
                timer?.cancel()
                timer = nil
            }
        }
    }
}
