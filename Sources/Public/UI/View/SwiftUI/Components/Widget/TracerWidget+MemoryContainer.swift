//
//  TracerWidget+MemoryContainer.swift
//  Tracer
//
//  Created by Cole Roberts on 4/9/25.
//

import Charts
import SwiftUI

extension TracerWidget {
    struct MemoryContainer: View {

        // MARK: - Public Properties

        let isCompact: Bool
        let style: Style
        let samples: [MemorySample]

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
                }

                Spacer()
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
}
