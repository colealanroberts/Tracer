//
//  MemorySampleProvider.swift
//  Tracer
//
//  Created by Cole Roberts on 4/9/25.
//

import Combine
import Foundation

final class MemorySampleProvider: SampleProvider<MemorySample> & MemorySampleProviding {

    // MARK: - Private Methods

    private let eventWriter: EventWriting

    // MARK: - Init

    init(
        eventWriter: EventWriting
    ) {
        self.eventWriter = eventWriter
    }

    // MARK: - Override

    override func startSampling() {
        cancellable = Tracer.shared.frameRatePublisher
            .filter { [unowned self] _ in self.isRunning }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                guard let footprint = memoryFootprint() else { return }

                let sample = MemorySample(
                    timestamp: .now,
                    value: Int(footprint)
                )

                append(sample: sample)

                if eventWriter.isRecording {
                    eventWriter.append(
                        event: .system(sample: sample)
                    )
                }
            }
    }

    // MARK: - Private Methods

    private func memoryFootprint() -> UInt64? {
        // The `TASK_VM_INFO_COUNT` and `TASK_VM_INFO_REV1_COUNT` macros are too
        // complex for the Swift C importer, so we have to define them ourselves.
        let TASK_VM_INFO_COUNT = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size)
        let TASK_VM_INFO_REV1_COUNT = mach_msg_type_number_t(MemoryLayout.offset(of: \task_vm_info_data_t.min_address)! / MemoryLayout<integer_t>.size)
        var info = task_vm_info_data_t()
        var count = TASK_VM_INFO_COUNT
        let kr = withUnsafeMutablePointer(to: &info) { infoPtr in
            infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { intPtr in
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), intPtr, &count)
            }
        }
        guard kr == KERN_SUCCESS, count >= TASK_VM_INFO_REV1_COUNT else { return nil }
        return info.phys_footprint
    }
}
