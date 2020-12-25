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
    let drinkBarTitleStr = "ドリンク数表示形式 - "
    let sliderMax = 5.0
    let sliderMin = 0.0
    
    var defaultEmoji = ""
    
    @IBAction func onChangeSlider(_ sender: UISlider) {
        targetUnit = Double(round(sender.value * 10)/10)
        target.text = targetUnit.decimalStr
    }
    
    @IBAction func emojiOnOff(_ sender: UISwitch) {
        emojiSwitch = sender.isOn
        emojiTitle.text = emojiTItleStr + eDname.wine.ctitle(emoji: emojiSwitch)
    }

    @IBOutlet weak var emojiStatus: UISwitch!
    
    private func loadInitialValue() {
        
        defaultEmoji = drinkBarTitleStr + String(repeating:eDname.wine.emoji, count:1) +
            String(repeating:eDname.nihonsyu.emoji, count:1) + String(repeating:eDname.beer.emoji, count:1) + etcStr
        
        target.text = targetUnit.decimalStr
        
        slider.maximumValue = Float(sliderMax)
        slider.minimumValue = Float(sliderMin)
        slider.setValue(Float(targetUnit), animated: true)
        
        emojiStatus.isOn = emojiSwitch
        emojiTitle.text = emojiTItleStr + eDname.wine.ctitle(emoji: emojiSwitch)
        if  drinkSet.dEmojiConfig == drinkSet.item_def {
            drinkBarTitle.text = defaultEmoji }
        else {drinkBarTitle.text = drinkBarTitleStr + String(repeating:drinkSet.dEmojiConfig.rawValue, count:4)+etcStr }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialValue()
        
    }
  
}
