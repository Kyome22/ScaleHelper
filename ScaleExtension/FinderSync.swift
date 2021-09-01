//
//  FinderSync.swift
//  ScaleExtension
//
//  Created by Takuto Nakamura on 2021/08/17.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    
    override init() {
        super.init()
        
        if let homeDirURL = FileManager.homeDirectoryURL {
            FIFinderSyncController.default().directoryURLs = [homeDirURL]
        }
        
        FIFinderSyncController.default()
            .setBadgeImage(NSImage(imageLiteralResourceName: "badge_2x"),
                           label: "Badge 2x",
                           forBadgeIdentifier: "Badge2x")

        FIFinderSyncController.default()
            .setBadgeImage(NSImage(imageLiteralResourceName: "badge_3x"),
                           label: "Badge 3x",
                           forBadgeIdentifier: "Badge3x")
    }
    
    override func requestBadgeIdentifier(for url: URL) {
        let fileName = url.fileName
        if ["png", "jpg", "jpeg"].contains(url.fileExtension) {
            if fileName.hasSuffix("@2x") {
                FIFinderSyncController.default()
                    .setBadgeIdentifier("Badge2x", for: url)
            } else if fileName.hasSuffix("@3x") {
                FIFinderSyncController.default()
                    .setBadgeIdentifier("Badge3x", for: url)
            }
        }
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        guard let items = FIFinderSyncController.default().selectedItemURLs(),
              items.count == 1,
              let url = items.first else { return nil }
        let fileName = url.fileName
        
        guard ["png", "jpg", "jpeg"].contains(url.fileExtension) else { return nil }
        var title = ""
        if fileName.hasSuffix("@2x") {
            title = "create1x".localized
        } else if fileName.hasSuffix("@3x") {
            title = "create2x".localized
        }
        if title.isEmpty { return nil }
        let menuItem = NSMenuItem(title: title,
                                  action: #selector(self.createScaledImages(_:)),
                                  keyEquivalent: "")
        let id = "com.kyome.ScaleHelper"
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: id) {
            menuItem.image = NSWorkspace.shared.icon(forFile: url.path)
        }
        let menu = NSMenu(title: "")
        menu.addItem(menuItem)
        return menu
    }
    
    @IBAction func createScaledImages(_ sender: Any?) {
        guard let targetURL = FIFinderSyncController.default().targetedURL() else { return }
        guard let url = FIFinderSyncController.default().selectedItemURLs()?.first else { return }
        let fileName = url.fileName.components(separatedBy: "@").first!
        let fileExtension = url.fileExtension
        
        guard let image = NSImage(contentsOf: url) else { return }
        if url.fileName.hasSuffix("@2x") {
            self.saveImageFile(url: targetURL,
                               image: image.resized(with: 1 / 2),
                               name: fileName,
                               ex: fileExtension)
        } else if url.fileName.hasSuffix("@3x") {
            self.saveImageFile(url: targetURL,
                               image: image.resized(with: 1 / 3),
                               name: fileName,
                               ex: fileExtension)
            self.saveImageFile(url: targetURL,
                               image: image.resized(with: 2 / 3),
                               name: "\(fileName)@2x",
                               ex: fileExtension)
        }
    }
    
    private func saveImageFile(url: URL, image: NSImage, name: String, ex: String) {
        let type: NSBitmapImageRep.FileType = (ex == "png") ? .png : .jpeg
        guard let data = image.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: data),
              let imageData = bitmapRep.representation(using: type, properties: [:])
        else { return }
        var destURL = url.newURL(name, ex)
        var cnt = 2
        while FileManager.default.fileExists(atPath: destURL.path) {
            destURL = url.newURL("\(name) \(cnt)", ex)
            cnt += 1
        }
        try? imageData.write(to: destURL, options: .atomic)
    }
    
}
