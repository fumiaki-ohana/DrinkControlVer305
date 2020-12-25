//
//  PastRecordsTableViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/03/10.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit

class PastRecordsTableViewController: UITableViewController {

    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    // Mark: - Properties
    let viewTitle = "過去のレコード"
    let numOfDrinkType = 6
    var sectionTitle:[String] = ["日付", "1ドリンク = アルコール約10グラム相当", "飲酒量"]
    var pastRecord = DrinkRecord()
    var pastDrinkArray:[(name:eDname,damount:Int)] = []
    

    func createDrinkArray() {
        pastDrinkArray.append((name: eDname.wine, damount:pastRecord.wine))
        pastDrinkArray.append((name: eDname.nihonsyu, damount:pastRecord.nihonsyu))
        pastDrinkArray.append((name: eDname.beer, damount:pastRecord.beer))
        pastDrinkArray.append((name: eDname.shocyu, damount:pastRecord.shocyu))
        pastDrinkArray.append((name: eDname.wisky, damount:pastRecord.wisky))
        pastDrinkArray.append((name: eDname.can, damount:pastRecord.can))
        
        pastDrinkArray.sort{ (A,B) -> Bool in
            return A.name.rawValue < B.name.rawValue }
        }
    
 
    // Mark: - Initialize
    override func viewDidLoad() {
        createDrinkArray()
        self.navigationItem.title = viewTitle
        super.viewDidLoad()
        if (pastRecord.totalUnits > 0.0) {
            if (pastRecord.wine == 0) && (pastRecord.nihonsyu == 0) && (pastRecord.beer == 0) && (pastRecord.shocyu == 0) && (pastRecord.wisky == 0) && (pastRecord.can == 0){
                showAlert()}
            }
        }
    
    private func showAlert() {
        let alert = UIAlertController(title:nil, message:nil, preferredStyle:.alert)
        alert.title = "旧バージョンでの入力データ"
        alert.message = "個別飲酒量はゼロで表示"
        alert.addAction(UIAlertAction (
            title: "了解",
            style: .default,
            handler: nil)
        )
        self.present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  section == 2 {
            return pastDrinkArray.count }
        else {
            return 1
            }
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.none
        
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = ""
            cell.detailTextLabel?.text = pastRecord.dDate?.mediumStr
        case 1:
            let prefix = pastRecord.totalUnits == 0 ? "0":String(round(pastRecord.totalUnits*10)/10)
            let diff = round((pastRecord.totalUnits - targetUnit)*10)/10
            cell.textLabel!.text = "ドリンク数"
            cell.detailTextLabel?.text = pastRecord.totalUnits.returnBlock + " " + prefix
            cell.detailTextLabel?.textColor = (diff>1) ? UIColor.red:UIColor.black
        case 2:
            let object = pastDrinkArray[indexPath.row]
            cell.textLabel!.text = object.name.rawValue
            cell.detailTextLabel!.text = object.damount.decimalStr
        default:
            return cell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

}
