//
//  HomeViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/08/19.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar
import StoreKit
import SwiftTheme
import Instructions
import WhatsNewKit

class HomeViewController: UIViewController,  FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance, UITableViewDataSource,UITableViewDelegate,CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    @IBOutlet var backGround: UIView!
    // MARK: - IB Properties
    
    @IBOutlet weak var drinkCalendar: FSCalendar!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var calendarHeight:NSLayoutConstraint!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var EmptyStateView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Properties
    var mySections = [String]()
    var twoDimArray = [tableArray]()
    var sectionTitleArray = ["１日の上限目標","合計の純アルコール量", "飲んだお酒の内訳"]
    let disclaimer = "【開始の前にお読みください。】\n　飲酒による健康への影響には大きな個人差があり特に妊婦や持病のある人は要注意です。自分に合った設定をして、アプリで計算・表示される数字等の意味と限界をご理解の上でご自身の責任でご利用ください。\n　厚生労働省のhttps://www.e-healthnet.mhlw.go.jp/には飲酒に参考となる情報があります。\n　当アプリの開発では正しい数字が計算・表示されるように注意しましたが誤りの可能性は完全には排除できません。\n　当アプリの使用の結果や健康等への影響に対してアプリ製作者は一切責任を負いません。"
    
    var drinkDaily = DrinkDailyRecord(dDate: Date())
    var selectedDate = Date()
    var saveStatus = true
    
    //MARK:- Coach Properties
    let coachMarksController = CoachMarksController()
    private var pointOfInterest:UIView!
    private var tableCellView:UIView!
    let hintStr =
    ["📅の点は飲酒量で、ひとつが純アルコール量10gを示します。",
         "カレンダーで日付を選ぶと、🍷飲酒データが表示されます。","編集は、セルか右上の📝ボタンをタップします。","詳細は📈グラフで表示します"]
 
    // MARK: -IB Action📝
    @IBAction func editDataEntry(_ sender: UIBarButtonItem) {
        processDataEntry()
    }
    
    @IBAction func pressAddButton(_ sender: UIButton) {
        if shouldShowCoarch {
            performSegue(withIdentifier: "showDailyDrinkRecord", sender: Any?.self)
        }
        else {
            processDataEntry()}
    }
    
    func processDataEntry() {
        
        guard selectedDate < Date() else {
            present(.okAlert(title: nil, message: "未来の日付では入力できません。"))
            return
        }
        guard canSave else {
            promptForPurchaseAlert(titleStr:"購入をご検討ください（⚙️設定＞🛒App内課金）", msgStr:"保存可能な回数を超えました", flag:false)
            return
        }
        guard unlocked || (remainSaveTime > haircutForNotice) else {
            promptForPurchaseAlert(titleStr:"購入をご検討ください（⚙️設定＞🛒App内課金）", msgStr: "保存可能な回数は残り"+String(remainSaveTime)+"回です。",flag:true)
            return
        }
        
        performSegue(withIdentifier: "showDailyDrinkRecord", sender: Any?.self)
    }
    
    @IBAction func press_deleteButton(_ sender: UIBarButtonItem) {
        
           self.navigationItem.title = selectedDate.mediumStr+"を選択"
           let date = selectedDate
           let id = (date.toHashStr)
           
           let actionSheet = UIAlertController(
               title: "確認",
               message: "削除しますか？",
               preferredStyle: .actionSheet)
           
           actionSheet.addAction(
               UIAlertAction(
                   title: "キャンセル",
                   style: .cancel,
                   handler:nil)
           )
           
           actionSheet.addAction(
               UIAlertAction(
                   title: "削除します",
                   style: .destructive,
                   handler:{(action) -> Void in self.deleteItem(did:id)})
           )
           actionSheet.pruneNegativeWidthConstraints()
           self.present(actionSheet,animated:true, completion: nil)
           
       }
       
       func deleteItem(did:String) {
           
           let realm = try! Realm()
           if let object = realm.object(ofType: DrinkRecord.self, forPrimaryKey: did) {
               try! realm.write {
                   realm.delete(object)
                   twoDimArray = loadDataForTable(date: selectedDate)
                   tableview.reloadData()
                   drinkCalendar.reloadData()
               }
           }
       }
    
    //MARK:- Coach
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        //表示するスポットライトの数。チュートリアルの数。
        return hintStr.count
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        //指し示す場所を決める。
        var point:UIView!
        switch index {
        /*
        case 0:
           // point = navigationController?.navigationBar
            point = self.tabBarController?.tabBar.items?[0].value(forKey: "view") as? UIView
            addAnimation(view: point)
        */
        case 0:
            point = drinkCalendar
        case 1:
          point = tableview
        case 2:
            point = tableCellView
        case 3: point = self.tabBarController?.tabBar.items?[1].value(forKey: "view") as? UIView
            addAnimation(view: point)
        default:break
        }
        return coachMarksController.helper.makeCoachMark(for: point)
    }
      
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willShow coachMark: inout CoachMark,
                              beforeChanging change: ConfigurationChange,
                              at index: Int) {
        switch index {
        case 0: coachMark.arrowOrientation = .top
        case 1:coachMark.arrowOrientation = .top
        case 2: coachMark.arrowOrientation = .bottom
        case 3: coachMark.arrowOrientation = .bottom
        case 4: coachMark.arrowOrientation = .bottom
        default:break
        }
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
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didEndShowingBySkipping skipped: Bool) {
    //   self.tabBarController?.selectedIndex = 1
         performSegue(withIdentifier: "moveToChartOnTutor", sender: Any?.self)
    }
    /*
    // MARK: - Review request
    func requestReview() {
        
        if #available(iOS 10.3, *) {
            // iOS 10.3以上の処理
            // Get the current bundle version for the app
            let infoDictionaryKey = kCFBundleVersionKey as String
            guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
                else { fatalError("Expected to find a bundle version in the info dictionary") }
            
            // Has the process been completed several times and the user has not already been prompted for this version?
            if currentVersion != lastVersionPromtedForReviewVar {
                let twoSecondsFromNow = DispatchTime.now() + 2.0
                DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                    SKStoreReviewController.requestReview()
                    
                }
            }
        }
       
        else {
            // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
            //       You can find the App Store ID in your app's product URL
            guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id"+appleid+"?action=write-review")
                else { fatalError("URLが存在しません。") }
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
    */
    
   // MARK: - purchase prompt
    func promptForPurchaseAlert (titleStr:String, msgStr:String, flag:Bool ) {
        
        let alertController = UIAlertController (
            title:titleStr,
            message:msgStr,
            preferredStyle: .actionSheet
        )
        
        if flag {
            alertController.addAction(
                UIAlertAction (
                    title:"今は購入しないで入力へ",
                    style: .default,
                    handler: {action in
                        self.performSegue(withIdentifier: "showDailyDrinkRecord", sender: Any?.self)
                }))
        }
        
        alertController.addAction(
            UIAlertAction (
                title:"キャンセル",
                style: .cancel,
                handler: nil
            )
        )
        
        alertController.addAction(
            UIAlertAction(
                title:"App内課金（購入又は復元）画面へ",
                style:.default,
                handler: {action in
                    self.performSegue(withIdentifier: "showPurchaseFromHome", sender: Any?.self)
            }))
        alertController.pruneNegativeWidthConstraints()
        present(alertController,animated:true, completion:nil)
        
    }
    
  //TODO Ver3.04で付け加えたい。購入ユーザーはスキップできる。
