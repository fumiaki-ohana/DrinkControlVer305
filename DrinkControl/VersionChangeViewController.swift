//
//  VersionChangeViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/05/15.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit

class VersionChangeViewController: ViewController {
    @IBOutlet weak var moveToPageMain: UIButton!
    
    @IBOutlet weak var versionStr: UILabel!
    
    override func viewDidLoad() {
        versionStr.text = "減酒くん Ver1.xxからVer."+appVersion!+"へ更新された方限定"
        self.overrideUserInterfaceStyle = .light
        shouldShowVersionInfo = false
        super.setButtonProperties(button: moveToPageMain, rgbaStr: "#F99F48")
        moveToPageMain.setTitle( OKstr, for: .normal)
        /*
         // MARK: - Navigation
         
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    }
}
