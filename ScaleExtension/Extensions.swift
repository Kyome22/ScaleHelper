//
//  Extensions.swift
//  ScaleExtension
//
//  Created by Takuto Nakamura on 2021/09/01.
//

import Cocoa

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}

extension URL {
    var fileName: String {
        return self.deletingPathExtension().lastPathComponent
    }
    var fileExtension: String {
        return self.pathExtension.lowercased()
    }
    func newURL(_ fileName: String, _ fileExtension: String) -> URL {
        return self.appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
    }
}

extension FileManager {
    static var homeDirectoryURL: URL? {
        guard let pw = getpwuid(getuid()), let home = pw.pointee.pw_dir else { return nil }
        let homePath = self.default.string(withFileSystemRepresentation: home,
                                           length: strlen(home))
        return URL(fileURLWithPath: homePath)
    }
}

extension CGFloat {
    var roundedInt: Int {
        return Int(self.rounded())
    }
}

extension NSImage {
    func resized(with ratio: CGFloat) -> NSImage {
        let rep = self.representations[0]
        let pixelSize = NSSize(width: rep.pixelsWide, height: rep.pixelsHigh)
        let newPixelSize = NSSize(width: (ratio * pixelSize.width).roundedInt,
                                  height: (ratio * pixelSize.height).roundedInt)
        let image = NSImage(size: newPixelSize)
        image.lockFocus()
        self.draw(in: NSRect(origin: .zero, size: newPixelSize))
        image.unlockFocus()
        return image
    }
}
