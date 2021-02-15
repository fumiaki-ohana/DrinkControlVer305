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
  //  let navTitle = "減酒の目標を設定"
    
    func showWeb() {
        // url = 遷移したいサイトのURLをString型で指定
        let url = NSURL(string: "https://www.e-healthnet.mhlw.go.jp/information/alcohol/a-03-002.html")

        if UIApplication.shared.canOpenURL(url! as URL) {
          UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    let header1 = "最初に１日の適量、休肝日の数、飲みすぎ基準を設定してみましょう。\n⚠️当アプリはユーザーの情報を、一切外部に送信しません。"
    let targetAlcDesc = "厚生労働省の「健康日本21」では節度ある適度な飲酒は20gとされます。女性はその半分から2/3程度とされます。㊟ 年齢、妊娠、体質等々で大きい個人差があるので、自分にあう数値を設定してください。"
    let excessAlcDesc = "厚生労働省の「健康日本21」は、平均１日あたり純アルコール量60g飲む人を多量飲酒者と呼びます。ただし大きな個人差はあります。"
    let buttonTitle = "ホーム画面へ移動"
    let indicatedAmount = "ビール(5度）ー＞ロング缶（500ml)\n日本酒（15度）ー＞ お銚子１合（180ml)\n焼酎（25度）ー＞コップ１杯0.6合（110ml)\nウイスキー（43度）ー＞ダブル１杯（60ml)\nワイン（14度）ー＞グラス１杯（180ml)\n缶チューハイ(5度）ー＞1.5缶（520ml)"
    let confirm = "お酒の影響には大きな個人差があります。自分の健康状態などを考えて適切な量を設定してください。\n設定画面でいつでも変更できます。"
    let ref1 = "開発参考：eヘルスネット厚生労働省"
    let ref2 = "飲酒を減らすための方法"
    
    
    @IBAction func pressButton(_ sender: UIButton) {
        present(.okAlert(alignment:.left, title:"確認です", message:confirm ,astyle: .alert, okstr:"了解", okHandler: {(action) -> Void in  self.self.performSegue(withIdentifier: "moveToMain", sender: Any?.self)}))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let titl = "減酒くん"
        let compButtonTitle = "続ける"
        let detailButtonTitle = "開発参考：厚生労働省e-ヘルスネットへ"
        let detailWebSite = "https://www.e-healthnet.mhlw.go.jp/information/alcohol"
        let msg:[(title:String,subtitle:String,icon:String)] =
            [("記録だけでは減らない！","毎朝反省→飲む前に読み返す。通知機能で習慣づけ","good"),
             ("飲んだお酒を見える化","純アルコール量換算、休肝・飲み過ぎ日","ChartBarIcon"),("かんたん入力","飲酒量(㎖)とグラス数のどちらでも入力、休肝日は一発入力","dash"),
             ("自分好みに変える","お酒の変更、アルコール濃度も個別調整。7種類のアプリ色テーマETC・・カスタマイズ可能","Paint")]
        let item = showWhatsNewPlus(titl: titl, compButtonTitle: compButtonTitle, detailButtonTitle:detailButtonTitle,webStr:detailWebSite, msg: msg)
        present(item,animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        setButtonProperties(button: nextButton,rgbaStr:"#F99F48" )
        nextButton.setTitle(buttonTitle , for: .normal)
  //      navigationItem.title = navTitle
     
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
            Section(header1)
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
                $0.title = "純アルコール量とは？" //TODO
                $0.cellStyle = .default
                $0.cell.accessoryType = .detailDisclosureButton
                $0.onCellSelection{ [self]_,_ in self.present(.okAlert(alignment:.left, title: "純アルコール量について",
                                                                message:targetAlcDesc+"\n\n"+indicatedAmount,astyle:.alert))}
            }
            .cellUpdate() {cell, row in
                cell.accessoryType = .detailButton
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
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
            <<< ButtonRow() {
                $0.title = "飲み過ぎとは？" //TODO
                $0.cellStyle = .default
                $0.onCellSelection{ [self]_,_ in self.present(.okAlert(alignment:.left, title: "飲み過ぎ（多量飲酒）",
                                                                message: excessAlcDesc,astyle:.alert))}
            }
            .cellUpdate() {cell, row in
                cell.accessoryType = .detailButton
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
        
            <<< ButtonRow() {
                $0.title = ""
//TODO
                $0.cellStyle = .default
                $0.onCellSelection{ [self]_,_ in self.showWeb()}
            }
            .cellUpdate() { [self]cell, row in
                cell.accessoryType = .detailButton
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.textLabel!.attributedText = setAttribute(title1: ref1, title2: "\n"+ref2,t1:12,t2:10)
                cell.textLabel?.numberOfLines = 2
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
