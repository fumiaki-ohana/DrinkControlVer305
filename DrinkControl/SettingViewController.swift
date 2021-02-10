//
//  SettingViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/12/03.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import Eureka
import Instructions
import Lottie
import WhatsNewKit

class SettingViewController: FormViewController,CoachMarksControllerDataSource,CoachMarksControllerDelegate {
 // MARK:- Properties
    private let secHeader_gen = "一般"
    private let secHeader_display = "表示"
    private let secHeader_target = "目標値の設定　"+"¹純アルコール量、²適量の倍数"
    private let secHeader_eacg = "個別のお酒の設定"
    private let secHeader_quick = "お酒の変更と入力"
    let emoji = entryFormPara(tag: "お酒の絵文字を表示")
    var emojiStrPara = entryFormPara(
        tag:"ドリンク数の表示形式",
        selectorTitle: "ドリンク数の表示形式",
        cancelTitle: cancelTitleStr
    )
    var emojiStrDic = [String:String] ()
    let maxTotalUnit:Double = 200.0
    let minTotalUnit:Double = 0.0
   
    // Coarch properties
       private var pointOfInterest:UIView!
       let coachMarksController = CoachMarksController()
      let hintStr  = ["使いながら設定⚙️で自分好みに変えてみましょう。\n\n- 🔔反省を読み返す時間を通知\n\n- 🎨アプリのテーマ色や絵文字\n\n- 🍷お酒の名前やアルコール濃度\n\n- 📅カレンダー詳細\n\n- 🏇飲酒のクイック入力\n\n- 🚰入力量の調整ETC.\n\n- 🥇休肝日や飲みすぎ"]
    
    // MARK:- Methods
     func reversedEmojiStr(emoji:drinkSet) -> String {
        switch emoji {
        case .item_def: return optionEmojiStr[0]+String(repeating:drinkSet.item_def.rawValue, count: 3)
        case .item_plain: return optionEmojiStr[1]+String(repeating:drinkSet.item_plain.rawValue, count: 3)
        case .item_alert: return optionEmojiStr[2]+String(repeating:drinkSet.item_alert.rawValue, count: 3)
        case .item_cross: return optionEmojiStr[3]+String(repeating:drinkSet.item_cross.rawValue, count: 3)
        case .item_sos: return optionEmojiStr[4]+String(repeating:drinkSet.item_sos.rawValue, count: 3)
        case .item_scul: return optionEmojiStr[5]+String(repeating:drinkSet.item_scul.rawValue, count: 3)
        default: return optionEmojiStr[6]+""
        }
    }
   // MARK:- Eureka table management
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    private func reflectOnEurekaTable() {
        
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        
        SwitchRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        ButtonRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        ActionSheetRow<String>.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        
        SwitchRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        StepperRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        AlertRow<String>.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        
        SegmentedRow<String>.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        
        LabelRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        
    }
    
    //MARK:- Coach
          
      func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
          //表示するスポットライトの数。チュートリアルの数。
          return hintStr.count
      }
          
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        //指し示す場所を決める。　今回はpointOfInterestすなわちButtonga指し示される
        var point:UIView!
        switch index {
      //  case 0:
     //       point = navigationItem.titleView
        case 0:
           let p = form.rowBy(tag: "theme")
          point = p?.baseCell
        /*
        case 1:
            let p = form.rowBy(tag: "calendar")
            point = p?.baseCell
        case 2:
            let p = form.rowBy(tag: "name")
            point = p?.baseCell
        case 3:
            let p = form.rowBy(tag: "totalUnit")
            point = p?.baseCell
        case 4:
            let p = form.rowBy(tag: "AlchoolDetail")
            point = p?.baseCell
        */
        default:break
        }
        return coachMarksController.helper.makeCoachMark(for: point)
    }
          
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
       
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, withNextText: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = hintStr[index]
        coachViews.bodyView.nextLabel.text = nextLabel
        
        coachViews.bodyView.background.cornerRadius = 20
        coachViews.bodyView.background.borderColor = UIColor(hexRGB:"#F99F48" )!
        coachViews.bodyView.hintLabel.textColor = .black
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
  /*
    func coachMarksController(_ coachMarksController: CoachMarksController, didShow coachMark: CoachMark, afterSizeTransition: Bool, at index: Int) {
        
        if index == 4 {
            // 通知許可の取得
            UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]){
                (granted, _) in
                if granted{
                    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
                }
            }
        }
    }
 */
 
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willShow coachMark: inout CoachMark,
                              beforeChanging change: ConfigurationChange,
                              at index: Int) {
      //  var  point:UIView!
        if index == 0 {
            coachMark.arrowOrientation = .top
            

        }
    }

