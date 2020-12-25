//
//  ConfigureTableViewController.swift
//  CaffeineManager
//
//  Created by 鶴見文明 on 2019/07/04.
//  Copyright © 2019 鶴見文明. All rights reserved.
//

import UIKit
import RealmSwift

class CalenderTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        switch indexPath.section {
        case 0:
            cell.accessoryType = (indexPath.row ==   (calConfig[calSet.firstWeekDay]!-1)) ? .checkmark : .none
        case 1:
            cell.accessoryType = (indexPath.row == (calConfig[calSet.scrollDir]!) ) ? .checkmark : .none
        case 2:
           cell.accessoryType = calConfig[calSet.theme] == indexPath.row ? .checkmark :
                .none
        case 3:
            cell.accessoryType = calConfig[calSet.language] == indexPath.row ? .checkmark :
            .none
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        //        case 0:
        
        case 0:
            calConfig[calSet.firstWeekDay] = indexPath.row+1
        case 1:
            calConfig[calSet.scrollDir] = (indexPath.row)
       case 2:
            calConfig[calSet.theme] = indexPath.row
        case 3:
            calConfig[calSet.language] = indexPath.row
        default:
            break
        }
        tableView.reloadSections([indexPath.section] as IndexSet, with: .none)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "カレンダー詳細"
        self.navigationItem.prompt = "ホーム画面の表示方法を設定します。"
       
    }
  
}
