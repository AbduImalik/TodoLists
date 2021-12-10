//
//  MyAlertViewController.swift
//  ToDo Lists
//
//  Created by Abdulmalik on 01/05/1443 AH.
//
import CleanyModal

import Foundation
class MyAlertViewController: CleanyAlertViewController {
    init(title: String?, message: String?, imageName: String? = nil, preferredStyle: CleanyAlertViewController.Style = .alert) {
        let styleSettings = CleanyAlertConfig.getDefaultStyleSettings()
        styleSettings[.tintColor] = .red
        styleSettings[.destructiveColor] = .systemPink
        super.init(title: title, message: message, imageName: imageName, preferredStyle: preferredStyle, styleSettings: styleSettings)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
