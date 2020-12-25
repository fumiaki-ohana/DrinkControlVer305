//
//  MasterViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2018/04/23.
//  Copyright © 2018年 Fumiaki Tsurumi. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var sectionTitle = ["飲んだお酒の量を入力してください。（単位：CC）", "計算結果です。（１ユニット＝設定された1日の適量"]
    var result = [("計算結果",0.0)]
    var standarizedDrink:Double = 1.5
    
    var totalUnits: Double {
        var numU:Double = 0
        for (ditem) in drinkArray {
            let unitN = ditem.unitAm // ドリンクごとの基準量
            let N1:Double = Double(ditem.damount)/Double(unitN)
                numU += N1
            }
        return numU
    }

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        loadIntialValue()
        
        }


    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        self.tableView.reloadData()
        super.viewWillAppear(animated)
        print("appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = drinkArray[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.drink = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else {
            if segue.identifier == "showConfig" {
            let controller = (segue.destination as! UINavigationController).topViewController as! UnitTableViewController
            controller.drink = drinkArray
            controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DetailViewController,
            let changed_drink = sourceViewController.drink {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                drinkArray[selectedIndexPath.row] = changed_drink
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                var sl = selectedIndexPath
                sl.section = 1
                sl.row = 0
                result[0] = ("計算", totalUnits)
                tableView.reloadRows(at: [sl], with: .none)
            }
            else {}
        }
    }
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return drinkArray.count } else
        {return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            let object = drinkArray[indexPath.row]
            cell.textLabel!.text = object.dname.rawValue
            cell.detailTextLabel!.text = object.damount.decimalStr
            
        case 1:
            let object = result[indexPath.row]
            cell.textLabel!.text = object.0
            cell.detailTextLabel!.text = totalUnits.decimalStr + " ユニット"
        default:
           return cell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 1 {
            return nil } else {
            return indexPath }
       
    }
    
    func loadIntialValue() {
        
        var dictDrink:[String:Double] = [:]
     
        if let data = UserDefaults.standard.dictionary(forKey: "data") {
            for d in data {
                    dictDrink[d.key] = d.value as? Double
                    }
            drinkArray = [Drink]()
            print(dictDrink)
            for (key,value) in dictDrink {
                let D = eDname(rawValue: key)
                let Al = value
                let Am = 0
                drinkArray.append(Drink(dname:D!, damount:UInt(Am), unitAl:Al)!)
            }
        }
            else {

                drinkArray = [
                    Drink(dname:eDname.wine, damount: 0, unitAl: dPUnit[eDname.wine]!),
                    Drink(dname:eDname.nihonsyu, damount:0, unitAl:dPUnit[eDname.nihonsyu]!),
                    Drink(dname:eDname.beer,damount:0, unitAl:dPUnit[eDname.beer]!),
                    Drink(dname:eDname.shocyu,damount:0, unitAl:dPUnit[eDname.shocyu]!),
                    Drink(dname:eDname.wisky,damount:0, unitAl:dPUnit[eDname.wisky]!),
                    Drink(dname:eDname.can, damount:0, unitAl:dPUnit[eDname.can]!)
                    ] as! [Drink]
            }
        }
}



