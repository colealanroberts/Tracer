//
//  URL+Util.swift
//  Tracer
//
//  Created by Cole Roberts on 4/12/25.
//

import Foundation

extension URL {
    static var documentsURL: Self {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
    }
}
