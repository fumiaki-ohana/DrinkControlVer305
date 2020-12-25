//
//  MyThemes.swift
//  Demo
//
//  Created by Gesen on 16/3/14.
//  Copyright © 2016年 Gesen. All rights reserved.
//

import Foundation
import SwiftTheme
import UIKit

private let lastThemeIndexKey = "lastedThemeIndex"
private let defaults = UserDefaults.standard

let ConstTheme =  ["標準", "ウオーム","クール","キュート","モノクロ","☾ ダークモード"]

enum MyThemes: Int {
    
    case norm = 0
    case warm = 1
    case cool = 2
    case cute = 3
    case night = 4
    case walkThrough = 5
    case inPurchase = 6
    case dark = 7
    
    // MARK: -
    
    static var current: MyThemes { return MyThemes(rawValue: ThemeManager.currentThemeIndex)! }
    static var before = MyThemes.norm
    
    // MARK: - Switch Night
    
    static func switchNight(isToNight: Bool) {
        switchTo(theme: isToNight ? .dark : before)
    }
    
    static func isNight() -> Bool {
        return current == .dark
    }
    
    // MARK: - Switch Theme
    
    static func switchToSimply(theme: MyThemes) {
        ThemeManager.setTheme(index: theme.rawValue)
    }
    
    static func switchTo(theme: MyThemes) {
        before = current
        ThemeManager.setTheme(index: theme.rawValue)
    }
    
    // MARK: - Save & Restore
    
    static func currentTheme() -> MyThemes {
        return MyThemes(rawValue: ThemeManager.currentThemeIndex)!
    }
    
    static func restoreLastTheme() {
        switchTo(theme: MyThemes(rawValue: defaults.integer(forKey: lastThemeIndexKey))!)
    }
    
    static func saveLastTheme() {
        defaults.set(ThemeManager.currentThemeIndex, forKey: lastThemeIndexKey)
    }
    
    static func nameStr(name: MyThemes) -> String {
        switch name {
        case .norm: return ConstTheme[0]
        case .warm: return ConstTheme[1]
        case .cool: return ConstTheme[2]
        case .cute: return ConstTheme[3]
        case .night: return ConstTheme[4]
        case .walkThrough: return ""
        case .inPurchase: return ""
        case .dark: return ConstTheme[5]
        }
    }
    
    static func setTheme() {
        /*
         let uiview = UIView.appearance()
         uiview.theme_tintColor = GlobalPicker.tintColor
         uiview.theme_backgroundColor = GlobalPicker.backgroundColor
         */
        // status bar
        
        UIApplication.shared.theme_setStatusBarStyle([.default, .default, .default, .default,.default,.default,.default ], animated: true)
        
        // navigation bar
        let shadow = NSShadow()
               shadow.shadowOffset = CGSize(width: 0, height: 0)
        
        let titleAttributes = GlobalPicker.barTitleColors.map { hexString in
                   return [
                       NSAttributedString.Key.foregroundColor: UIColor(rgba: hexString),
                       NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                       NSAttributedString.Key.shadow: shadow,
                   ]
               }
        
        
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.theme_titleTextAttributes = ThemeStringAttributesPicker.pickerWithAttributes(titleAttributes)
        
        let labelAttributes = GlobalPicker.labelTextColors.map { hexString in
            return [
                NSAttributedString.Key.foregroundColor: UIColor(rgba: hexString),
                //                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                //                NSAttributedString.Key.font: UIFont.systemFontSize
                NSAttributedString.Key.shadow: shadow
            ]
        }
        
        let tabbar = UITabBar.appearance()
        tabbar.theme_tintColor = GlobalPicker.tabTintColor
        
        let stepper = UIStepper.appearance()
        stepper.theme_backgroundColor = GlobalPicker.stepperBackgroundColor
      //  stepper.theme_tintColor = GlobalPicker.stepperTinColor
        
        let label = UILabel.appearance()
        label.theme_textColor = GlobalPicker.labelTextColor
        label.theme_highlightedTextColor = GlobalPicker.labelHilight
        label.theme_textAttributes = ThemeStringAttributesPicker.pickerWithAttributes(labelAttributes)
        
     //   navigationBar.theme_barTintColor = GlobalPicker.barTintColor //background
        
    //    navigationBar.isTranslucent = true
    //    navigationBar.theme_tintColor = GlobalPicker.barTextColor
   //     navigationBar.theme_backgroundColor = GlobalPicker.barBackGroundColor
    
     //   navigationController?.navigationBar.theme_barTintColor = GlobalPicker.barTintColor
    //           navigationController?.navigationBar.theme_backgroundColor = GlobalPicker.barBackGroundColor

        
        // tool bar
        
        let toolbar = UIToolbar.appearance()
        
        toolbar.theme_tintColor = GlobalPicker.barTextColor
        toolbar.theme_barTintColor = GlobalPicker.cellBackGround_dataEntry
        toolbar.theme_backgroundColor = GlobalPicker.barTintColor
        
        let button = UIButton.appearance()
     //   button.theme_tintColor = GlobalPicker.buttonTintColorForNavigation
        button.theme_setTitleColor(GlobalPicker.buttonTitleColor, forState:.normal)
        
        let segment = UISegmentedControl.appearance()
        segment.theme_selectedSegmentTintColor = GlobalPicker.segmentTintColor
        
        let SelectSwitch = UISwitch.appearance()
        SelectSwitch.theme_onTintColor = GlobalPicker.onSwithTintColor
        SelectSwitch.theme_thumbTintColor = GlobalPicker.thumbTintColor
        
    }
    
}
