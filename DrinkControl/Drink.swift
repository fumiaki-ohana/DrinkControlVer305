//
//  Drink.swift
//  DrinkTracker
//
//  Created by 鶴見文明 on 2018/04/22.
//  Copyright © 2018年 Fumiaki Tsurumi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

// MARK: - Const

let defaultTint = UIColor.init(red: 242/255, green: 5/255, blue: 92/255, alpha: 94/100)

let etcStr = "\u{2026}"
let cancelTitleStr = "キャンセル"
let OKstr = "OK"
let appleid = "1510172085"// for manually reviewing
let nextLabel = "OK" // Coach

let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
var lastDate = Date()//グラフの最終日
let ml = "㎖"

//var lastDataCoachStr = "2020/08/25"

// MARK: - type allias

typealias tableArray = [(title: String, desc: String)]
typealias drinkTupple = [(title:eDname,damount:Int)]
typealias drinkDict = [eDname: Int]
typealias ChartArray = [(xval:String, yval:Double, rating:String)]
typealias StackedChartArray = [(xval:String,yval: [Double])]
typealias RawData = [(date:Date, value:Double,rating:String)]

// MARK: - 評価

enum eval: String {
    case good = "🤗良い"
    case improving = "🙂普通"
    case bad  = "😡悪い"
    case veryBad  = "😱要改善"
    case no = "レビュー無し"
}
//MARK: - 初期画面管理のためのUserDefaultなど

var flagReadMeV3:Bool { //  V3以降のdisclaimerを読んだか？ //エラーによりVer3.06 と　3.07のユーザーで読んだにも関わらずFalseのままのユーザーがいる。
    get {
        UserDefaults.standard.register(defaults: ["readMeV3": false])
        return UserDefaults.standard.bool(forKey: "readMeV3")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "readMeV3")
    }
}

var flagReadMe:Bool { //  V2以前のdisclaimerを読んだか？
       get {
           UserDefaults.standard.register(defaults: ["readMe": false])
           return UserDefaults.standard.bool(forKey: "readMe")
       }
       set {
           UserDefaults.standard.set(newValue, forKey: "readMe")
       }
   }

var reviewReadNotifyTime:Date {
    get {
        var time = Date()
        time.hour = 18
        time.minute = 30
        UserDefaults.standard.register(defaults: ["readReviewTime": time])
        return UserDefaults.standard.object(forKey: "readReviewTime") as? Date ?? time
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "readReviewTime")
    }
}

var NotSuspendNotification:Bool {
    get {
        UserDefaults.standard.register(defaults: ["NotSuspendNotification": false])
        return UserDefaults.standard.bool(forKey: "readReviewTime")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "NotSuspendNotification")
    }
}
//MARK:- Coach properties
enum CoarchCources {
    case chart
    case dataEntry
    case none
}

var shownLastChartPage:Bool = false

let chartDataArrayDummy:ChartArray =  [(xval: "2020/06/27", yval: 20.0,rating:"🤗良い"),
                                       (xval: "2020/06/28", yval: 10.0,rating:"🙂普通"),
                                       (xval: "2020/06/29", yval: 30.0,rating:"🙂普通"),
                                       (xval: "2020/06/30", yval: 0.0,rating:"🤗良い"),
                                        (xval: "2020/07/01", yval: 50.0,rating:"😡悪い"),
                                        (xval: "2020/07/02", yval: 70.0,rating:"😱要改善"),
                                        (xval: "2020/07/03", yval: 60.0,rating:"😡悪い"),
                                        (xval: "2020/07/04", yval: 80.0,rating:"😱要改善"),
                                        (xval: "2020/07/05", yval: 100.0,rating:"😱要改善"),
                                        (xval: "2020/07/06", yval: 0.0,rating:"🤗良い"),
                                        (xval: "2020/07/07", yval: 90.0,rating:"😱要改善"),
                                        (xval: "2020/07/07", yval: 20.0,rating:"🤗良い"),
                                        (xval: "2020/07/09", yval: 50.0,rating:"😡悪い"),
                                        (xval: "2020/07/10", yval: 0.0,rating:"🤗良い"),
                                        (xval: "2020/07/11", yval: 30.0,rating:"🤗良い"),
                                        (xval: "2020/07/12", yval: 21.0,rating:"🤗良い"),
                                        (xval: "2020/07/13", yval: 55.0,rating:"😡悪い"),
                                        (xval: "2020/07/14", yval: 25.0,rating:"🙂普通"),
                                        (xval: "2020/07/15", yval: 29.0,rating:"🙂普通"),
                                        (xval: "2020/07/16", yval: 50.0,rating:"😡悪い"),
                                        (xval: "2020/07/17", yval: 12.0,rating:"🤗良い"),
                                        (xval: "2020/07/18", yval: 34.0,rating:"🙂普通"),
                                        (xval: "2020/07/19", yval: 62.0,rating:"😱要改善"),
                                        (xval: "2020/07/20", yval: 21.0,rating:"🤗良い"),
                                        (xval: "2020/07/21", yval: 22.0,rating:"🙂普通"),
                                        (xval: "2020/07/22", yval: 25.0,rating:"🤗良い"),
                                        (xval: "2020/07/23", yval: 59.0,rating:"😡悪い"),
                                        (xval: "2020/07/24", yval: 60.0,rating:"😱要改善"),
                                        (xval: "2020/07/25", yval: 97.0,rating:"😱要改善")]

