//
//  TableViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2018/04/26.
//  Copyright © 2018年 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
//import SwiftIconFont

class UnitTableViewController: UITableViewController {
    var UnitDetailViewController: UnitDetailViewController? = nil
    
    var objects = [Any]()
    var sectionTitle = ["お酒ごと基準飲酒量（1ドリンク：純アルコール量10g）を設定。", "合計飲酒量の上限目標を、ドリンク数で設定。"]
    let section1 = ["ドリンク数(基準飲酒量)"]
  
    var drinksUT = [Drink]()
    
    var targetUT:Double = 0.0
    
    @IBOutlet weak var helpButton: UIBarButtonItem!
   /*
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion:nil)
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
//        helpButton.icon(from: .fontAwesome, code: "question", ofSize:30.0)
        helpButton.tintColor = UIColor.red
        drinksUT = drinks
        targetUT = targetUnit
//        navigationItem.backBarButtonItem?.icon(from: .fontAwesome, code: "cog", ofSize:22.0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        /*
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        */
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return drinksUT.count
        case 1:
            return section1.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnitCell", for: indexPath)
    
        var strArray = [String]()
        for d in drinksUT{
            strArray.append(d.unitAl.percentStr)
        }
        
        switch indexPath.section {
        case 0:
            let object = drinksUT[indexPath.row]
            cell.textLabel!.text = object.dname.rawValue + " " + object.unitAm.decimalStr
            cell.detailTextLabel!.text =  object.unitAl.percentStr
            cell.detailTextLabel!.textColor = defaultTint
            cell.accessoryType = .disclosureIndicator
            
        case 1:
            cell.textLabel!.text = section1[0]
            cell.detailTextLabel!.text = targetUT.decimalStr
            cell.accessoryType = .disclosureIndicator
        default:
            return cell
        }
        return cell
    }
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.section {
            case 0 :
                performSegue(withIdentifier: "showUnitDetail", sender: indexPath)
            case 1 :
                performSegue(withIdentifier: "showTarget", sender: self)
    
            default: break
                
            }
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showUnitDetail":
                let indexPath = sender as! IndexPath
                let object = drinksUT[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! UnitDetailViewController
                controller.drinkUD = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
        case "showTarget":
                let object = targetUT
                let controller = (segue.destination as! UINavigationController).topViewController as! TargetViewController
                    controller.targetTV = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
        default: targetUnit = targetUT
           
         }
    }
    @IBAction func unwindToUnitList(sender: UIStoryboardSegue) {
       
        if let sourceViewController = sender.source as? UnitDetailViewController {
            let changed_drink = sourceViewController.drinkUD
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                drinksUT[selectedIndexPath.row] = changed_drink!
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                dictDrink = Drink.gen_dict_dname_unitAl(darray: drinksUT)
                drinks = drinksUT
            }
        }
            else {
                if let sourceViewContoller = sender.source as? TargetViewController {
                    targetUT = sourceViewContoller.targetTV
                    targetUnit = targetUT
                }
            }
        }
    
    /* 左づめでスペースを入れて文字列を均等にする。
    private func leftedStr(strAr:[String],num:Double)->String {
            let maxstr = strAr.max(by: {$1.count > $0.count})?.count
            let diff = maxstr! - num.percentStr.count
            let result = num.percentStr + String(repeating:" ", count:diff)
            return result
        }
*/
    }

