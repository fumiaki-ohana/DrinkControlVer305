//
//  ConfigureViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/11/22.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import Eureka

class ConfigureViewController: FormViewController {
    let secHeader1 = "カレンダー"
    let secHeader2 = "お酒"
    let emoji = entryFormPara(tag: "お酒の絵文字を表示")
    var emojiStrPara = entryFormPara(
        tag:"グラフの絵文字",
        selectorTitle: "ドリンク数の表示方法",
        cancelTitle: "取りやめ"
        )
    var emojiStrDic = [String:String] ()
    
    let maxTotalUnit:Double = 20.0
    let minTotalUnit:Double = 0.0
    let maxAlchool:Double = 70.0
    let minAlchool:Double = 1.0
    let maxLimit:Double = 5000
    
    func reversedEmojiStr(emoji:drinkSet) -> String {
        switch emoji {
            case .item_def: return optionEmojiStr[0]+String(repeating:drinkSet.item_def.rawValue, count: 3)
            case .item_plain: return optionEmojiStr[1]+String(repeating:drinkSet.item_plain.rawValue, count: 3)
            case .item_alert: return optionEmojiStr[2]+String(repeating:drinkSet.item_alert.rawValue, count: 3)
            case .item_cross: return optionEmojiStr[3]+String(repeating:drinkSet.item_cross.rawValue, count: 3)
            case .item_sos: return optionEmojiStr[4]+String(repeating:drinkSet.item_sos.rawValue, count: 3)
            case .item_scul: return optionEmojiStr[5]+String(repeating:drinkSet.item_scul.rawValue, count: 3)
        default: return optionEmojiStr[6]+""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        emojiStrPara.options  = [
        optionEmojiStr[0]+String(repeating:drinkSet.item_def.rawValue, count: 3),
        optionEmojiStr[1]+String(repeating:drinkSet.item_plain.rawValue, count: 3),
        optionEmojiStr[2]+String(repeating:drinkSet.item_alert.rawValue, count: 3),
        optionEmojiStr[3]+String(repeating:drinkSet.item_cross.rawValue, count: 3),
        optionEmojiStr[4]+String(repeating:drinkSet.item_sos.rawValue, count: 3),
        optionEmojiStr[5]+String(repeating:drinkSet.item_scul.rawValue, count: 3),
        optionEmojiStr[6]+"" ]
   
        for (index, item) in emojiStrPara.options.enumerated() {
            emojiStrDic[item] = drinkSetChar[index]
        }
        // Do any additional setup after loading the view.
        
form +++
        
  // Mark: - Calender
        
    Section(secHeader1)

    <<< ActionSheetRow<String>() {
//        $0.tag = calSet.firstWeekDay.tag
        $0.title = calSet.firstWeekDay.tag
        $0.selectorTitle = calSet.firstWeekDay.selectorTitle
        $0.options = calSet.firstWeekDay.options
        $0.value = calSet.firstWeekDay.options[calConfig[calSet.firstWeekDay]!]
        }
        .onChange{
        calConfig[calSet.firstWeekDay] = ConstFirstWeekDay.index(of: $0.value!)
        }
        .onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }
        
      <<< ActionSheetRow<String>() {
//        $0.tag = calSet.scrollDir.tag
        $0.title = calSet.scrollDir.tag
        $0.selectorTitle = calSet.scrollDir.selectorTitle
        $0.options = calSet.scrollDir.options
        $0.value =  calSet.scrollDir.options[calConfig[calSet.scrollDir]!]
       }
        .onChange{
            calConfig[calSet.scrollDir
            ] = ConstScrollDir.index(of: $0.value!)
        }
        
        .onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }
        
