//
//  TableViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2018/10/30.
//  Copyright © 2018 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    var objects : Results<DrinkRecord>!
    var detailViewController: MasterViewController? = nil
  
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        
        // Migration of the Realm Database
       // let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//        let config = Realm.Configuration(schemaVersion: 1)
//        Realm.Configuration.defaultConfiguration = config
        // 永続化されているデータを取りだす
        
        do{
            let realm = try Realm()
            objects = realm.objects(DrinkRecord.self)
            .sorted(byKeyPath: "id",ascending: false)
            tableView.reloadData()
        }catch{
        }
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPastRecords" {
                if let indexPath = tableView.indexPathForSelectedRow {
                let object  = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! PastRecordsTableViewController
                    controller.pastRecord = object
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    @IBAction func unwindToMail(sender: UIStoryboardSegue) {
        
        if sender.source is MasterViewController {
            if  (entryDate != nil) {
                let newDrinkData = DrinkRecord()
                newDrinkData.dDate = entryDate
                newDrinkData.totalUnits = numOfUnits
                newDrinkData.id = (entryDate?.toHashStr)!
                
                for item in drinks {
                    switch item.dname {
                        case eDname.wine: newDrinkData.wine = item.damount
                        case eDname.nihonsyu: newDrinkData.nihonsyu = item.damount
                        case eDname.beer: newDrinkData.beer = item.damount
                        case eDname.shocyu: newDrinkData.shocyu = item.damount
                        case eDname.wisky: newDrinkData.wisky = item.damount
                        case eDname.can: newDrinkData.can = item.damount
                    }
                }
                
                let realm = try! Realm()
                try! realm.write{ realm.add(newDrinkData,update:true)}
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let item = objects {
            return objects.count }
        else {return 0}
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let object = objects[indexPath.row]
      let diff = round((object.totalUnits - targetUnit)*10)/10
        
        //        Cellの表示
        /*
        let excellent = "\u{1F496}"
        let good = "\u{2713}"
        let bad = "\u{2718}"
        let tooBad = "\u{2620}"
         let assesStr = [excellent,good,bad,tooBad]
         */
        
        let prefix = object.totalUnits == 0 ? "0":String(round(object.totalUnits*10)/10)
        cell.textLabel?.text = (object.dDate?.mediumStr)!
        cell.detailTextLabel?.text = object.totalUnits.returnBlock + " " + prefix
        cell.detailTextLabel?.textColor = (diff>1) ? UIColor.red:UIColor.black
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let deletedObject = objects[indexPath.row]
            let realm = try! Realm()
            try! realm.write{ realm.delete(deletedObject)}
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
}
