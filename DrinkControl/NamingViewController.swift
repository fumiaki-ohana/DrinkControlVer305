//
//  NamingViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/09/09.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Eureka

class NamingViewController: FormViewController {
    let nameOptions = [
        "ﾌﾞﾗﾝﾃﾞｰ",
        "ｼｬﾝﾊﾟﾝ",
        "ｳｵｯｶ",
        "ﾃｷｰﾗ",
        "ﾊﾞｰﾎﾞﾝ",
        "ﾘｷｭｰﾙ",
        "ﾍﾞﾙﾓｯﾄ",
        "ﾎｯﾋﾟｰ",
        "ラム",
        "ジン",
        "焼酎",
        "酎ハイ",
        "紹興酒",
        "梅酒",
        "泡盛",
        "米焼酎",
        "芋焼酎",
        "麦焼酎",
        "黒糖酎",
        "泡"]
    let hStr = "2種類のお酒の名前が変更できます。"
    let fStr = "①過去の入力済みデータは、新しい名前で置き換えて表示します。\n②アルコール濃度が変わる場合は、忘れずに変更してください。方法：設定>個別のお酒の設定"
    
    @IBAction func pressCancel(_ sender: UIBarButtonItem) {
        if (altCanName == altShochuName)  {
            present(.okAlert(title: "エラー: 同じ名前です。", message: "違う名前を設定してください。"))}
        else {
             self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        
        AlertRow<String>.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor}
            
        form +++
            
            Section(header:hStr,footer:fStr)
           <<< AlertRow<String>() {
                $0.title = eDname.shocyu.ctitle(emoji: true)+"（現在）➡️"
                $0.cancelTitle = cancelTitleStr
                $0.selectorTitle = "選択してください"
                $0.options = nameOptions
                $0.value = eDname.shocyu.ctitle(emoji: false)
                }.onChange { row in
                    let before = altShochuName
                    altShochuName = row.value ?? before
                }
                .onPresent{ _, to in
                    to.view.theme_backgroundColor = GlobalPicker.backgroundColor
                    to.view.theme_tintColor = GlobalPicker.labelTextColor
                  //  to.view.tintColor = .purple
            }
            .cellUpdate() {cell, row in
                           cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                           cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                       }
            
            <<< AlertRow<String>() {
                $0.title = eDname.can.ctitle(emoji: true)+"（現在）➡️"
                $0.cancelTitle = cancelTitleStr
                $0.selectorTitle = "選択してください"
                $0.options = nameOptions
                $0.value = eDname.can.ctitle(emoji: false)
            }.onChange { row in
                let before = altCanName
                altCanName = row.value ?? before
            }
            .onPresent{ _, to in
               to.view.theme_backgroundColor = GlobalPicker.backgroundColor
                to.view.theme_tintColor = GlobalPicker.labelTextColor
        }
        .cellUpdate() {cell, row in
                       cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                       cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                   }
    }
}
