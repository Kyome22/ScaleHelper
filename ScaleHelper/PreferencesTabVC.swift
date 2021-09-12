//
//  PreferencesTabVC.swift
//  ScaleHelper
//
//  Created by Takuto Nakamura on 2021/09/11.
//

import Cocoa

class PreferencesTabVC: NSTabViewController {

    override func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        var array = super.toolbarDefaultItemIdentifiers(toolbar)
        array.append(NSToolbarItem.Identifier.flexibleSpace)
        array.insert(NSToolbarItem.Identifier.flexibleSpace, at: 0)
        return array
    }

    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let tabViewItem = tabViewItem,
              let selectedVC = tabViewItem.viewController
        else { return assertionFailure() }
        var originalSize = CGSize.zero
        var title = ""
        switch selectedVC {
        case let generalPane as GeneralPaneVC:
            originalSize = generalPane.originalSize
            title = generalPane.title!
        case let aboutPane as AboutPaneVC:
            originalSize = aboutPane.originalSize
            title = aboutPane.title!
        default:
            break
        }
        let delta = self.view.frame.height - originalSize.height
        guard let window = self.view.window else {
            self.view.frame.size = originalSize
            return
        }
        window.title = "ScaleHelper  〉\(title)"
        var frame = window.frame
        frame.origin.y += delta
        frame.size.height -= delta
        frame.size.width = originalSize.width
        window.setFrame(frame, display: true, animate: true)
    }
    
}

class PreferencesWindow: NSWindow {

    override func cancelOperation(_ sender: Any?) {
        self.close()
    }

}

