//
//  NotificationViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/12/08.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Eureka
import UserNotifications

class NotificationViewController: FormViewController{
    
    var NotSuspendNotification:Bool = true
    //左上の閉じるボタンである
    @IBAction func NoticeBtonTapped(_ sender: UIBarButtonItem) {
        if NotSuspendNotification {
        // 通知を管理するクラスのシングルトンを取得
        let center = UNUserNotificationCenter.current()
        // 通知を許可するリクエストを表示する（すでに許可するしないの画面が出ていれば表示されずに中の処理がすぐに処理される）
        center.requestAuthorization(options: [.alert, .sound],completionHandler: { granted, error in
            // エラーチェック
            if error != nil {
               DispatchQueue.main.sync {
                    // code...
                    // エラーを表示
                    self.present(.okAlert(title: "通知は未設定", message: "設定＞通知で確認ください。",okHandler: {(action) -> Void in
                        self.navigationController?.popViewController(animated: true)}))
                }
            }
            // 許可する・しないの結果によって処理を変える
            if granted {
                // 予定されている全ての通知の設定を削除してから通知の設定を行う
                center.removeAllPendingNotificationRequests()
                
                // 通知の内容を設定 ======
                let content = UNMutableNotificationContent()
                
                // 通知のタイトル
                content.title = "お酒を飲む前に"
                
                // 通知のサブタイトル（iOS10から使用可能）
                content.subtitle = "反省を読み返す時間です！"
                
                // 通知の本文
                content.body = "前回お酒を飲んだ後に、あなたが何を考え、反省し、誓ったかを読み返してみましょう。"
                // 通知音の設定
                content.sound = UNNotificationSound.default
                // =====
                // カレンダーのインスタンスを生成
                let calendar = Calendar.current
                
                // 日付や時間をを数値で取得できるDateComponentsを作成
                // 今回はdatePickerで設定した時間を基に時間、分のみを取得
                let dateComponents = calendar.dateComponents([.hour, .minute], from: reviewReadNotifyTime)
                
                // どの時間で通知をするかを設定するか、繰り返し通知するかの設定
                // dateComponentsで設定した時間で通知。今回は繰り返し通知を行うので、repeatsはtrue
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,repeats: true)
                
                // 通知の識別子を設定
                let identifier = "NewsNotification"
                
                // 通知の内容と時間を基にリクエストを作成
                let request = UNNotificationRequest(identifier:identifier,
                                                    content:content,
                                                    trigger:trigger)
                
                // 通知を設定する
                center.add(request, withCompletionHandler:{ _ in
                    DispatchQueue.main.sync {
                        // code...
                        // 通知の設定が完了した旨の表示を行う
                        self.present(.okAlert(title: "通知を設定", message: "指定時刻に通知を設定しました。",okHandler: {(action) -> Void in
                 //           self.buttonPendingList()
                            self.navigationController?.popViewController(animated: true)}))
                    }
                })
            }
        })
    }
        else {
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     buttonPendingList() // MARK:- Debug
        self.tabBarController?.tabBar.isHidden = true
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        
        let hStrSwitch = "オフにすると通知を一時停止します。"
        let fStrSwitch = "アプリの通知機能自体を無効にしたい場合は、iOSでの設定＞通知で減酒くんをオフにしてください"
        let hStr = "通知したい時間"
        let fStr = "お酒を飲む前に、前回の反省を読み返しましょう。\nアプリを使っていない時に、指定した時間になったら通知します。\n\n⚠️iOSの設定＞通知で、減酒くんがオフになっている場合は通知をしません。"
        
        TimeRow.defaultCellSetup = { cell, row in
        cell.theme_backgroundColor = GlobalPicker.backgroundColor
        cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor}
        
        SwitchRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor}
        
        form +++
            Section(header:hStrSwitch, footer:fStrSwitch)
            
            <<< SwitchRow() {
                $0.title = "通知する"
                $0.value = NotSuspendNotification
                $0.tag = "Show Next Section"
            }
            .onChange {
                if $0.value == false {
                    // 予定されている通知を解除する
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        //            self.buttonPendingList()//MARK:- デバッグ用
                    self.NotSuspendNotification = false
                    // 通知を解除した旨の表示を行う
                    self.present(.okAlert(title: "通知を一時停止", message: "設定済みの通知をいったん削除しました。"))
                }
                else {self.NotSuspendNotification = true}
            }
            
            .cellUpdate() {cell, row in
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            
            +++ Section(header:hStr,footer: fStr){
            
                       $0.hidden = .function(["Show Next Section"], { form -> Bool in
                        let row: RowOf<Bool>! = form.rowBy(tag: "Show Next Section")
                               return row.value ?? false == false
                       })
                   }
            
            <<< TimeRow() {
                $0.title = "読み返す時間"
                $0.value = reviewReadNotifyTime
            }
            .onChange {
                reviewReadNotifyTime =  $0.value ?? Date()
            }
                
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        
        // Do any additional setup after loading the view.
        
    }
//MARK:- Debug
    /*
    func buttonPendingList() {
        print("<Pending request identifiers>")

        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("identifier:\(request.identifier)")
                print("  title:\(request.content.title)")

                if request.trigger is UNCalendarNotificationTrigger {
                    let trigger = request.trigger as! UNCalendarNotificationTrigger
                    print("  <CalendarNotification>")
                    let components = DateComponents(calendar: Calendar.current, year: trigger.dateComponents.year, month: trigger.dateComponents.month, day: trigger.dateComponents.day, hour: trigger.dateComponents.hour, minute: trigger.dateComponents.minute)
                    print("    Scheduled Date:"+components.date!.timeStr)
                    print("    Reports:\(trigger.repeats)")
                    
                } else if request.trigger is UNTimeIntervalNotificationTrigger {
                    let trigger = request.trigger as! UNTimeIntervalNotificationTrigger
                    print("  <TimeIntervalNotification>")
                    print("    TimeInterval:\(trigger.timeInterval)")
                    print("    Reports:\(trigger.repeats)")
                }
                print("----------------")
            }
        }
    }
 */
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

