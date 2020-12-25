//
//  DrinkTableViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/09/19.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import RealmSwift

class DrinkTableViewController: UITableViewController {
    var defaultEmoji = ""
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkSet.drinkSetTableRef.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = drinkSet.drinkSetTableArray[indexPath.row].name
            cell.detailTextLabel?.text = drinkSet.drinkSetTableArray[indexPath.row].emoji
            cell.accessoryType = (indexPath.row == (drinkSet.drinkSetTableRef.index(of:drinkSet.dEmojiConfig) ) ) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        drinkSet.dEmojiConfig = drinkSet.drinkSetTableRef[indexPath.row]
        tableView.reloadSections([indexPath.section] as IndexSet, with: .none)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ドリンク数の表示"
        self.navigationItem.prompt = "お好きな絵文字を選択してください"
        defaultEmoji = String(repeating:eDname.wine.emoji, count:2) +
            String(repeating:eDname.nihonsyu.emoji, count:1) + String(repeating:eDname.beer.emoji, count:1) + etcStr
        
        
    }
    
}