let dDateDummy = chartDataArrayDummy.last!.xval.dateConverted
let dailyDrinkDummy:DrinkDailyRecord = DrinkDailyRecord(dDate: dDateDummy, drinks: [DrinkControl.eDname.nihonsyu: 200, DrinkControl.eDname.whisky: 0, DrinkControl.eDname.beer: 350, DrinkControl.eDname.shocyu: 0, DrinkControl.eDname.wine: 200, DrinkControl.eDname.can: 0], evaluation: "😡悪い", comment:"【コメント】お酒のちゃんぽんは最大２種類まで。「まずはビール」はしばらく止めてみる。")
 let tableDataDummy = [[(title: "😡悪い", desc: "")], [(title: "🍺🍷🍷", desc: "57𝐠")], [(title: "🍷ワイン", desc: "200㏄"), (title: "🍶日本酒", desc: "200㏄"), (title: "🍺ビール", desc: "350㏄")]]

var justFinishedCoachCources:CoarchCources = .none
var shouldShowCoarch: Bool { //コーチを走らせるべきか？
    get {
        UserDefaults.standard.register(defaults: [ "shouldShowCoarch" : true])
        let n = UserDefaults.standard.bool(forKey:"shouldShowCoarch")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "shouldShowCoarch")
    }
}

let thisVerStr = appVersion!
var shouldShowVerInfo: Bool { //バージョン情報を見せる？
    get {
        UserDefaults.standard.register(defaults: [ thisVerStr : true])
        let n = UserDefaults.standard.bool(forKey:thisVerStr)
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: thisVerStr)
    }
}

var shouldWarningOnRatingGraph: Bool { //感想のグラフで初回表示
    get {
        UserDefaults.standard.register(defaults: [ "RatingGraph" : true])
        let n = UserDefaults.standard.bool(forKey:"RatingGraph")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "RatingGraph")
    }
}
var shouldWarningAlchool: Bool { //アルコール濃度の設定で初回表示
    get {
        UserDefaults.standard.register(defaults: [ "alchoolChange" : true])
        let n = UserDefaults.standard.bool(forKey:"alchoolChange")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "alchoolChange")
    }
}

// Mark:-　保存可能回数の関連

enum UserType {
    case newUser
    case currentUser
    case purchasedUser
}
var userType:UserType = .newUser
var maxSaveTime = 2// 保存上限
let haircutForNotice = 2 // お知らせ開始 =>　既存ユーザー

var flagConverted:Bool{
    get {
        UserDefaults.standard.register(defaults: ["converted_statusToV3" : false])
        let n = UserDefaults.standard.bool(forKey:"converted_statusToV3")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "converted_statusToV3")
        
    }
}

var unlocked:Bool{
    get {
        UserDefaults.standard.register(defaults: ["unlock_status" : false])
        let n = UserDefaults.standard.bool(forKey:"unlock_status")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "unlock_status")
    }
}

var saveTimes:Int {
    get {
        UserDefaults.standard.register(defaults: ["saveTimes" : 0])
        let n = UserDefaults.standard.integer(forKey: "saveTimes")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "saveTimes")
    }
}

