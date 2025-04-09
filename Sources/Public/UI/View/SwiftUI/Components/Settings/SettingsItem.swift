//
//  SettingItem.swift
//  Frame
//
//  Created by Cole Roberts on 4/8/25.
//

import Foundation

struct SettingsItem {
    /// The system (SFSymbol) name of the associated icon.
    let symbolName: String

    /// The name of the setting item.
    let name: String

    /// An action performed when the item is tapped.
    let onTap: () -> Void
}

// MARK: - SettingsItem+Hashable

extension SettingsItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(symbolName)
    }
}

// MARK: - SettingsItem+Equatable

extension SettingsItem: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
        && lhs.symbolName == rhs.symbolName
    }
}
