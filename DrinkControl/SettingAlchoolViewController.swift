//
//  SettingAlchoolViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2020/03/13.
//  Copyright © 2020 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import Eureka

class SettingAlchoolViewController:FormViewController {
    
    let maxAlchool:Double = 70.0
    let minAlchool:Double = 1.0
    let maxLimit:Double = 7000
    
    private func reflectOnEurekaTable() {
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        
        StepperRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        SegmentedRow<String>.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
    }
    
    let descriptionStr = ["アルコールの濃度（度数）",
                          "飲酒量を入力する時の上限飲酒量",
                          "飲酒量の入力で1回クリックの増減量"]
    let alertTitle = "アルコール濃度の変更"
    let alertMsg =  "【原則】⭕️新規に入力するデータから適用されます。\n❌過去の入力済みデータには自動的には適用させません。\n【例外】⭕️設定画面に来る直前にホーム画面で選択されていた日付のデータには、戻った時に適用されます。\n【任意】過去のデータでアルコール量を再計算したい場合は、ホーム画面でその日付にタッチしてください。"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        reflectOnEurekaTable()
        
        //TODO 名前を設定しろ。
        form = Section("お酒別の設定")
            
            <<< SegmentedRow<String>("segments"){
                $0.options = ["濃度", "飲酒量の上限","増減量"]
                $0.value = "濃度"
            }
            
            +++ Section(){
                $0.tag = "alchool_s"
                $0.hidden = "$segments != '濃度'"
                self.present(.okAlert(title:self.alertTitle , message:self.alertMsg ,astyle:.alert))
            } // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
            
            <<< LabelRow () {
                $0.title = descriptionStr[0]
                //     $0.value = "OHANA Inc."
            }
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 1
                $0.cell.stepper.maximumValue = maxAlchool
                $0.cell.stepper.minimumValue = minAlchool
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"%"
                }
                $0.title = eDname.wine.ctitle(emoji: emojiSwitch)
                $0.value = alc_dic[eDname.wine]!
            }
                
            .onChange {
                let v = floor(Double($0.value!))
                alc_dic[eDname.wine] = v
              
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
                
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 1
                $0.cell.stepper.maximumValue = maxAlchool
                $0.cell.stepper.minimumValue = minAlchool
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"%"
                }
                $0.title = eDname.nihonsyu.ctitle(emoji: emojiSwitch)
                $0.value = alc_dic[eDname.nihonsyu]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_dic[eDname.nihonsyu] = v
                
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
                
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 1
                $0.cell.stepper.maximumValue = maxAlchool
                $0.cell.stepper.minimumValue = minAlchool
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"%"
                }
                $0.title = eDname.beer.ctitle(emoji: emojiSwitch)
                $0.value = alc_dic[eDname.beer]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_dic[eDname.beer] = v
                 
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 1
                $0.cell.stepper.maximumValue = maxAlchool
                $0.cell.stepper.minimumValue = minAlchool
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"%"
                }
                $0.title = eDname.shocyu.ctitle(emoji: emojiSwitch)
                $0.value = alc_dic[eDname.shocyu]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_dic[eDname.shocyu] = v
                
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 1
                $0.cell.stepper.maximumValue = maxAlchool
                $0.cell.stepper.minimumValue = minAlchool
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"%"
                }
                $0.title = eDname.whisky.ctitle(emoji: emojiSwitch)
                $0.value = alc_dic[eDname.whisky]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_dic[eDname.whisky] = v
                 
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 1
                $0.cell.stepper.maximumValue = maxAlchool
                $0.cell.stepper.minimumValue = minAlchool
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"%"
                }
                $0.title = eDname.can.ctitle(emoji: emojiSwitch)
                $0.value = alc_dic[eDname.can]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_dic[eDname.can] = v
                
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            
            //            飲酒量の上限
            
            +++ Section(){
                $0.tag = "limit_s"
                $0.hidden = "$segments != '飲酒量の上限'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
            }
            <<< LabelRow () {
                $0.title = descriptionStr[1]
                //     $0.value = "OHANA Inc."
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = maxLimit
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    //                           return "\(Int(v))"+"cc"
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.wine.ctitle(emoji: emojiSwitch)
                $0.value = alc_limit[eDname.wine]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_limit[eDname.wine] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = maxLimit
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.nihonsyu.ctitle(emoji: emojiSwitch)
                $0.value = alc_limit[eDname.nihonsyu]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_limit[eDname.nihonsyu] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = maxLimit
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.beer.ctitle(emoji: emojiSwitch)
                $0.value = alc_limit[eDname.beer]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_limit[eDname.beer] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = maxLimit
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.shocyu.ctitle(emoji: emojiSwitch)
                $0.value = alc_limit[eDname.shocyu]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_limit[eDname.shocyu] = v
            }
                
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = maxLimit
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.whisky.ctitle(emoji: emojiSwitch)
                $0.value = alc_limit[eDname.whisky]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_limit[eDname.whisky] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = maxLimit
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.can.ctitle(emoji: emojiSwitch)
                $0.value = alc_limit[eDname.can]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_limit[eDname.can] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            //            飲酒量のステップ
            
            +++ Section(){
                $0.tag = "limit_s"
                $0.hidden = "$segments != '増減量'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
            }
            <<< LabelRow () {
                $0.title = descriptionStr[2]
                //     $0.value = "OHANA Inc."
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = alc_limit[eDname.wine]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    //                           return "\(Int(v))"+"cc"
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.wine.ctitle(emoji: emojiSwitch)
                $0.value = alc_step[eDname.wine]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_step[eDname.wine] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = alc_limit[eDname.nihonsyu]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.nihonsyu.ctitle(emoji: emojiSwitch)
                $0.value = alc_step[eDname.nihonsyu]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_step[eDname.nihonsyu] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = alc_limit[eDname.beer]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.beer.ctitle(emoji: emojiSwitch)
                $0.value = alc_step[eDname.beer]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_step[eDname.beer] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = alc_limit[eDname.shocyu]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.shocyu.ctitle(emoji: emojiSwitch)
                $0.value = alc_step[eDname.shocyu]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_step[eDname.shocyu] = v
            }
                
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = alc_limit[eDname.whisky]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.whisky.ctitle(emoji: emojiSwitch)
                $0.value = alc_step[eDname.whisky]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_step[eDname.whisky] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = 10
                $0.cell.stepper.minimumValue = 10
                $0.cell.stepper.maximumValue = alc_limit[eDname.can]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.can.ctitle(emoji: emojiSwitch)
                $0.value = alc_step[eDname.can]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_step[eDname.can] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
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
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard
            #available(iOS 13.0, *),
            traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)
            else { return }
        
        updateTheme()
    }
    
    private func updateTheme() {
        guard #available(iOS 12.0, *) else { return }
        
        switch traitCollection.userInterfaceStyle {
        case .light:
            MyThemes.switchNight(isToNight: false)
        case .dark:
            MyThemes.switchNight(isToNight: true)
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
}