        <<< ActionSheetRow<String>() {
//        $0.tag = calSet.theme.tag
        $0.title = calSet.theme.tag
        $0.selectorTitle = calSet.theme.selectorTitle
        $0.options = calSet.theme.options
        $0.value = calSet.theme.options[calConfig[calSet.theme]!]
        }
        .onChange{
            calConfig[calSet.theme
            ] = ConstTheme.index(of: $0.value!)
        }
        .onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }
        <<< ActionSheetRow<String>() {
//        $0.tag = calSet.language.tag
        $0.title = calSet.language.tag
        $0.selectorTitle = calSet.language.selectorTitle
        $0.options = calSet.language.options
        $0.value = calSet.language.options[calConfig[calSet.language]!]
       }
          
        .onChange{
            calConfig[calSet.language
                   ] = ConstLanguage.index(of: $0.value!)
               }
           
        .onPresent { from, to in
            to.popoverPresentationController?.permittedArrowDirections = .up
        }
        
        <<< SwitchRow() {
                        $0.title = emoji.tag
                        $0.value = emojiSwitch
                   }
        .onChange{
            emojiSwitch = $0.value!
           }
        
        <<< AlertRow<String>() {
            $0.title = emojiStrPara.tag
            $0.cancelTitle = emojiStrPara.cancelTitle
            $0.selectorTitle = emojiStrPara.selectorTitle
            $0.options = emojiStrPara.options
            $0.value = reversedEmojiStr(emoji: drinkSet.dEmojiConfig)
            
        }.onChange {
            let v = self.emojiStrDic[$0.value!]
            drinkSet.dEmojiConfig = drinkSet(rawValue: v!)!
        }
        .onPresent{ _, to in
            to.view.tintColor = .purple
        }
        +++ Section(secHeader2)
        
        <<< StepperRow() {
            $0.cell.stepper.isContinuous = false
            $0.cell.stepper.maximumValue = maxTotalUnit
            $0.cell.stepper.minimumValue = minTotalUnit
            $0.title = "1日のドリンク数上限"
            $0.value = targetUnit
            $0.displayValueFor = {
                guard let v = $0 else {return "0"}
                return "\(Int(v))"
            }
        }
        .onChange {
            targetUnit = floor(Double($0.value!))
        }
    
        <<< SegmentedRow<String>("segments"){
            $0.options = ["アルコール濃度", "上限"]
            $0.value = "アルコール濃度"
        }
        +++ Section(){
            $0.tag = "アルコール濃度"
            $0.hidden = "$segments != 'アルコール濃度'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
        }
        
        <<< StepperRow() {
            $0.cell.stepper.stepValue = 1
            $0.cell.stepper.maximumValue = maxAlchool
            $0.cell.stepper.minimumValue = minAlchool
            $0.displayValueFor = {
                guard let v = $0 else {return "0"}
                return "\(Int(v))"+"%"
            }
            $0.title = eDname.wine.rawValue
            $0.value = eDname.alc_dic[eDname.wine]!
        }
        .onChange {
            let v = floor(Double($0.value!))
            eDname.alc_dic[eDname.wine] = v
        }
    
        <<< StepperRow() {
            $0.cell.stepper.stepValue = 1
           $0.cell.stepper.maximumValue = maxAlchool
            $0.cell.stepper.minimumValue = minAlchool
            $0.displayValueFor = {
                guard let v = $0 else {return "0"}
                return "\(Int(v))"+"%"
            }
            $0.title = eDname.nihonsyu.rawValue
            $0.value = eDname.alc_dic[eDname.nihonsyu]!
        }
        .onChange {
            let v = floor(Double($0.value!))
            eDname.alc_dic[eDname.nihonsyu] = v
        }
    
    <<< StepperRow() {
        $0.cell.stepper.stepValue = 1
       $0.cell.stepper.maximumValue = maxAlchool
        $0.cell.stepper.minimumValue = minAlchool
        $0.displayValueFor = {
            guard let v = $0 else {return "0"}
            return "\(Int(v))"+"%"
        }
        $0.title = eDname.beer.rawValue
        $0.value = eDname.alc_dic[eDname.beer]!
    }
    .onChange {
        let v = floor(Double($0.value!))
        eDname.alc_dic[eDname.beer] = v
    }
    
    <<< StepperRow() {
        $0.cell.stepper.stepValue = 1
       $0.cell.stepper.maximumValue = maxAlchool
        $0.cell.stepper.minimumValue = minAlchool
        $0.displayValueFor = {
            guard let v = $0 else {return "0"}
            return "\(Int(v))"+"%"
        }
        $0.title = eDname.shocyu.rawValue
        $0.value = eDname.alc_dic[eDname.shocyu]!
    }
    .onChange {
        let v = floor(Double($0.value!))
        eDname.alc_dic[eDname.shocyu] = v
    }
    
    <<< StepperRow() {
        $0.cell.stepper.stepValue = 1
      $0.cell.stepper.maximumValue = maxAlchool
        $0.cell.stepper.minimumValue = minAlchool
        $0.displayValueFor = {
            guard let v = $0 else {return "0"}
            return "\(Int(v))"+"%"
        }
        $0.title = eDname.wisky.rawValue
        $0.value = eDname.alc_dic[eDname.wisky]!
    }
    .onChange {
        let v = floor(Double($0.value!))
        eDname.alc_dic[eDname.wisky] = v
    }
    
    <<< StepperRow() {
        $0.cell.stepper.stepValue = 1
      $0.cell.stepper.maximumValue = maxAlchool
        $0.cell.stepper.minimumValue = minAlchool
        $0.displayValueFor = {
            guard let v = $0 else {return "0"}
            return "\(Int(v))"+"%"
        }
        $0.title = eDname.can.rawValue
        $0.value = eDname.alc_dic[eDname.can]!
    }
    .onChange {
        let v = floor(Double($0.value!))
        eDname.alc_dic[eDname.can] = v
    }
        
        +++ Section(){
            $0.tag = "上限"
            $0.hidden = "$segments != '上限'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
        }
        
          <<< StepperRow() {
                  $0.cell.stepper.stepValue = 25
                  $0.cell.stepper.minimumValue = 25
                  $0.cell.stepper.maximumValue = maxLimit
                  $0.displayValueFor = {
                      guard let v = $0 else {return "0"}
                      return "\(Int(v))"+"cc"
                  }
                  $0.title = eDname.wine.rawValue
                  $0.value = eDname.alc_limit[eDname.wine]!
              }
              .onChange {
                  let v = floor(Double($0.value!))
                  eDname.alc_limit[eDname.wine] = v
              }
          
              <<< StepperRow() {
                  $0.cell.stepper.stepValue = 25
                  $0.cell.stepper.minimumValue = 25
                $0.cell.stepper.maximumValue = maxLimit
                  $0.displayValueFor = {
                      guard let v = $0 else {return "0"}
                      return "\(Int(v))"+"cc"
                  }
                  $0.title = eDname.nihonsyu.rawValue
                  $0.value = eDname.alc_limit[eDname.nihonsyu]!
              }
              .onChange {
                  let v = floor(Double($0.value!))
                  eDname.alc_limit[eDname.nihonsyu] = v
              }
          
          <<< StepperRow() {
              $0.cell.stepper.stepValue = 25
              $0.cell.stepper.minimumValue = 25
            $0.cell.stepper.maximumValue = maxLimit
              $0.displayValueFor = {
                  guard let v = $0 else {return "0"}
                  return "\(Int(v))"+"cc"
              }
              $0.title = eDname.beer.rawValue
              $0.value = eDname.alc_limit[eDname.beer]!
          }
          .onChange {
              let v = floor(Double($0.value!))
              eDname.alc_limit[eDname.beer] = v
          }
          
          <<< StepperRow() {
              $0.cell.stepper.stepValue = 25
              $0.cell.stepper.minimumValue = 25
            $0.cell.stepper.maximumValue = maxLimit
              $0.displayValueFor = {
                  guard let v = $0 else {return "0"}
                  return "\(Int(v))"+"cc"
              }
              $0.title = eDname.shocyu.rawValue
              $0.value = eDname.alc_limit[eDname.shocyu]!
          }
          .onChange {
              let v = floor(Double($0.value!))
              eDname.alc_limit[eDname.shocyu] = v
          }
          
          <<< StepperRow() {
              $0.cell.stepper.stepValue = 25
              $0.cell.stepper.minimumValue = 25
            $0.cell.stepper.maximumValue = maxLimit
              $0.displayValueFor = {
                  guard let v = $0 else {return "0"}
                  return "\(Int(v))"+"cc"
              }
              $0.title = eDname.wisky.rawValue
              $0.value = eDname.alc_limit[eDname.wisky]!
          }
          .onChange {
              let v = floor(Double($0.value!))
              eDname.alc_limit[eDname.wisky] = v
          }
          
          <<< StepperRow() {
              $0.cell.stepper.stepValue = 25
              $0.cell.stepper.minimumValue = 25
            $0.cell.stepper.maximumValue = maxLimit
              $0.displayValueFor = {
                  guard let v = $0 else {return "0"}
                  return "\(Int(v))"+"cc"
              }
              $0.title = eDname.can.rawValue
              $0.value = eDname.alc_limit[eDname.can]!
          }
          .onChange {
              let v = floor(Double($0.value!))
              eDname.alc_limit[eDname.can] = v
          }
              
    }

}