var remainSaveTime:Int {
    return max(maxSaveTime - saveTimes,0)
}

var canSave :Bool {
    get {
        let n = UserDefaults.standard.integer(forKey: "saveTimes")
        if unlocked {return true}
        else {
            if n < maxSaveTime {
                return true }
            else {
                return false}
        }
    }
}
// Mark:- レビュー要請

let processCompletedCountKey = "processCompletedCount"
let lastVersionPromptedForReview = "lastVersionPromptedForReview"

let hairCutForReview = 10

var processCompletedCountVar: Int {
    
    get {
        UserDefaults.standard.register(defaults: [processCompletedCountKey : 0])
        let count = UserDefaults.standard.integer(forKey: processCompletedCountKey)
        return count
    }
    set {
        UserDefaults.standard.set(newValue,forKey:processCompletedCountKey)
    }
}

var lastVersionPromtedForReviewVar: String {
    
    get {
        UserDefaults.standard.register(defaults: [lastVersionPromptedForReview : ""])
        let value = UserDefaults.standard.string(forKey: lastVersionPromptedForReview)
        return value!
    }
    set {
        UserDefaults.standard.set(newValue,forKey:lastVersionPromptedForReview)
    }
}

// MARK:- 入力方法のチョイス

var execQuickDataEntry:Bool{
    get {
        UserDefaults.standard.register(defaults: ["shouldQuickEntry" : true])
        let n = UserDefaults.standard.bool(forKey:"shouldQuickEntry")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "shouldQuickEntry")
    }
}



/*
// MARK:- PopTipの設定

func initPopTip(popObj:PopTip) {
    
    popObj.font = UIFont.systemFont(ofSize: 13.0)
    popObj.textColor = UIColor.black
    popObj.textAlignment = .left
    popObj.shouldDismissOnTap = true
    popObj.shouldDismissOnTapOutside = true
    popObj.shouldDismissOnSwipeOutside = true
    popObj.edgeMargin = 5
    popObj.offset = 2
    popObj.bubbleOffset = 0
    popObj.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    popObj.arrowRadius = 0
    popObj.bubbleColor = UIColor.white
    
    popObj.borderWidth = 2
    popObj.borderColor = UIColor.gray
    popObj.shadowOpacity = 0.4
    popObj.shadowRadius = 3
    popObj.shadowOffset = CGSize(width: 1, height: 1)
    popObj.shadowColor = .black
}
*/
//MARK: - 飲酒ガイドラインの設定

var numOfNoDrinkDays: Int { //休肝日
    
    get {
        UserDefaults.standard.register(defaults: ["numOfNoDrinkDays" : 2])
        let value = UserDefaults.standard.integer(forKey: "numOfNoDrinkDays")
        return value
    }
    set {
        let v = min(newValue,7)
        UserDefaults.standard.set(v,forKey:"numOfNoDrinkDays")
    }
}

var excessDrinkHairCut: Int { //過剰な飲酒 ...適量の倍数
    
    get {
        UserDefaults.standard.register(defaults: ["excessDrinkHairCut" : 3])
        let value = UserDefaults.standard.integer(forKey: "excessDrinkHairCut")
        return value
    }
    set {
        let v = max(newValue,1)
        UserDefaults.standard.set(v,forKey:"excessDrinkHairCut")
    }
}


// MARK: - 個別のお酒

enum icon: String {
    case wine = "\u{1F377}" // 🍷
    case nihon = "\u{1F376}"// 🍶
    case beer  = "\u{1F37A}"//🍺
    case shocyu  = "\u{1F534}"//🔴
    case whisky  = "\u{1F943}"//🥃
    case can  = "🔵"
    
}
var altShochuName: String { //焼酎の別名
    
    get {
        UserDefaults.standard.register(defaults: ["altShochuName" : eDname.shocyu.rawValue])
        let value = UserDefaults.standard.string (forKey: "altShochuName")
        return value!
    }
    set {
        UserDefaults.standard.set(newValue,forKey:"altShochuName")
    }
}

var altCanName: String { //缶の別名
    
    get {
        UserDefaults.standard.register(defaults: ["altCanName" : eDname.can.rawValue])
        let value = UserDefaults.standard.string (forKey: "altCanName")
        return value!
    }
    set {
        UserDefaults.standard.set(newValue,forKey:"altCanName")
    }
}



