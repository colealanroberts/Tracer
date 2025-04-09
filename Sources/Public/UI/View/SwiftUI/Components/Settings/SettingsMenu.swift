//
//  SettingsMenu.swift
//  Frame
//
//  Created by Cole Roberts on 4/8/25.
//

import SwiftUI

struct SettingsMenu: View {

    // MARK: - Properties

    let items: [SettingsItem]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ForEach(items, id: \.self) { item in
                VStack {
                    HStack {
                        Image(systemName: item.symbolName)
                            .font(.system(size: 12))
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.secondary)

                        Text(item.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(perform: item.onTap)
                }
                .padding(12)
            }
        }
        .background(Material.regular)
    }
}