/*
    func AskCoach (titleStr:String, messageStr:String ) {
        let actionSheet = UIAlertController(
            title: titleStr,
            message: messageStr,
            preferredStyle: .alert)
        
        actionSheet.addAction(
            UIAlertAction(
                title:"進む",
                style: .default,
                handler:{(action) -> Void in self.coachMarksController.start(in: .currentWindow(of: self))}))
        if unlocked {
            actionSheet.addAction(
                UIAlertAction(
                    title: "スキップする",
                    style: .cancel,
                    handler:{(action) -> Void in shouldShowCoarch = false
                        let selectDate = Date()
                        self.drinkCalendar.select(selectDate)
                        self.twoDimArray = self.loadDataForTable(date: selectDate)
                        self.tableview.reloadData()
                }
                    ))
        }
        self.present(actionSheet,animated:true, completion: nil)
    }
*/
    
    // MARK: - View Rotation
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        self.tableview.delegate = self

  //     realmのデフォルトのファイル
  //   print(Realm.Configuration.defaultConfiguration.fileURL!)
  
        drinkCalendar.dataSource = self
        drinkCalendar.delegate = self
        
        self.theme = MyThemes.currentTheme()
        self.launguage = cal_language
        self.drinkCalendar.firstWeekday = 1
        self.drinkCalendar.scrollDirection = FSCalendarScrollDirection(rawValue:UInt(cal_direction))!
        
        mySections = sectionTitleArray
        twoDimArray = loadDataForTable(date: Date())
        
        let realm = try! Realm()
        drinkRecord_Results = realm.objects(DrinkRecord.self)
        
        drinkCalendar.reloadData()
     
    }
        
    override func viewWillAppear(_ animated: Bool) {
        self.theme = MyThemes.currentTheme()
        self.launguage = cal_language
        self.tabBarController?.tabBar.isHidden = false
        
        view.theme_backgroundColor = GlobalPicker.barTintColor
        tableview.theme_backgroundColor = GlobalPicker.backgroundColor
        tableview.theme_separatorColor = GlobalPicker.tv_separatorColor
        tableview.theme_sectionIndexBackgroundColor = GlobalPicker.backgroundColor
        tableview.theme_sectionIndexColor = GlobalPicker.tintColor
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.theme_tintColor = GlobalPicker.toolBarButtonColor1
      
        drinkCalendar.reloadData()
        EmptyStateView.theme_backgroundColor = GlobalPicker.emptyStateViewBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var titl:String = ""
        var msg:String  = ""
        
        super.viewDidAppear(animated)
        
        //MARK:-　バージョンの情報
     if !shouldShowCoarch, shouldShowVerInfo  {
        //このバージョンでは特に表示しない。
        /*
        let titl = "Ver."+appVersion!+"の新機能"
        let compButtonTitle = "続ける"
        let detailButtonTitle = "e-ヘルスネット（お酒へ）"
        let detailWebSite = "https://www.e-healthnet.mhlw.go.jp/information/alcohol"
        let msg:[(title:String,subtitle:String,icon:String)] = [("ホーム画面を刷新","🆕表示をタップしても、編集画面に飛べます。","wine"),
            ("🆕通知機能","飲む前に反省を読む。（設定＞通知の設定）","bell"),("🆕休肝日の一発入力","タップするだけで飲酒ゼロを入力","dash"),
            ("他にも多くの改良点","追加・編集できるお酒の種類を増やすなど。\niOS14に対応、全般的により効率的なプログラムに書き換えました。","beer")]
        
        let item = showWhatsNewPlus(titl: titl, compButtonTitle: compButtonTitle, detailButtonTitle:detailButtonTitle,webStr:detailWebSite, msg: msg)
        present(item,animated: true)
         */
        shouldShowVerInfo = false
     }
        
        guard !shouldShowCoarch else {
            switch justFinishedCoachCources {
            case .chart :
                EmptyStateView.isHidden = false
                tableview.isHidden = true
                addAnimation(view: addButton)
                self.present(.okAlert(title:"飲んだお酒を入力します。", message: "まずカレンダーで日付を選び、➕にタッチします。",astyle: .alert, okstr:"進む", okHandler: {(action) -> Void in  self.performSegue(withIdentifier: "showDailyDrinkRecord", sender: Any.self)}))
            case .dataEntry :
                navigationItem.title = dailyDrinkDummy.dDate.mediumStr
                EmptyStateView.isHidden = true
                tableview.isHidden = false
                let SettingTabItem = self.tabBarController?.tabBar.items?[2].value(forKey: "view") as? UIView
                addAnimation(view: SettingTabItem!)
                self.present(.okAlert(title:"🎊ツアーが完了しました。", message: "",astyle: .alert, okstr:"⚙️設定画面へ", okHandler: {(action) -> Void in  //self.performSegue(withIdentifier: "showConfig", sender: Any.self)}))
            
                    self.tabBarController?.selectedIndex = 2}))
            case .none :
                EmptyStateView.isHidden = true
                tableview.isHidden = false
                twoDimArray = tableDataDummy
                tableview.reloadData()

                
                switch userType {
                case .newUser :
                    titl = "⏰90秒クイックツアーを開始"
                    msg = disclaimer
                    self.present(.okAlert(alignment:.left, title:titl, message:msg ,astyle: .alert, okstr:"了解", okHandler: {(action) -> Void in  self.coachMarksController.start(in: .currentWindow(of: self))}))
                case .currentUser:
                    titl = "新Ver."+appVersion!+"の使用ガイドを開始。"
                    msg = "操作画面が一部変更し新規機能も追加されました。\nなお、無料版の保存回数は最大2回に変更されています。\nこれを機会にご購入を是非ご検討ください。"
                    self.present(.okAlert(title:titl, message:msg ,astyle: .alert, okstr:"ツアーを開始(約2分）", okHandler: {(action) -> Void in  self.coachMarksController.start(in: .currentWindow(of: self))}))
                case .purchasedUser:
                    titl = "新Ver."+appVersion!+"の使用ガイドを開始。"
                    msg = "操作画面が一部変更し新規機能も追加されました。。\n少しの間お付き合いください。"
                    self.present(.okAlert(title:titl, message:msg ,astyle: .alert, okstr:"ツアーを開始(約2分）", okHandler: {(action) -> Void in  self.coachMarksController.start(in: .currentWindow(of: self))}))
                }
            }
            return
        }
    }
    //TODO: 後ほど付け加える予定。購入ユーザーはスキップできる。
                    
   /*
                   
                }
                 AskCoach(titleStr:titl, messageStr:msg )
            }
            return
        }
    }
 */
    
