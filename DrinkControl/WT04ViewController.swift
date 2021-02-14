//
//  WT04ViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/18.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Eureka
import SnapKit

class WT04ViewController: FormViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    let header1 = "１日の適量、休肝日の数、飲みすぎ基準を設定してみましょう。"
    let footer1 = "参考：厚生労働省の「健康日本21」では節度ある適度な飲酒は20gとされます。女性はその半分から2/3程度とされます。㊟ 年齢、妊娠、体質等々で大きい個人差があるので、自分にあう数値を設定してください。"
    let footer2 = "参考：厚生労働省の「健康日本21」は、平均１日あたり純アルコール量60g飲む人を多量飲酒者と呼びます。ただし大きな個人差はあります。"
    let buttonTitle = "ホーム画面へ移動"
    let indicatedAmount = "ビール(5度）ー＞ロング缶（500ml)\n日本酒（15度）ー＞ お銚子１合（180ml)\n焼酎（25度）ー＞コップ１杯0.6合（110ml)\nウイスキー（43度）ー＞ダブル１杯（60ml)\nワイン（14度）ー＞グラス１杯（180ml)\n缶チューハイ(5度）ー＞1.5缶（520ml)"
    
    @IBAction func pressButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "moveToMain", sender: Any?.self)
    }
    
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
            <<< ButtonRow() {
                $0.title = "💡具体例はこちら" //TODO
                $0.onCellSelection{ [self]_,_ in self.present(.okAlert(alignment:.left, title: "純アルコール量20gのおおよその目安です",
                                                                message: indicatedAmount,astyle:.alert))}
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
        
           +++ Section(header:"",footer:footer2)
            <<< StepperRow() {
            //    $0.tag = "selection"
                $0.cell.stepper.isContinuous = true
                $0.cell.stepper.maximumValue = 7
                $0.cell.stepper.minimumValue = 0
                //  $0.title =
                $0.value = Double(numOfNoDrinkDays)
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "休肝日：一週間"+"\(Int(v))"+"日"
                }
            }
            .onChange {
                numOfNoDrinkDays = Int($0.value!)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            
            
            <<< StepperRow() {
                $0.tag = "selection"
                $0.cell.stepper.isContinuous = true
                $0.cell.stepper.maximumValue = 9
                $0.cell.stepper.minimumValue = 0
                //  $0.title =
                $0.value = Double(excessDrinkHairCut)
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "飲みすぎ：適量の"+"\(Int(v))"+"倍 (" + (targetUnit*10*v).decimalStr+")"
                }
            }
            .onChange {
                excessDrinkHairCut = Int($0.value!)
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
