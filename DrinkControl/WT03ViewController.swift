//
//  WT03ViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/17.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Eureka
import SnapKit

class WT03ViewController: FormViewController {
    @IBOutlet weak var nextButton: UIButton!
    let header1 = "１日の適量を設定してみましょう。"
    let footer1 = "厚生労働省の「健康日本21」では節度ある適度な飲酒は20gとされます。女性はその半分から2/3程度とされます。㊟ 年齢、妊娠、体質等々で大きい個人差があるので、必ず自分にあう数値を設定してください。"
    let buttonTitle = "休肝日の目標"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        setButtonProperties(button: nextButton,rgbaStr:"#F99F48" )
        nextButton.setTitle(buttonTitle , for: .normal)
   
        self.tableView?.rowHeight = 40.0
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        nextButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(35)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-15)
        }
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
