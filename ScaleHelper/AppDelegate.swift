//
//  AppDelegate.swift
//  ScaleHelper
//
//  Created by Takuto Nakamura on 2021/08/17.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWC: NSWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        openPreferences()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func openPreferences() {
        if mainWC == nil {
            let sb = NSStoryboard(name: "PreferencesTab", bundle: nil)
            mainWC = (sb.instantiateInitialController() as! NSWindowController)
            mainWC!.window?.delegate = self
        }
        NSApp.activate(ignoringOtherApps: true)
        mainWC?.showWindow(nil)
    }

}

extension AppDelegate: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if window === mainWC?.window {
            mainWC = nil
        }
    }
    
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