enum eDname: String {
    case wine =  "ワイン"
    case nihonsyu =  "日本酒"
    case beer =   "ビール"
    case shocyu =  "焼酎"
    case whisky =  "ｳｲｽｷｰ"
    case can =  "酎ハイ"
    
    var c_order:Int {
        get {
            switch self {
            case .wine : return 0 // 🍷
            case .nihonsyu: return 1// 🍶
            case .beer: return 2//🍺
            case .shocyu: return 3//🔴
            case .whisky: return 4 //🥃
            case .can: return 5//🍹
            }
        }
    }
    
    //    アルコール濃度から、アルコール比重を計算
    var unitAm: Int {
        let alc = alc_dic[self]
        guard alc! > 0.0 else { return 0 }
        return Int (10 / (alc! / 100) / 0.8)
    }
    
    func Amount2Glasses(damount:Int) -> Double {
        if let perGlass = alc_quick[self] {
            guard !(perGlass == 0) else {
                return 0
            }
            let numGlasses = Double(damount) / perGlass
            return numGlasses
        }
      return 0
    }
    
    func Glasses2Amount(numGlass:Double) -> Int {
        if let perGlass = alc_quick[self] {
            guard !(perGlass == 0) else {
                return 0
            }
            let amount = floor(numGlass * perGlass)
            return Int(amount)
        }
      return 0
    }
     
    
    func emojiStrPerDrink(damount:Double) -> String {
        guard self.numOfDrinkUnit(damount:damount) > 0.0 else {return ""}
        //            let t = Int(self.TU.rounded(.toNearestOrEven))
        
        let unit = self.unitAm
        let nu:Int = Int((Double(damount)/Double(unit)).rounded(.toNearestOrEven))
        let result = String(repeating:self.emoji, count:nu)
        
        return result
    }
    
    func numOfDrinkUnit(damount:Double) -> Double {
        let unitN = self.unitAm // ドリンクごとの基準量
        let N1:Double = damount / Double(unitN)
        return N1
    }
    
    func altMeasured(damount:Double) -> String {
        let N1:Double = Double(damount)/Double(self.approx)
        let result = damount == 0 ? "無し": self.desc+N1.decimalStr+self.unit
        return result
    }
    
    var emoji: String {
        get {
            switch self {
            case .wine : return icon.wine.rawValue // 🍷
            case .nihonsyu: return icon.nihon.rawValue// 🍶
            case .beer: return icon.beer.rawValue//🍺
            case .shocyu: return icon.shocyu.rawValue//🔴
            case .whisky: return icon.whisky.rawValue //🥃
            case .can: return icon.can.rawValue//🔵
            }
        }
    }
    
    func ctitle (emoji:Bool) -> String {
        var result:String = ""
        
        switch self {
        case .shocyu :  result = emoji ? self.emoji + altShochuName : altShochuName
        case .can:  result = emoji ? self.emoji + altCanName : altCanName
        default:  result = emoji ? self.emoji + self.rawValue : self.rawValue
        }
        return result
    }
    
    var desc:String {
        get {
            
            switch self {
            case .wine: return "ワイングラス(1杯100cc)で、"
            case .nihonsyu: return "合（一合160cc)で、"
            case .beer: return "中ビン・ロング缶(500cc)で、"
            case .shocyu: return "コップ（７分目、お湯割ハーフ)で、"
            case .whisky: return "シングル（30cc)で、"
            case .can: return "350mL缶で、"
            }
        }
    }
    
    var unit:String {
        get {
            
            switch self {
            case .wine: return "杯"
            case .nihonsyu: return "合"
            case .beer: return "本"
            case .shocyu: return "杯"
            case .whisky: return "杯"
            case .can: return "本"
            }
        }
    }
    // Mark:- アルコール濃度などデフォルトの数字
  //TODO - 目安の分量だが現在は使用されていない。
    var approx: Int {
        get {
            switch self {
            case .wine: return 100
            case .nihonsyu:return 160
            case .beer:return 500
            case .shocyu:return 50
            case .whisky:return 30
            case .can: return 350
                
            }
        }
    }
    
