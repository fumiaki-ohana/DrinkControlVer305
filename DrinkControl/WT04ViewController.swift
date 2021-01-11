//
//  WT04ViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/18.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Eureka

class WT04ViewController: FormViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    let header1 = "休肝日は一週間の目標日数、多量飲酒は適量の倍数を設定してください。"
    let footer1 = "厚生労働省の「健康日本21」は、平均１日あたり純アルコール量60g(通常適量20gの3倍）飲む人を多量飲酒者と呼びます。ただし大きな個人差はあります。"
    let buttonTitle = "ホーム画面へ移動"
    
    @IBAction func pressButton(_ sender: UIButton) {
        /*
        let titl = "ご使用の前にお読みください。"
        let disclaimer = "飲酒による健康への影響は性別、年齢、健康状態、妊娠、体質等々、様々な要因で異なり、大きな個人差があります。ご自身に適した設定を判断しアプリで計算・表示される数字等の意味と限界をご理解の上でご自身の責任でご利用ください。独力で減酒が難しい場合は専門家に相談してください。厚生労働省のhttps://www.e-healthnet.mhlw.go.jp/には飲酒に参考となる情報があります。\n当アプリの使用の結果や健康等への影響に対してアプリ製作者は一切責任を負いません。"
        self.present(.okAlert(title:titl, message:disclaimer ,astyle: .alert, okstr:"了解", okHandler: {(action) -> Void in  self.performSegue(withIdentifier: "moveToMain", sender: Any?.self)}))
        */
        self.performSegue(withIdentifier: "moveToMain", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        setButtonProperties(button: nextButton,rgbaStr:"#F99F48" )
        nextButton.setTitle(buttonTitle , for: .normal)
        tableView.frame =
            CGRect(x:10, y: 160, width: self.view.frame.width-20, height: self.view.frame.height - 290)
        self.tableView?.rowHeight = 40.0
        form +++
            Section(header:header1,footer:footer1)
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
                    return "多量飲酒：適量の"+"\(Int(v))"+"倍 (" + (targetUnit*10*v).decimalStr+")"
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
