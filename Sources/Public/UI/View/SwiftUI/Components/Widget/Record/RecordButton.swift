//
//  TracerWidget+RecordButton.swift
//  Tracer
//
//  Created by Cole Roberts on 4/11/25.
//

import Combine
import SwiftUI

extension TracerWidget {
    struct RecordButton: View {

        // MARK: - Public Properties

        let isRecording: Bool
        let onTap: () -> Void

        // MARK: - Body

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: isRecording ? 2 : 7)
                    .fill(.red)
                    .frame(width: 10, height: 10)
            }
            .padding(6)
            .background(Material.ultraThin)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture(perform: {
                withAnimation(.bouncy) {
                    onTap()
                }
            })
        }
    }
}
