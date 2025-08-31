//
//  FileMonitor.swift
//  Monitoring
//
//  Created by David Rosenberg on 8/30/25.
//

import Foundation

public final class FileMonitor {
    let path: URL
    let fileHandle: FileHandle
    let source: DispatchSourceFileSystemObject
    let onChange: (DispatchSource.FileSystemEvent) -> Void

    public init(path: URL, onChange: @escaping (DispatchSource.FileSystemEvent) -> Void) throws {
        self.path = path
        self.fileHandle = try FileHandle(forReadingFrom: path)
        self.onChange = onChange

        self.source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileHandle.fileDescriptor,
            eventMask: [.rename, .write, .delete, .extend],
            queue: DispatchQueue.main,
        )

        self.source.setEventHandler {
            let event = self.source.data
            onChange(event)
        }

        self.source.setCancelHandler {
            try? self.fileHandle.close()
        }
    }

    deinit {
        source.cancel()
    }
}
