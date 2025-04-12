//
//  TracerWidget+FrameContainer.swift
//  Tracer
//
//  Created by Cole Roberts on 4/9/25.
//

import Charts
import SwiftUI

extension TracerWidget {
    struct FrameContainer: View {

        // MARK: - Public Properties

        let isCompact: Bool
        let isRecording: Bool
        let isShowingOverflowMenu: Bool
        let style: Style
        let samples: [FrameRateSample]
        let onRecord: () -> Void
        let onOverflowMenu: () -> Void

        // MARK: - Private Properties

        private var current: Double {
            samples.last?.value ?? 0
        }

        // MARK: - Body

        var body: some View {
            if !isCompact {
                Chart(samples, id: \.self) { sample in
                    BarMark(
                        x: .value("", sample.timestamp, unit: .second),
                        y: .value("", sample.value)
                    )
                    .interpolationMethod(style.interoplationMethod)
                    .foregroundStyle(style.frameGraphGradient)
                }
                .padding(.top, 12)
                .padding(.trailing, 12)
                .padding(.leading, 12)
                .chartXAxis(.hidden)
                .chartYScale(domain: 0...Tracer.shared.maximumFrameRate)
                .chartYAxis {}
                .padding(.bottom, 8)
                .animation(.spring, value: samples)
            }

            HStack {
                HStack {
                    Text("FPS")
                        .font(.caption2)
                        .monospaced()
                        .foregroundColor(.gray)

                    Text("\(String(format: "%.0f", current))")
                        .bold()
                        .font(.caption2)
                        .monospaced()
                        .foregroundColor(.white)
                }
                
                Spacer()

                CircularButton(
                    background: .ultraThin,
                    onTap: onOverflowMenu, {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 8))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                )
                .rotationEffect(.degrees(isShowingOverflowMenu ? 180 : 0))

                RecordButton(
                    isRecording: isRecording,
                    onTap: onRecord
                )
            }
        }
    }
}
