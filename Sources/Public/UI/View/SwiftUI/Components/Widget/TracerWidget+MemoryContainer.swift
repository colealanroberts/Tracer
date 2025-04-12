//
//  TracerWidget+MemoryContainer.swift
//  Tracer
//
//  Created by Cole Roberts on 4/9/25.
//

import Charts
import Combine
import SwiftUI

extension TracerWidget {
    struct MemoryContainer: View {

        // MARK: - Public Properties

        let isCompact: Bool
        let isRecording: Bool
        let style: Style
        let samples: [MemorySample]
        let tickBinding: Binding<Int>

        // MARK: - Private Properties

        private var memory: Int {
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
                    .foregroundStyle(style.memoryGraphGradient)
                }
                .padding(.top, 12)
                .padding(.trailing, 12)
                .padding(.leading, 12)
                .chartXAxis(.hidden)
                .chartYAxis {}
                .padding(.bottom, 4)
                .animation(.spring, value: samples)
            }

            HStack {
                Text("MEM")
                    .font(.caption2)
                    .monospaced()
                    .foregroundColor(.gray)

                Text(memory.byteString)
                    .bold()
                    .font(.caption2)
                    .monospaced()
                    .foregroundColor(.white)

                Spacer()

                if isRecording {
                    Text("\(tickBinding.wrappedValue.timeString)")
                        .monospaced()
                        .font(.system(size: 10))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .contentTransition(.numericText())
                        .transaction { t in
                            t.animation = .bouncy
                        }
                        .background(.red, in: Capsule())
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

// MARK: - Int+Util

private extension Int {
    var byteString: String {
        let units = ["Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        var value = Double(self)
        var unitIndex = 0

        while value >= 1024 && unitIndex < units.count - 1 {
            value /= 1024
            unitIndex += 1
        }

        return String(format: "%.1f %@", value, units[unitIndex])
    }

    var timeString: String {
        let hours = self / 3_600
        let minutes = (self % 3_600) / 60
        let seconds = self % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
}
