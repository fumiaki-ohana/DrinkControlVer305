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

let defaultTint = UIColor.init(red: 242/255, green: 5/255, blue: 92/255, alpha: 94/100)
let versionInfo = "バージョン　3.0"

let etcStr = "\u{2026}"

var drinks = [Drink]()
var entryDate: Date? = nil
var numOfUnits: Double = 0

enum icon: String {
    case wine = "\u{1F377}" // 🍷
    case nihon = "\u{1F376}"// 🍶
    case beer  = "\u{1F37A}"//🍺
    case shocy  = "\u{1F943}"//🥃
    case wisky  =  "\u{1F534}"//🔴
    case can  = "\u{1F535}"//🔵
}

enum eDname: String {
    case wine =  "ワイン"
    case nihonsyu =  "日本酒"
    case beer =   "ビール"
    case shocyu =  "焼酎"
    case wisky =  "ウイスキー"
    case can =  "缶酎ハイ"
    
    var c_order:Int {
        get {
            switch self {
            case .wine : return 0 // 🍷
            case .nihonsyu: return 1// 🍶
            case .beer: return 2//🍺
            case .shocyu: return 3//🔴
            case .wisky: return 4 //🥃
            case .can: return 5//🔵
            }
        }
    }
    
    var emoji: String {
        get {
            switch self {
            case .wine : return icon.wine.rawValue // 🍷
            case .nihonsyu: return icon.nihon.rawValue// 🍶
            case .beer: return icon.beer.rawValue//🍺
            case .shocyu: return icon.wisky.rawValue//🔴
            case .wisky: return icon.shocy.rawValue //🥃
            case .can: return icon.can.rawValue//🔵
            }
        }
    }
    
    func ctitle (emoji:Bool) -> String {
        let result = emoji ? self.emoji + self.rawValue : self.rawValue
        return result
    }
    
    var desc:String {
        get {
            
            switch self {
            case .wine: return "ワイングラス(1杯100cc)で、"
            case .nihonsyu: return "合（一合160cc)で、"
            case .beer: return "中ビン・ロング缶(500cc)で、"
            case .shocyu: return "コップ（７分目、お湯割ハーフ)で、"
            case .wisky: return "シングル（30cc)で、"
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
            case .wisky: return "杯"
            case .can: return "本"
            }
        }
    }
    
    var approx: Int {
        get {
            switch self {
            case .wine: return 100
            case .nihonsyu:return 160
            case .beer:return 500
            case .shocyu:return 50
            case .wisky:return 30
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
            case.wisky:return 40.0
            case.can:return 7.0
            }
        }
    }
    
    var unitAm: Int {
        return Int (10 / (eDname.alc_dic[self]! / 100) / 0.8)
    }
    