/*
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willLoadCoachMarkAt index: Int) -> Bool {
        if index == 3 {//&& presentationContext == .controller {
           // coachMark.arrowOrientation = .top
            DispatchQueue.main.async { // テーブルをスクロールする。
                let indexPath = IndexPath(row: 0, section: 3)
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: false)
            }
        }
        return true
    }
*/
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didEndShowingBySkipping skipped: Bool) {
        
         DispatchQueue.main.async { // テーブルをスクロールする。
             let indexPath = IndexPath(row: 0, section: 1)
         self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
           }
     //   showAnimation(parentView:self.view, lottieJason: "3152-star-success")
        
        shouldShowCoarch = false // コーチフラグを偽
        flagReadMeV3 = true // ディスクレイマーも読んだ
        shouldShowVerInfo = false // 次回は新バージョンの情報は表示しなくても良い。コーチで学んだから。
        
        coarchWrapUp()
        DispatchQueue.main.async { // テーブルをスクロールする。
            let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
          }
        
        
        if !(userType == .newUser) {
            MyThemes.restoreLastTheme()
            MyThemes.setTheme()
        }
    }
    
    func coarchWrapUp() {
         
        let actionSheet = UIAlertController(
            title: "無料版のデータ保存回数は２回までです。",
            message: "制限の解除は【🛒App内購入の説明】をご覧ください。",
            preferredStyle: .alert)
        
        if unlocked {
            actionSheet.addAction(
                UIAlertAction(
                    title:OKstr,
                    style: .default,
                    handler:nil ))
        }
        else {
            actionSheet.addAction(
                UIAlertAction(
                    title: "🛒　App内購入の説明",
                    style: .default,
                    
                    handler:{(action) -> Void in self.performSegue(withIdentifier: "showPurchaseIntro", sender: Any?.self)}
            ))
            
            actionSheet.addAction(
                UIAlertAction(
                    title: "あとで説明を読む",
                    style: .default,
                    handler:{(action) -> Void in
                        actionSheet.pruneNegativeWidthConstraints()
                        self.present(.okAlert(title: "無料試用での保存回数", message: "最大2回までです。\n制限解除は、⚙️設定画面＞🛒App内課金の説明からどうぞ"))}
            ))
        }
        actionSheet.setMessageAlignment(.left)
        actionSheet.pruneNegativeWidthConstraints()
        self.present(actionSheet,animated:true, completion: nil)
    }
    
