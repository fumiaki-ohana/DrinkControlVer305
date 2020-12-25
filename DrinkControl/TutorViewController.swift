//
//  TutorViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2020/04/14.
//  Copyright © 2020 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import Eureka
import MessageUI

class TutorViewController: FormViewController,MFMailComposeViewControllerDelegate {
    
    private func reflectOnEurekaTable() {
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        
        ButtonRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //     MyThemes.restoreLastTheme()
        reflectOnEurekaTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        reflectOnEurekaTable()
        navigationItem.leftBarButtonItem?.theme_tintColor = GlobalPicker.naviItemColor
        
        form +++
            //  Mark:- General
            
            Section("飲酒に関する参考情報（外部サイト）")
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "アプリ内での用語を説明"
                
            }
            .onCellSelection { [weak self] (cell, row) in
                let pathStr = "https://ohanakk.blogspot.com/p/blog-page_83.html"
                self?.openUrl(path: pathStr)
            }
            .cellUpdate() {cell, row in
                           cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                           cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                       }
            
            /*
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "（参考）12の飲酒ルール"
            }
                
            .onCellSelection { [weak self] (cell, row) in
                let pathStr = "https://ohanakk.blogspot.com/p/12.html"
                self?.openUrl(path: pathStr)
            }
            .cellUpdate() {cell, row in
                           cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                           cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                       }
            */
            +++ Section("使用方法（外部サイト）")
            
      /*
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "機能の紹介"
                row.presentationMode = .segueName(segueName: "showTutorFromTutorSegue", onDismiss: nil)
            }
            .cellUpdate() {cell, row in
                           cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                           cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                       }
     */
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "詳しい使用方法"
                
            }
            .onCellSelection { (cell, row) in
                let pathStr = "https://ohanakk.blogspot.com/p/blog-page_13.html"
                self.openUrl(path: pathStr)
            }
            .cellUpdate() {cell, row in
                           cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                           cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                       }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "サポートサイト"
                
            }
            .onCellSelection { (cell, row) in
                let pathStr = "https://ohanakk.blogspot.com"
                self.openUrl(path: pathStr)
            }
            .cellUpdate() {cell, row in
                           cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                           cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                       }
            +++ Section("問合せ")
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "メールクライアントを起動"
                
            }
            .onCellSelection { [weak self] (cell, row) in
                self?.sendMail()
            }
            .cellUpdate() {cell, row in
                           cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                           cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                       }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "サポートサイトから入力"
                
            }
            .onCellSelection { [weak self] (cell, row) in
                let pathStr = "https://ohanakk.blogspot.com/p/blog-page_29.html"
                self?.openUrl(path: pathStr)
        }
        .cellUpdate() {cell, row in
                       cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                       cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
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
    @IBAction func openUrl(path:String) {
        let urlPath = URL(string: path)
        UIApplication.shared.open(urlPath!, options: [:], completionHandler: nil)
    }
    
    @IBAction func sendMail() {
        var messageStr = "デバイスの環境\n"
        let user_device = UIDevice()
        let user_env = [ "デバイス":user_device.name,
                         "モデル":user_device.model,
                         "システム":user_device.systemName,
                         "バージョン：":user_device.systemVersion
        ]
        for i in user_env {
            messageStr += i.key + ":"+i.value+"\n"
        }
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["camellia@dear-ohana.com"]) // 宛先アドレス
            mail.setSubject("お問い合わせ") // 件名
            mail.setMessageBody("【ここにメッセージ本文を入力して下さい。】"+"\n"+messageStr, isHTML: false) // 本文
            present(mail, animated: true, completion: nil)
        } else {
            present(.okAlert(title: nil, message: "送信できません"))
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            break
        case .saved:
            present(.okAlert(title: nil, message: "下書き保存"))
        case .sent:
            present(.okAlert(title: "ご協力ありがとうございました。", message: "送信成功"))
        default:
            present(.okAlert(title: nil, message: "送信できません"))
        }
        dismiss(animated: true, completion: nil)
    }
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
