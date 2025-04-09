//
//  HostingController.swift
//  Frame
//
//  Created by Cole Roberts on 4/8/25.
//

import SwiftUI

#if os(macOS)
public typealias HostingController<Content: View> = NSHostingController<Content>
#elseif os(iOS) || os(tvOS) || os(visionOS)
public typealias HostingController<Content: View> = UIHostingController<Content>
#endif
