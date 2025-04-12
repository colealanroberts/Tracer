//
//  TracerWidget+CloseButton.swift
//  Tracer
//
//  Created by Cole Roberts on 4/9/25.
//

import SwiftUI

extension TracerWidget {
    struct CircularButton<Content: View>: View {

        // MARK: - Properties

        /// The background - `Material`.
        let background: Material

        /// An action performed when the item is tapped.
        let onTap: () -> Void

        /// The content of the view, i.e. `Image`, etc.
        @ViewBuilder let content: () -> Content

        init(
            background: Material,
            onTap: @escaping () -> Void,
            _ content: @escaping () -> Content
        ) {
            self.background = background
            self.onTap = onTap
            self.content = content
        }

        // MARK: - Body

        var body: some View {
            Button(action: onTap) {
                ZStack {
                    content()
                }
                .bold()
                .padding(8)
                .background(background)
                .clipShape(Circle())
                .contentShape(Circle())
            }
        }
    }
}
