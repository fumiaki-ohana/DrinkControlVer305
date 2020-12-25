//
//  WT01ViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/17.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit

let titleStr = "ガイドを体験する（無料）"

class WT01ViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        self.overrideUserInterfaceStyle = .light
        super.viewDidLoad()
       
        setButtonProperties(button: nextButton,rgbaStr:"#F99F48" )
        nextButton.setTitle( titleStr, for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