    var defAlc: Double {
        get {
            switch self {
            case .wine: return 12.0
            case.nihonsyu: return 15.0
            case.beer:return 5.0
            case.shocyu:return 25.0
            case.whisky:return 40.0
            case.can:return 7.0
            }
        }
    }
}

//Mark :- 設定関連


// カレンダー
let optionEmojiStr =
    [ "標準" ,
      "ブロック",
      "注意",
      "要改善",
      "SOS",
      "スカル",
      "絵文字の表示無し" ]

let drinkSetChar = [
    "\u{1F377}",
    "\u{25A0}",
    "\u{2757}",
    "\u{274C}",
    "\u{1F198}",
    "\u{1F480}",
    ""]

let ConstFirstWeekDay = ["日曜日", "月曜日"]
let ConstScrollDir = ["縦", "横"]
let ConstLanguage = ["日本語", "英語"]

enum calSet: String {
    case scrollDir
    //    case theme
    case language
    
    //    for Eureka! entry
    
    var tag:String {
        switch self {
        case .scrollDir : return "月を移動する方向"
        case .language : return "カレンダーの表示言語"
        }
    }
    
    var defaultValue: Int {
        switch self {
        case .scrollDir:return 1
        //        case .theme:return 0
        case .language:return 0
        }
    }
    
    var selectorTitle: String {
        switch self {
        case .scrollDir:return "カレンダーのスワイプ向き"
        //            case .theme:return "色のテーマ"
        case .language:return "カレンダーの表示言語"
        }
    }
    
    var options: [String] {
        switch self {
            
        case .scrollDir:return ConstScrollDir
        //            case .theme:return ConstTheme
        case .language:return ConstLanguage
        }
    }
}

// Userdefault

// グラフのタイプ
let graphOption = ["棒グラフ","線グラフ"]
var graphType:Int {
    get {
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["graphType": 1])
        return userDefaults.integer(forKey: "graphType")}
    set {
        UserDefaults.standard.set(newValue, forKey: "graphType")
    }
}

var cal_language:Int {
    get {
        let userDefaults = UserDefaults.standard
        //        userDefaults.register(defaults: ["language": 0])
        return userDefaults.integer(forKey: "language")}
    set {
        UserDefaults.standard.set(newValue, forKey: "language")
    }
}
var cal_direction:Int {
    get {
        let userDefaults = UserDefaults.standard
        //        userDefaults.register(defaults: ["direction": 0])
        return userDefaults.integer(forKey: "direction")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "direction")
    }
}

var emojiSwitch:Bool {
    get {
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["emoji": true])
        
        let result: Bool = userDefaults.object(forKey: "emoji") as! Bool
        
        return result
    }
    set {
        let userDefaluts = UserDefaults.standard
        userDefaluts.set(newValue, forKey: "emoji")
    }
}

var dEmojiConfig:drinkSet {
    
    get {
        if let data = UserDefaults.standard.string(forKey: "emojiDrink") {
            return drinkSet(rawValue: data)! }
        else {return drinkSet.item_def}
    }
    
    set {
        let newValueStr = newValue.rawValue
        UserDefaults.standard.set(newValueStr, forKey: "emojiDrink")
    }
    
}

var targetUnit:Double {
    get {
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["target": 2.0])
        return userDefaults.double(forKey: "target")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "target")
    }
}
var alc_quick:[eDname:Double] {
    get {
        
        var result:[eDname:Double]=[:]
        
        if let data = UserDefaults.standard.dictionary(forKey: "quickShot") {
            
            for d in data {
                let n = eDname(rawValue: d.key)!
                result[n] = d.value as? Double
            }
        }
        else {
            
            result = [
                eDname.wine: 120 ,
                eDname.nihonsyu : 180,
                eDname.beer : 350,
                eDname.shocyu : 110,
                eDname.whisky : 60,
                eDname.can :520
            ]
        }
        
        return result
    }
    set {
        let defaluts = UserDefaults.standard
        var result:[String:Double]=[:]
        for d in newValue {
            let n_str = d.key.rawValue
            result[n_str] = d.value
        }
        defaluts.set(result, forKey: "quickShot")
    }
}