// MARK: - Calendar
   /*
    func swapEntryButtons(newData:Bool){
        editButton.isEnabled = !newData
    }
 */
    
    private func loadDataForTable(date: Date)  ->  [[(title: String, desc: String)]]{
        drinkDaily = DrinkDailyRecord(dDate: date)
        let id = (date.toHashStr)
        
        self.navigationItem.title = date.mediumStr
        
        let realm = try! Realm()
        if let object = realm.object(ofType: DrinkRecord.self, forPrimaryKey: id) {
            //             データが存在する
            
            EmptyStateView.isHidden = true
          //  swapEntryButtons(newData: false)
            
            //Section 2 for tableview
             var array_2:tableArray = []
       //     var array_2 = [(title: String, desc: String)]()
            let pastDrinkArray: [(title:eDname,damount:Int)] = [
                (title:eDname.wine, damount:object.wine),
                (title:eDname.nihonsyu, damount:object.nihonsyu) ,
                (title:eDname.beer, damount:object.beer) ,
                (title:eDname.shocyu, damount:object.shocyu) ,
                (title:eDname.whisky, damount:object.whisky) ,
                (title:eDname.can, damount:object.can) ]
            for item in pastDrinkArray { // Parse for segue
                drinkDaily.drinks.updateValue(item.damount, forKey: item.title)
                
                //Section 2 for tableview
                if item.damount > 0 {
                    let t = item.title.ctitle (emoji: emojiSwitch)
                    let record = (title:t, desc:item.damount.decimalStr)
                    array_2.append(record)
                }
            }
            
            // Parse for segue
            drinkDaily.dDate = date
            if !(drinkDaily.TU == object.totalUnits) {
                let realm = try! Realm()
                try! realm.write {
 //                   let value:[String:Any] = ["id":object.dDate!.toHashStr, "totalUnits":drinkDaily.totalAlchool]
                    let value:[String:Any] = ["id":object.dDate!.toHashStr, "totalUnits":drinkDaily.TU]
                    realm.create(DrinkRecord.self, value:value, update: .modified)
                }
            }
            
            //Section 1 for tableview　「ドリンク数」
            deleteButton.isEnabled = true
            editButton.isEnabled = true
            //      let desc:String = ""
          //  let diff = round((object.totalUnits - targetUnit*10)*10)/10
         //   let diff = object.totalUnits*10 - targetUnit*10
         //   let prefix = object.totalUnits == 0 ? "0":String(round(object.totalUnits*10)/10)
     //       print(object.totalUnits)
              let prefix = object.totalUnits == 0 ? "休肝日💖お酒は飲みませんでした！":(object.totalUnits*10.0).decimalStr
        //     let prefix = object.totalUnits == 0 ? "0g":(object.totalUnits).decimalStr            //      let title = drinkDaily.emojiStr + " " + prefix
            let title = drinkDaily.emojiStr
            let desc =  prefix
            let array_1 = [(title: title, desc: desc)]
            
            //Section 0 for tableview 「評価」
            drinkDaily.evaluation = object.evaluation.isEmpty ? "評価未了": object.evaluation
         //   print(drinkDaily)
            if object.comment.isEmpty {
                drinkDaily.comment = "" }
            else if object.comment == "-" {
                drinkDaily.comment = "" }
            else {drinkDaily.comment = object.comment }
            
            let array_0 = [(title: drinkDaily.evaluation, desc: drinkDaily.comment)]
            
            // Parse for segue
            return  [array_0, array_1, array_2]
        }
            // データが無い
        else {
            //Parse for segue
            EmptyStateView.isHidden = false
            deleteButton.isEnabled = false
            editButton.isEnabled = false
        //    swapEntryButtons(newData: true)

            // Section 0 and 1 for table
            //            let title:String = ""
            let desc:String = "無し"
            let array_0 = [(title:"", desc:desc)]
            let array_1 = [(title: "", desc: "0")]
            let array_2 = [(title:"", desc:"0cc")]
            
            return  [array_0,array_1, array_2]            }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        popTip.hide()
        selectedDate = date
        twoDimArray = loadDataForTable(date: date)
        tableview.reloadData()
        
    
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
        let id = date.toHashStr
        let record = drinkRecord_Results.filter("id = %@",id).first
        return record?.totalUnits.dots ?? 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let cal1 = UIColor(hexRGB:GlobalPicker.cal_event1[0])!
        let cal2 = UIColor(hexRGB:GlobalPicker.cal_event2[0])!
        
        return [appearance.eventDefaultColor, cal1, cal2]
    }
    
   // MARK: -  Table Management
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UITableViewHeaderFooterView()
       
        mySections[0] = sectionTitleArray[0]+(targetUnit*10).decimalStr+"と比較"
        
        view.contentView.theme_backgroundColor = GlobalPicker.groupBackground
        view.textLabel?.theme_textColor = GlobalPicker.groupTextColor
        view.textLabel?.text = mySections[section]
        
        return view }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoDimArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = twoDimArray[indexPath.section][indexPath.row].title
        cell.detailTextLabel?.text = twoDimArray[indexPath.section][indexPath.row].desc
        cell.theme_backgroundColor = GlobalPicker.backgroundColor
        
        cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
        
        if indexPath.section == 2, indexPath.row == 0  {tableCellView = cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        processDataEntry()
    }
    
  // MARK: -  Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        switch segue.identifier {
        case "showDailyDrinkRecord":
            let controller = segue.destination as!  DatEntryViewController
            controller.drinkDaily =  shouldShowCoarch ? dailyDrinkDummy :  self.drinkDaily
        default:break
        }
    }
    
    @IBAction func unwindToHomeView(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? EvalViewController {
            let object = sourceViewController.drinkDaily
            let data = DrinkRecord()
            data.id = object.dDate.toHashStr
            data.totalUnits = object.TU
            data.dDate = object.dDate
            data.comment = object.comment
            data.evaluation = object.evaluation
            
            data.wine = object.drinks[eDname.wine] ?? 0
            data.nihonsyu = object.drinks[eDname.nihonsyu] ?? 0
            data.beer = object.drinks[eDname.beer] ?? 0
            data.shocyu = object.drinks[eDname.shocyu] ?? 0
            data.whisky = object.drinks[eDname.whisky] ?? 0
            data.can = object.drinks[eDname.can] ?? 0
            
            if canSave {
                let realm = try! Realm()
                try! realm.write{ realm.add(data,update: .modified)}
                saveTimes += 1
                processCompletedCountVar += 1
            }
            else {
                saveStatus = false
            }
            
            twoDimArray = loadDataForTable(date: object.dDate)
            tableview.reloadData()
            drinkCalendar.reloadData()
        }
            
        else if let sourceViewController = sender.source as? DatEntryViewController {
            let object = sourceViewController.drinkDaily
            let data = DrinkRecord()
            data.id = object.dDate.toHashStr
            data.totalUnits = object.TU
            data.dDate = object.dDate
            data.comment = object.comment
            data.evaluation = object.evaluation
            
            data.wine = object.drinks[eDname.wine] ?? 0
            data.nihonsyu = object.drinks[eDname.nihonsyu] ?? 0
            data.beer = object.drinks[eDname.beer] ?? 0
            data.shocyu = object.drinks[eDname.shocyu] ?? 0
            data.whisky = object.drinks[eDname.whisky] ?? 0
            data.can = object.drinks[eDname.can] ?? 0
            
            if canSave {
                let realm = try! Realm()
                try! realm.write{ realm.add(data,update: .modified)}
                saveTimes += 1
                processCompletedCountVar += 1
            }
            else {
                saveStatus = false
            }
            
            twoDimArray = loadDataForTable(date: object.dDate)
            tableview.reloadData()
            drinkCalendar.reloadData()
        }
            
        else if sender.source is SettingViewController {
            self.theme = MyThemes.currentTheme()
            self.launguage = cal_language
            self.drinkCalendar.scrollDirection = FSCalendarScrollDirection(rawValue:UInt(cal_direction))!
            twoDimArray = loadDataForTable(date: selectedDate)
            tableview.reloadData()
            drinkCalendar.reloadData()
        }
    }
   
   // MARK: -  Appearance
    
    fileprivate var launguage: Int = 0 {
        didSet {
            switch (launguage) {
            case 0: //日本語
                self.drinkCalendar.appearance.headerDateFormat = "YYYY年MM月"
                
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[0].text = "日"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[1].text = "月"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[2].text = "火"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[3].text = "水"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[4].text = "木"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[5].text = "金"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[6].text = "土"
                
                
            case 1: //英語
                self.drinkCalendar.appearance.headerDateFormat = "yyyy-MM"
                
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[0].text = "Sun"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[1].text = "Mon"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[2].text = "Tue"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[3].text = "Wed"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[4].text = "Thu"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[5].text = "Fri"
                self.drinkCalendar.calendarWeekdayView.weekdayLabels[6].text = "Sat"
                
            default:
                break;
            }
        }
    }
    
    
    var theme: MyThemes = MyThemes.currentTheme() {
        didSet {
            let themeIndex:Int = theme.rawValue
            self.drinkCalendar.appearance.weekdayTextColor = UIColor(hexRGB: GlobalPicker.cal_weekdayTextColor[themeIndex])
            self.drinkCalendar.appearance.headerTitleColor = UIColor(hexRGB:GlobalPicker.cal_headerTitleColor[themeIndex])
            self.drinkCalendar.appearance.eventDefaultColor = UIColor(hexRGB:GlobalPicker.cal_eventDefaultColor[themeIndex])
            self.drinkCalendar.appearance.selectionColor = UIColor(hexRGB:GlobalPicker.cal_selectionColor[themeIndex])
            self.drinkCalendar.appearance.todayColor = UIColor(hexRGB:GlobalPicker.cal_todayColor[themeIndex])
            self.drinkCalendar.theme_backgroundColor = GlobalPicker.backgroundColor
             self.drinkCalendar.appearance.titleDefaultColor = UIColor(hexRGB:GlobalPicker.cal_defaultColor[themeIndex])
            
            self.drinkCalendar.appearance.borderRadius = 1.0
            self.drinkCalendar.appearance.headerMinimumDissolvedAlpha = 1.0
           
        }
    }
}
// MARK: - Support night mode

extension HomeViewController {
    
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
            self.theme = MyThemes.currentTheme()
        case .dark:
            MyThemes.before = MyThemes.current
            MyThemes.switchNight(isToNight: true)
            self.theme = MyThemes.currentTheme()
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
}
