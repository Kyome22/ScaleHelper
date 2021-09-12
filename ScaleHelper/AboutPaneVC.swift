//
//  AboutPaneVC.swift
//  ScaleHelper
//
//  Created by Takuto Nakamura on 2021/09/11.
//

import Cocoa

class AboutPaneVC: NSViewController {

    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var copyrightLabel: NSTextField!
    
    var originalSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalSize = self.view.frame.size
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        versionLabel.stringValue = "version \(version)"
        
        let copyright = Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as! String
        copyrightLabel.stringValue = copyright
    }
    
}