var alc_step:[eDname:Double] {
    get {
        
        var result:[eDname:Double]=[:]
        
        if let data = UserDefaults.standard.dictionary(forKey: "step") {
            
            for d in data {
                let n = eDname(rawValue: d.key)!
                result[n] = d.value as? Double
            }
        }
        else {
            
            result = [
                eDname.wine: 20 ,
                eDname.nihonsyu : 20,
                eDname.beer : 50,
                eDname.shocyu : 10,
                eDname.whisky : 10,
                eDname.can :50
            ]
        }
        
        return result
    }
    set {
        let defaluts = UserDefaults.standard
        var result:[String:Double]=[:]
        for d in newValue {
            let n_str = d.key.rawValue
            result[n_str] = d.value
        }
        defaluts.set(result, forKey: "step")
    }
}

var alc_limit:[eDname:Double] {
            get {
                
                var result:[eDname:Double]=[:]
                
                if let data = UserDefaults.standard.dictionary(forKey: "limit") {
                    
                    for d in data {
                        let n = eDname(rawValue: d.key)!
                        result[n] = d.value as? Double
                    }
                }
                else {
                    
                    result = [
                        eDname.wine: 3000 ,
                        eDname.nihonsyu : 3000 ,
                        eDname.beer : 5000,
                        eDname.shocyu : 1500,
                        eDname.whisky : 1500,
                        eDname.can :3000
                    ]
                }
                
                return result
            }
            set {
                let defaluts = UserDefaults.standard
                var result:[String:Double]=[:]
                for d in newValue {
                    let n_str = d.key.rawValue
                    result[n_str] = d.value
                }
                defaluts.set(result, forKey: "limit")
            }
        }
        
var alc_dic:[eDname:Double] {
            get {
                
                var result:[eDname:Double]=[:]
                
                if let data = UserDefaults.standard.dictionary(forKey: "data") {
                    
                    for d in data {
                        let n = eDname(rawValue: d.key)!
                        result[n] = d.value as? Double
                    }
                }
                else {
                    
                    result = [
                        eDname.wine: eDname.wine.defAlc ,
                        eDname.nihonsyu : eDname.nihonsyu.defAlc ,
                        eDname.beer : eDname.beer.defAlc,
                        eDname.shocyu : eDname.shocyu.defAlc,
                        eDname.whisky : eDname.whisky.defAlc,
                        eDname.can : eDname.can.defAlc
                    ]
                }
                
                return result
            }
            set {
                let defaluts = UserDefaults.standard
                var result:[String:Double]=[:]
                for d in newValue {
                    let n_str = d.key.rawValue
                    result[n_str] = d.value
                }
                defaluts.set(result, forKey: "data")
            }
        }
    
    
    
// MARK: - Realm

var drinkRecord_Results : Results<DrinkRecord>!

class DrinkRecord: Object {
    
    @objc dynamic var dDate:Date? = nil
    @objc dynamic var totalUnits:Double = 0
    @objc dynamic var id:String = ""
    
    @objc dynamic var wine:Int = 0
    @objc dynamic var nihonsyu:Int = 0
    @objc dynamic var beer:Int = 0
    @objc dynamic var shocyu:Int = 0
    @objc dynamic var whisky:Int = 0
    @objc dynamic var can:Int = 0
    
    @objc dynamic var evaluation:String = ""
    @objc dynamic var comment:String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - Daily Drink Record

struct DrinkDailyRecord {
    
    var dDate : Date
    var drinks: drinkDict = [:]
    //    DBへの保存と読み出しの導管としてのみ使用される。削除の検討も必要か？
    //    var totalUnits :Double
    var evaluation: String = eval.no.rawValue
    var comment:String = ""
    
    var TU:Double {
        // 値を取得するときに呼ばれる。
        get{
            var numU:Double = 0
            for ditem in self.drinks {
                let u = ditem.key.unitAm
                let v = ditem.value
                // ドリンクごとの基準量
                let N1:Double = Double(v)/Double(u)
                numU += N1
            }
            return round(numU * 10) / 10
        }
    }
    
    var totalAlchool: Double {// 純アルコール量を返す
        return TU*10
    }
    
