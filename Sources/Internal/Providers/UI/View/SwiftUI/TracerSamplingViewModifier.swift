//
//  TracerSamplingViewModifier.swift
//  Tracer
//
//  Created by Cole Roberts on 4/6/25.
//

import SwiftUI

/// A SwiftUI view modifier that relays frame rate samples via closure to the caller.
/// This `FrameRateSample` array can be used to populate a chart, etc.
struct TracerSamplingViewModifier<V: View>: ViewModifier {

    // MARK: - Public Properties

    private var isPresented: Binding<Bool>
    private let alignment: Alignment
    @ViewBuilder private let builder: (SampleBuffer) -> V

    // MARK: - Init

    init(
        isPresented: Binding<Bool>,
        alignment: Alignment,
        @ViewBuilder _ builder: @escaping (SampleBuffer) -> V
    ) {
        self.isPresented = isPresented
        self.alignment = alignment
        self.builder = builder
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content.overlay(alignment: alignment) {
            if isPresented.wrappedValue {
                TracerSamplingView(builder)
                    .transition(
                        .asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        )
                    )
            }
        }
        .animation(.snappy(duration: 0.3), value: isPresented.wrappedValue)
    }
}

// MARK: - View+TracerSamplingViewModifier

extension View {
    /// A utility method to present an overlay with several options.
    /// - Parameters:
    /// - Note: This enables full control over the presented UI, i.e. one could
    /// render a custom chart, etc.
    ///  - isPresented: Whether the overlay is presented.
    ///  - alignment: The current `Alignment` defaulting to `Alignment.bottom`.
    public func tracerSamplingOverlay(
        isPresented: Binding<Bool>,
        alignment: Alignment = .bottom,
        builder: @escaping (SampleBuffer) -> some View
    ) -> some View {
        modifier(
            TracerSamplingViewModifier(
                isPresented: isPresented,
                alignment: alignment,
                builder
            )
        )
    }

    /// A utility method to present a preconfigured widget
    /// - Parameters:
    ///  - isPresented: Whether the overlay is presented.
    ///  - alignment: The current `Alignment` defaulting to `Alignment.bottom`.
    public func tracerWidgetOverlay(
        isPresented: Binding<Bool>,
        alignment: Alignment = .bottom
    ) -> some View {
        tracerSamplingOverlay(
            isPresented: isPresented,
            alignment: alignment,
            builder: { buffer in
                TracerWidget(
                    buffer: buffer,
                    onClose: {
                        isPresented.wrappedValue.toggle()
                    }
                )
            }
        )
    }
}