//MARK:- View Rotationtrue
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.theme_tintColor = GlobalPicker.toolBarButtonColor1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        self.tableView.reloadData()
        guard !shouldShowCoarch else {
            
            DispatchQueue.main.async { // テーブルをスクロールする。
                let indexPath = IndexPath(row: 0, section: 1)
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
            }
            self.coachMarksController.start(in: .currentWindow(of: self))
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "設定"
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        tableView.frame =
                        CGRect(x: 0, y: 44,  width: self.view.bounds.size.width, height: (self.view.bounds.size.height - 44))
        
      //  navigationItem.leftBarButtonItem?.theme_tintColor = GlobalPicker.naviItemColor
        reflectOnEurekaTable()
     //   self.tableView.rowHeight = UITableView.automaticDimension
        emojiStrPara.options  = [
            
            optionEmojiStr[0]+String(repeating:drinkSet.item_def.rawValue, count: 3),
            optionEmojiStr[1]+String(repeating:drinkSet.item_plain.rawValue, count: 3),
            optionEmojiStr[2]+String(repeating:drinkSet.item_alert.rawValue, count: 3),
            optionEmojiStr[3]+String(repeating:drinkSet.item_cross.rawValue, count: 3),
            optionEmojiStr[4]+String(repeating:drinkSet.item_sos.rawValue, count: 3),
            optionEmojiStr[5]+String(repeating:drinkSet.item_scul.rawValue, count: 3),
            optionEmojiStr[6]+"" ]
        
        for (index, item) in emojiStrPara.options.enumerated() {
            emojiStrDic[item] = drinkSetChar[index]
        }
//MARK:- Eureka
        
        form +++
            Section(secHeader_gen) //一般
     
            <<< ButtonRow() {
                $0.title = "減酒くんについて"
                $0.presentationMode = .segueName(segueName: "aboutViewControllerSegue", onDismiss: nil)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            <<< ButtonRow() {
                $0.title = "🛒App内課金の説明"
                $0.presentationMode = .segueName(segueName: "showPurchaseIntro", onDismiss:nil )
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            
            <<< ButtonRow() {
                $0.title = "⏰通知の設定"
                $0.presentationMode = .segueName(segueName: "showNotificationSettingSegue", onDismiss:nil )
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            /*
            <<< SwitchRow() {
                $0.title = "起動時に利用ガイドを表示"
                $0.value = shouldShowCoarch
            }
            .onChange{
                shouldShowCoarch = $0.value!
                
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            */
            
            +++ Section(secHeader_display)// 表示
            
            <<< ActionSheetRow<String>() {
                $0.tag = "theme"
                $0.title = "🎨色テーマ"
                $0.selectorTitle = "色テーマ"
                $0.options = ConstTheme
                let index = (MyThemes.currentTheme().rawValue == 7) ? 5: MyThemes.currentTheme().rawValue
                $0.value = ConstTheme[index]
                $0.cancelTitle = cancelTitleStr
            }
            .onChange{
                let index:Int = ConstTheme.firstIndex(of: $0.value!)!
                let themeInt:Int = (index == 5) ? 7:index
                let newTheme = MyThemes(rawValue: themeInt)
                MyThemes.switchTo(theme: newTheme!)
                
                MyThemes.saveLastTheme()
                
            }.cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
                
            .onPresent { from, to in
                to.popoverPresentationController?.permittedArrowDirections = .up
                
                if MyThemes.current == .dark {
                    to.view.theme_backgroundColor = GlobalPicker.labelTextColor
                    to.view.theme_tintColor = GlobalPicker.backgroundColor
                }
                else {
                to.view.theme_backgroundColor = GlobalPicker.backgroundColor
                    to.view.theme_tintColor = GlobalPicker.labelTextColor}
            }
            <<< ButtonRow() {
                $0.tag = "calendar"
                $0.title = "🗓カレンダーとグラフの詳細"
                $0.presentationMode = .segueName(segueName: "showCalendarSettingSegue", onDismiss: nil)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
          
            // 絵文字
            <<< SwitchRow() {
                $0.title = emoji.tag
                $0.value = emojiSwitch
            }
            .onChange{
                emojiSwitch = $0.value!
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            <<< ActionSheetRow<String>() {
                $0.title = emojiStrPara.tag
                $0.cancelTitle = emojiStrPara.cancelTitle
                $0.selectorTitle = emojiStrPara.selectorTitle
                $0.options = emojiStrPara.options
                $0.value = reversedEmojiStr(emoji: dEmojiConfig)
                
            }.onChange {
                let v = self.emojiStrDic[$0.value!]
                dEmojiConfig = drinkSet(rawValue: v!)!
            }
            .onPresent{ _, to in
                to.popoverPresentationController?.permittedArrowDirections = .up
                if MyThemes.current == .dark {
                    to.view.theme_backgroundColor = GlobalPicker.labelTextColor
                    to.view.theme_tintColor = GlobalPicker.backgroundColor
                }
                else {
                to.view.theme_backgroundColor = GlobalPicker.backgroundColor
                    to.view.theme_tintColor = GlobalPicker.labelTextColor}
            }
                
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            
            <<< ButtonRow() {
                $0.tag = "name"
                $0.title = "🍷→🍾🍸 お酒の名前変更"
                $0.presentationMode = .segueName(segueName: "showNamingSegue", onDismiss: nil)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            +++ Section(secHeader_quick)
            <<< SwitchRow() {
                $0.title = "飲酒のクイック入力"
                $0.value = execQuickDataEntry
                $0.tag = "quickEntryEnabled"
            }
            .onChange{
                $0.title = ($0.value ?? false) ? "CCの代わりにグラス数" : "飲酒のクイック入力"
           //     $0.updateCell()
                execQuickDataEntry = $0.value!
                
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            
            <<< ButtonRow() {
           //     $0.tag = "quickSetting"
           /*
                $0.hidden = .function(["quickEntryEnabled"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "quickEntryEnabled")
                    return row.value ?? false == false
                })
            */
                $0.title = "単位量を設定"
                $0.presentationMode = .segueName(segueName: "showQuickEntryViewSegue", onDismiss: nil)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            
            .cellSetup{cell, row in
                row.hidden = .function(["quickEntryEnabled"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "quickEntryEnabled")
                    return row.value ?? false == false
                })
            }

            +++ Section(secHeader_target) //目標値の設定
            <<< StepperRow() {
                $0.tag = "totalUnit"
                $0.cell.stepper.isContinuous = true
                $0.cell.stepper.maximumValue = maxTotalUnit
                $0.cell.stepper.minimumValue = minTotalUnit
                $0.cell.stepper.stepValue = 10
                $0.title = "適量（１日の上限）¹"
                $0.value = targetUnit*10
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"𝐠"
                }
            }
            .onChange {
                targetUnit = floor(Double($0.value!)/10)
              //  update()
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.cell.stepper.isContinuous = true
                $0.cell.stepper.maximumValue = 7
                $0.cell.stepper.minimumValue = 0
                $0.title = "一週間の休肝日"
                $0.value = Double(numOfNoDrinkDays)
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"日"
                }
            }
            .onChange {
                numOfNoDrinkDays = Int($0.value!)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            <<< StepperRow() {
                $0.tag = "excessDrink"
                $0.cell.stepper.isContinuous = true
                $0.cell.stepper.maximumValue = 10
                $0.cell.stepper.minimumValue = 1
                $0.title = "飲み過ぎ²"
                $0.value = Double(excessDrinkHairCut)
                $0.displayValueFor = {
                    guard let v = $0 else {return "1"}
                    let t = targetUnit*10*Double(v)
                    return v.decimalStrPlain + "倍(" + t.decimalStr + ")"
                }
            }
            .onChange {
                excessDrinkHairCut = Int($0.value!)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.theme_backgroundColor = GlobalPicker.backgroundColor
            }
            
            +++ Section(secHeader_eacg)//個別のお酒の設定
            <<< ButtonRow() {
                $0.tag = "AlchoolDetail"
                $0.title = "濃度・上限・増減"
                $0.presentationMode = .segueName(segueName: "alchoolSettingSegue", onDismiss: nil)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        
        /*
       func update() {
        
        
            if let excessDrink = self.form.rowBy(tag: "excessDrink") {
                // 対象のセレクトボックスにデータを入れるために.cellUpdateを呼ぶ
                excessDrink.updateCell()
                excessDrink.reload()
            }
       
        }
         */
    }
    

    
//MARK:- Dark mode support
    
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
    
/*
//MARK:- PopTip
    
    override func viewWillDisappear(_ animated: Bool) {
        popTip.hide()
    }
    
       @objc func sectionHeaderDidTap(_ sender: UIGestureRecognizer) {
              
           let helpMessage = ["飲酒と健康について参考になる情報や、減酒くんの使用方法、サポートへのコンタクトなどの画面を表示します","全般の色テーマを選択できます。\n　カレンダーの月を移動する時のスワイプの方向や表示言語、絵文字等を変更できます。","⚠️重要な設定項目です。\n　１日の純アルコール量の上限目標を設定します。減酒くんでは厚生労働省の推奨に基づき初期値を20gに設定してありますが、ご自身の健康状況などを考慮して慎重に設定ください。","⚠️重要な設定項目です。\n　個別のお酒ごとにアルコール濃度と、入力の上限量、一回タップした時の増減量を設定できます。アルコール濃度の初期値を変更する場合は、慎重に行ってください。\n　初期値に戻したい場合は、設定＞使用方法＞詳しい使用方法をご覧ください。"]
              
           popTip.show(text: helpMessage[sender.view!.tag], direction: .none, maxWidth: 150, in: view, from: view!.frame)
          }
       override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           
           let view = UITableViewHeaderFooterView()
          
           let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDidTap(_:)))
           view.addGestureRecognizer(gesture)
           view.tag = section
           
           return view }
 */
}