    // 絵文字
    
    
    var emojiStr:String {
        get{
            
            let emoji = dEmojiConfig
            var result:String = ""
            switch emoji {
                
            case drinkSet.item_def:
                let max = 8
                
                guard self.TU > 0.0 else {return ""}
                let t = Int(self.TU.rounded(.toNearestOrEven))
                for ditem in self.drinks {
                    let unit = ditem.key.unitAm
                    let nu:Int = Int((Double(ditem.value)/Double(unit)).rounded(.toNearestOrAwayFromZero))
                    let count = String(repeating:ditem.key.emoji, count:nu)
                    result += count }
                guard !(result == "") else {return String(repeating:"\u{2B55}", count:t)} //⭕️
                let m = min(t,result.count)
                result = (m >= max) ? result.SubString( from: 0, lenght: max)!+etcStr : result
                
                return result
                
            case drinkSet.item_none:
                return ""
                
            default:
                let max = 8
                guard self.TU > 0.0 else {return ""}
                let total = min(Int(self.TU.rounded(.toNearestOrEven)),max)
                let flag = Int(self.TU.rounded(.toNearestOrEven))>max
                result = String(repeating:emoji.rawValue, count:total)
                result = flag ? result+etcStr : result
                return result
            }
        }
    }
    //    カレンダーの上のドット🍷
    var dots: Int {
        get {
            let n = Int( (self.TU / targetUnit).rounded(.toNearestOrAwayFromZero) ) > 3 ? 3 : Int( (self.TU/targetUnit).rounded(.toNearestOrAwayFromZero) )
            
            return n
        }
    }
}

// MARK: - Calendar

struct entryFormPara {
    var tag = ""
    var selectorTitle = ""
    var options = [String]()
    var cancelTitle = ""
}

enum drinkSet:String {
    
    case item_def   = "\u{1F377}"
    case item_plain = "\u{25A0}"
    case item_alert = "\u{2757}"
    case item_cross = "\u{274C}"
    case item_sos = "\u{1F198}"
    case item_scul = "\u{1F480}"
    case item_none = ""
    
    static var drinkSetTableRef: [drinkSet] {
        get {
            let result: [drinkSet] = [
                
                .item_def, .item_plain, .item_alert ,.item_cross ,.item_sos,.item_scul,.item_none
            ]
            return result
            
        }
    }
    
    static var drinkSetTableArray:[(name:String, emoji:String)]  {
        
        get {
            let result:[(name:String, emoji:String)]  = [
                (name:optionEmojiStr[0], emoji:drinkSet.item_def.rawValue),
                (name: optionEmojiStr[1], emoji: drinkSet.item_plain.rawValue),
                (name: optionEmojiStr[2], emoji: drinkSet.item_alert.rawValue),
                (name: optionEmojiStr[3], emoji: drinkSet.item_cross.rawValue),
                (name: optionEmojiStr[4], emoji: drinkSet.item_sos.rawValue),
                (name: optionEmojiStr[5], emoji: drinkSet.item_scul.rawValue),
                (name: optionEmojiStr[6], drinkSet.item_none.rawValue) ]
            
            var result2 = [(name:String, emoji:String)] ()
            
            for i in result {
                let n = (name:i.name, emoji:String(repeating:i.emoji, count:4))
                result2.append(n)
            }
            
            return result2
        }
    }
    
}


// MARK:- もはや利用されていないUserDefault
/*
var shouldShowVersionInfo: Bool { //ver2 より追加。変更があった場合に表示する。
    get {
        UserDefaults.standard.register(defaults: [ "showVersionPresented" : true])
        let n = UserDefaults.standard.bool(forKey:"showVersionPresented")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "showVersionPresented")
    }
}



var shouldShowVersionSummaryAtOnce: Bool {
    get {
        UserDefaults.standard.register(defaults: [ "versionSummaryPresented" : true])
        let n = UserDefaults.standard.bool(forKey:"versionSummaryPresented")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "versionSummaryPresented")
    }
}

var shouldShowVersionSummaryAtOnceForVer22: Bool {
    get {
        UserDefaults.standard.register(defaults: [ "versionSummaryPresentedV22" : true])
        let n = UserDefaults.standard.bool(forKey:"versionSummaryPresentedV22")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "versionSummaryPresentedV22")
    }
}

var shouldShowWalkThrough: Bool {
    get {
        UserDefaults.standard.register(defaults: [ "walkthroughPresented" : true])
        let n = UserDefaults.standard.bool(forKey:"walkthroughPresented")
        return n
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "walkthroughPresented")
    }
}
*/
