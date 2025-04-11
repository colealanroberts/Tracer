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
        let isShowingOverflowMenu: Bool
        let style: Style
        let samples: [FrameRateSample]
        let onOverflowMenu: () -> Void

        // MARK: - Private Properties

        private var current: Double {
            samples.last?.value ?? 0
        }

        private var average: Int {
            guard !samples.isEmpty else { return 0 }
            let total = samples.reduce(0.0) { $0 + $1.value }
            return Int(total) / samples.count
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

                HStack {
                    Text("AVG")
                        .font(.caption2)
                        .monospaced()
                        .foregroundColor(.gray)

                    Text("\(average)")
                        .bold()
                        .font(.caption2)
                        .monospaced()
                        .foregroundColor(.white)
                }

                Spacer()

                Button(action: onOverflowMenu) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8))
                        .bold()
                        .padding(8)
                        .foregroundStyle(.white.opacity(0.7))
                        .background(Material.ultraThin)
                        .clipShape(Circle())
                        .rotationEffect(.degrees(isShowingOverflowMenu ? 180 : 0))
                }
            }
        }
    }
}
