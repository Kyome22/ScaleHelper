//
//  AppDelegate.swift
//  ScaleHelper
//
//  Created by Takuto Nakamura on 2021/08/17.
//

import Cocoa
import FinderSync

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DispatchQueue.main.async {
            if FIFinderSyncController.isExtensionEnabled {
                let alert = NSAlert()
                alert.alertStyle = .informational
                alert.informativeText = "allowedInformative".localized
                alert.addButton(withTitle: "OK")
                if alert.runModal() == .alertFirstButtonReturn {
                    NSApplication.shared.terminate(nil)
                }
            } else {
                let alert = NSAlert()
                alert.alertStyle = .warning
                alert.informativeText = "requiresPermission".localized
                alert.messageText = "grantPermission".localized
                alert.addButton(withTitle: "openPreferences".localized)
                alert.addButton(withTitle: "cancel".localized)
                if alert.runModal() == .alertFirstButtonReturn {
                    FIFinderSyncController.showExtensionManagementInterface()
                    NSApplication.shared.terminate(nil)
                }
            }
        }
    }

}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
