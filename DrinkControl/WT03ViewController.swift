//
//  WT03ViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/17.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Eureka

class WT03ViewController: FormViewController {
    @IBOutlet weak var nextButton: UIButton!
    let header1 = "１日の適量を、純アルコール量で設定してみましょう。"
    let footer1 = "◦ 厚生労働省の「健康日本21」では節度ある適度な飲酒は20gとされます。女性はその半分から2/3程度です。\n\n◦ 目安はビールでロング缶1本、ワイングラス２杯弱、日本酒一合、ウイスキーダブル相当です。\n㊟ 年齢、妊娠、体質等々で大きい個人差があるので自分にあう数値を設定してください。"
    let buttonTitle = "休肝日"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        setButtonProperties(button: nextButton,rgbaStr:"#F99F48" )
        nextButton.setTitle(buttonTitle , for: .normal)
        tableView.frame =
                  CGRect(x:10, y: 160, width: self.view.frame.width-20, height: self.view.frame.height  - 290)
        self.tableView?.rowHeight = 40.0
        form +++
            Section(header:header1,footer:footer1)
                   
                   <<< StepperRow() {
                 //      $0.tag = "selection"
                       $0.cell.stepper.isContinuous = true
                       $0.cell.stepper.maximumValue = 50
                       $0.cell.stepper.minimumValue = 0
                       $0.title = "純アルコール量"
                       $0.value = targetUnit*10
                       $0.displayValueFor = {
                           guard let v = $0 else {return "0"}
                           return "\(Int(v))"+"𝐠"
                       }
                   }
                   .onChange {
                       targetUnit = floor(Double($0.value!)/10)
                   }
                   .cellUpdate() {cell, row in
                       cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                       cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                       cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                   }
      
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
