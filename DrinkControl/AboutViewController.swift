//
//  AboutViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2020/03/13.
//  Copyright © 2020 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import Eureka
import MessageUI
import WebKit


class AboutViewController: FormViewController,MFMailComposeViewControllerDelegate,WKUIDelegate {
    let secHeader0 = "減酒くん"
    let secHeader1 = "サポート"
    
    private func reflectOnEurekaTable() {
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_tintColor = GlobalPicker.tintColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        
        ButtonRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        
        LabelRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        reflectOnEurekaTable()
        navigationItem.leftBarButtonItem?.theme_tintColor = GlobalPicker.naviItemColor
        
        form +++
            //  Mark:- General
            
            Section(secHeader0)
            // ガイドを表示する
            
            <<< ButtonRow() {
                $0.title = "サポート"
                $0.presentationMode = .segueName(segueName: "showTutorSegue", onDismiss:nil )
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            <<< LabelRow () {
                $0.title = "バージョン"
                $0.value = appVersion
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            
            <<< LabelRow () {
                $0.title = "開発"
                $0.value = "OHANA Inc."
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "プライバシーポリシー"
                
            }
            .onCellSelection { [weak self] (cell, row) in
                let pathStr = "https://ohanakk.blogspot.com/p/blog-page_15.html"
                self?.openUrl(path: pathStr)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
            // TODO: Apple IDを記入せよ
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "AppStoreで評価する"
                
            }
            .onCellSelection { (cell, row) in
                guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id"+appleid+"?action=write-review")
                    else { fatalError("URLが存在しません") }
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
    }
  /*
    @IBAction func showAlert() {
        let aboutMessage = "お酒を健康的に楽しむことをお手伝い"
        let title = " ver1.0　開発（株）OHANA Inc."
        present(.okAlert(title: title, message: aboutMessage))
        /*
         let alertController = UIAlertController(title: title, message: aboutMessage, preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
         alertController.addAction(defaultAction)
         present(alertController, animated: true)
         */
    }
    */
    @IBAction func openUrl(path:String) {
       
               let urlPath = URL(string: path)
               UIApplication.shared.open(urlPath!, options: [:], completionHandler: nil)
           }
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonIte
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
