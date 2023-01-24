//
//  ViewController.swift
//  SpyneSDK
//
//  Created by Akash Verma on 01/23/2023.
//  Copyright (c) 2023 Akash Verma. All rights reserved.
//

import UIKit
import SpyneSDK
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SpyneSDK.shared.onCreate(presentingByViewController: self, api_Key: "f632fef7-d237-4e57-8848-0c0c08732b4e", categoryId: "cat_d8R14zUNE", emailID: "test@test.com", userId: "test user", skuID: "test1234", frameNumber: 8)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

