//
//  ConfigureTableViewController.swift
//  CaffeineManager
//
//  Created by 鶴見文明 on 2019/07/04.
//  Copyright © 2019 鶴見文明. All rights reserved.
//

import UIKit
import RealmSwift

class ConfigureTableViewController: UITableViewController {
    
    @IBOutlet weak var target: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var emojiTitle: UILabel!
    
    @IBOutlet weak var drinkBarTitle: UILabel!
    let emojiTItleStr = "絵文字も表示 - "
    let drinkBarTitleStr = "カレンダーでのドリンク数表示形式 "
    
    var defaultEmoji = ""
    
    @IBAction func onChangeSlider(_ sender: UISlider) {
        target.text = Double(sender.value).decimalStr
        targetUnit = floor(Double(sender.value))
    }
    
    @IBAction func emojiOnOff(_ sender: UISwitch) {
        emojiSwitch = sender.isOn
        emojiTitle.text = emojiTItleStr + eDname.wine.ctitle(emoji: emojiSwitch)
    }

    @IBOutlet weak var emojiStatus: UISwitch!
    
    private func loadInitialValue() {
        /*
        defaultEmoji = drinkBarTitleStr + String(repeating:eDname.wine.emoji, count:1) +
        String(repeating:eDname.nihonsyu.emoji, count:1)String(repeating:eDname.beer.emoji, count:1) + etcStr
        */
        target.text = targetUnit.decimalStr
        
        slider.maximumValue = 20
        slider.minimumValue = 0
        
        slider.value = Float(targetUnit)
        
        emojiStatus.isOn = emojiSwitch
        emojiTitle.text = emojiTItleStr + eDname.wine.ctitle(emoji: emojiSwitch)
        drinkBarTitle.text = drinkBarTitleStr
        
        /*
        if  drinkSet.dEmojiConfig == drinkSet.item_def {
            drinkBarTitle.text = defaultEmoji }
        else {drinkBarTitle.text = drinkBarTitleStr + String(repeating:drinkSet.dEmojiConfig.rawValue, count:4)+etcStr }
        */
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialValue()
        
    }
    
  
}
