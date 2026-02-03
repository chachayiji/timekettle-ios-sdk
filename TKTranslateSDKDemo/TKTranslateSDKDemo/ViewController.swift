//
//  ViewController.swift
//  TKTranslateSDKDemo
//
//  Created by xiongjinhui on 2026/2/3.
//

import UIKit
import os
import TKTranslateSDK

class ViewController: UIViewController {
    private let logger = Logger(subsystem: "TKTranslateSDKDemo", category: "SDK")

    override func viewDidLoad() {
        super.viewDidLoad()
        let result = TKTranslateSDK.translate("Hello", to: "zh")
        print("TKTranslateSDK demo:", result)
        NSLog("TKTranslateSDK demo: %@", result)
        logger.info("TKTranslateSDK demo: \(result, privacy: .public)")
    }


}
