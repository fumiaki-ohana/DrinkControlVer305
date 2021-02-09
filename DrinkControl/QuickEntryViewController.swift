//
//  QuickEntryViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2021/02/03.
//  Copyright © 2021 OHANA Inc. All rights reserved.
//

import UIKit
import Eureka

class QuickEntrylViewController:FormViewController {
    
    let max:Double = 1000.0
    let min:Double = 50.0
    let step:Double = 10.0
    
    private func reflectOnEurekaTable() {
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        
        StepperRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        reflectOnEurekaTable()
        form
            //            飲酒量の上限
            
            +++ Section("グラス／ボトルの量を設定")
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = step
                $0.cell.stepper.minimumValue = min
                $0.cell.stepper.maximumValue = max
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    //                           return "\(Int(v))"+ml
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.wine.ctitle(emoji: emojiSwitch)
                $0.value = alc_quick[eDname.wine]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_quick[eDname.wine] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = step
                $0.cell.stepper.minimumValue = min
                $0.cell.stepper.maximumValue = max
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.nihonsyu.ctitle(emoji: emojiSwitch)
                $0.value = alc_quick[eDname.nihonsyu]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_quick[eDname.nihonsyu] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = step
                $0.cell.stepper.minimumValue = min
                $0.cell.stepper.maximumValue = max
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.beer.ctitle(emoji: emojiSwitch)
                $0.value = alc_quick[eDname.beer]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_quick[eDname.beer] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = step
                $0.cell.stepper.minimumValue = min
                $0.cell.stepper.maximumValue = max
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.shocyu.ctitle(emoji: emojiSwitch)
                $0.value = alc_quick[eDname.shocyu]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_quick[eDname.shocyu] = v
            }
                
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            <<< StepperRow() {
                $0.cell.stepper.stepValue = step
                $0.cell.stepper.minimumValue = min
                $0.cell.stepper.maximumValue = max
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.whisky.ctitle(emoji: emojiSwitch)
                $0.value = alc_quick[eDname.whisky]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_quick[eDname.whisky] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.stepValue = step
                $0.cell.stepper.minimumValue = min
                $0.cell.stepper.maximumValue = max
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return (Int(v)).decimalStr
                }
                $0.title = eDname.can.ctitle(emoji: emojiSwitch)
                $0.value = alc_quick[eDname.can]!
            }
            .onChange {
                let v = floor(Double($0.value!))
                alc_quick[eDname.can] = v
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
        
           
        }
        // Do any additional setup after loading the view.

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
