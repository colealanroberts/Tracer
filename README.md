<h1 align="center">Tracer</h1>
<p align="center">
</p>
<p align="center">A lightweight Swift package for real-time performance monitoring.</p>
<p align="center">
  <img alt="workflow" src="https://github.com/colealanroberts/Tracer/actions/workflows/main.yml/badge.svg"></a>
  <a href="LICENSE"><img alt="license" src="https://img.shields.io/badge/license-MIT-black.svg"></a>
</p>


# Tracer

Tracer tracks frame rate and memory usage in real time, making it easy to capture and analyze performance logs directly on device.

## Requirements

- iOS 16.0+

## Setup
### Installation

**Swift Package Manager**

To install OpenAlpha using Swift Package Manager, add the following dependency to your Package.swift file:

```swift
.Package(url: "https://github.com/colealanroberts/Tracer.git")
```

## Usage

**Getting Started**

To start collecting memory and frame samples, call `Tracer.shared.startObservation()`. 

```swift
import Tracer

@main struct MyApp: App {
    ...
    init() {
        Tracer.shared.startObservation()
    }
}
```

**Viewing Sample Data**

Tracer provides several mechanisms for viewing sample data. The simplest is `TracerSamplingViewModifier`, which can be applied to any SwiftUI view using `.tracerWidgetOverlay(isPresented:)`. For more granular control, use `.tracerSamplingOverlay(isPresented:alignment:builder:)`, which allows full customization of the UI.

```swift

@State var isPresentingTracer = false

...
MyView().tracerWidgetOverlay(isPresented: $isPresentingTracer)
```

## License
This library is released under the MIT license. See [LICENSE](LICENSE) for details.