    static var alc_dic:[eDname:Double] {
        get {
           
            var result:[eDname:Double]=[:]
  //   /*
            if let data = UserDefaults.standard.dictionary(forKey: "data") {
                
                for d in data {
                    let n = eDname(rawValue: d.key)!
                    result[n] = d.value as? Double
                }
            }
            else {
  //         */
            
                result = [
                    eDname.wine: eDname.wine.defAlc ,
                    eDname.nihonsyu : eDname.nihonsyu.defAlc ,
                    eDname.beer : eDname.beer.defAlc,
                    eDname.shocyu : eDname.shocyu.defAlc,
                    eDname.wisky : eDname.wisky.defAlc,
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

let dPUnit:[eDname:Double] = [
    eDname.wine: 12,
    eDname.nihonsyu:15,
    eDname.beer:5,
    eDname.shocyu:25,
    eDname.wisky:40,
    eDname.can:7
]

var dictDrink:[String:Double] {
    get {
        var drinkDic:[String:Double]=[:]
        
        if let data = UserDefaults.standard.dictionary(forKey: "data") {
            for d in data {
                drinkDic[d.key] = d.value as? Double }
        }
        else {
            
            drinkDic = [
                eDname.wine.rawValue: dPUnit[eDname.wine]!,
                eDname.nihonsyu.rawValue : dPUnit[eDname.nihonsyu]!,
                eDname.beer.rawValue : dPUnit[eDname.beer]!,
                eDname.shocyu.rawValue : dPUnit[eDname.shocyu]!,
                eDname.wisky.rawValue : dPUnit[eDname.wisky]!,
                eDname.can.rawValue : dPUnit[eDname.can]!
            ]
        }
        return drinkDic
    }
    set {
        let defaluts = UserDefaults.standard
        defaluts.set(newValue, forKey: "data")
    }
}

// Mark: - Realm Definition
class DrinkRecord: Object {
    
    @objc dynamic var dDate:Date? = nil
    @objc dynamic var totalUnits:Double = 0
    @objc dynamic var id:String = ""
    
    @objc dynamic var wine:Int = 0
    @objc dynamic var nihonsyu:Int = 0
    @objc dynamic var beer:Int = 0
    @objc dynamic var shocyu:Int = 0
    @objc dynamic var wisky:Int = 0
    @objc dynamic var can:Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

let schemaVer:UInt64 = 16
var drinkRecord_Results : Results<DrinkRecord>!

struct DrinkDailyRecord {
    
    var dDate : Date
    var drinks : [Drink]
    //    DBへの保存と読み出しの導管としてのみ使用される。削除の検討も必要か？
    var totalUnits :Double
    
    var TU:Double {
        // 値を取得するときに呼ばれる。
        get{
            var numU:Double = 0
            for ditem in self.drinks {
                let unitN = ditem.unitAm // ドリンクごとの基準量
                let N1:Double = Double(ditem.damount)/Double(unitN)
                numU += N1
            }
            return round(numU * 10) / 10
        }
    }
    
    var emojiStr:String {
        get{
            
            let emoji = drinkSet.dEmojiConfig
            var result:String = ""
            switch emoji {
                
            case drinkSet.item_def:
                let max = 11
                
                guard self.TU > 0.0 else {return ""}
                let t = Int(self.TU.rounded(.toNearestOrEven))
                for ditem in self.drinks {
                    let unit = ditem.unitAm
                    let nu:Int = Int((Double(ditem.damount)/Double(unit)).rounded(.toNearestOrAwayFromZero))
                    let count = String(repeating:ditem.dname.emoji, count:nu)
                    result += count }
                guard !(result == "") else {return String(repeating:"\u{2B55}", count:t)} //⭕️
                let m = min(t,result.count)
                result = (m >= max) ? result.SubString( from: 0, lenght: max)!+etcStr : result
                
                return result
                
            case drinkSet.item_none:
                return ""
                
            default:
                let max = 11
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
    
    init?(dDate: Date, drinks: [Drink], totalUnits: Double) {
        // Initialize stored properties.
        self.dDate = dDate
        self.drinks = drinks
        self.totalUnits = totalUnits // アルコール濃度
    }
}

struct Drink {
    
    static let dPIndictive:[eDname:String] = [
        eDname.wine: "ワイングラス1杯弱",
        eDname.nihonsyu:"0.5合",
        eDname.beer:"中ビン・ロング缶の半分",
        eDname.shocyu:"お湯割5割でコップ0.7杯程度",
        eDname.wisky:"シングル1杯",
        eDname.can:"コップ1杯または350mL缶の半分"
    ]
    
    static let dPIndictiveAmount:[eDname:String] = [
        eDname.wine: "100cc",
        eDname.nihonsyu:"80cc",
        eDname.beer:"250cc",
        eDname.shocyu:"50cc",
        eDname.wisky:"30cc",
        eDname.can:"180cc"
    ]
    
    
    var dname: eDname
    var damount: Int
    var unitAl: Double {
        get {
            let result =  eDname.alc_dic[self.dname]
            return result!
        }
    }
    
    init?(dname: eDname, damount: Int) {
        // Initialize stored properties.
        self.dname = dname
        self.damount = damount
        //        self.unitAl = unitAl // アルコール濃度
    }
    
}

extension  Drink {
    
    var altMeasured: String {
        let N1:Double = Double(self.damount)/Double(self.dname.approx)
        let result = self.damount == 0 ? "無し": self.dname.desc+N1.decimalStr+self.dname.unit
        return result
    }
    
    //    アルコール濃度から、アルコール比重を計算
    var unitAm: Int {
        guard unitAl > 0.0 else { return 0 }
        return Int (10 / (self.unitAl / 100) / 0.8)
    }
    
    var numOfDrinkUnit: Double {
        let unitN = self.unitAm // ドリンクごとの基準量
        let N1:Double = Double(self.damount)/Double(unitN)
        return N1
    }
    
    mutating func restore() {
        //        self.unitAl = self.dname.defAlc
    }
    
    var emojiStr:String {
        get{
            guard self.numOfDrinkUnit > 0.0 else {return ""}
            //            let t = Int(self.TU.rounded(.toNearestOrEven))
            
            let unit = self.unitAm
            let nu:Int = Int((Double(self.damount)/Double(unit)).rounded(.toNearestOrEven))
            let result = String(repeating:self.dname.emoji, count:nu)
            
            return result
        }
        
    }
    
    //    Drinkから、酒類とアルコール濃度のペアの辞書型を作る。darrayは、アルコール濃度の情報のみ。
    static func gen_dict_dname_unitAl(darray:[Drink]) -> Dictionary<String,Double> {
        var dictDrink:[String:Double] = [:]
        for ditem in darray {
            dictDrink[ditem.dname.rawValue] = ditem.unitAl
        }
        return dictDrink
    }
    //   アルコール濃度のデータを持つ、Drink型を生成する。ただし、アルコール量はゼロ。
    static func gen_DrinkArray_with_zeroAmount_dname_al(dictDrink:[String:Double] ) -> [Drink] {
        var darray = [Drink]()
        for (key,value) in dictDrink {
            let D = eDname(rawValue: key)
            let Al = value
            let Am = 0
            darray.append(Drink(dname:D!, damount:Int(Am))!)
            darray.sort {(A,B) -> Bool in
                return A.dname.rawValue < B.dname.rawValue
            }
        }
        return darray
    }
}

enum calSet: String {
    case firstWeekDay
    case scrollDir
    case theme
    case language
    
    var defaultValue: Int {
        switch self {
        case .firstWeekDay : return 1
        case .scrollDir:return 1
        case .theme:return 0
        case .language:return 0
        }
    }
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
                (name:"デフォルト", emoji:drinkSet.item_def.rawValue),
                (name: "シンプル", emoji: drinkSet.item_plain.rawValue),
                (name: "アラート", emoji: drinkSet.item_alert.rawValue),
                (name: "クロス", emoji: drinkSet.item_cross.rawValue),
                (name: "ストーム", emoji: drinkSet.item_sos.rawValue),
                (name: "スカル", emoji: drinkSet.item_scul.rawValue),
                (name: "無し", drinkSet.item_none.rawValue) ]
            
            var result2 = [(name:String, emoji:String)] ()
                
                for i in result {
                    let n = (name:i.name, emoji:String(repeating:i.emoji, count:4))
                    result2.append(n)
                }
                
                return result2
            }
        }
    
    static var dEmojiConfig:drinkSet {
        
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
}
    var calConfig:[calSet:Int] {
        get {
            var calDic:[calSet:Int]=[:]
            
            if let data = UserDefaults.standard.dictionary(forKey: "cal") {
                for d in data {
                    let k:calSet = calSet(rawValue: d.key)!
                    calDic[k] = d.value as? Int
                }
            }
            else {
                calDic = [
                    calSet.firstWeekDay:calSet.firstWeekDay.defaultValue,
                    calSet.scrollDir:calSet.firstWeekDay.defaultValue,
                    calSet.theme:calSet.firstWeekDay.defaultValue,
                    calSet.language:calSet.language.defaultValue
                ]
            }
            return calDic
        }
        set {
            let defaluts = UserDefaults.standard
            var new_calDic:[String:Int]=[:]
            
            for d in newValue {
                let k_str:String = d.key.rawValue
                new_calDic[k_str] = d.value
            }
            defaluts.set(new_calDic, forKey: "cal")
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
    
    var flagReadMe:Bool {
        get {
            return UserDefaults.standard.bool(forKey: "readMe")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "readMe")
        }
    }
    //Extension
    extension Int {
        // Intを三桁ごとにカンマが入ったStringへ
        var decimalStr: String {
            let decimalFormatter = NumberFormatter()
            decimalFormatter.numberStyle = NumberFormatter.Style.decimal
            decimalFormatter.groupingSeparator = ","
            decimalFormatter.groupingSize = 3
            
            return decimalFormatter.string(from: self as NSNumber)! + "\u{33C4}" // ㏄
        }
    }
    
    extension String {
        
        func SubString(from f:Int, lenght n:Int) -> String? {
            guard self.count >= f + n else {return ""}
            let begin = self.index(self.startIndex, offsetBy:f)
            let upto = self.index(begin, offsetBy:n)
            return String(self[begin..<upto])
        }
    }
    
    extension Double {
        
        var decimalStr: String {
            let decimalFormatter = "%.1f"
            return String(format:decimalFormatter,self)
        }
        
        var decimalStrFloor: String {
            let decimalFormatter = "%.1f"
                return String(format:decimalFormatter,floor(self))
            }
        //    パーセント
        var percentStr: String {
            let decimalFormatter = "%.1f"
            return String(format:decimalFormatter,floor(self)) + "\u{FE6A}" //%
        }
        //    ブロック
        var returnBlock: String {
            let blockChar = "\u{1F377}"
            let times = Int( (self).rounded(.toNearestOrEven) ) > 14 ? 14 : Int( (self).rounded(.toNearestOrEven) )
            return  String(repeating:blockChar, count:times)
        }
        //    カレンダーの上のドット🍷
        var dots: Int{
            get {
                if targetUnit == Double(0) {return 3}
                else {
                let n = Int( (self / targetUnit).rounded(.toNearestOrAwayFromZero) ) > 3 ? 3 : Int( (self / targetUnit).rounded(.toNearestOrAwayFromZero) )
                    return n }
            }
        }
        
    }
    
    
    extension Date {
        var mediumStr: String {
            let f = DateFormatter()
            f.timeStyle = .none
            f.dateStyle = .medium
            f.locale = Locale(identifier: "ja_JP")
            return f.string(from: (self as Date))}
        var toHashStr: String {
            let f = DateFormatter()
            
            f.timeStyle = .none
            f.dateStyle = .short
            f.locale = Locale(identifier: "ja_JP")
            return f.string(from: self)
        }
    }
    
    extension Date {
        
        init(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
            self.init()
            if let value = year   { self.year   = value }
            if let value = month  { self.month  = value }
            if let value = day    { self.day    = value }
            if let value = hour   { self.hour   = value }
            if let value = minute { self.minute = value }
            if let value = second { self.second = value }
        }
        
        var year: Int {
            get {
                return calendar.component(.year, from: self)
            }
            set {
                setComponentValue(newValue, for: .year)
            }
        }
        
        var month: Int {
            get {
                return calendar.component(.month, from: self)
            }
            set {
                setComponentValue(newValue, for: .month)
            }
        }
        
        var day: Int {
            get {
                return calendar.component(.day, from: self)
            }
            set {
                setComponentValue(newValue, for: .day)
            }
        }
        
        var hour: Int {
            get {
                return calendar.component(.hour, from: self)
            }
            set {
                setComponentValue(newValue, for: .hour)
            }
        }
        
        var minute: Int {
            get {
                return calendar.component(.minute, from: self)
            }
            set {
                setComponentValue(newValue, for: .minute)
            }
        }
        
        var second: Int {
            get {
                return calendar.component(.second, from: self)
            }
            set {
                setComponentValue(newValue, for: .second)
            }
        }
        
        private mutating func setComponentValue(_ value: Int, for component: Calendar.Component) {
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            components.setValue(value, for: component)
            if let date = calendar.date(from: components) {
                self = date
            }
        }
        
        var calendar: Calendar {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = .japan
            calendar.locale   = .japan
            return calendar
        }
    }
    
    extension TimeZone {
        
        static let japan = TimeZone(identifier: "Asia/Tokyo")!
    }
    
    extension Locale {
        
        static let japan = Locale(identifier: "ja_JP")
    }
    
    extension UIAlertController {
        
        func addAction(title: String, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
            let okAction = UIAlertAction(title: title, style: style, handler: handler)
            addAction(okAction)
            return self
        }
        
        func addActionWithTextFields(title: String, style: UIAlertAction.Style = .default, handler: ((UIAlertAction, [UITextField]) -> Void)? = nil) -> Self {
            let okAction = UIAlertAction(title: title, style: style) { [weak self] action in
                handler?(action, self?.textFields ?? [])
            }
            addAction(okAction)
            return self
        }
        
        func configureForIPad(sourceRect: CGRect, sourceView: UIView? = nil) -> Self {
            popoverPresentationController?.sourceRect = sourceRect
            if let sourceView = UIApplication.shared.inputViewController?.view {
                popoverPresentationController?.sourceView = sourceView
            }
            return self
        }
        
        func configureForIPad(barButtonItem: UIBarButtonItem) -> Self {
            popoverPresentationController?.barButtonItem = barButtonItem
            return self
        }
        
        func addTextField(handler: @escaping (UITextField) -> Void) -> Self {
            addTextField(configurationHandler: handler)
            return self
        }
        
        func show() {
            UIApplication.shared.inputViewController?.present(self, animated: true, completion: nil)
        }
        
        
}

