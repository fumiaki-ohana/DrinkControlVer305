//
//  CalanderSettingViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/31.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Eureka


class CalanderSettingViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        ActionSheetRow<String>.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        
        // スワイプの方向
        form +++
            Section("カレンダー")
            <<< ActionSheetRow<String>() {
                $0.title = calSet.scrollDir.tag
                $0.selectorTitle = calSet.scrollDir.selectorTitle
                $0.options = calSet.scrollDir.options
                $0.value =  calSet.scrollDir.options[cal_direction]
                $0.cancelTitle = cancelTitleStr
                
            }
            .onChange{
                cal_direction
                    = ConstScrollDir.firstIndex(of: $0.value!)!
            }
                
            .onPresent { from, to in
                to.popoverPresentationController?.permittedArrowDirections = .up
                to.view.theme_backgroundColor = GlobalPicker.backgroundColor
                               to.view.theme_tintColor = GlobalPicker.labelTextColor
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            // 言語
            <<< ActionSheetRow<String>() {
                $0.title = calSet.language.tag
                $0.selectorTitle = calSet.language.selectorTitle
                $0.options = calSet.language.options
                $0.value = calSet.language.options[cal_language]
                $0.cancelTitle = cancelTitleStr
            }
                
            .onChange{
                cal_language = ConstLanguage.firstIndex(of: $0.value!)!
            }
                
            .onPresent { from, to in
                to.popoverPresentationController?.permittedArrowDirections = .up
                to.view.theme_backgroundColor = GlobalPicker.backgroundColor
                               to.view.theme_tintColor = GlobalPicker.labelTextColor
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            /*
            +++   Section(header:"グラフ", footer:"¹グラフや直近７日データなど過去データを表示する際に、デフォルトでは表示期間の最終日を昨日に設定しています。常に本日にしたい場合はオフにしてください。")
            */
             +++   Section("グラフ")
            
            <<< ActionSheetRow<String>() {
                $0.title = "グラフの種類"
                $0.selectorTitle = "グラフの種類"
                $0.options = graphOption
                $0.value = graphOption[graphType]
                $0.cancelTitle = cancelTitleStr
                
            }
               
            .onChange{
                graphType
                    = graphOption.firstIndex(of: $0.value!)!
            }
                
            .onPresent { from, to in
                to.popoverPresentationController?.permittedArrowDirections = .up
                to.view.theme_backgroundColor = GlobalPicker.backgroundColor
                               to.view.theme_tintColor = GlobalPicker.labelTextColor
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        //
        /*
        絵文字
                       <<< SwitchRow() {
                       $0.title = "昨日が最終日¹"
                       $0.value = lastDateSetAsOf
                       }
                       .onChange{
                       lastDateSetAsOf = $0.value!
                       }
                       .cellUpdate() {cell, row in
                       cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                       cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                       }
                       
        */
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
