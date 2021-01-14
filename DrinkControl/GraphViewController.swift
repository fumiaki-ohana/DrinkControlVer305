//
//  GraphViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2021/01/13.
//  Copyright © 2021 OHANA Inc. All rights reserved.
//

import UIKit
import Eureka

class GraphViewController: FormViewController {

   //MARK:- Eureka Management
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }

    private func reflectOnEurekaTable() {
        
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        
        ButtonRow.defaultCellSetup = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.backgroundColor
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
    }
    
    //MARK:- View Rotation
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reflectOnEurekaTable()
   
        //MARK:- Eureka
        
        form +++
            Section("グラフの種類") //一般
            
            <<< ButtonRow() {
                $0.title = "飲んだお酒の量"
                $0.presentationMode = .segueName(segueName: "showChart1", onDismiss: nil)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
        
            <<< ButtonRow() {
                $0.title = "休館日と飲みすぎの日"
                $0.presentationMode = .segueName(segueName: "showChart2", onDismiss: nil)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
        
            <<< ButtonRow() {
                $0.title = "飲んだ後の反省"
                $0.presentationMode = .segueName(segueName: "showChart3", onDismiss: nil)
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
        
        // Do any additional setup after loading the view.
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
