//
//  FrameWidget+CloseButton.swift
//  Frame
//
//  Created by Cole Roberts on 4/9/25.
//

import SwiftUI

extension FrameWidget {
    struct CloseButton: View {

        // MARK: - Properties

        let onClose: () -> Void

        // MARK: - Body

        var body: some View {
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 8))
                    .bold()
                    .padding(8)
                    .foregroundStyle(.white)
                    .background(Material.ultraThick)
                    .clipShape(Circle())
                    .offset(x: -8, y: -8)
                    .shadow(radius: 4)
            }
        }
    }
}
