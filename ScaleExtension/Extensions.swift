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
    var ppi: CGFloat {
        let rep = self.representations[0]
        return (72.0 * CGFloat(rep.pixelsWide) / self.size.width)
    }
    
    var pixelSize: CGSize {
        let rep = self.representations[0]
        return CGSize(width: rep.pixelsWide, height: rep.pixelsHigh)
    }
    
    func resized(with ratio: CGFloat) -> NSImage {
        let pixelSize = self.pixelSize
        let newPixelsWide: Int = (ratio * pixelSize.width).roundedInt
        let newPixelsHigh: Int = (ratio * pixelSize.height).roundedInt
        
        let sourceRep = NSBitmapImageRep(data: self.tiffRepresentation!)!
        let resizedRep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                          pixelsWide: newPixelsWide,
                                          pixelsHigh: newPixelsHigh,
                                          bitsPerSample: sourceRep.bitsPerSample,
                                          samplesPerPixel: sourceRep.samplesPerPixel,
                                          hasAlpha: sourceRep.hasAlpha,
                                          isPlanar: sourceRep.isPlanar,
                                          colorSpaceName: sourceRep.colorSpaceName,
                                          bytesPerRow: sourceRep.bytesPerRow,
                                          bitsPerPixel: sourceRep.bitsPerPixel)!
        let ppi = self.ppi
        let newSize = NSSize(width: CGFloat(newPixelsWide) * 72.0 / ppi,
                             height: CGFloat(newPixelsHigh) * 72.0 / ppi)
        resizedRep.size = newSize
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: resizedRep)
        self.draw(in: NSRect(origin: .zero, size: newSize))
        NSGraphicsContext.restoreGraphicsState()
        
        let image = NSImage(size: newSize)
        image.addRepresentation(resizedRep)
        return image
    }
}
